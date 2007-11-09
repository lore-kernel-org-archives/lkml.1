Return-Path: <linux-kernel-owner+w=401wt.eu-S1763650AbXKIPgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763650AbXKIPgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 10:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763443AbXKIPgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 10:36:18 -0500
Received: from beatrix.usno.navy.mil ([198.116.61.254]:18353 "EHLO
	ad.usno.navy.mil" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763585AbXKIPgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 10:36:08 -0500
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2007 10:36:07 EST
Message-ID: <473479B3.90300@navy.mil>
Date: Fri, 09 Nov 2007 10:16:03 -0500
From: Greg Hennessy <greg.hennessy@navy.mil>
Reply-To: gsh@usno.navy.mil
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: only 1 disk of 5 in port multiplier setup is recognized
Content-Type: multipart/mixed;
 boundary="------------060308050405080203050303"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060308050405080203050303
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I have a silicon image 3124 based pci card that is port multiplier
compatible (it works fine under win xp) that is only showing one of 5
attached drives when attached to a Redhat 5 computer, with both
2.6.18-8.1.15.el5 and 2.6.23.1. The SATA link shows as up for the one
recognized drive, the other four drives show the link down.Any
sugguestions as to what may be the problem? I'm using the sata_sil24
driver.

A subset of what I consider the relavant portion of dmesg for the
 2.6.18-8.1.15.el5 kernel is:
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x2f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pmp pio slum part ata1: SATA max
UDMA/133 cmd 0xF882C100 ctl 0x0 bmdma 0x0 irq 233
ata2: SATA max UDMA/133 cmd 0xF882C180 ctl 0x0 bmdma 0x0 irq 233
ata3: SATA max UDMA/133 cmd 0xF882C200 ctl 0x0 bmdma 0x0 irq 233
ata4: SATA max UDMA/133 cmd 0xF882C280 ctl 0x0 bmdma 0x0 irq 233
ata5: SATA max UDMA/133 cmd 0xF882C300 ctl 0x0 bmdma 0x0 irq 233
ata6: SATA max UDMA/133 cmd 0xF882C380 ctl 0x0 bmdma 0x0 irq 233
scsi0 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 488281250 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7, max UDMA/133, 488281250 sectors: LBA48 NCQ (depth 31/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATAPI, max UDMA/100
ata3.00: configured for UDMA/100
scsi3 : ahci
ata4: SATA link down (SStatus 4 SControl 300)
scsi4 : ahci
ata5: SATA link down (SStatus 0 SControl 0)
scsi5 : ahci
ata6: SATA link down (SStatus 4 SControl 300)
 Vendor: ATA       Model: Hitachi HDT72502  Rev: V5DO
 Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 488281250 512-byte hdwr sectors (250000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
SCSI device sda: 488281250 512-byte hdwr sectors (250000 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: drive cache: write back
sda: sda1
sd 0:0:0:0: Attached scsi disk sda
 Vendor: ATA       Model: Hitachi HDT72502  Rev: V5DO
 Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 488281250 512-byte hdwr sectors (250000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
SCSI device sdb: 488281250 512-byte hdwr sectors (250000 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: drive cache: write back
sdb: sdb1
sd 1:0:0:0: Attached scsi disk sdb
 Vendor: PBDS      Model: DVD+-RW DH-16W1S  Rev: 2D14
 Type:   CD-ROM                             ANSI SCSI revision: 05
sata_sil24 0000:03:02.0: version 0.3
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 18 (level, low) -> IRQ 217
ata7: SATA max UDMA/100 cmd 0xF8840000 ctl 0x0 bmdma 0x0 irq 217
ata8: SATA max UDMA/100 cmd 0xF8842000 ctl 0x0 bmdma 0x0 irq 217
ata9: SATA max UDMA/100 cmd 0xF8844000 ctl 0x0 bmdma 0x0 irq 217
ata10: SATA max UDMA/100 cmd 0xF8846000 ctl 0x0 bmdma 0x0 irq 217
scsi6 : sata_sil24
ata7: SATA link down (SStatus 0 SControl 300)
scsi7 : sata_sil24
ata8: SATA link down (SStatus 0 SControl 300)
scsi8 : sata_sil24
ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata9.00: ATA-7, max UDMA/133, 1953525168 sectors: LBA48 NCQ (depth 31/32)
ata9.00: ata9: dev 0 multi count 16
ata9.00: configured for UDMA/100
scsi9 : sata_sil24
ata10: SATA link down (SStatus 0 SControl 300)
 Vendor: ATA       Model: Hitachi HDS72101  Rev: GKAO
 Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 1953525168 512-byte hdwr sectors (1000205 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
SCSI device sdc: 1953525168 512-byte hdwr sectors (1000205 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: drive cache: write back
sdc: sdc1
sd 8:0:0:0: Attached scsi disk sdc

[root@localhost ~]# fdisk -l

Disk /dev/sda: 250.0 GB, 250000000000 bytes
255 heads, 63 sectors/track, 30394 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
  Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1       30394   244139773+  83  Linux

Disk /dev/sdb: 250.0 GB, 250000000000 bytes
255 heads, 63 sectors/track, 30394 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

  Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1       30394   244139773+  83  Linux

WARNING: GPT (GUID Partition Table) detected on '/dev/sdc'! The util fdisk doesn
't support GPT. Use GNU Parted.


Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
256 heads, 63 sectors/track, 121126 cylinders
Units = cylinders of 16128 * 512 = 8257536 bytes

  Device Boot      Start         End      Blocks   Id  System
/dev/sdc1               1      121126   976760032+  83  Linux



--------------060308050405080203050303
Content-Type: text/x-vcard; charset=utf-8;
 name="greg.hennessy.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="greg.hennessy.vcf"

begin:vcard
fn:Greg Hennessy
n:Hennessy;Greg
org:USNO;Astrometry Department
adr:;;3450 Mass. Ave. NW;Washington;DC;20392;USA
email;internet:gsh@usno.navy.mil
title:Astronomer
tel;work:(202) 762-1523
tel;fax:(202) 762-1514
url:http://ad.usno.navy.mil/~gsh
version:2.1
end:vcard


--------------060308050405080203050303--
