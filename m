Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbYBSHCQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbYBSHCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 02:02:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbYBSHCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 02:02:06 -0500
Received: from [90.184.2.114] ([90.184.2.114]:17314 "EHLO mail.jaquet.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754053AbYBSHCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 02:02:05 -0500
Date: Tue, 19 Feb 2008 08:02:02 +0100
From: Rasmus Andersen <rasmus@avlebavle.dk>
To: linux-kernel@vger.kernel.org
Subject: LILO fatal error after going from 2.6.22 to 2.6.24.2
Message-ID: <20080219070201.GA7353@avlebavle.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have just upgraded from 2.6.22 to 2.6.24.2 and after booting into the
new kernel and seeing that everything went right, I wanted to make the
new kernel the default boot kernel. But running LILO I got

   Fatal: Linux experimental device 0x04x needs to be defined.
   Check 'man lilo.conf' under 'disk=' and 'max-partitions='

(Full output from lilo -v 5 below). Apart from setting 2.6.24.2 as
default this is the same lilo config as 2.6.22 was able to write fine.
Can anyone tell me what I (or the kernel) am/is doing wrong?

Thanks,
  Rasmus



LILO version 22.7.3, Copyright (C) 1992-1998 Werner Almesberger
Development beyond version 21 Copyright (C) 1999-2006 John Coffman
Released 11-Aug-2006 and compiled at 17:06:40 on Jan 17 2007

raid_setup: dev=000C  rdev=0340
raid_setup returns offset = 00000000  ndisk = 0
 BIOS   VolumeID   Device
Reading boot sector from /dev/hdb
geo_get: device 0340, all=1
pf_hard_disk_scan: (7,0) /dev/loop0
pf_hard_disk_scan: (3,64) /dev/hdb
pf_hard_disk_scan: (3,65) /dev/hdb1
lookup_dev:  number=0340
lookup_dev:  number=0340
pf:  dev=0340  id=B661B661  name=/dev/hdb
geo_query_dev: device=0340
lookup_dev:  number=0340
exit geo_query_dev
bios_dev:  device 0340
lookup_dev:  number=0340
bios_dev:  masked device 0340, which is /dev/hdb
bios_dev: geometry check found 0 matches
bios_dev: (0x82)  vol-ID=17FF01F9  *PT=08070AD0
bios_dev: (0x81)  vol-ID=7C4DC2CA  *PT=08070A88
bios_dev: (0x80)  vol-ID=B661B661  *PT=08070A40
bios_dev: PT match found 1 match (0x80)
pf_hard_disk_scan: (3,66) /dev/hdb2
pf_hard_disk_scan: (8,0) /dev/sda
pf_hard_disk_scan: (8,1) /dev/sda1
lookup_dev:  number=0800
lookup_dev:  number=0800
pf:  dev=0800  id=7C4DC2CA  name=/dev/sda
geo_query_dev: device=0800
lookup_dev:  number=0800
lookup_dev:  number=0300
exit geo_query_dev
bios_dev:  device 0800
lookup_dev:  number=0800
bios_dev:  masked device 0800, which is /dev/sda
bios_dev: geometry check found 0 matches
bios_dev: (0x82)  vol-ID=17FF01F9  *PT=08070AD0
bios_dev: (0x81)  vol-ID=7C4DC2CA  *PT=08070A88
bios_dev: (0x80)  vol-ID=B661B661  *PT=08070A40
bios_dev: PT match found 1 match (0x81)
pf_hard_disk_scan: (8,16) /dev/sdb
pf_hard_disk_scan: (8,17) /dev/sdb1
lookup_dev:  number=0810
lookup_dev:  number=0810
pf:  dev=0810  id=17FF01F9  name=/dev/sdb
geo_query_dev: device=0810
lookup_dev:  number=0810
lookup_dev:  number=0300
exit geo_query_dev
bios_dev:  device 0810
lookup_dev:  number=0810
bios_dev:  masked device 0810, which is /dev/sdb
bios_dev: geometry check found 0 matches
bios_dev: (0x82)  vol-ID=17FF01F9  *PT=08070AD0
bios_dev: (0x81)  vol-ID=7C4DC2CA  *PT=08070A88
bios_dev: (0x80)  vol-ID=B661B661  *PT=08070A40
bios_dev: PT match found 1 match (0x81)
pf_hard_disk_scan: (9,0) /dev/md0
pf_hard_disk_scan: (253,0) /dev/dm-0
Caching device /dev/dm-0 (0xFD00)
pf_hard_disk_scan: (253,1) /dev/dm-1
Caching device /dev/dm-1 (0xFD01)
pf_hard_disk_scan: (253,2) /dev/dm-2
Caching device /dev/dm-2 (0xFD02)
pf_hard_disk_scan: (253,3) /dev/dm-3
Caching device /dev/dm-3 (0xFD03)
pf_hard_disk_scan: (253,4) /dev/dm-4
Caching device /dev/dm-4 (0xFD04)
pf_hard_disk_scan: (253,5) /dev/dm-5
Caching device /dev/dm-5 (0xFD05)
pf_hard_disk_scan: (253,6) /dev/dm-6
Caching device /dev/dm-6 (0xFD06)
  0340  B661B661  /dev/hdb
  0800  7C4DC2CA  /dev/sda
  0810  17FF01F9  /dev/sdb
pf_hard_disk_scan: ndevs=3
  0340  B661B661  /dev/hdb
  0800  7C4DC2CA  /dev/sda
  0810  17FF01F9  /dev/sdb
Resolve invalid VolumeIDs
Resolve duplicate VolumeIDs
  0340  B661B661  /dev/hdb
  0800  7C4DC2CA  /dev/sda
  0810  17FF01F9  /dev/sdb
device codes (user assigned pf) = 0
device codes (user assigned) = 0
device codes (BIOS assigned) = 3
Filling in '/dev/sdb' = 0x82
device codes (canonical) = 7
geo_query_dev: device=0340
lookup_dev:  number=0340
exit geo_query_dev
bios_dev:  device 0340
lookup_dev:  number=0340
bios_dev:  masked device 0340, which is /dev/hdb
bios_dev: geometry check found 0 matches
bios_dev: (0x82)  vol-ID=17FF01F9  *PT=08070AD0
bios_dev: (0x81)  vol-ID=7C4DC2CA  *PT=08070A88
bios_dev: (0x80)  vol-ID=B661B661  *PT=08070A40
bios_dev: PT match found 1 match (0x80)
Device 0x0340: BIOS drive 0x80, 255 heads, 9729 cylinders,
               63 sectors. Partition offset: 0 sectors.
registering bios=0x80  device=0x0340
Using Volume ID B661B661 on bios 80
geo_get: device FD06, all=1
geo_query_dev: device=FD06
lookup_dev:  number=FD06
Fatal: Linux experimental device 0x04x needs to be defined.
Check 'man lilo.conf' under 'disk=' and 'max-partitions='
