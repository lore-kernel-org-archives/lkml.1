Return-Path: <linux-kernel-owner+w=401wt.eu-S1757896AbYDHPNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896AbYDHPNj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 11:13:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021AbYDHPNb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 11:13:31 -0400
Received: from smtp.ono.com ([62.42.230.12]:54675 "EHLO resmaa05.ono.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756056AbYDHPN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 11:13:29 -0400
Date: Tue, 8 Apr 2008 17:13:11 +0200
From: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
To: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: DRDY errors again
Message-ID: <20080408171311.69441c8b@werewolf>
X-Mailer: Claws Mail 3.3.1cvs48 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all...

Well, I'm getting all those errors on SATA disks again. I have just returned
one thinkin it was faulty. But I don't buy I got all the bad drives in the
store...

Disks:

werewolf:~> lsscsi -H
[0]    aic79xx
[1]    aic79xx
[2]    ata_piix
[3]    ata_piix
[4]    ata_piix
[5]    ata_piix
werewolf:~> lsscsi
[1:0:0:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sda
[1:0:1:0]    disk    SEAGATE  ST336807LW       0C01  /dev/sdb
[2:0:0:0]    disk    ATA      ST3120022A       3.06  /dev/sdc
[2:0:1:0]    cd/dvd  HL-DT-ST DVDRAM GSA-H10N  JL12  /dev/sr0
[4:0:0:0]    disk    ATA      WDC WD3200AVJS-6 12.0  /dev/sdd
[5:0:0:0]    disk    ATA      ST3500820AS      SD25  /dev/sde

dmesg:

scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
ACPI: PCI Interrupt 0000:03:0a.1[B] -> GSI 23 (level, low) -> IRQ 17
scsi1 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320 Ultra320 SCSI adapter>
        aic7902: Ultra320 Wide Channel B, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs
scsi 1:0:0:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
 target1:0:0: asynchronous
scsi1:A:0:0: Tagged Queuing enabled.  Depth 32
 target1:0:0: Beginning Domain Validation
 target1:0:0: wide asynchronous
 target1:0:0: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
 target1:0:0: Ending Domain Validation
scsi 1:0:1:0: Direct-Access     SEAGATE  ST336807LW       0C01 PQ: 0 ANSI: 3
 target1:0:1: asynchronous
scsi1:A:1:0: Tagged Queuing enabled.  Depth 32
 target1:0:1: Beginning Domain Validation
 target1:0:1: wide asynchronous
 target1:0:1: FAST-160 WIDE SCSI 320.0 MB/s DT IU QAS RDSTRM WRFLOW PCOMP (6.25 ns, offset 63)
 target1:0:1: Ending Domain Validation
Driver 'sd' needs updating - please use bus_type methods
sd 1:0:0:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 1:0:0:0: [sda] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:0:0: [sda] Write Protect is off
sd 1:0:0:0: [sda] Mode Sense: ab 00 10 08
sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sda: sda1 sda2
sd 1:0:0:0: [sda] Attached SCSI disk
sd 1:0:1:0: [sdb] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: ab 00 10 08
sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
sd 1:0:1:0: [sdb] 71687372 512-byte hardware sectors (36704 MB)
sd 1:0:1:0: [sdb] Write Protect is off
sd 1:0:1:0: [sdb] Mode Sense: ab 00 10 08
sd 1:0:1:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
 sdb: sdb1
sd 1:0:1:0: [sdb] Attached SCSI disk
Driver 'sr' needs updating - please use bus_type methods
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1.00: ATA-6: ST3120022A, 3.06, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 
ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-H10N, JL12, max UDMA/33
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/33
scsi 2:0:0:0: Direct-Access     ATA      ST3120022A       3.06 PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 234441648 512-byte hardware sectors (120034 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
scsi 2:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-H10N  JL12 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 2:0:1:0: Attached scsi CD-ROM sr0
ata_piix 0000:00:1f.2: MAP [ P0 -- P1 -- ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata3: SATA max UDMA/133 cmd 0xc000 ctl 0xc400 bmdma 0xd000 irq 18
ata4: SATA max UDMA/133 cmd 0xc800 ctl 0xcc00 bmdma 0xd008 irq 18
ata3.00: ATA-8: WDC WD3200AVJS-63WDA0, 12.01B02, max UDMA/133
ata3.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4.00: ATA-8: ST3500820AS, SD25, max UDMA/133
ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      WDC WD3200AVJS-6 12.0 PQ: 0 ANSI: 5
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 4:0:0:0: [sdd] Attached SCSI disk
scsi 5:0:0:0: Direct-Access     ATA      ST3500820AS      SD25 PQ: 0 ANSI: 5
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 5:0:0:0: [sde] Attached SCSI disk

The WDC is the new brand disk I received in change for the 'faulty' Seagate.
The ST3500820AS is also new.

This happened burning a data DVD:

ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: soft resetting link
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:00:b7:f7:a0/00:00:00:00:00/ed tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd b0/d0:01:00:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
         res 40/00:00:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: soft resetting link
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:00:c7:26:a1/00:00:00:00:00/ed tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata3.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata3.00: cmd c8/00:00:ef:d9:a1/00:00:00:00:00/ed tag 0 dma 131072 in
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata3.00: status: { DRDY }
ata3: soft resetting link
ata3.00: configured for UDMA/133
ata3: EH complete
sd 4:0:0:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 4:0:0:0: [sdd] Write Protect is off
sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb 1-8: USB disconnect, address 4
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: soft resetting link
ata4.00: configured for UDMA/133
ata4: EH complete
sd 5:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 5:0:0:0: [sde] Write Protect is off
sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata4.00: limiting speed to UDMA/100:PIO4
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }
ata4: port is slow to respond, please be patient (Status 0x80)
ata4: device not ready (errno=-16), forcing hardreset
ata4: soft resetting link
ata4.00: revalidation failed (errno=-2)
ata4: failed to recover some devices, retrying in 5 secs
ata4: soft resetting link
ata4.00: configured for UDMA/100
ata4: EH complete
ata4.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata4.00: cmd b0/d0:01:00:4f:c2/00:00:00:00:00/00 tag 0 pio 512 in
         res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
ata4.00: status: { DRDY }

So the 2 SATA drives begin to spit errors when writing the DVD. This must
be a kernel bug...One other disk that was flaky in this box has survived
a full erase with SeaTools, a long test, and a Vista install on it.
Kernel is 2.6.24.4.

Any ideas ?

TIA

-- 
J.A. Magallon <jamagallon()ono!com>     \               Software is like sex:
                                         \         It's better when it's free
Mandriva Linux release 2008.1 (Cooker) for i586
Linux 2.6.23-jam05 (gcc 4.2.2 20071128 (4.2.2-2mdv2008.1)) SMP PREEMPT
