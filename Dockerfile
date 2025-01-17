FROM nvidia/opengl:1.2-glvnd-runtime-ubuntu22.04

# configs
ARG user=docker
ARG passwd=docker
ARG home=/home/$user

# install basic softwares and add user
# prevent interactive input prompts
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y xauth zsh git curl glmark2 lsb-release gnupg2 neovim sudo && \
    useradd --create-home -s /bin/bash $user && \
    echo $user:$passwd | chpasswd && \
    adduser $user sudo

# install ros and clean cache
RUN apt-get install -y software-properties-common && \
    add-apt-repository universe && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu jammy main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null && \
    apt-get update && apt-get upgrade -y && \
    apt-get install -y ros-iron-desktop && \
    rm -rf /var/lib/apt/lists/* && \
    echo "source /opt/ros/iron/setup.bash" >> $home/.bashrc   
