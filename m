Return-Path: <linux-kernel-owner+w=401wt.eu-S1756846AbXFDPZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846AbXFDPZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 11:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXFDPY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 11:24:58 -0400
Received: from spatial.ca ([66.11.172.77]:12906 "EHLO fawkes.spatial.ca"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750795AbXFDPY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 11:24:57 -0400
X-Greylist: delayed 613 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Jun 2007 11:24:57 EDT
Message-ID: <46642EC7.2050407@spatial.ca>
Date: Mon, 04 Jun 2007 11:24:55 -0400
From: Tom Moore <tmoore@spatial.ca>
Reply-To: tmoore@spatial.ca
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: eSATA errors
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Sanitizer: Advosys mail filter
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I have system running the 2.6.20 kernel, and I am trying to use an eSATA 
disk with it.  The hardware in question is a 'NexStar-3' eSATA 
enclosure, and inside it is a Seagate Barracuda 7200.10 750Gb SATA drive.

I am hooking this up to an ASUS M2N-MX motherboard using the SATA to 
eSATA bracket that comes with the enclosure.

When I boot up the machine the disk is recognized, but it immediately 
has device errors and 'slow to respond' errors.  When I use fdisk to 
write a partition table it seems to give up entirely.  Is this a known 
problem, or is there something I can try?

I am not subscribed to the mailing list so I would appreciate a CC on 
any replies.

Thanks,

Tom

Relevant lines from syslog...

Jun  3 15:33:57 fawkes Uniform Multi-Platform E-IDE driver Revision: 
7.00alpha2
Jun  3 15:33:57 fawkes ide: Assuming 33MHz system bus speed for PIO 
modes; override with idebus=xx
Jun  3 15:33:57 fawkes NFORCE-MCP61: IDE controller at PCI slot 0000:00:06.0
Jun  3 15:33:57 fawkes NFORCE-MCP61: chipset revision 162
Jun  3 15:33:57 fawkes NFORCE-MCP61: not 100% native mode: will probe 
irqs later
Jun  3 15:33:57 fawkes NFORCE-MCP61: BIOS didn't set cable bits 
correctly. Enabling workaround.
Jun  3 15:33:57 fawkes NFORCE-MCP61: 0000:00:06.0 (rev a2) UDMA133 
controller
Jun  3 15:33:57 fawkes ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: 
hda:DMA, hdb:pio
Jun  3 15:33:57 fawkes Probing IDE interface ide0...
Jun  3 15:33:57 fawkes hda: WDC WD2500JB-00GVA0, ATA DISK drive
Jun  3 15:33:57 fawkes ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Jun  3 15:33:57 fawkes Probing IDE interface ide1...
Jun  3 15:33:57 fawkes hda: max request size: 512KiB
Jun  3 15:33:57 fawkes hda: 488397168 sectors (250059 MB) w/8192KiB 
Cache, CHS=30401/255/63<6>hda: hw_config=604d
Jun  3 15:33:57 fawkes , UDMA(100)
Jun  3 15:33:57 fawkes hda: cache flushes supported
Jun  3 15:33:57 fawkes hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
Jun  3 15:33:57 fawkes 3ware Storage Controller device driver for Linux 
v1.26.02.002.
Jun  3 15:33:57 fawkes sata_nv 0000:00:08.0: version 3.2
Jun  3 15:33:57 fawkes ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 22
Jun  3 15:33:57 fawkes ACPI: PCI Interrupt 0000:00:08.0[A] -> Link 
[LSA0] -> GSI 22 (level, low) -> IRQ 18
Jun  3 15:33:57 fawkes PCI: Setting latency timer of device 0000:00:08.0 
to 64
Jun  3 15:33:57 fawkes ata1: SATA max UDMA/133 cmd 0xD400 ctl 0xD082 
bmdma 0xC880 irq 18
Jun  3 15:33:57 fawkes ata2: SATA max UDMA/133 cmd 0xD000 ctl 0xCC02 
bmdma 0xC888 irq 18
Jun  3 15:33:57 fawkes scsi0 : sata_nv
Jun  3 15:33:57 fawkes ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)
Jun  3 15:33:57 fawkes ata1.00: ATA-7, max UDMA/133, 1465149168 sectors: 
LBA48 NCQ (depth 0/32)
Jun  3 15:33:57 fawkes ata1.00: ata1: dev 0 multi count 16
Jun  3 15:33:57 fawkes ata1.00: configured for UDMA/133
Jun  3 15:33:57 fawkes scsi1 : sata_nv
Jun  3 15:33:57 fawkes ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 
300)
Jun  3 15:33:57 fawkes ata2.00: ATA-7, max UDMA/133, 1465149168 sectors: 
LBA48 NCQ (depth 0/32)
Jun  3 15:33:57 fawkes ata2.00: ata2: dev 0 multi count 16
Jun  3 15:33:57 fawkes ata2.00: configured for UDMA/133
Jun  3 15:33:57 fawkes scsi 0:0:0:0: Direct-Access     ATA      
ST3750640AS      3.AA PQ: 0 ANSI: 5
Jun  3 15:33:57 fawkes SCSI device sda: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sda: Write Protect is off
Jun  3 15:33:57 fawkes sda: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sda: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes SCSI device sda: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sda: Write Protect is off
Jun  3 15:33:57 fawkes sda: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sda: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes sda: sda1 sda2 sda3 sda4 < sda5 >
Jun  3 15:33:57 fawkes sd 0:0:0:0: Attached scsi disk sda
Jun  3 15:33:57 fawkes sd 0:0:0:0: Attached scsi generic sg0 type 0
Jun  3 15:33:57 fawkes scsi 1:0:0:0: Direct-Access     ATA      
ST3750640AS      3.AA PQ: 0 ANSI: 5
Jun  3 15:33:57 fawkes SCSI device sdb: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sdb: Write Protect is off
Jun  3 15:33:57 fawkes sdb: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sdb: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes SCSI device sdb: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sdb: Write Protect is off
Jun  3 15:33:57 fawkes sdb: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sdb: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes sdb: sdb1
Jun  3 15:33:57 fawkes sd 1:0:0:0: Attached scsi disk sdb
Jun  3 15:33:57 fawkes sd 1:0:0:0: Attached scsi generic sg1 type 0
Jun  3 15:33:57 fawkes ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 21
Jun  3 15:33:57 fawkes ACPI: PCI Interrupt 0000:00:08.1[B] -> Link 
[LSA1] -> GSI 21 (level, low) -> IRQ 19
Jun  3 15:33:57 fawkes PCI: Setting latency timer of device 0000:00:08.1 
to 64
Jun  3 15:33:57 fawkes ata3: SATA max UDMA/133 cmd 0xC800 ctl 0xC482 
bmdma 0xC000 irq 19
Jun  3 15:33:57 fawkes ata4: SATA max UDMA/133 cmd 0xC400 ctl 0xC082 
bmdma 0xC008 irq 19
Jun  3 15:33:57 fawkes scsi2 : sata_nv
Jun  3 15:33:57 fawkes ata3: port is slow to respond, please be patient 
(Status 0xd0)
Jun  3 15:33:57 fawkes ata3: port failed to respond (30 secs, Status 0xd0)
Jun  3 15:33:57 fawkes ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 
300)
Jun  3 15:33:57 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:33:57 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:33:57 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:33:57 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:33:57 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:33:57 fawkes ata3.00: ATA-7, max UDMA/133, 1465149168 sectors: 
LBA48 NCQ (depth 0/32)
Jun  3 15:33:57 fawkes ata3.00: ata3: dev 0 multi count 16
Jun  3 15:33:57 fawkes ata3.00: Drive reports diagnostics failure. This 
may indicate a drive
Jun  3 15:33:57 fawkes ata3.00: fault or invalid emulation. Contact 
drive vendor for information.
Jun  3 15:33:57 fawkes ata3.00: configured for UDMA/133
Jun  3 15:33:57 fawkes scsi3 : sata_nv
Jun  3 15:33:57 fawkes ata4: SATA link down (SStatus 0 SControl 300)
Jun  3 15:33:57 fawkes ATA: abnormal status 0x7F on port 0xC407
Jun  3 15:33:57 fawkes scsi 2:0:0:0: Direct-Access     ATA      
ST3750640AS      3.AA PQ: 0 ANSI: 5
Jun  3 15:33:57 fawkes SCSI device sdc: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sdc: Write Protect is off
Jun  3 15:33:57 fawkes sdc: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sdc: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes SCSI device sdc: 1465149168 512-byte hdwr sectors 
(750156 MB)
Jun  3 15:33:57 fawkes sdc: Write Protect is off
Jun  3 15:33:57 fawkes sdc: Mode Sense: 00 3a 00 00
Jun  3 15:33:57 fawkes SCSI device sdc: write cache: enabled, read 
cache: enabled, doesn't support DPO or FUA
Jun  3 15:33:57 fawkes sdc: unknown partition table
Jun  3 15:33:57 fawkes sd 2:0:0:0: Attached scsi disk sdc
Jun  3 15:33:57 fawkes sd 2:0:0:0: Attached scsi generic sg2 type 0

later after trying to write new partition information...

Jun  3 15:35:58 fawkes ata3: port failed to respond (30 secs, Status 0xd0)
Jun  3 15:35:58 fawkes ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 
300)
Jun  3 15:35:58 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:35:58 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:35:58 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:35:58 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:35:58 fawkes ATA: abnormal status 0xD0 on port 0xC807
Jun  3 15:36:28 fawkes ata3.00: qc timeout (cmd 0xec)
Jun  3 15:36:28 fawkes ata3.00: failed to IDENTIFY (I/O error, err_mask=0x4)
Jun  3 15:36:28 fawkes ata3.00: revalidation failed (errno=-5)
Jun  3 15:36:28 fawkes ata3: failed to recover some devices, retrying in 
5 secs
Jun  3 15:36:33 fawkes ata3: hard resetting port
Jun  3 15:36:40 fawkes ata3: port is slow to respond, please be patient 
(Status 0xd0)

