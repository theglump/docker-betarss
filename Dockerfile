FROM ubuntu:saucy

MAINTAINER Sebastien Rozange <srozange@gmail.com>

# Update Ubuntu
RUN apt-get update && apt-get -y upgrade

# Get Supervisor
RUN apt-get install -y supervisor
RUN mkdir -p /var/log/supervisor

# Install Git
RUN apt-get -y install git

# Install Java
RUN apt-get -y install openjdk-7-jre 
RUN apt-get -y install openjdk-7-jdk

# Install maven
RUN apt-get -y install maven

# Install tomcat
RUN apt-get -y install tomcat7
RUN echo "JAVA_HOME=/usr/" >> /etc/default/tomcat7

# Clean packages
RUN apt-get clean

# Supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Betarss
RUN git clone https://github.com/srozange/betarss
RUN cd betarss && mvn clean package

# Deploy war
RUN cp betarss/target/betarss.war /var/lib/tomcat7/webapps/

EXPOSE 8080
CMD ["/usr/bin/supervisord"]