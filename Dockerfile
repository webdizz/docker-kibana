FROM webdizz/nginx:latest

# Set correct environment variables.
ENV	HOME /root
ENV	LANG en_US.UTF-8
ENV	LC_ALL en_US.UTF-8
ENV	DEBIAN_FRONTEND	noninteractive

# set sane locale
RUN	locale-gen en_US.UTF-8

# Install Kibana.
ENV KIBANA_VERSION 3.1.0
RUN \
  mkdir -p /usr/share/kibana && \
  cd /tmp && \
  wget https://download.elasticsearch.org/kibana/kibana/kibana-${KIBANA_VERSION}.tar.gz && \
  tar xvzf kibana-${KIBANA_VERSION}.tar.gz && \
  rm -f kibana-${KIBANA_VERSION}.tar.gz && \
  mv kibana-${KIBANA_VERSION}/* /usr/share/kibana && \
  ls -la /usr/share/kibana

# Copy kibana config.
ADD configs/config.js /usr/share/kibana/config.js

# Attach volumes.
#VOLUME /usr/local/nginx/conf/sites-enabled
VOLUME /kibana

ADD configs/nginx.conf /usr/local/nginx/conf/nginx.conf
ADD configs/kibana.conf /usr/local/nginx/conf/sites-enabled/kibana.conf



# Expose ports.
EXPOSE 80

CMD ["/run.sh"]

# Clean up APT when done.
RUN	apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
