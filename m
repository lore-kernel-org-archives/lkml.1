Return-Path: <linux-kernel-owner+w=401wt.eu-S1751982AbXCTWIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982AbXCTWIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 18:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXCTWIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 18:08:17 -0400
Received: from vapor.arctrix.com ([66.220.1.99]:3266 "HELO vapor.arctrix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751982AbXCTWIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 18:08:14 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 18:08:14 EDT
Date: Tue, 20 Mar 2007 16:01:32 -0600
From: Neil Schemenauer <nas@arctrix.com>
To: Robert Hancock <hancockr@shaw.ca>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, Allen Martin <AMartin@nvidia.com>,
       B.Steinbrink@gmx.de
Subject: Re: sata_nv ADMA controller lockup investigation
Message-ID: <20070320220132.GA10984@python.ca>
References: <45D3E1FF.3080606@shaw.ca> <45D439F7.3030604@garzik.org> <45D5389E.70300@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45D5389E.70300@shaw.ca>
X-PGP-Fingerprint: 9B3B 987B F40E 9320 0619  0A17 A366 302E B1DE 86CE
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Not sure if this helps.  I'm getting this reset with 2.6.21-rc4.
After the reset the controller seems to work again.

sata_nv 0000:00:07.0: version 3.3
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 22 (level, low) -> IRQ 22
sata_nv 0000:00:07.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:07.0 to 64
ata1: SATA max UDMA/133 cmd 0xffffc2000001e480 ctl 0xffffc2000001e4a0 bmdma 0x000000000001cc00 irq 22
ata2: SATA max UDMA/133 cmd 0xffffc2000001e580 ctl 0xffffc2000001e5a0 bmdma 0x000000000001cc08 irq 22
scsi0 : sata_nv
ata1: SATA link down (SStatus 0 SControl 300)
scsi1 : sata_nv
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: ATA-7: Maxtor 6V300F0, VA111630, max UDMA/133
ata2.00: 586114704 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata2.00: configured for UDMA/133
scsi 1:0:0:0: Direct-Access     ATA      Maxtor 6V300F0   VA11 PQ: 0 ANSI: 5
ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 1:0:0:0: Attached scsi disk sda
sd 1:0:0:0: Attached scsi generic sg0 type 0
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:08.0: Using ADMA mode
PCI: Setting latency timer of device 0000:00:08.0 to 64
ata3: SATA max UDMA/133 cmd 0xffffc20000020480 ctl 0xffffc200000204a0 bmdma 0x000000000001b800 irq 21
ata4: SATA max UDMA/133 cmd 0xffffc20000020580 ctl 0xffffc200000205a0 bmdma 0x000000000001b808 irq 21
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:06.0: version 0.2.8
PCI: Setting latency timer of device 0000:00:06.0 to 64
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6 bmdma 0x000000000001e000 irq 14
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376 bmdma 0x000000000001e008 irq 15
scsi4 : pata_amd
ata5.00: ATAPI, max UDMA/33
ata5.01: ATAPI, max MWDMA2
ata5.00: configured for UDMA/33
ata5.01: configured for MWDMA2
scsi5 : pata_amd
ATA: abnormal status 0x8 on port 0x0000000000010177
scsi 4:0:0:0: CD-ROM            PLEXTOR  DVDR   PX-504A   1.02 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
sr 4:0:0:0: Attached scsi generic sg1 type 5
scsi 4:0:1:0: CD-ROM            COMPAQ   SC-140S          SE04 PQ: 0 ANSI: 5
sr1: scsi3-mmc drive: 1x/40x cd/rw xa/form2 cdda tray
sr 4:0:1:0: Attached scsi CD-ROM sr1
sr 4:0:1:0: Attached scsi generic sg2 type 5

[...]

ata2: EH in ADMA mode, notifier 0x0 notifier_error 0x0 gen_ctl 0x1501000 status 0x400 next cpb count 0x0 next cpb idx 0x0
ata2: CPB 1: ctl_flags 0x1f, resp_flags 0x2
ata2: timeout waiting for ADMA IDLE, stat=0x400
ata2: timeout waiting for ADMA LEGACY, stat=0x400
ata2.00: exception Emask 0x0 SAct 0x2 SErr 0x0 action 0x2 frozen
ata2.00: cmd 61/00:08:72:44:22/02:00:21:00:00/40 tag 1 cdb 0x0 data 262144 out
         res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata2: soft resetting port
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: configured for UDMA/133
ata2: EH complete
SCSI device sda: 586114704 512-byte hdwr sectors (300091 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA


$ lspci
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller (rev a3)
00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2)
00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3)
00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 Audio Controller (rev a2)
00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2)
00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller (rev f3)
00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev a2)
00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3)
00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] HyperTransport Technology Configuration
00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Address Map
00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] DRAM Controller
00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] Miscellaneous Control
01:0c.0 FireWire (IEEE 1394): VIA Technologies, Inc. IEEE 1394 Host Controller (rev 80)
01:0d.0 RAID bus controller: Silicon Image, Inc. SiI 3114 [SATALink/SATARaid] Serial ATA Controller (rev 02)
03:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8053 PCI-E Gigabit Ethernet Controller (rev 15)
05:00.0 VGA compatible controller: ATI Technologies Inc R430 [Radeon X800 XL] (PCIe)
05:00.1 Display controller: ATI Technologies Inc R430 [Radeon X800 XL] (PCIe) Secondary

