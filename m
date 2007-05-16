Return-Path: <linux-kernel-owner+w=401wt.eu-S1763033AbXEPT7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763033AbXEPT7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbXEPT7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:59:33 -0400
Received: from mail4.webhostingstar.com ([67.106.77.50]:42567 "HELO
	mail4.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758598AbXEPT7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:59:31 -0400
Message-ID: <20070516145822.d1bz7paab4o8gg8c@67.106.77.50>
Date: Wed, 16 May 2007 14:58:22 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, greg@kroah.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

greg

CONFIG_SYSFS_DEPRECATED=Y

check that we have
rwxrwxrwx 1 root root       15 May 16 13:43 scanner-usbdev2.12 ->  
bus/usb/002/012

in /dev directory after usb-scanner connection for kernel-2.6.20
we don't have this for kernel-2.6.22

----------------------------2.6.20 usb-scanner connect

# /usr/sbin/udevmonitor

UEVENT[1179340996.886805] add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UEVENT[1179340996.886864] add@/class/usb_endpoint/usbdev2.12_ep00
UEVENT[1179340996.887438]  
add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UEVENT[1179340996.887467] add@/class/usb_endpoint/usbdev2.12_ep81
UEVENT[1179340996.887484] add@/class/usb_endpoint/usbdev2.12_ep02
UEVENT[1179340996.887499] add@/class/usb_endpoint/usbdev2.12_ep83
UEVENT[1179340996.887514] add@/class/usb_device/usbdev2.12
UDEV  [1179340996.921506] add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UDEV  [1179340996.936005] add@/class/usb_endpoint/usbdev2.12_ep00
UDEV  [1179340996.960144] add@/class/usb_endpoint/usbdev2.12_ep81
UDEV  [1179340996.963672] add@/class/usb_endpoint/usbdev2.12_ep02
UDEV  [1179340996.967439] add@/class/usb_endpoint/usbdev2.12_ep83
UDEV  [1179340997.240934]  
add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UDEV  [1179340997.473142] add@/class/usb_device/usbdev2.12

--------------------------- /dev

$ ls -l
total 0
crw------- 1 test root  14,  12 May 16 13:39 adsp
crw------- 1 test root  14,   4 May 16 13:39 audio
drwxr-xr-x 3 root root       60 May 16 13:39 bus
lrwxrwxrwx 1 root root        3 May 16 13:39 cdrom -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 cdrom-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 cdrw -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 cdrw-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 cdwriter -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 cdwriter-hdc -> hdc
crw------- 1 test root   5,   1 May 16 13:40 console
lrwxrwxrwx 1 root root       11 May 16 13:39 core -> /proc/kcore
drwxr-xr-x 4 root root       80 May 16 13:39 cpu
drwxr-xr-x 6 root root      120 May 16 13:39 disk
drwxr-xr-x 2 root root       60 May 16 13:39 dri
crw------- 1 test root  14,   3 May 16 13:39 dsp
lrwxrwxrwx 1 root root        3 May 16 13:39 dvd -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 dvd-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 dvdrw -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 dvdrw-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 dvdwriter -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:39 dvdwriter-hdc -> hdc
lrwxrwxrwx 1 root root       13 May 16 13:39 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1,   7 May 16 13:39 full
srwx------ 1 test root        0 May 16 13:40 gpmctl
brw------- 1 test disk  22,   0 May 16 13:39 hdc
crw------- 1 root root  10, 228 May 16 13:39 hpet
prw------- 1 root root        0 May 16 13:40 initctl
drwxr-xr-x 2 root root      220 May 16 13:40 input
crw------- 1 root root   1,  11 May 16 13:39 kmsg
srw-rw-rw- 1 root root        0 May 16 13:40 log
brw-r----- 1 root disk   7,   0 May 16 13:39 loop0
brw-r----- 1 root disk   7,   1 May 16 13:39 loop1
brw-r----- 1 root disk   7,   2 May 16 13:39 loop2
brw-r----- 1 root disk   7,   3 May 16 13:39 loop3
brw-r----- 1 root disk   7,   4 May 16 13:39 loop4
brw-r----- 1 root disk   7,   5 May 16 13:39 loop5
brw-r----- 1 root disk   7,   6 May 16 13:39 loop6
brw-r----- 1 root disk   7,   7 May 16 13:39 loop7
lrwxrwxrwx 1 root root       13 May 16 13:39 MAKEDEV -> /sbin/MAKEDEV
drwxr-xr-x 2 root root      100 May 16 08:39 mapper
crw------- 1 root root  10, 227 May 16 13:39 mcelog
brw-r----- 1 root disk   9,   0 May 16 13:40 md0
crw-r----- 1 root kmem   1,   1 May 16 13:39 mem
crw------- 1 test root  14,   0 May 16 13:39 mixer
drwxr-xr-x 2 root root       60 May 16 13:39 net
crw-rw-rw- 1 root root   1,   3 May 16 13:39 null
crw-rw---- 1 root root  10, 144 May 16 13:39 nvram
crw-rw---- 1 root lp    99,   0 May 16 13:39 parport0
crw-rw---- 1 root lp    99,   1 May 16 13:39 parport1
crw-rw---- 1 root lp    99,   2 May 16 13:39 parport2
crw-rw---- 1 root lp    99,   3 May 16 13:39 parport3
crw-r----- 1 root kmem   1,   4 May 16 13:39 port
crw------- 1 root root 108,   0 May 16 13:39 ppp
crw-rw-rw- 1 root tty    5,   2 May 16 13:46 ptmx
drwxr-xr-x 2 root root        0 May 16 08:39 pts
lrwxrwxrwx 1 root root        4 May 16 13:39 ram -> ram1
brw-r----- 1 root disk   1,   0 May 16 08:39 ram0
brw-r----- 1 root disk   1,   1 May 16 08:39 ram1
brw-r----- 1 root disk   1,  10 May 16 08:39 ram10
brw-r----- 1 root disk   1,  11 May 16 08:39 ram11
brw-r----- 1 root disk   1,  12 May 16 08:39 ram12
brw-r----- 1 root disk   1,  13 May 16 08:39 ram13
brw-r----- 1 root disk   1,  14 May 16 08:39 ram14
brw-r----- 1 root disk   1,  15 May 16 08:39 ram15
brw-r----- 1 root disk   1,   2 May 16 08:39 ram2
brw-r----- 1 root disk   1,   3 May 16 08:39 ram3
brw-r----- 1 root disk   1,   4 May 16 08:39 ram4
brw-r----- 1 root disk   1,   5 May 16 08:39 ram5
brw-r----- 1 root disk   1,   6 May 16 08:39 ram6
brw-r----- 1 root disk   1,   7 May 16 08:39 ram7
brw-r----- 1 root disk   1,   8 May 16 08:39 ram8
brw-r----- 1 root disk   1,   9 May 16 08:39 ram9
lrwxrwxrwx 1 root root        4 May 16 13:39 ramdisk -> ram0
crw-rw-rw- 1 root root   1,   8 May 16 13:39 random
brw------- 1 root root 253,   0 May 16 08:39 root
crw-r--r-- 1 root root  10, 135 May 16 08:39 rtc

lrwxrwxrwx 1 root root       15 May 16 13:43 scanner-usbdev2.12 ->  
bus/usb/002/012
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

brw-r----- 1 root disk   8,   0 May 16 08:39 sda
brw-r----- 1 root disk   8,   1 May 16 13:40 sda1
brw-r----- 1 root disk   8,   2 May 16 08:39 sda2
brw-r----- 1 root disk   8,  16 May 16 13:39 sdb
brw-r----- 1 root disk   8,  17 May 16 13:39 sdb1
brw-r----- 1 root disk   8,  32 May 16 13:39 sdc
brw-r----- 1 root disk   8,  33 May 16 13:39 sdc1
brw-r----- 1 root disk   8,  48 May 16 13:39 sdd
brw-r----- 1 root disk   8,  49 May 16 13:39 sdd1
brw-r----- 1 root disk   8,  64 May 16 13:39 sde
brw-r----- 1 root disk   8,  65 May 16 13:39 sde1
brw-r----- 1 root disk   8,  80 May 16 13:39 sdf
brw-r----- 1 root disk   8,  81 May 16 13:39 sdf1
brw-r----- 1 root disk   8,  96 May 16 13:39 sdg
brw-r----- 1 root disk   8,  97 May 16 13:39 sdg1
brw-r----- 1 root disk   8, 112 May 16 13:39 sdh
brw-r----- 1 root disk   8, 113 May 16 13:39 sdh1
brw-r----- 1 root disk   8, 128 May 16 13:39 sdi
brw-r----- 1 root disk   8, 144 May 16 13:39 sdj
brw-r----- 1 root disk   8, 160 May 16 13:39 sdk
brw-r----- 1 root disk   8, 176 May 16 13:39 sdl
crw------- 1 test root  14,   1 May 16 13:39 sequencer
crw------- 1 test root  14,   8 May 16 13:39 sequencer2
crw------- 1 root root  21,   0 May 16 13:39 sg0
crw------- 1 root root  21,   1 May 16 13:39 sg1
crw------- 1 root root  21,  10 May 16 13:39 sg10
crw------- 1 root root  21,  11 May 16 13:39 sg11
crw------- 1 root root  21,   2 May 16 13:39 sg2
crw------- 1 root root  21,   3 May 16 13:39 sg3
crw------- 1 root root  21,   4 May 16 13:39 sg4
crw------- 1 root root  21,   5 May 16 13:39 sg5
crw------- 1 root root  21,   6 May 16 13:39 sg6
crw------- 1 root root  21,   7 May 16 13:39 sg7
crw------- 1 root root  21,   8 May 16 13:39 sg8
crw------- 1 root root  21,   9 May 16 13:39 sg9
drwxrwxrwt 2 root root       40 May 16 13:40 shm
crw------- 1 root root  10, 231 May 16 13:39 snapshot
drwxr-xr-x 2 root root      180 May 16 13:39 snd
lrwxrwxrwx 1 root root       15 May 16 13:39 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root       15 May 16 13:39 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root       15 May 16 13:39 stdout -> /proc/self/fd/1
crw------- 1 root root   4,   0 May 16 08:39 systty
crw-rw-rw- 1 root tty    5,   0 May 16 13:39 tty
crw-rw---- 1 root root   4,   0 May 16 08:39 tty0
crw------- 1 root root   4,   1 May 16 13:40 tty1
crw-rw---- 1 root tty    4,  10 May 16 08:39 tty10
crw-rw---- 1 root tty    4,  11 May 16 08:39 tty11
crw-rw---- 1 root tty    4,  12 May 16 08:39 tty12
crw-rw---- 1 root tty    4,  13 May 16 13:39 tty13
crw-rw---- 1 root tty    4,  14 May 16 13:39 tty14
crw-rw---- 1 root tty    4,  15 May 16 13:39 tty15
crw-rw---- 1 root tty    4,  16 May 16 13:39 tty16
crw-rw---- 1 root tty    4,  17 May 16 13:39 tty17
crw-rw---- 1 root tty    4,  18 May 16 13:39 tty18
crw-rw---- 1 root tty    4,  19 May 16 13:39 tty19
crw------- 1 root root   4,   2 May 16 13:40 tty2
crw-rw---- 1 root tty    4,  20 May 16 13:39 tty20
crw-rw---- 1 root tty    4,  21 May 16 13:39 tty21
crw-rw---- 1 root tty    4,  22 May 16 13:39 tty22
crw-rw---- 1 root tty    4,  23 May 16 13:39 tty23
crw-rw---- 1 root tty    4,  24 May 16 13:39 tty24
crw-rw---- 1 root tty    4,  25 May 16 13:39 tty25
crw-rw---- 1 root tty    4,  26 May 16 13:39 tty26
crw-rw---- 1 root tty    4,  27 May 16 13:39 tty27
crw-rw---- 1 root tty    4,  28 May 16 13:39 tty28
crw-rw---- 1 root tty    4,  29 May 16 13:39 tty29
crw------- 1 root root   4,   3 May 16 13:40 tty3
crw-rw---- 1 root tty    4,  30 May 16 13:39 tty30
crw-rw---- 1 root tty    4,  31 May 16 13:39 tty31
crw-rw---- 1 root tty    4,  32 May 16 13:39 tty32
crw-rw---- 1 root tty    4,  33 May 16 13:39 tty33
crw-rw---- 1 root tty    4,  34 May 16 13:39 tty34
crw-rw---- 1 root tty    4,  35 May 16 13:39 tty35
crw-rw---- 1 root tty    4,  36 May 16 13:39 tty36
crw-rw---- 1 root tty    4,  37 May 16 13:39 tty37
crw-rw---- 1 root tty    4,  38 May 16 13:39 tty38
crw-rw---- 1 root tty    4,  39 May 16 13:39 tty39
crw------- 1 root root   4,   4 May 16 13:40 tty4
crw-rw---- 1 root tty    4,  40 May 16 13:39 tty40
crw-rw---- 1 root tty    4,  41 May 16 13:39 tty41
crw-rw---- 1 root tty    4,  42 May 16 13:39 tty42
crw-rw---- 1 root tty    4,  43 May 16 13:39 tty43
crw-rw---- 1 root tty    4,  44 May 16 13:39 tty44
crw-rw---- 1 root tty    4,  45 May 16 13:39 tty45
crw-rw---- 1 root tty    4,  46 May 16 13:39 tty46
crw-rw---- 1 root tty    4,  47 May 16 13:39 tty47
crw-rw---- 1 root tty    4,  48 May 16 13:39 tty48
crw-rw---- 1 root tty    4,  49 May 16 13:39 tty49
crw------- 1 root root   4,   5 May 16 13:40 tty5
crw-rw---- 1 root tty    4,  50 May 16 13:39 tty50
crw-rw---- 1 root tty    4,  51 May 16 13:39 tty51
crw-rw---- 1 root tty    4,  52 May 16 13:39 tty52
crw-rw---- 1 root tty    4,  53 May 16 13:39 tty53
crw-rw---- 1 root tty    4,  54 May 16 13:39 tty54
crw-rw---- 1 root tty    4,  55 May 16 13:39 tty55
crw-rw---- 1 root tty    4,  56 May 16 13:39 tty56
crw-rw---- 1 root tty    4,  57 May 16 13:39 tty57
crw-rw---- 1 root tty    4,  58 May 16 13:39 tty58
crw-rw---- 1 root tty    4,  59 May 16 13:39 tty59
crw------- 1 root root   4,   6 May 16 13:40 tty6
crw-rw---- 1 root tty    4,  60 May 16 13:39 tty60
crw-rw---- 1 root tty    4,  61 May 16 13:39 tty61
crw-rw---- 1 root tty    4,  62 May 16 13:39 tty62
crw-rw---- 1 root tty    4,  63 May 16 13:39 tty63
crw-rw---- 1 root root   4,   7 May 16 08:39 tty7
crw-rw---- 1 root tty    4,   8 May 16 13:39 tty8
crw-rw---- 1 root tty    4,   9 May 16 08:39 tty9
crw-rw---- 1 root uucp   4,  64 May 16 08:39 ttyS0
crw-rw---- 1 root uucp   4,  65 May 16 08:39 ttyS1
crw-rw---- 1 root uucp   4,  66 May 16 08:39 ttyS2
crw-rw---- 1 root uucp   4,  67 May 16 08:39 ttyS3
cr--r--r-- 1 root root   1,   9 May 16 13:40 urandom
crw------- 1 root root 253,   0 May 16 13:39 usbdev1.1_ep00
crw------- 1 root root 253,   1 May 16 13:39 usbdev1.1_ep81
crw------- 1 root root 253,  27 May 16 13:39 usbdev1.2_ep00
crw------- 1 root root 253,  28 May 16 13:39 usbdev1.2_ep81
crw------- 1 root root 253,  29 May 16 13:39 usbdev1.3_ep00
crw------- 1 root root 253,  30 May 16 13:39 usbdev1.3_ep01
crw------- 1 root root 253,  31 May 16 13:39 usbdev1.3_ep82
crw------- 1 root root 253,  21 May 16 13:39 usbdev2.10_ep00
crw------- 1 root root 253,  22 May 16 13:39 usbdev2.10_ep02
crw------- 1 root root 253,  23 May 16 13:39 usbdev2.10_ep88
crw------- 1 root root 253,  24 May 16 13:39 usbdev2.11_ep00
crw------- 1 root root 253,  25 May 16 13:39 usbdev2.11_ep01
crw------- 1 root root 253,  26 May 16 13:39 usbdev2.11_ep82
crw------- 1 root root 253,  32 May 16 13:43 usbdev2.12_ep00
crw------- 1 root root 253,  34 May 16 13:43 usbdev2.12_ep02
crw------- 1 root root 253,  33 May 16 13:43 usbdev2.12_ep81
crw------- 1 root root 253,  35 May 16 13:43 usbdev2.12_ep83
crw------- 1 root root 253,   2 May 16 13:39 usbdev2.1_ep00
crw------- 1 root root 253,   3 May 16 13:39 usbdev2.1_ep81
crw------- 1 root root 253,   4 May 16 13:39 usbdev2.2_ep00
crw------- 1 root root 253,   5 May 16 13:39 usbdev2.2_ep02
crw------- 1 root root 253,   6 May 16 13:39 usbdev2.2_ep86
crw------- 1 root root 253,   7 May 16 13:39 usbdev2.3_ep00
crw------- 1 root root 253,   8 May 16 13:39 usbdev2.3_ep81
crw------- 1 root root 253,   9 May 16 13:39 usbdev2.4_ep00
crw------- 1 root root 253,  10 May 16 13:39 usbdev2.4_ep02
crw------- 1 root root 253,  11 May 16 13:39 usbdev2.4_ep86
crw------- 1 root root 253,  12 May 16 13:39 usbdev2.5_ep00
crw------- 1 root root 253,  13 May 16 13:39 usbdev2.5_ep02
crw------- 1 root root 253,  14 May 16 13:39 usbdev2.5_ep86
crw------- 1 root root 253,  15 May 16 13:39 usbdev2.7_ep00
crw------- 1 root root 253,  16 May 16 13:39 usbdev2.7_ep02
crw------- 1 root root 253,  17 May 16 13:39 usbdev2.7_ep86
crw------- 1 root root 253,  18 May 16 13:39 usbdev2.9_ep00
crw------- 1 root root 253,  19 May 16 13:39 usbdev2.9_ep02
crw------- 1 root root 253,  20 May 16 13:39 usbdev2.9_ep86
crw------- 1 vcsa tty    7,   0 May 16 13:39 vcs
crw------- 1 vcsa tty    7,   1 May 16 13:40 vcs1
crw------- 1 vcsa tty    7,   2 May 16 13:40 vcs2
crw------- 1 vcsa tty    7,   3 May 16 13:40 vcs3
crw------- 1 vcsa tty    7,   4 May 16 13:40 vcs4
crw------- 1 vcsa tty    7,   5 May 16 13:40 vcs5
crw------- 1 vcsa tty    7,   6 May 16 13:40 vcs6
crw------- 1 vcsa tty    7,   7 May 16 13:40 vcs7
crw------- 1 vcsa tty    7, 128 May 16 13:39 vcsa
crw------- 1 vcsa tty    7, 129 May 16 13:40 vcsa1
crw------- 1 vcsa tty    7, 130 May 16 13:40 vcsa2
crw------- 1 vcsa tty    7, 131 May 16 13:40 vcsa3
crw------- 1 vcsa tty    7, 132 May 16 13:40 vcsa4
crw------- 1 vcsa tty    7, 133 May 16 13:40 vcsa5
crw------- 1 vcsa tty    7, 134 May 16 13:40 vcsa6
crw------- 1 vcsa tty    7, 135 May 16 13:40 vcsa7
drwx------ 2 root root       80 May 16 08:39 VolGroup00
lrwxrwxrwx 1 root root        4 May 16 13:39 X0R -> null
crw-rw-rw- 1 root root   1,   5 May 16 13:39 zero


-------------------------------------2.6.20 --disconnect

UEVENT[1179341320.097663] remove@/class/usb_endpoint/usbdev2.12_ep81
UEVENT[1179341320.097722] remove@/class/usb_endpoint/usbdev2.12_ep02
UEVENT[1179341320.100214] remove@/class/usb_endpoint/usbdev2.12_ep83
UEVENT[1179341320.100260]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UEVENT[1179341320.100279] remove@/class/usb_device/usbdev2.12
UEVENT[1179341320.100296] remove@/class/usb_endpoint/usbdev2.12_ep00
UEVENT[1179341320.100313]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UDEV  [1179341320.115056] remove@/class/usb_endpoint/usbdev2.12_ep81
UDEV  [1179341320.121885] remove@/class/usb_endpoint/usbdev2.12_ep02
UDEV  [1179341320.139815] remove@/class/usb_endpoint/usbdev2.12_ep83
UDEV  [1179341320.151459]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UDEV  [1179341320.162928] remove@/class/usb_device/usbdev2.12
UDEV  [1179341320.174825] remove@/class/usb_endpoint/usbdev2.12_ep00
UDEV  [1179341320.175389]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2



----------------------------------------2.6.22 --connect
# /usr/sbin/udevmonitor

UEVENT[1179342321.574080] add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UEVENT[1179342321.574335] add@/class/usb_endpoint/usbdev2.12_ep00
UEVENT[1179342321.574416]  
add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UEVENT[1179342321.574492] add@/class/usb_endpoint/usbdev2.12_ep81
UEVENT[1179342321.574566] add@/class/usb_endpoint/usbdev2.12_ep02
UEVENT[1179342321.574640] add@/class/usb_endpoint/usbdev2.12_ep83
UDEV  [1179342321.615769] add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UDEV  [1179342321.753760] add@/class/usb_endpoint/usbdev2.12_ep00
UDEV  [1179342321.852997]  
add@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UDEV  [1179342322.182201] add@/class/usb_endpoint/usbdev2.12_ep81
UDEV  [1179342322.186271] add@/class/usb_endpoint/usbdev2.12_ep02
UDEV  [1179342322.187252] add@/class/usb_endpoint/usbdev2.12_ep83

---------------------------- /dev


$ ls -l
total 0
crw------- 1 root root 189,   1 May 16 13:54 1-6
crw------- 1 root root 189,   2 May 16 13:54 1-8
crw------- 1 root root 189, 129 May 16 13:54 2-1
crw------- 1 root root 189, 130 May 16 13:54 2-2
crw------- 1 root root 189, 136 May 16 13:54 2-2.1
crw------- 1 root root 189, 139 May 16 14:05 2-2.2
crw------- 1 root root 189, 137 May 16 13:54 2-2.3
crw------- 1 root root 189, 138 May 16 13:54 2-2.4
crw------- 1 root root 189, 131 May 16 13:54 2-3
crw------- 1 root root 189, 132 May 16 13:54 2-5
crw------- 1 root root 189, 134 May 16 13:54 2-7
crw------- 1 test root  14,  12 May 16 13:54 adsp
crw------- 1 test root  14,   4 May 16 13:54 audio
lrwxrwxrwx 1 root root        3 May 16 13:54 cdrom -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 cdrom-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 cdrw -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 cdrw-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 cdwriter -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 cdwriter-hdc -> hdc
crw------- 1 test root   5,   1 May 16 13:55 console
lrwxrwxrwx 1 root root       11 May 16 13:54 core -> /proc/kcore
drwxr-xr-x 4 root root       80 May 16 13:54 cpu
drwxr-xr-x 6 root root      120 May 16 13:54 disk
drwxr-xr-x 2 root root       60 May 16 13:54 dri
crw------- 1 test root  14,   3 May 16 13:54 dsp
lrwxrwxrwx 1 root root        3 May 16 13:54 dvd -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 dvd-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 dvdrw -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 dvdrw-hdc -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 dvdwriter -> hdc
lrwxrwxrwx 1 root root        3 May 16 13:54 dvdwriter-hdc -> hdc
lrwxrwxrwx 1 root root       13 May 16 13:54 fd -> /proc/self/fd
crw-rw-rw- 1 root root   1,   7 May 16 13:54 full
srwx------ 1 test root        0 May 16 13:55 gpmctl
brw------- 1 test disk  22,   0 May 16 13:54 hdc
crw------- 1 root root  10, 228 May 16 13:54 hpet
prw------- 1 root root        0 May 16 13:55 initctl
drwxr-xr-x 2 root root      200 May 16 13:54 input
crw-r----- 1 root kmem   1,   2 May 16 13:54 kmem
crw------- 1 root root   1,  11 May 16 13:54 kmsg
srw-rw-rw- 1 root root        0 May 16 13:55 log
brw-r----- 1 root disk   7,   0 May 16 13:54 loop0
brw-r----- 1 root disk   7,   1 May 16 13:54 loop1
brw-r----- 1 root disk   7,   2 May 16 13:54 loop2
brw-r----- 1 root disk   7,   3 May 16 13:54 loop3
brw-r----- 1 root disk   7,   4 May 16 13:54 loop4
brw-r----- 1 root disk   7,   5 May 16 13:54 loop5
brw-r----- 1 root disk   7,   6 May 16 13:54 loop6
brw-r----- 1 root disk   7,   7 May 16 13:54 loop7
lrwxrwxrwx 1 root root       13 May 16 13:54 MAKEDEV -> /sbin/MAKEDEV
drwxr-xr-x 2 root root      100 May 16 08:54 mapper
crw------- 1 root root  10, 227 May 16 13:54 mcelog
brw-r----- 1 root disk   9,   0 May 16 13:54 md0
crw-r----- 1 root kmem   1,   1 May 16 13:54 mem
crw------- 1 test root  14,   0 May 16 13:54 mixer
drwxr-xr-x 2 root root       60 May 16 13:54 net
crw-rw-rw- 1 root root   1,   3 May 16 13:54 null
crw-rw---- 1 root root  10, 144 May 16 13:54 nvram
crw-rw---- 1 root lp    99,   0 May 16 13:54 parport0
crw-rw---- 1 root lp    99,   1 May 16 13:54 parport1
crw-rw---- 1 root lp    99,   2 May 16 13:54 parport2
crw-rw---- 1 root lp    99,   3 May 16 13:54 parport3
crw-r----- 1 root kmem   1,   4 May 16 13:54 port
crw------- 1 root root 108,   0 May 16 13:54 ppp
crw-rw-rw- 1 root tty    5,   2 May 16 14:07 ptmx
drwxr-xr-x 2 root root        0 May 16 08:54 pts
lrwxrwxrwx 1 root root        4 May 16 13:54 ram -> ram1
brw-r----- 1 root disk   1,   0 May 16 08:54 ram0
brw-r----- 1 root disk   1,   1 May 16 08:54 ram1
brw-r----- 1 root disk   1,  10 May 16 08:54 ram10
brw-r----- 1 root disk   1,  11 May 16 08:54 ram11
brw-r----- 1 root disk   1,  12 May 16 08:54 ram12
brw-r----- 1 root disk   1,  13 May 16 08:54 ram13
brw-r----- 1 root disk   1,  14 May 16 08:54 ram14
brw-r----- 1 root disk   1,  15 May 16 08:54 ram15
brw-r----- 1 root disk   1,   2 May 16 08:54 ram2
brw-r----- 1 root disk   1,   3 May 16 08:54 ram3
brw-r----- 1 root disk   1,   4 May 16 08:54 ram4
brw-r----- 1 root disk   1,   5 May 16 08:54 ram5
brw-r----- 1 root disk   1,   6 May 16 08:54 ram6
brw-r----- 1 root disk   1,   7 May 16 08:54 ram7
brw-r----- 1 root disk   1,   8 May 16 08:54 ram8
brw-r----- 1 root disk   1,   9 May 16 08:54 ram9
lrwxrwxrwx 1 root root        4 May 16 13:54 ramdisk -> ram0
crw-rw-rw- 1 root root   1,   8 May 16 13:54 random
brw------- 1 root root 253,   0 May 16 08:54 root
crw-r--r-- 1 root root  10, 135 May 16 08:54 rtc
brw-r----- 1 root disk   8,   0 May 16 08:54 sda
brw-r----- 1 root disk   8,   1 May 16 13:55 sda1
brw-r----- 1 root disk   8,   2 May 16 08:54 sda2
brw-r----- 1 root disk   8,  16 May 16 13:54 sdb
brw-r----- 1 root disk   8,  17 May 16 13:54 sdb1
brw-r----- 1 root disk   8,  32 May 16 13:54 sdc
brw-r----- 1 root disk   8,  33 May 16 13:54 sdc1
brw-r----- 1 root disk   8,  48 May 16 13:54 sdd
brw-r----- 1 root disk   8,  49 May 16 13:54 sdd1
brw-r----- 1 root disk   8,  64 May 16 13:54 sde
brw-r----- 1 root disk   8,  65 May 16 13:54 sde1
brw-r----- 1 root disk   8,  80 May 16 13:54 sdf
brw-r----- 1 root disk   8,  81 May 16 13:54 sdf1
brw-r----- 1 root disk   8,  96 May 16 13:54 sdg
brw-r----- 1 root disk   8,  97 May 16 13:54 sdg1
brw-r----- 1 root disk   8, 112 May 16 13:54 sdh
brw-r----- 1 root disk   8, 113 May 16 13:54 sdh1
brw-r----- 1 root disk   8, 128 May 16 13:54 sdi
brw-r----- 1 root disk   8, 144 May 16 13:54 sdj
brw-r----- 1 root disk   8, 160 May 16 13:54 sdk
brw-r----- 1 root disk   8, 176 May 16 13:54 sdl
crw------- 1 test root  14,   1 May 16 13:54 sequencer
crw------- 1 test root  14,   8 May 16 13:54 sequencer2
crw------- 1 root root  21,   0 May 16 13:54 sg0
crw------- 1 root root  21,   1 May 16 13:54 sg1
crw------- 1 root root  21,  10 May 16 13:54 sg10
crw------- 1 root root  21,  11 May 16 13:54 sg11
crw------- 1 root root  21,   2 May 16 13:54 sg2
crw------- 1 root root  21,   3 May 16 13:54 sg3
crw------- 1 root root  21,   4 May 16 13:54 sg4
crw------- 1 root root  21,   5 May 16 13:54 sg5
crw------- 1 root root  21,   6 May 16 13:54 sg6
crw------- 1 root root  21,   7 May 16 13:54 sg7
crw------- 1 root root  21,   8 May 16 13:54 sg8
crw------- 1 root root  21,   9 May 16 13:54 sg9
drwxrwxrwt 2 root root       40 May 16 13:55 shm
crw------- 1 root root  10, 231 May 16 13:54 snapshot
drwxr-xr-x 2 root root      180 May 16 13:54 snd
lrwxrwxrwx 1 root root       15 May 16 13:54 stderr -> /proc/self/fd/2
lrwxrwxrwx 1 root root       15 May 16 13:54 stdin -> /proc/self/fd/0
lrwxrwxrwx 1 root root       15 May 16 13:54 stdout -> /proc/self/fd/1
crw------- 1 root root   4,   0 May 16 08:54 systty
crw-rw-rw- 1 root tty    5,   0 May 16 13:54 tty
crw-rw---- 1 root root   4,   0 May 16 08:54 tty0
crw------- 1 root root   4,   1 May 16 13:55 tty1
crw-rw---- 1 root tty    4,  10 May 16 08:54 tty10
crw-rw---- 1 root tty    4,  11 May 16 08:54 tty11
crw-rw---- 1 root tty    4,  12 May 16 08:54 tty12
crw-rw---- 1 root tty    4,  13 May 16 13:54 tty13
crw-rw---- 1 root tty    4,  14 May 16 13:54 tty14
crw-rw---- 1 root tty    4,  15 May 16 13:54 tty15
crw-rw---- 1 root tty    4,  16 May 16 13:54 tty16
crw-rw---- 1 root tty    4,  17 May 16 13:54 tty17
crw-rw---- 1 root tty    4,  18 May 16 13:54 tty18
crw-rw---- 1 root tty    4,  19 May 16 13:54 tty19
crw------- 1 root root   4,   2 May 16 13:55 tty2
crw-rw---- 1 root tty    4,  20 May 16 13:54 tty20
crw-rw---- 1 root tty    4,  21 May 16 13:54 tty21
crw-rw---- 1 root tty    4,  22 May 16 13:54 tty22
crw-rw---- 1 root tty    4,  23 May 16 13:54 tty23
crw-rw---- 1 root tty    4,  24 May 16 13:54 tty24
crw-rw---- 1 root tty    4,  25 May 16 13:54 tty25
crw-rw---- 1 root tty    4,  26 May 16 13:54 tty26
crw-rw---- 1 root tty    4,  27 May 16 13:54 tty27
crw-rw---- 1 root tty    4,  28 May 16 13:54 tty28
crw-rw---- 1 root tty    4,  29 May 16 13:54 tty29
crw------- 1 root root   4,   3 May 16 13:55 tty3
crw-rw---- 1 root tty    4,  30 May 16 13:54 tty30
crw-rw---- 1 root tty    4,  31 May 16 13:54 tty31
crw-rw---- 1 root tty    4,  32 May 16 13:54 tty32
crw-rw---- 1 root tty    4,  33 May 16 13:54 tty33
crw-rw---- 1 root tty    4,  34 May 16 13:54 tty34
crw-rw---- 1 root tty    4,  35 May 16 13:54 tty35
crw-rw---- 1 root tty    4,  36 May 16 13:54 tty36
crw-rw---- 1 root tty    4,  37 May 16 13:54 tty37
crw-rw---- 1 root tty    4,  38 May 16 13:54 tty38
crw-rw---- 1 root tty    4,  39 May 16 13:54 tty39
crw------- 1 root root   4,   4 May 16 13:55 tty4
crw-rw---- 1 root tty    4,  40 May 16 13:54 tty40
crw-rw---- 1 root tty    4,  41 May 16 13:54 tty41
crw-rw---- 1 root tty    4,  42 May 16 13:54 tty42
crw-rw---- 1 root tty    4,  43 May 16 13:54 tty43
crw-rw---- 1 root tty    4,  44 May 16 13:54 tty44
crw-rw---- 1 root tty    4,  45 May 16 13:54 tty45
crw-rw---- 1 root tty    4,  46 May 16 13:54 tty46
crw-rw---- 1 root tty    4,  47 May 16 13:54 tty47
crw-rw---- 1 root tty    4,  48 May 16 13:54 tty48
crw-rw---- 1 root tty    4,  49 May 16 13:54 tty49
crw------- 1 root root   4,   5 May 16 13:55 tty5
crw-rw---- 1 root tty    4,  50 May 16 13:54 tty50
crw-rw---- 1 root tty    4,  51 May 16 13:54 tty51
crw-rw---- 1 root tty    4,  52 May 16 13:54 tty52
crw-rw---- 1 root tty    4,  53 May 16 13:54 tty53
crw-rw---- 1 root tty    4,  54 May 16 13:54 tty54
crw-rw---- 1 root tty    4,  55 May 16 13:54 tty55
crw-rw---- 1 root tty    4,  56 May 16 13:54 tty56
crw-rw---- 1 root tty    4,  57 May 16 13:54 tty57
crw-rw---- 1 root tty    4,  58 May 16 13:54 tty58
crw-rw---- 1 root tty    4,  59 May 16 13:54 tty59
crw------- 1 root root   4,   6 May 16 13:55 tty6
crw-rw---- 1 root tty    4,  60 May 16 13:54 tty60
crw-rw---- 1 root tty    4,  61 May 16 13:54 tty61
crw-rw---- 1 root tty    4,  62 May 16 13:54 tty62
crw-rw---- 1 root tty    4,  63 May 16 13:54 tty63
crw-rw---- 1 root root   4,   7 May 16 08:54 tty7
crw-rw---- 1 root tty    4,   8 May 16 13:54 tty8
crw-rw---- 1 root tty    4,   9 May 16 08:54 tty9
crw-rw---- 1 root uucp   4,  64 May 16 08:54 ttyS0
crw-rw---- 1 root uucp   4,  65 May 16 08:54 ttyS1
crw-rw---- 1 root uucp   4,  66 May 16 08:54 ttyS2
crw-rw---- 1 root uucp   4,  67 May 16 08:54 ttyS3
cr--r--r-- 1 root root   1,   9 May 16 13:55 urandom
crw------- 1 root root 189,   0 May 16 13:54 usb1
crw------- 1 root root 189, 128 May 16 13:54 usb2
crw------- 1 root root 252,   0 May 16 13:54 usbdev1.1_ep00
crw------- 1 root root 252,   1 May 16 13:54 usbdev1.1_ep81
crw------- 1 root root 252,  27 May 16 13:54 usbdev1.2_ep00
crw------- 1 root root 252,  28 May 16 13:54 usbdev1.2_ep81
crw------- 1 root root 252,  29 May 16 13:54 usbdev1.3_ep00
crw------- 1 root root 252,  30 May 16 13:54 usbdev1.3_ep01
crw------- 1 root root 252,  31 May 16 13:54 usbdev1.3_ep82
crw------- 1 root root 252,  21 May 16 13:54 usbdev2.10_ep00
crw------- 1 root root 252,  22 May 16 13:54 usbdev2.10_ep02
crw------- 1 root root 252,  23 May 16 13:54 usbdev2.10_ep88
crw------- 1 root root 252,  24 May 16 13:54 usbdev2.11_ep00
crw------- 1 root root 252,  25 May 16 13:54 usbdev2.11_ep01
crw------- 1 root root 252,  26 May 16 13:54 usbdev2.11_ep82
crw------- 1 root root 252,  32 May 16 14:05 usbdev2.12_ep00
crw------- 1 root root 252,  34 May 16 14:05 usbdev2.12_ep02
crw------- 1 root root 252,  33 May 16 14:05 usbdev2.12_ep81
crw------- 1 root root 252,  35 May 16 14:05 usbdev2.12_ep83
crw------- 1 root root 252,   2 May 16 13:54 usbdev2.1_ep00
crw------- 1 root root 252,   3 May 16 13:54 usbdev2.1_ep81
crw------- 1 root root 252,   4 May 16 13:54 usbdev2.2_ep00
crw------- 1 root root 252,   5 May 16 13:54 usbdev2.2_ep02
crw------- 1 root root 252,   6 May 16 13:54 usbdev2.2_ep86
crw------- 1 root root 252,   7 May 16 13:54 usbdev2.3_ep00
crw------- 1 root root 252,   8 May 16 13:54 usbdev2.3_ep81
crw------- 1 root root 252,   9 May 16 13:54 usbdev2.4_ep00
crw------- 1 root root 252,  10 May 16 13:54 usbdev2.4_ep02
crw------- 1 root root 252,  11 May 16 13:54 usbdev2.4_ep86
crw------- 1 root root 252,  12 May 16 13:54 usbdev2.5_ep00
crw------- 1 root root 252,  13 May 16 13:54 usbdev2.5_ep02
crw------- 1 root root 252,  14 May 16 13:54 usbdev2.5_ep86
crw------- 1 root root 252,  15 May 16 13:54 usbdev2.7_ep00
crw------- 1 root root 252,  16 May 16 13:54 usbdev2.7_ep02
crw------- 1 root root 252,  17 May 16 13:54 usbdev2.7_ep86
crw------- 1 root root 252,  18 May 16 13:54 usbdev2.9_ep00
crw------- 1 root root 252,  19 May 16 13:54 usbdev2.9_ep02
crw------- 1 root root 252,  20 May 16 13:54 usbdev2.9_ep86
crw------- 1 vcsa tty    7,   0 May 16 13:54 vcs
crw------- 1 vcsa tty    7,   1 May 16 13:55 vcs1
crw------- 1 vcsa tty    7,   2 May 16 13:55 vcs2
crw------- 1 vcsa tty    7,   3 May 16 13:55 vcs3
crw------- 1 vcsa tty    7,   4 May 16 13:55 vcs4
crw------- 1 vcsa tty    7,   5 May 16 13:55 vcs5
crw------- 1 vcsa tty    7,   6 May 16 13:55 vcs6
crw------- 1 vcsa tty    7,   7 May 16 13:55 vcs7
crw------- 1 vcsa tty    7, 128 May 16 13:54 vcsa
crw------- 1 vcsa tty    7, 129 May 16 13:55 vcsa1
crw------- 1 vcsa tty    7, 130 May 16 13:55 vcsa2
crw------- 1 vcsa tty    7, 131 May 16 13:55 vcsa3
crw------- 1 vcsa tty    7, 132 May 16 13:55 vcsa4
crw------- 1 vcsa tty    7, 133 May 16 13:55 vcsa5
crw------- 1 vcsa tty    7, 134 May 16 13:55 vcsa6
crw------- 1 vcsa tty    7, 135 May 16 13:55 vcsa7
drwx------ 2 root root       80 May 16 08:54 VolGroup00
lrwxrwxrwx 1 root root        4 May 16 13:54 X0R -> null
crw-rw-rw- 1 root root   1,   5 May 16 13:54 zero


--------------------------------------- 2.6.21 -disconnect

UEVENT[1179342515.567479] remove@/class/usb_endpoint/usbdev2.12_ep81
UEVENT[1179342515.567530] remove@/class/usb_endpoint/usbdev2.12_ep02
UEVENT[1179342515.567545] remove@/class/usb_endpoint/usbdev2.12_ep83
UEVENT[1179342515.567659]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UEVENT[1179342515.567695] remove@/class/usb_endpoint/usbdev2.12_ep00
UEVENT[1179342515.567712]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2
UDEV  [1179342515.582791] remove@/class/usb_endpoint/usbdev2.12_ep81
UDEV  [1179342515.593420] remove@/class/usb_endpoint/usbdev2.12_ep02
UDEV  [1179342515.625094] remove@/class/usb_endpoint/usbdev2.12_ep83
UDEV  [1179342515.626044]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2/2-2.2:1.0
UDEV  [1179342515.628889] remove@/class/usb_endpoint/usbdev2.12_ep00
UDEV  [1179342515.854630]  
remove@/devices/pci0000:00/0000:00:0b.1/usb2/2-2/2-2.2


xboom


