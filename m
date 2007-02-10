Return-Path: <linux-kernel-owner+w=401wt.eu-S1751749AbXBJSkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbXBJSkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 13:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751756AbXBJSkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 13:40:15 -0500
Received: from tag.witbe.net ([81.88.96.48]:54319 "EHLO tag.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbXBJSkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 13:40:13 -0500
Reply-To: <rol@as2917.net>
From: "Paul Rolland" <rol@as2917.net>
To: <rol@as2917.net>, "'Robert Hancock'" <hancockr@shaw.ca>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: RE: AHCI - remove probing of ata2
Date: Sat, 10 Feb 2007 19:39:21 +0100
Organization: AS2917.net
Message-ID: <00c601c74d42$c81b2170$2101a8c0@donald>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
In-Reply-To: <00ba01c74d39$604fddf0$2101a8c0@donald>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3028
Thread-Index: AcdNN7sLUrn+rpIGROWi4ShTlWpQ2wAARfXwAAJI26A=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I've been trying this, but I ended with the ICH7 not detecting anymore
> my IDE disks... 
> Should try again, maybe I missed something.

Done a new built, and I now have :

Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hda: Maxtor 6L200P0, ATA DISK drive
hdb: ASUS CRW-5232A3, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hda: max request size: 512KiB
hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
hdb: ATAPI 52X CD-ROM CD-R/RW drive, 1536kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 23 (level, low) -> IRQ 23
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq led clo pio slum part 
ata1: SATA max UDMA/133 cmd 0xFFFFC200000B6900 ctl 0x0 bmdma 0x0 irq 504
ata2: SATA max UDMA/133 cmd 0xFFFFC200000B6980 ctl 0x0 bmdma 0x0 irq 504
ata3: SATA max UDMA/133 cmd 0xFFFFC200000B6A00 ctl 0x0 bmdma 0x0 irq 504
ata4: SATA max UDMA/133 cmd 0xFFFFC200000B6A80 ctl 0x0 bmdma 0x0 irq 504
scsi0 : ahci
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : ahci
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: qc timeout (cmd 0xec)
ata2.00: failed to IDENTIFY (I/O error, err_mask=0x104)
ata2: port is slow to respond, please be patient (Status 0x80)
ata2: port failed to respond (30 secs, Status 0x80)
ata2: COMRESET failed (device not ready)
ata2: hardreset failed, retrying in 5 secs
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-6, max UDMA/133, 640 sectors: LBA 
ata2.00: ata2: dev 0 multi count 1
ata2.00: configured for UDMA/133
scsi2 : ahci
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 490234752 sectors: LBA48 NCQ (depth 31/32)
ata3.00: ata3: dev 0 multi count 0
ata3.00: configured for UDMA/133
scsi3 : ahci
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-7, max UDMA/133, 976773168 sectors: LBA48 NCQ (depth 31/32)
ata4.00: ata4: dev 0 multi count 16
ata4.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sda: 490234752 512-byte hdwr sectors (251000 MB)
sda: Write Protect is off
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: Direct-Access     ATA      Config  Disk     RGL1 PQ: 0 ANSI: 5
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdb: 640 512-byte hdwr sectors (0 MB)
sdb: Write Protect is off
SCSI device sdb: write cache: disabled, read cache: enabled, doesn't support
DPO or FUA
 sdb: unknown partition table
sd 1:0:0:0: Attached scsi disk sdb
sd 1:0:0:0: Attached scsi generic sg1 type 0
scsi 2:0:0:0: Direct-Access     ATA      Maxtor 6L250S0   BANC PQ: 0 ANSI: 5
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdc: 490234752 512-byte hdwr sectors (251000 MB)
sdc: Write Protect is off
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdc: sdc1 sdc2
sd 2:0:0:0: Attached scsi disk sdc
sd 2:0:0:0: Attached scsi generic sg2 type 0
scsi 3:0:0:0: Direct-Access     ATA      ST3500641AS      3.AA PQ: 0 ANSI: 5
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support
DPO or FUA
 sdd: sdd1 sdd2 sdd3
sd 3:0:0:0: Attached scsi disk sdd
sd 3:0:0:0: Attached scsi generic sg3 type 0
PCI: Device 0000:02:00.0 not available because of resource collisions
ahci: probe of 0000:02:00.0 failed with error -22
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 22 (level, low) -> IRQ 22
ata: 0x1F0 IDE port busy
ata: conflict with ide0
ata5: DUMMY
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xFFA8 irq 15
scsi4 : ata_piix
scsi5 : ata_piix
ATA: abnormal status 0x7F on port 0x177
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
ata7: PATA max UDMA/100 cmd 0x9C00 ctl 0x9882 bmdma 0x9400 irq 16
ata8: PATA max UDMA/100 cmd 0x9800 ctl 0x9482 bmdma 0x9408 irq 16
scsi6 : pata_jmicron
ata7.00: ATAPI, max UDMA/66
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: limiting speed to UDMA/44
ata7: failed to recover some devices, retrying in 5 secs
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: limiting speed to PIO0
ata7: failed to recover some devices, retrying in 5 secs
ata7.00: qc timeout (cmd 0xef)
ata7.00: failed to set xfermode (err_mask=0x4)
ata7.00: disabled
scsi7 : pata_jmicron
ATA: abnormal status 0x7F on port 0x9807

So, the Jmicron stuff is still not working... It starts with the :
PCI: Device 0000:02:00.0 not available because of resource collisions
ahci: probe of 0000:02:00.0 failed with error -22

and then it fails to detect any kind of devices I have...

.config contains :
#
# ATA/ATAPI/MFM/RLL support
# 
CONFIG_IDE=y
CONFIG_BLK_DEV_IDE=y

# 
# Please see Documentation/ide.txt for help/info on IDE drives
# 
# CONFIG_BLK_DEV_IDE_SATA is not set
# CONFIG_BLK_DEV_HD_IDE is not set
CONFIG_BLK_DEV_IDEDISK=y
# CONFIG_IDEDISK_MULTI_MODE is not set
CONFIG_BLK_DEV_IDECD=y 
# CONFIG_BLK_DEV_IDETAPE is not set
CONFIG_BLK_DEV_IDEFLOPPY=y
CONFIG_BLK_DEV_IDESCSI=y
CONFIG_IDE_TASK_IOCTL=y

#
# IDE chipset support/bugfixes
#
CONFIG_IDE_GENERIC=y
# CONFIG_BLK_DEV_CMD640 is not set
# CONFIG_BLK_DEV_IDEPNP is not set
# CONFIG_BLK_DEV_IDEPCI is not set
# CONFIG_IDE_ARM is not set
# CONFIG_BLK_DEV_IDEDMA is not set
# CONFIG_IDEDMA_AUTO is not set
# CONFIG_BLK_DEV_HD is not set

#
# SCSI device support
#
# CONFIG_RAID_ATTRS is not set
CONFIG_SCSI=y
# CONFIG_SCSI_TGT is not set
# CONFIG_SCSI_NETLINK is not set
CONFIG_SCSI_PROC_FS=y

#
# SCSI support type (disk, tape, CD-ROM)
#
CONFIG_BLK_DEV_SD=y
# CONFIG_CHR_DEV_ST is not set 
# CONFIG_CHR_DEV_OSST is not set
CONFIG_BLK_DEV_SR=y
# CONFIG_BLK_DEV_SR_VENDOR is not set
CONFIG_CHR_DEV_SG=y
# CONFIG_CHR_DEV_SCH is not set

#
# Some SCSI devices (e.g. CD jukebox) support multiple LUNs
# 
CONFIG_SCSI_MULTI_LUN=y
CONFIG_SCSI_CONSTANTS=y
CONFIG_SCSI_LOGGING=y
...
(SCSI is set for USB devices I'm using).
...
#
# Serial ATA (prod) and Parallel ATA (experimental) drivers
#
CONFIG_ATA=y
# CONFIG_ATA_NONSTANDARD is not set
CONFIG_SATA_AHCI=y
# CONFIG_SATA_SVW is not set
CONFIG_ATA_PIIX=y
# CONFIG_SATA_MV is not set
# CONFIG_SATA_NV is not set
# CONFIG_PDC_ADMA is not set
# CONFIG_SATA_QSTOR is not set
# CONFIG_SATA_PROMISE is not set
# CONFIG_SATA_SX4 is not set
# CONFIG_SATA_SIL is not set
# CONFIG_SATA_SIL24 is not set
# CONFIG_SATA_SIS is not set
# CONFIG_SATA_ULI is not set
# CONFIG_SATA_VIA is not set
# CONFIG_SATA_VITESSE is not set
CONFIG_SATA_INTEL_COMBINED=y
# CONFIG_PATA_ALI is not set
# CONFIG_PATA_AMD is not set
# CONFIG_PATA_ARTOP is not set
# CONFIG_PATA_ATIIXP is not set
# CONFIG_PATA_CMD64X is not set 
# CONFIG_PATA_CS5520 is not set
# CONFIG_PATA_CS5530 is not set
# CONFIG_PATA_CYPRESS is not set
# CONFIG_PATA_EFAR is not set
# CONFIG_ATA_GENERIC is not set
# CONFIG_PATA_HPT366 is not set
# CONFIG_PATA_HPT37X is not set
# CONFIG_PATA_HPT3X2N is not set
# CONFIG_PATA_HPT3X3 is not set
# CONFIG_PATA_IT821X is not set
CONFIG_PATA_JMICRON=y
# CONFIG_PATA_TRIFLEX is not set
# CONFIG_PATA_MARVELL is not set
# CONFIG_PATA_MPIIX is not set
# CONFIG_PATA_OLDPIIX is not set
# CONFIG_PATA_NETCELL is not set
# CONFIG_PATA_NS87410 is not set
# CONFIG_PATA_OPTI is not set
# CONFIG_PATA_OPTIDMA is not set
# CONFIG_PATA_PDC_OLD is not set
# CONFIG_PATA_RADISYS is not set
# CONFIG_PATA_RZ1000 is not set
# CONFIG_PATA_SC1200 is not set
# CONFIG_PATA_SERVERWORKS is not set
# CONFIG_PATA_PDC2027X is not set
# CONFIG_PATA_SIL680 is not set
# CONFIG_PATA_SIS is not set
# CONFIG_PATA_VIA is not set
# CONFIG_PATA_WINBOND is not set

Robert, based on what you wrote, I have a few questions :
 - Should I activate CONFIG_SATA_SIL and/or CONFIG_SATA_SIL24 for the
   ata2 timeout,
 - If I set CONFIG_IDE=n, this will remove support for :
   . Floppy,
   . Scsi -> USB keys.
   or am I missing something ?

Regards,
Paul

