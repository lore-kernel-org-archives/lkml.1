Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbYJBIYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbYJBIYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 04:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752429AbYJBIYX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 04:24:23 -0400
Received: from mail.ku-gbr.de ([81.3.11.18]:54489 "EHLO ku-gbr.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751939AbYJBIYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:24:22 -0400
X-Greylist: delayed 2943 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2008 04:24:21 EDT
Date: Wed, 1 Oct 2008 21:30:13 +0200
From: Konstantin Kletschke <lists@ku-gbr.de>
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
Message-ID: <20081001193013.GA6565@anita.doom>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <48DA0A2C.8010008@kernel.org> <20080924105943.GB2094@anita> <20080925081848.GB2305@anita> <48DEA40D.40709@kernel.org> <20080930081257.GB18961@anita.doom> <48E232FC.1090902@kernel.org> <20080930151622.GC18961@anita.doom> <48E25831.4030505@kernel.org> <20081001073817.GA3098@anita.doom> <48E32C93.8060201@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48E32C93.8060201@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, this way the Situation is the following:

TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
msgmni has been set to 2008
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:01:00.0: Boot video device
Linux agpgart interface v0.103
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
forcedeth 0000:00:05.0: PCI INT A -> Link[LKLN] -> GSI 22 (level, low) -> IRQ 22
forcedeth 0000:00:05.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
Switched to high resolution mode on CPU 0
forcedeth 0000:00:05.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:13:8f:fd:f9:26
forcedeth 0000:00:05.0: csum timirq lnktim desc-v2
netconsole: local port 6665
netconsole: local IP 10.10.0.1
netconsole: interface eth0
netconsole: remote port 6666
netconsole: remote IP 10.10.0.18
netconsole: remote ethernet address 00:22:15:68:2c:eb
netconsole: device eth0 not up yet, forcing it
eth0: no link during initialization.
eth0: link up.
console [netcon0] enabled
netconsole: network logging started
Driver 'sd' needs updating - please use bus_type methods
sata_nv 0000:00:0a.0: version 3.5
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
sata_nv 0000:00:0a.0: PCI INT A -> Link[LTID] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:0a.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xf80 ctl 0xf00 bmdma 0xd800 irq 21
ata2: SATA max UDMA/133 cmd 0xe80 ctl 0xe00 bmdma 0xd808 irq 21
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: SAMSUNG HD753LJ, 1AA01106, max UDMA7
ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD753LJ  1AA0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 1465149168 512-byte hardware sectors (750156 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 >
sd 0:0:0:0: [sda] Attached SCSI disk
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
TCP cubic registered
NET: Registered protocol family 17
XFS mounting filesystem sda1
Ending clean XFS mount for filesystem: sda1
VFS: Mounted root (xfs filesystem) readonly.
Freeing unused kernel memory: 220k freed

Then this continues:

ata2: EH pending after 5 tries, giving up
ata2: EH complete
ata2: EH pending after 5 tries, giving up
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete
ata2: EH complete


Rebooting is not possible (seldom it is possible though), most often it
yields into the BIOS not recognizing the disk after the reset anymore. 
The shutdown (the system is headless regularly and I wait for hearing the
BIOS beep) lasts very long (before it waits for the disk or finds no OS).

Sadly I have no time to put a monitor onto it, if further investigations
are required I can take care of this friday.

Kind Regards and happy hacking, Konsti


-- 
GPG KeyID EF62FCEF
Fingerprint: 13C9 B16B 9844 EC15 CC2E  A080 1E69 3FDA EF62 FCEF
