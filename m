Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbZIRRzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbZIRRzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZIRRzt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 13:55:49 -0400
Received: from mail.candelatech.com ([208.74.158.172]:46662 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757411AbZIRRzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 13:55:49 -0400
Message-ID: <4AB3C9A8.4060700@candelatech.com>
Date: Fri, 18 Sep 2009 10:55:52 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Problems booting 2.6.31 on Fedora 8
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm having troubles booting 2.6.31 on Fedora 8.  The same kernel
boots fine on F11, but on F8, it cannot find the root logical volume.

One thing I notice is that F11 uses root=/dev/mapper... and F8 uses
root=/dev/VolGroup00/LogVol00 in grub.  It's not clear to me what
the value of mapper should be...is there some way to figure this
out from an older kernel (2.6.29) that boots fine?

I'm using a kernel config based on the one in F11.

My grub entry looks like:

title SERIAL 2.6.31
         root (hd0,0)
         kernel /ct2.6.31.img ro root=/dev/VolGroup00/LogVol00 console=ttyS0,38400
         initrd /initrd-ct2.6.31.img


sr 0:0:1:0: Attached scsi generic sg0 type 5
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L080M0   BACE PQ: 0 ANSI: 5
registered taskstats version 1
   Magic number: 9:307:694
Initalizing network drop monitor service
sd 2:0:0:0: [sda] 160086528 512-byte logical blocks: (81.9 GB/76.3 GiB)
sd 2:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
  sda: sda1 sda2
sd 2:0:0:0: [sda] Attached SCSI disk
Freeing unused kernel memory: 1292k freed
Write protecting the kernel read-only data: 6036k
Red Hat nash version 6.0.19 starting
Mounting proc filesystem
Mounting sysfs filesystem
Creating /dev
Creating initial device nodes
Sinput: ImExPS/2 Generic Explorer Mouse as /devices/platform/i8042/serio1/input/input4
etting up hotplug.
Creating block device nodes.
Loading pata_acpi.ko module
Waiting for driver initialization.
Loading ata_generic.ko module
Making device-mapper control node
Scanning logical volumes
   Reading all physical volumes.  This may take a while...
   No volume groups found
Activating logical volumes
   Volume group "VolGroup00" not found
Trying to resume from /dev/VolGroup00/LogVol01
Unable to access resume device (/dev/VolGroup00/LogVol01)
Creating root device.
Mounting root filesystem.
mount: could not find filesystem '/dev/root'
Setting up other filesystems.
Setting up new root fs
setuproot: moving /dev failed: No such file or directory
no fstab.sys, mounting internal defaults
setuproot: error mounting /proc: No such file or directory
setuproot: error mounting /sys: No such file or directory
Switching to new root and running init.
unmounting old /dev
unmounting old /proc
unmounting old /sys
switchroot: mount failed: No such file or directory
Booting has failed.


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

