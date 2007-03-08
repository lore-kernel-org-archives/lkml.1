Return-Path: <linux-kernel-owner+w=401wt.eu-S1752468AbXCHQYK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752468AbXCHQYK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 11:24:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbXCHQYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 11:24:09 -0500
Received: from vsmtp3.tin.it ([212.216.176.223]:56102 "EHLO vsmtp3.tin.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460AbXCHQYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 11:24:07 -0500
Subject: Re: Problem with libata-pata, ATAPI DVD reader and a
	"copy-protected" audio cd
From: GhePeU <ghepeu@virgilio.it>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070308170731.458fe407@lxorguk.ukuu.org.uk>
References: <1172919624.23576.31.camel@KazeNoTani>
	 <1173360956.24659.3.camel@KazeNoTani>
	 <20070308170731.458fe407@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Thu, 08 Mar 2007 17:23:49 +0100
Message-Id: <1173371030.24659.19.camel@KazeNoTani>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Il giorno gio, 08/03/2007 alle 17.07 +0000, Alan Cox ha scritto:
> > Well, it happened again, with a different cd, and this time I never
> > started the player: hal/g-v-m tried to access the CD and now my driver
> > is in PIO2 mode and pretty much unusable. Is there a way to fix this
> > without rebooting?
> 
> Hard to tell. If it happens again then a "dmesg" after it misbehaves and
> an lspci -vxx might provide enough information to begin to debug it.
> 
> Alan

I posted these informations in my first message, however:

This is the output related to my controllers during the boot:

SCSI subsystem initialized
libata version 2.00 loaded.
sata_nv 0000:00:07.0: version 3.2
sata_nv 0000:00:07.0: Using ADMA mode
ata1: SATA max UDMA/133 cmd 0xF0804480 ctl 0xF08044A0 bmdma 0xD400 irq
16
ata2: SATA max UDMA/133 cmd 0xF0804580 ctl 0xF08045A0 bmdma 0xD408 irq
16
scsi0 : sata_nv
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7, max UDMA/133, 312581808 sectors: LBA48 NCQ (depth 31/32)
ata1.00: ata1: dev 0 multi count 16
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      WDC WD1600JS-22N 10.0 PQ: 0
ANSI: 5
ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw
segs 61
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sda: sda1 sda2 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: Attached scsi disk sda
sd 0:0:0:0: Attached scsi generic sg0 type 0
sata_nv 0000:00:08.0: Using ADMA mode
ata3: SATA max UDMA/133 cmd 0xF0806480 ctl 0xF08064A0 bmdma 0xC000 irq
17
ata4: SATA max UDMA/133 cmd 0xF0806580 ctl 0xF08065A0 bmdma 0xC008 irq
17
scsi2 : sata_nv
ata3: SATA link down (SStatus 0 SControl 300)
scsi3 : sata_nv
ata4: SATA link down (SStatus 0 SControl 300)
pata_amd 0000:00:06.0: version 0.2.7
ata5: PATA max UDMA/133 cmd 0x1F0 ctl 0x3F6 bmdma 0xE800 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xE808 irq 15
scsi4 : pata_amd
ata5.00: ATA-6, max UDMA/100, 156301488 sectors: LBA 
ata5.00: ata5: dev 0 multi count 16
ata5.01: ATA-5, max UDMA/133, 78177792 sectors: LBA 
ata5.01: ata5: dev 1 multi count 16
ata5.00: configured for UDMA/100
ata5.01: configured for UDMA/133
scsi5 : pata_amd
ata6.00: ATAPI, max UDMA/66
ata6.01: ATAPI, max UDMA/33
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
scsi 4:0:0:0: Direct-Access     ATA      WDC WD800JB-00FM 13.0 PQ: 0
ANSI: 5
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 sdb8 >
sd 4:0:0:0: Attached scsi disk sdb
sd 4:0:0:0: Attached scsi generic sg1 type 0
scsi 4:0:1:0: Direct-Access     ATA      MAXTOR 6L040J2   A93. PQ: 0
ANSI: 5
SCSI device sdc: 78177792 512-byte hdwr sectors (40027 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdc: 78177792 512-byte hdwr sectors (40027 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sdc: sdc1
sd 4:0:1:0: Attached scsi disk sdc
sd 4:0:1:0: Attached scsi generic sg2 type 0
scsi 5:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-111D 1.23 PQ: 0
ANSI: 5
sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 5:0:0:0: Attached scsi CD-ROM sr0
sr 5:0:0:0: Attached scsi generic sg3 type 5
scsi 5:0:1:0: CD-ROM            TOSHIBA  DVD-ROM SD-M1612 1806 PQ: 0
ANSI: 5
sr1: scsi3-mmc drive: 40x/48x cd/rw xa/form2 cdda tray
sr 5:0:1:0: Attached scsi CD-ROM sr1
sr 5:0:1:0: Attached scsi generic sg4 type 5



This is the dmesg output due to the error. This is with the Enhanced CD:

ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/33
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
    ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
        72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
        00 00 00 00 b0 51 
end_request: I/O error, dev sr1, sector 0
Buffer I/O error on device sr1, logical block 0
Buffer I/O error on device sr1, logical block 1
Buffer I/O error on device sr1, logical block 2
Buffer I/O error on device sr1, logical block 3
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: limiting speed to UDMA/25
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/25
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/25
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: limiting speed to UDMA/16
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for UDMA/16
ata6: EH complete
ata6.01: qc timeout (cmd 0xa0)
ata6.01: limiting speed to PIO4
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: (BMDMA stat 0x65)
ata6.01: cmd a0/01:00:00:00:00/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:00/00:00:00:00:00/b0 Emask 0x5 (timeout)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
    ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
        72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
        00 00 00 00 b0 51 
end_request: I/O error, dev sr1, sector 0
Buffer I/O error on device sr1, logical block 0
ata6: EH complete


at this point, I could finally eject the cd. I just tried again and this
is what happens:

ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
16384 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
    ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
        72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
        00 00 00 20 b0 51 
end_request: I/O error, dev sr1, sector 0
printk: 21 messages suppressed.
Buffer I/O error on device sr1, logical block 0
Buffer I/O error on device sr1, logical block 1
Buffer I/O error on device sr1, logical block 2
Buffer I/O error on device sr1, logical block 3
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
ata6: EH complete
ata6.01: 8096 bytes trailing data
ata6.01: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
ata6.01: cmd a0/00:00:00:00:20/00:00:00:00:00/b0 tag 0 cdb 0x28 data
4096 in
         res 51/51:03:00:00:20/00:00:00:00:00/b0 Emask 0x3 (HSM
violation)
ata6: soft resetting port
ata6.00: configured for UDMA/66
ata6.01: configured for PIO4
sr 5:0:1:0: SCSI error: return code = 0x08000002
sr1: Current [descriptor]: sense key=0x3
    ASC=0x13 ASCQ=0x0
Descriptor sense data with sense descriptors (in hex):
        72 03 13 00 00 00 00 0e 09 0c 00 51 00 03 00 00 
        00 00 00 20 b0 51 
end_request: I/O error, dev sr1, sector 0
Buffer I/O error on device sr1, logical block 0
ata6: EH complete


Then I ejected the cd again.

lspci -vvv output (ide interfaces only). Mobo is an ABIT KN9 (Nforce4):

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a
[Master SecP PriP])
        Subsystem: Unknown device f47b:1c28
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at e800 [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ABIT Computer Corp. Unknown device 1c28
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 09f0 [size=8]
        Region 1: I/O ports at 0bf0 [size=4]
        Region 2: I/O ports at 0970 [size=8]
        Region 3: I/O ports at 0b70 [size=4]
        Region 4: I/O ports at d400 [size=16]
        Region 5: Memory at fe02c000 (32-bit, non-prefetchable)
[size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ABIT Computer Corp. Unknown device 1c28
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 17
        Region 0: I/O ports at 09e0 [size=8]
        Region 1: I/O ports at 0be0 [size=4]
        Region 2: I/O ports at 0960 [size=8]
        Region 3: I/O ports at 0b60 [size=4]
        Region 4: I/O ports at c000 [size=16]
        Region 5: Memory at fe02b000 (32-bit, non-prefetchable)
[size=4K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-



