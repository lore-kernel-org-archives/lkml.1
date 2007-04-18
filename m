Return-Path: <linux-kernel-owner+w=401wt.eu-S1422744AbXDRJm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422744AbXDRJm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 05:42:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422745AbXDRJm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 05:42:26 -0400
Received: from mail10.tpgi.com.au ([203.12.160.147]:40402 "EHLO
	mail10.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422740AbXDRJmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 05:42:08 -0400
X-Greylist: delayed 2938 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 05:42:08 EDT
X-TPG-Antivirus: Passed
Date: Wed, 18 Apr 2007 18:49:23 +1000
From: Will Trives <will@trivescon.com.au>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] libata: add Samsung HD401LJ to the NCQ blacklist
Message-ID: <20070418184923.4f71f35c@disher.kickcrew>
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Yet another hard drive which doesn't seem to get NCQ right.


I have a Samsung 400LJ that appears to work fine with NCQ on an Intel
965 chipset motherboard (Asus P5B) and Linux kernel 2.6.20.7.

Dmesg Output :

scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7, max UDMA7, 781422768 sectors: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133

sd 0:0:0:0: Attached scsi disk sda
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD400LJ  ZZ10 PQ: 0 ANSI: 5
SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
SCSI device sdb: 781422768 512-byte hdwr sectors (400088 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO
or FUA
 sdb: sdb1 sdb2


Regards,

Will Trives
