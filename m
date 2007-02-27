Return-Path: <linux-kernel-owner+w=401wt.eu-S1751740AbXB0O1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751740AbXB0O1R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 09:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXB0O1R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 09:27:17 -0500
Received: from ip-svs-1.Informatik.Uni-Oldenburg.DE ([134.106.12.126]:45721
	"EHLO schlidder.svs.informatik.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbXB0O1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 09:27:15 -0500
X-Greylist: delayed 1713 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Feb 2007 09:27:15 EST
Date: Tue, 27 Feb 2007 14:58:38 +0100
From: Philipp Matthias Hahn <pmhahn@titan.lahn.de>
To: linux-ide@vger.kernel.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATA] Failed to set xfermode on LITE-ON LTR-48246S
Message-ID: <20070227135838.GA4328@titan.lahn.de>
Mail-Followup-To: linux-ide@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702041057090.8424@woody.linux-foundation.org>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

As reported by John Williams and others like in
http://www.mail-archive.com/linux-ide@vger.kernel.org/msg03088.html
I too have a problem with 2.6.20.1 using ata_piix not detecting the
CD-ROM any more. Applying the patch from
http://lkml.org/lkml/2007/2/12/24 did not help, but additionally
applying
http://readlist.com/lists/vger.kernel.org/linux-kernel/45/228948.html
made it work. Here's the relevant extra debugging output:

ata_piix 0000:00:1f.1: version 2.00ac7
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata1: PATA max UDMA/100 cmd 0x1F0 ctl 0x3F6 bmdma 0x2800 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x2808 irq 15
scsi0 : ata_piix
ata1.00: ATA-7, max UDMA/133, 160086528 sectors: LBA
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/100
scsi1 : ata_piix
ata2.00: ATAPI, max UDMA/33
ata2: ata_altstatus take 4us
ata2.00: configured for UDMA/33
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 160086528 512-byte hdwr sectors (81964 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 sda12 > sda4
 sd 0:0:0:0: Attached scsi disk sda
 scsi 1:0:0:0: CD-ROM            LITE-ON  LTR-48246S       SID4 PQ: 0 ANSI: 5
 sr0: scsi3-mmc drive: 230x/48x writer cd/rw xa/form2 cdda tray
 Uniform CD-ROM driver Revision: 3.20
 sr 1:0:0:0: Attached scsi CD-ROM sr0

Something other I should try to get this fixed for 2.6.20.2+?

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@titan.lahn.de
