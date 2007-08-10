Return-Path: <linux-kernel-owner+w=401wt.eu-S935427AbXHJMR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935427AbXHJMR3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 08:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758196AbXHJMRW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 08:17:22 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:47509 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbXHJMRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 08:17:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=AgewRlWHD1N4xY6tiJ2e2g4wcDZUTjeNEbhyZZDisZ27riNis8+Zmm+hNN6u8ZdYA8z7b4yzfBGdMK5PgnPiX2yqDk9y0CeYB7kupDs/CbHldolllg9QLfMqOPS2sOuwbNhOoXZ8fUG4Vmnki8B1oH5GYX7723xX+ppX1mJWNIs=
Message-ID: <2e1f41c80708100517y736b8cd7xaebed333a0748a3@mail.gmail.com>
Date: Fri, 10 Aug 2007 17:47:19 +0530
From: Jegadeesh <kovaiteam@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Partition information lost on reboot.
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a scsi disk on Adaptec ASC-29320 U320. I have created a linux
partition and ext3 filesystem over it.
Now the problem is, whenever the machine is rebooted, the partition
information to the OS is lost and I get an error saying it as a not valid
block device.
But fdisk tool shows the partitions, but "cat /proc/partitions" doesnt have
this. I need to do a "partprobe" and then have to mount it explicitly.

What could be causing this problem. Given below are some of the command
outputs.

# uname -a
Linux pr.vionline.net 2.6.18-1.2798.fc6 #1 SMP Mon Oct 16 14:37:32 EDT 2006
i686 i686 i386 GNU/Linux

# mount /dev/sda1 /disk1
mount: /dev/sda1 is not a valid block device

# fdisk -l /dev/sda

Disk /dev/sda: 73.4 GB, 73407900160 bytes
255 heads, 63 sectors/track, 8924 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Device Boot Start End Blocks Id System
/dev/sda1 1 7417 59577021 83 Linux
/dev/sda2 7418 8924 12104977+ 83 Linux

# cat /proc/partitions
major minor #blocks name

3 0 60051600 hda
3 1 409626 hda1
3 2 10482412 hda2
3 3 10482412 hda3
3 4 1 hda4
3 5 10482381 hda5
3 6 2096451 hda6
3 7 2096451 hda7
3 8 2096451 hda8
8 0 71687402 sda

Thanks
-Jag
