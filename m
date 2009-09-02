Return-Path: <linux-kernel-owner+w=401wt.eu-S1752501AbZIBOP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501AbZIBOP3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 10:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZIBOP2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 10:15:28 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:32576 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbZIBOP1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 10:15:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=fT4tryY02IaeFiEgWM/udVgWgGulpCMVgQqLhZJ+ccxst8V3F5ihAifeniL9EgALsp
         Rib9YwhZzcgHwb++AePGhq0qSHsA45bzIQLLa0FJFHZ4AuxftVjEJvfnVa5sCT691fya
         MumeXLkYgwrAslb8KkK150gwgy2g/lR14j8Nw=
MIME-Version: 1.0
In-Reply-To: <200909021542.11767.oliver@neukum.org>
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
	 <200909021542.11767.oliver@neukum.org>
Date: Wed, 2 Sep 2009 16:15:28 +0200
Message-ID: <8db1092f0909020715g3e6f9815w96efc801cc18e3bc@mail.gmail.com>
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/9/2 Oliver Neukum <oliver@neukum.org>:

> We have to find out where the event is lost. Please run
> "udevadm monitor" and tell us whether you see an event as
> you unplug your device.

Thanks for response.

1. Start monitor:
root@zlom:/home/maciek# udevadm monitor
monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

2. Connect device:
KERNEL[1251900238.630740] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1 (usb)
KERNEL[1251900238.631294] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
UDEV  [1251900238.635817] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1 (usb)
KERNEL[1251900238.658567] add      /module/usb_storage (module)
UDEV  [1251900238.659543] add      /module/usb_storage (module)
KERNEL[1251900238.660124] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
KERNEL[1251900238.660161] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/scsi_host/host4
(scsi_host)
KERNEL[1251900238.660208] add      /bus/usb/drivers/usb-storage (drivers)
UDEV  [1251900238.664418] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
UDEV  [1251900238.666087] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
UDEV  [1251900238.666997] add      /bus/usb/drivers/usb-storage (drivers)
UDEV  [1251900238.667274] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/scsi_host/host4
(scsi_host)
KERNEL[1251900243.666195] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0
(scsi)
KERNEL[1251900243.666298] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0
(scsi)
KERNEL[1251900243.666388] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_disk/4:0:0:0
(scsi_disk)
KERNEL[1251900243.666461] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_device/4:0:0:0
(scsi_device)
KERNEL[1251900243.666564] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_generic/sg2
(scsi_generic)
UDEV  [1251900243.668787] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0
(scsi)
KERNEL[1251900243.669784] change
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0
(scsi)
UDEV  [1251900243.675609] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0
(scsi)
UDEV  [1251900243.675920] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_disk/4:0:0:0
(scsi_disk)
UDEV  [1251900243.679152] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_device/4:0:0:0
(scsi_device)
UDEV  [1251900243.679597] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_generic/sg2
(scsi_generic)
UDEV  [1251900243.681201] change
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0
(scsi)
KERNEL[1251900243.780545] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb
(block)
KERNEL[1251900243.780596] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb/sdb1
(block)
KERNEL[1251900243.780625] add      /devices/virtual/bdi/8:16 (bdi)
UDEV  [1251900243.784615] add      /devices/virtual/bdi/8:16 (bdi)
UDEV  [1251900243.955713] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb
(block)
UDEV  [1251900243.990627] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb/sdb1
(block)

maciek@zlom:~$ lsusb
Bus 005 Device 003: ID 062a:0201 Creative Labs Defender Office
Keyboard (K7310) S Zodiak KM-9010
Bus 005 Device 002: ID 1020:0206 Labtec
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 004: ID 3538:0054 Power Quotient International Co., Ltd
Flash Drive (2GB)
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

3. Disconnect:
KERNEL[1251900287.925502] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_generic/sg2
(scsi_generic)
KERNEL[1251900287.925554] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_device/4:0:0:0
(scsi_device)
KERNEL[1251900287.925604] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_disk/4:0:0:0
(scsi_disk)
KERNEL[1251900287.925680] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb/sdb1
(block)
KERNEL[1251900287.925721] remove   /devices/virtual/bdi/8:16 (bdi)
KERNEL[1251900287.925819] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb
(block)
KERNEL[1251900287.925850] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0
(scsi)
KERNEL[1251900287.925893] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0
(scsi)
KERNEL[1251900287.925944] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/scsi_host/host4
(scsi_host)
KERNEL[1251900287.925994] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
KERNEL[1251900287.926058] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
KERNEL[1251900287.926302] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1 (usb)
UDEV  [1251900287.927833] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_disk/4:0:0:0
(scsi_disk)
UDEV  [1251900287.928827] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_generic/sg2
(scsi_generic)
UDEV  [1251900287.929674] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/scsi_device/4:0:0:0
(scsi_device)
UDEV  [1251900287.936095] remove
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4/target4:0:0/4:0:0:0/block/sdb/sdb1
(block)

maciek@zlom:~$ lsusb
Bus 005 Device 003: ID 062a:0201 Creative Labs Defender Office
Keyboard (K7310) S Zodiak KM-9010
Bus 005 Device 002: ID 1020:0206 Labtec
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

4. Connect again:

KERNEL[1251900489.897750] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1 (usb)
KERNEL[1251900489.897896] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
KERNEL[1251900489.898108] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5 (scsi)
KERNEL[1251900489.898147] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/scsi_host/host5
(scsi_host)
KERNEL[1251900494.900911] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0
(scsi)
KERNEL[1251900494.900974] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0
(scsi)
KERNEL[1251900494.901005] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0/scsi_disk/5:0:0:0
(scsi_disk)
KERNEL[1251900494.901040] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0/scsi_device/5:0:0:0
(scsi_device)
KERNEL[1251900494.901074] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0/scsi_generic/sg2
(scsi_generic)
KERNEL[1251900494.904546] change
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0
(scsi)
KERNEL[1251900495.015049] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0/block/sdb
(block)
KERNEL[1251900495.015133] add
/devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host5/target5:0:0/5:0:0:0/block/sdb/sdb1
(block)
KERNEL[1251900495.015237] add      /devices/virtual/bdi/8:16 (bdi)

maciek@zlom:~$ lsusb
Bus 005 Device 003: ID 062a:0201 Creative Labs Defender Office
Keyboard (K7310) S Zodiak KM-9010
Bus 005 Device 002: ID 1020:0206 Labtec
Bus 005 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 002 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

>
>        HTH
>                Oliver
>
>

Regards

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
