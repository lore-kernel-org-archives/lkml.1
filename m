Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092AbYJQJ0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbYJQJ0s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752760AbYJQJ0j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:26:39 -0400
Received: from wf-out-1314.google.com ([209.85.200.175]:40085 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbYJQJ0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:26:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=F44mxLs2wLAmJRQs7EwzblfRcuUXV0i5Ic4oHZimSMaYKkIw0W3oIjpo/OmlbMj3L+
         JrHRLk1cHx5ENn2ec8nRKqjPwLcnwtVzUOn8f887riTKdnK48Kpc27mGp3nrp/t5EiPl
         1Zyiw+FwL1ncXLgz9m0V8YMm1hhWFJZmgTY68=
Message-ID: <a8e1da0810170226j2a59465ey752f952d4143ac0b@mail.gmail.com>
Date: Fri, 17 Oct 2008 17:26:34 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Subject: oops: unable to handle kernel paging request at ffffffff
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's git (10.17), boot with this oops. I have no time to analyze it,
report it:

Here is the full dmesg:

[    1.445579] system 00:07: ioport range 0xb00-0xbfe has been reserved
[    1.445652] system 00:07: ioport range 0xc80-0xcaf has been reserved
[    1.445725] system 00:07: ioport range 0xcb0-0xcbf has been reserved
[    1.445798] system 00:07: ioport range 0xcc0-0xcf7 has been reserved
[    1.445870] system 00:07: ioport range 0xd00-0xdfe has been reserved
[    1.445943] system 00:07: ioport range 0xe00-0xefe has been reserved
[    1.446018] system 00:07: ioport range 0xf00-0xffe has been reserved
[    1.446092] system 00:07: ioport range 0x2000-0x20fe has been reserved
[    1.446177] system 00:07: ioport range 0x2100-0x21fe has been reserved
[    1.446251] system 00:07: ioport range 0x2200-0x22fe has been reserved
[    1.446324] system 00:07: ioport range 0x2300-0x23fe has been reserved
[    1.446397] system 00:07: ioport range 0x2400-0x24fe has been reserved
[    1.446471] system 00:07: ioport range 0x2500-0x25fe has been reserved
[    1.446544] system 00:07: ioport range 0x2600-0x26fe has been reserved
[    1.446617] system 00:07: ioport range 0x2700-0x27fe has been reserved
[    1.446690] system 00:07: ioport range 0x2800-0x28fe has been reserved
[    1.446763] system 00:07: ioport range 0x2900-0x29fe has been reserved
[    1.446837] system 00:07: ioport range 0x2a00-0x2afe has been reserved
[    1.446910] system 00:07: ioport range 0x2b00-0x2bfe has been reserved
[    1.446983] system 00:07: ioport range 0x2c00-0x2cfe has been reserved
[    1.447057] system 00:07: ioport range 0x2d00-0x2dfe has been reserved
[    1.447130] system 00:07: ioport range 0x2e00-0x2efe has been reserved
[    1.447203] system 00:07: ioport range 0x2f00-0x2ffe has been reserved
[    1.447277] system 00:07: ioport range 0x5000-0x50fe has been reserved
[    1.447350] system 00:07: ioport range 0x5100-0x51fe has been reserved
[    1.447424] system 00:07: ioport range 0x5200-0x52fe has been reserved
[    1.447497] system 00:07: ioport range 0x5300-0x53fe has been reserved
[    1.447586] system 00:07: ioport range 0x5400-0x54fe has been reserved
[    1.447660] system 00:07: ioport range 0x5500-0x55fe has been reserved
[    1.447734] system 00:07: ioport range 0x5600-0x56fe has been reserved
[    1.447807] system 00:07: ioport range 0x5700-0x57fe has been reserved
[    1.447881] system 00:07: ioport range 0x5800-0x58fe has been reserved
[    1.447955] system 00:07: ioport range 0x5900-0x59fe has been reserved
[    1.448051] system 00:07: ioport range 0x5a00-0x5afe has been reserved
[    1.448126] system 00:07: ioport range 0x5b00-0x5bfe has been reserved
[    1.448199] system 00:07: ioport range 0x5c00-0x5cfe has been reserved
[    1.448273] system 00:07: ioport range 0x5d00-0x5dfe has been reserved
[    1.448347] system 00:07: ioport range 0x5e00-0x5efe has been reserved
[    1.448420] system 00:07: ioport range 0x5f00-0x5ffe has been reserved
[    1.448494] system 00:07: ioport range 0x6000-0x60fe has been reserved
[    1.448568] system 00:07: ioport range 0x6100-0x61fe has been reserved
[    1.448642] system 00:07: ioport range 0x6200-0x62fe has been reserved
[    1.448716] system 00:07: ioport range 0x6300-0x63fe has been reserved
[    1.448790] system 00:07: ioport range 0x6400-0x64fe has been reserved
[    1.448863] system 00:07: ioport range 0x6500-0x65fe has been reserved
[    1.448937] system 00:07: ioport range 0x6600-0x66fe has been reserved
[    1.449011] system 00:07: ioport range 0x6700-0x67fe has been reserved
[    1.449086] system 00:07: ioport range 0x6800-0x68fe has been reserved
[    1.449160] system 00:07: ioport range 0x6900-0x69fe has been reserved
[    1.449234] system 00:07: ioport range 0x6a00-0x6afe has been reserved
[    1.449308] system 00:07: ioport range 0x6b00-0x6bfe has been reserved
[    1.449383] system 00:07: ioport range 0x6c00-0x6cfe has been reserved
[    1.449457] system 00:07: ioport range 0x6d00-0x6dfe has been reserved
[    1.449531] system 00:07: ioport range 0x6e00-0x6efe has been reserved
[    1.449606] system 00:07: ioport range 0x6f00-0x6ffe has been reserved
[    1.449680] system 00:07: ioport range 0xa000-0xa0fe has been reserved
[    1.449754] system 00:07: ioport range 0xa100-0xa1fe has been reserved
[    1.449829] system 00:07: ioport range 0xa200-0xa2fe has been reserved
[    1.449903] system 00:07: ioport range 0xa300-0xa3fe has been reserved
[    1.449991] system 00:07: ioport range 0xa400-0xa4fe has been reserved
[    1.450066] system 00:07: ioport range 0xa500-0xa5fe has been reserved
[    1.450141] system 00:07: ioport range 0xa600-0xa6fe has been reserved
[    1.450216] system 00:07: ioport range 0xa700-0xa7fe has been reserved
[    1.450291] system 00:07: ioport range 0xa800-0xa8fe has been reserved
[    1.450366] system 00:07: ioport range 0xa900-0xa9fe has been reserved
[    1.450441] system 00:07: ioport range 0xaa00-0xaafe has been reserved
[    1.450515] system 00:07: ioport range 0xab00-0xabfe has been reserved
[    1.450590] system 00:07: ioport range 0xac00-0xacfe has been reserved
[    1.450665] system 00:07: ioport range 0xad00-0xadfe has been reserved
[    1.450740] system 00:07: ioport range 0xae00-0xaefe has been reserved
[    1.450815] system 00:07: ioport range 0xaf00-0xaffe has been reserved
[    1.450894] system 00:07: iomem range 0xf0000000-0xf3ffffff could
not be reserved
[    1.450998] system 00:07: iomem range 0xfeda0000-0xfedacfff has been reserved
[    1.489583] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    1.489659] pci 0000:00:01.0:   IO window: 0xd000-0xdfff
[    1.489736] pci 0000:00:01.0:   MEM window: 0xefd00000-0xefefffff
[    1.489811] pci 0000:00:01.0:   PREFETCH window:
0x000000e0000000-0x000000e7ffffff
[    1.489921] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    1.489990] pci 0000:00:1c.0:   IO window: disabled
[    1.490067] pci 0000:00:1c.0:   MEM window: 0xefc00000-0xefcfffff
[    1.490141] pci 0000:00:1c.0:   PREFETCH window: disabled
[    1.490227] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:03
[    1.490301] pci 0000:00:1e.0:   IO window: 0xc000-0xcfff
[    1.490378] pci 0000:00:1e.0:   MEM window: 0xefa00000-0xefbfffff
[    1.490453] pci 0000:00:1e.0:   PREFETCH window:
0x00000050000000-0x000000500fffff
[    1.490588] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.490665] pci 0000:00:01.0: setting latency timer to 64
[    1.490685] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.490762] pci 0000:00:1c.0: setting latency timer to 64
[    1.490780] pci 0000:00:1e.0: setting latency timer to 64
[    1.490787] bus: 00 index 0 io port: [0, ffff]
[    1.490854] bus: 00 index 1 mmio: [0, ffffffff]
[    1.490921] bus: 01 index 0 io port: [d000, dfff]
[    1.490988] bus: 01 index 1 mmio: [efd00000, efefffff]
[    1.491056] bus: 01 index 2 mmio: [e0000000, e7ffffff]
[    1.491123] bus: 01 index 3 mmio: [0, 0]
[    1.491189] bus: 02 index 0 mmio: [0, 0]
[    1.491255] bus: 02 index 1 mmio: [efc00000, efcfffff]
[    1.491322] bus: 02 index 2 mmio: [0, 0]
[    1.491388] bus: 02 index 3 mmio: [0, 0]
[    1.491454] bus: 03 index 0 io port: [c000, cfff]
[    1.491521] bus: 03 index 1 mmio: [efa00000, efbfffff]
[    1.491589] bus: 03 index 2 mmio: [50000000, 500fffff]
[    1.491656] bus: 03 index 3 io port: [0, ffff]
[    1.491723] bus: 03 index 4 mmio: [0, ffffffff]
[    1.491822] NET: Registered protocol family 2
[    1.504800] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.506171] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.507212] TCP bind hash table entries: 65536 (order: 9, 2359296 bytes)
[    1.517988] TCP: Hash tables configured (established 131072 bind 65536)
[    1.518113] TCP reno registered
[    1.520982] NET: Registered protocol family 1
[    1.522425] Simple Boot Flag at 0x7a set to 0x1
[    1.525588] alg: cipher: Test 1 failed on encryption for aes-asm
[    1.525661] 00000000: 00 01 02 03 04 05 06 07 08 08 08 08 08 08 08 08
[    1.527957] highmem bounce pool size: 64 pages
[    1.556600] VFS: Disk quotas dquot_6.5.1
[    1.557778] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.561831] JFFS2 version 2.2. (NAND) (c) 2001-2006 Red Hat, Inc.
[    1.564833] msgmni has been set to 1715
[    1.565840] alg: No test for cipher_null (cipher_null-generic)
[    1.566150] alg: No test for digest_null (digest_null-generic)
[    1.566359] alg: No test for compress_null (compress_null-generic)
[    1.568958] alg: No test for fcrypt (fcrypt-generic)
[    1.573273] alg: No test for stdrng (krng)
[    1.573411] io scheduler noop registered
[    1.573479] io scheduler anticipatory registered
[    1.573547] io scheduler deadline registered
[    1.574308] io scheduler cfq registered (default)
[    1.574621] pci 0000:01:00.0: Boot video device
[    1.574668] pci 0000:03:08.0: Firmware left e100 interrupts
enabled; disabling
[    1.728109] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    1.731689] Floppy drive(s): fd0 is 1.44M
[    4.744096] floppy0: no floppy controllers found
[    4.754422] brd: module loaded
[    4.754490] Compaq SMART2 Driver (v 2.6.0)
[    4.754916] HP CISS Driver (v 3.6.20)
[    4.756476] tun: Universal TUN/TAP device driver, 1.6
[    4.756546] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.756993] Uniform Multi-Platform E-IDE driver
[    4.760019] Driver 'sd' needs updating - please use bus_type methods
[    4.760339] Driver 'sr' needs updating - please use bus_type methods
[    4.761707] ata_piix 0000:00:1f.1: version 2.12
[    4.761728] ata_piix 0000:00:1f.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    4.761936] ata_piix 0000:00:1f.1: setting latency timer to 64
[    4.762170] scsi0 : ata_piix
[    4.763814] scsi1 : ata_piix
[    4.764257] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    4.764332] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    4.940413] ata1.00: ATAPI: TSSTcorp CD-RW/DVD-ROM TS-H492C, DE02,
max UDMA/33
[    4.972317] ata1.00: configured for UDMA/33
[    4.973350] ata2: port disabled. ignoring.
[    4.974883] scsi 0:0:0:0: CD-ROM            TSSTcorp CDRWDVD
TS-H492C DE02 PQ: 0 ANSI: 5
[    4.979478] sr0: scsi3-mmc drive: 8x/48x writer cd/rw xa/form2 cdda tray
[    4.979556] Uniform CD-ROM driver Revision: 3.20
[    4.980804] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    4.981238] ata_piix 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
[    4.981317] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    5.136063] ata_piix 0000:00:1f.2: setting latency timer to 64
[    5.136259] scsi2 : ata_piix
[    5.136797] scsi3 : ata_piix
[    5.137236] ata3: SATA max UDMA/133 cmd 0xfe00 ctl 0xfe10 bmdma 0xfea0 irq 20
[    5.137308] ata4: SATA max UDMA/133 cmd 0xfe20 ctl 0xfe30 bmdma 0xfea8 irq 20
[    5.300373] ata3.00: ATA-7: SAMSUNG HD160JJ/P, ZM100-34, max UDMA7
[    5.300445] ata3.00: 312500000 sectors, multi 8: LBA48 NCQ (depth 0/32)
[    5.308377] ata3.00: configured for UDMA/133
[    5.475243] scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG
HD160JJ/ ZM10 PQ: 0 ANSI: 5
[    5.476372] sd 2:0:0:0: [sda] 312500000 512-byte hardware sectors:
(160GB/149GiB)
[    5.476573] sd 2:0:0:0: [sda] Write Protect is off
[    5.476642] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.476803] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.477787] sd 2:0:0:0: [sda] 312500000 512-byte hardware sectors:
(160GB/149GiB)
[    5.477976] sd 2:0:0:0: [sda] Write Protect is off
[    5.478044] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.478205] sd 2:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.478351]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
[    5.565788] sd 2:0:0:0: [sda] Attached SCSI disk
[    5.572376] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.572476] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    5.572483] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    5.575028] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 1
[    5.579117] ehci_hcd 0000:00:1d.7: debug port 1
[    5.579196] ehci_hcd 0000:00:1d.7: cache line size of 128 is not supported
[    5.579250] ehci_hcd 0000:00:1d.7: irq 21, io mem 0xffa80800
[    5.592023] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[    5.592957] usb usb1: configuration #1 chosen from 1 choice
[    5.593489] hub 1-0:1.0: USB hub found
[    5.593684] hub 1-0:1.0: 8 ports detected
[    5.802552] 116x: driver isp116x-hcd, 03 Nov 2005
[    5.802839] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller
(OHCI) Driver
[    5.803180] USB Universal Host Controller Interface driver v3.0
[    5.803671] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
[    5.803761] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    5.803768] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    5.804621] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 2
[    5.804770] uhci_hcd 0000:00:1d.0: irq 21, io base 0x0000ff80
[    5.805472] usb usb2: configuration #1 chosen from 1 choice
[    5.805890] hub 2-0:1.0: USB hub found
[    5.806057] hub 2-0:1.0: 2 ports detected
[    5.912061] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    6.013367] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    6.013458] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.013465] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.014257] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 3
[    6.014437] uhci_hcd 0000:00:1d.1: irq 22, io base 0x0000ff60
[    6.015149] usb usb3: configuration #1 chosen from 1 choice
[    6.015571] hub 3-0:1.0: USB hub found
[    6.015670] hub 3-0:1.0: 2 ports detected
[    6.044883] usb 1-1: configuration #1 chosen from 1 choice
[    6.045406] hub 1-1:1.0: USB hub found
[    6.045602] hub 1-1:1.0: 4 ports detected
[    6.221134] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.221225] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.221232] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.221990] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 4
[    6.222169] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000ff40
[    6.222843] usb usb4: configuration #1 chosen from 1 choice
[    6.223239] hub 4-0:1.0: USB hub found
[    6.223333] hub 4-0:1.0: 2 ports detected
[    6.429189] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 23 (level, low) -> IRQ 23
[    6.429278] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    6.429285] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    6.430035] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 5
[    6.430246] uhci_hcd 0000:00:1d.3: irq 23, io base 0x0000ff20
[    6.430973] usb usb5: configuration #1 chosen from 1 choice
[    6.431400] hub 5-0:1.0: USB hub found
[    6.431496] hub 5-0:1.0: 2 ports detected
[    6.612042] usb 3-2: new low speed USB device using uhci_hcd and address 2
[    6.637419] Initializing USB Mass Storage driver...
[    6.781113] usb 3-2: configuration #1 chosen from 1 choice
[    6.896041] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    7.070853] usb 4-1: configuration #1 chosen from 1 choice
[    7.184041] usb 5-1: new full speed USB device using uhci_hcd and address 2
[    7.342919] usb 5-1: configuration #1 chosen from 1 choice
[    7.347897] usbcore: registered new interface driver usb-storage
[    7.347977] USB Mass Storage support registered.
[    7.349127] PNP: No PS/2 controller found. Probing ports directly.
[    7.352291] serio: i8042 KBD port at 0x60,0x64 irq 1
[    7.352427] serio: i8042 AUX port at 0x60,0x64 irq 12
[    7.353392] mice: PS/2 mouse device common for all mice
[    7.353853] I2O subsystem v1.325
[    7.353923] i2o: max drivers = 8
[    7.354993] I2O Configuration OSM v1.323
[    7.355259] I2O Bus Adapter OSM v1.317
[    7.355523] I2O Block Device OSM v1.325
[    7.356544] I2O SCSI Peripheral OSM v1.316
[    7.357005] I2O ProcFS OSM v1.316
[    7.358804] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    7.358936] cpuidle: using governor ladder
[    7.359005] cpuidle: using governor menu
[    7.375892] dcdbas dcdbas: Dell Systems Management Base Driver
(version 5.6.0-3.2)
[    7.381641] usbcore: registered new interface driver hiddev
[    7.395400] input: USB Optical Mouse as /class/input/input0
[    7.397992] generic-usb 0003:0461:4D15.0001: input,hidraw0: USB HID
v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.1-2/input0
[    7.414135] input: Dell Dell USB Keyboard as /class/input/input1
[    7.417014] generic-usb 0003:413C:2003.0002: input,hidraw1: USB HID
v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.2-1/input0
[    7.417404] usbcore: registered new interface driver usbhid
[    7.417483] usbhid: v2.6:USB HID core driver
[    7.417907] GACT probability NOT on
[    7.417974] Mirror/redirect action on
[    7.419705] TCP cubic registered
[    7.419775] NET: Registered protocol family 17
[    7.420498] Bridge firewalling registered
[    7.420644] Ebtables v2.0 registered
[    7.420711] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    7.420781] All bugs added by David S. Miller <davem@redhat.com>
[    7.420921] Starting balanced_irq
[    7.421080] Using IPI No-Shortcut mode
[    7.422782] BIOS EDD facility v0.16 2004-Jun-25, 1 devices found
[    7.449139] EXT3-fs: INFO: recovery required on readonly filesystem.
[    7.449212] EXT3-fs: write access will be enabled during recovery.
[    7.511953] kjournald starting.  Commit interval 5 seconds
[    7.512150] EXT3-fs: recovery complete.
[    7.513123] EXT3-fs: mounted filesystem with ordered data mode.
[    7.513315] VFS: Mounted root (ext3 filesystem) readonly.
[    7.514630] Freeing unused kernel memory: 1488k freed
[    7.515425] Write protecting the kernel text: 3316k
[    7.515770] Write protecting the kernel read-only data: 1296k
[   10.644377] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   10.644691] sd 2:0:0:0: Attached scsi generic sg1 type 0
[   11.282396] BUG: unable to handle kernel paging request at ffffffff
[   11.282554] IP: [<ffffffff>] 0xffffffff
[   11.282661] *pde = 00008067 *pte = 00000000
[   11.282806] Oops: 0000 [#1] SMP
[   11.282944] Modules linked in: button(+) evdev sg
[   11.283148]
[   11.283221] Pid: 2169, comm: modprobe Not tainted (2.6.27-smp #5)
Dell DM051
[   11.283332] EIP: 0060:[<ffffffff>] EFLAGS: 00010286 CPU: 0
[   11.284013] EIP is at 0xffffffff
[   11.284013] EAX: f70267b4 EBX: 00000000 ECX: ffffffff EDX: f61d8000
[   11.284013] ESI: f70267b4 EDI: f61d8000 EBP: f6027d3c ESP: f6027d1c
[   11.284013]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[   11.284013] Process modprobe (pid: 2169, ti=f6026000 task=f6a74680
task.ti=f6026000)
[   11.284013] Stack:
[   11.284013]  c02ca536 f6027d50 000080d0 f6acbe10 f6027d4c f7042120
f702689c c02ca400
[   11.284013]  f6027d8c c025f50a f61d8000 c052c821 c0508b7a c01509cb
00000000 00000000
[   11.284013]  c05122ad f6acbe10 c0508b7a c059e040 f61d8000 c0439738
f6027d94 c02d10f6
[   11.284013] Call Trace:
[   11.284013]  [<c02ca536>] ? dev_uevent+0x136/0x1d0
[   11.284013]  [<c02ca400>] ? dev_uevent+0x0/0x1d0
[   11.284013]  [<c025f50a>] ? kobject_uevent_env+0x18a/0x380
[   11.284013]  [<c01509cb>] ? trace_hardirqs_on+0xb/0x10
[   11.284013]  [<c0439738>] ? mutex_unlock+0x8/0x10
[   11.284013]  [<c02d10f6>] ? device_pm_add+0x56/0xb0
[   11.284013]  [<c025f70a>] ? kobject_uevent+0xa/0x10
[   11.284013]  [<c02cb3e4>] ? device_add+0x454/0x600
[   11.284013]  [<f80821e9>] ? acpi_button_notify_fixed+0x0/0x20 [button]
[   11.284013]  [<c015093d>] ? trace_hardirqs_on_caller+0xbd/0x140
[   11.284013]  [<c01509cb>] ? trace_hardirqs_on+0xb/0x10
[   11.284013]  [<c0377c78>] ? input_register_device+0x88/0x1f0
[   11.284013]  [<f80825dc>] ? acpi_button_add+0x319/0x425 [button]
[   11.284013]  [<c02a303b>] ? acpi_device_probe+0x3a/0x88
[   11.284013]  [<c02cd37e>] ? driver_probe_device+0x7e/0x170
[   11.284013]  [<c02cd4e5>] ? __driver_attach+0x75/0x80
[   11.284013]  [<c02cca29>] ? bus_for_each_dev+0x49/0x70
[   11.284013]  [<c02cd1f9>] ? driver_attach+0x19/0x20
[   11.284013]  [<c02cd470>] ? __driver_attach+0x0/0x80
[   11.284013]  [<c02ccf81>] ? bus_add_driver+0x1b1/0x230
[   11.284013]  [<c02a2f9f>] ? acpi_device_remove+0x0/0x62
[   11.284013]  [<c02cd67f>] ? driver_register+0x4f/0x120
[   11.284013]  [<f8086000>] ? acpi_button_init+0x0/0x51 [button]
[   11.284013]  [<c01cd1e3>] ? proc_mkdir_mode+0x33/0x50
[   11.284013]  [<f8086000>] ? acpi_button_init+0x0/0x51 [button]
[   11.284013]  [<c02a332c>] ? acpi_bus_register_driver+0x3a/0x3c
[   11.284013]  [<f8086032>] ? acpi_button_init+0x32/0x51 [button]
[   11.284013]  [<c010111a>] ? do_one_initcall+0x2a/0x150
[   11.284013]  [<c014d82b>] ? trace_hardirqs_off+0xb/0x10
[   11.284013]  [<c043b4d7>] ? _spin_unlock_irqrestore+0x37/0x60
[   11.284013]  [<c012667a>] ? try_to_wake_up+0xca/0x160
[   11.284013]  [<c01509cb>] ? trace_hardirqs_on+0xb/0x10
[   11.284013]  [<c015093d>] ? trace_hardirqs_on_caller+0xbd/0x140
[   11.284013]  [<c015bf15>] ? sys_init_module+0x85/0x1b0
[   11.284013]  [<c015093d>] ? trace_hardirqs_on_caller+0xbd/0x140
[   11.284013]  [<c0264264>] ? trace_hardirqs_on_thunk+0xc/0x10
[   11.284013]  [<c0103e22>] ? syscall_call+0x7/0xb
[   11.284013] Code:  Bad EIP value.
[   11.284013] EIP: [<ffffffff>] 0xffffffff SS:ESP 0068:f6027d1c
[   11.284013] ---[ end trace 8aedfe1cfa9aa99a ]---
[   11.640783] Linux agpgart interface v0.103
[   11.720111] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level,
low) -> IRQ 17
[   11.839081] rtc_cmos 00:05: RTC can wake from S4
[   11.839417] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[   11.839522] rtc0: alarms up to one day, hpet irqs
[   11.982530] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level,
low) -> IRQ 16
[   11.982831] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.013421] usbcore: registered new interface driver usbserial
[   12.013501] usbserial: USB Serial Driver core
[   12.076298] usbserial: USB Serial support registered for pl2303
[   12.076458] pl2303 5-1:1.0: pl2303 converter detected
[   12.088454] usb 5-1: pl2303 converter now attached to ttyUSB0
[   12.088605] usbcore: registered new interface driver pl2303
[   12.088685] pl2303: Prolific PL2303 USB to serial adaptor driver
[   12.197887] 3c59x 0000:03:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   12.198005] 3c59x: Donald Becker and others.
[   12.198102] 0000:03:02.0: 3Com PCI 3c905C Tornado at f81a6f80.
[   12.229792] udev: renamed network interface eth0 to eth1
[   42.224017] thermal: gave up waiting for init of module processor.
[   42.224094] thermal: Unknown symbol acpi_processor_set_thermal_limit
[   42.228591] e100: Intel(R) PRO/100 Network Driver, 3.5.23-k4-NAPI
[   42.228667] e100: Copyright(c) 1999-2006 Intel Corporation
[   42.228834] e100 0000:03:08.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[   42.253651] e100 0000:03:08.0: PME# disabled
[   42.254504] e100: eth0: e100_probe: addr 0xefaff000, irq 20, MAC
addr 00:13:72:e7:4d:66
[  117.954860] SysRq : Show Blocked State
[  117.954960]   task                PC stack   pid father
[  117.955037] modprobe      D f675bdac     0  2170   2167
[  117.955167]  f675be08 00000046 00000246 f675bdac 00000046 00000001
f739e9c0 f6cbf918
[  117.955510]  f675bdac c07490e0 c074c500 c074c500 c074c500 00000001
f739eb14 c205b500
[  117.955853]  00000001 00000000 f675be18 f6631e00 00000000 f70d0b78
f739e9c0 f739e9c0
[  117.956196] Call Trace:
[  117.956269]  [<c014e72a>] ? print_lock_contention_bug+0x1a/0xe0
[  117.956340]  [<c014e72a>] ? print_lock_contention_bug+0x1a/0xe0
[  117.956413]  [<c0438fa5>] schedule_timeout+0x75/0xc0
[  117.956483]  [<c01509cb>] ? trace_hardirqs_on+0xb/0x10
[  117.956552]  [<c0439fd9>] __down+0x49/0x70
[  117.956626]  [<c014589e>] down+0x3e/0x40
[  117.956696]  [<c02cd4a6>] __driver_attach+0x36/0x80
[  117.956767]  [<c02cca29>] bus_for_each_dev+0x49/0x70
[  117.956838]  [<c02cd1f9>] driver_attach+0x19/0x20
[  117.956907]  [<c02cd470>] ? __driver_attach+0x0/0x80
[  117.956977]  [<c02ccf81>] bus_add_driver+0x1b1/0x230
[  117.957048]  [<c02a2f9f>] ? acpi_device_remove+0x0/0x62
[  117.957118]  [<c02cd67f>] driver_register+0x4f/0x120
[  117.957192]  [<f80a0000>] ? acpi_processor_init+0x0/0xea [processor]
[  117.957267]  [<f80a0000>] ? acpi_processor_init+0x0/0xea [processor]
[  117.957339]  [<c02a332c>] acpi_bus_register_driver+0x3a/0x3c
[  117.957412]  [<f80a0081>] acpi_processor_init+0x81/0xea [processor]
[  117.957484]  [<c010111a>] do_one_initcall+0x2a/0x150
[  117.957554]  [<c014d82b>] ? trace_hardirqs_off+0xb/0x10
[  117.957625]  [<c043b4d7>] ? _spin_unlock_irqrestore+0x37/0x60
[  117.957696]  [<c012667a>] ? try_to_wake_up+0xca/0x160
[  117.957768]  [<c015bf15>] sys_init_module+0x85/0x1b0
[  117.957839]  [<c018f27d>] ? sys_read+0x3d/0x70
[  117.957909]  [<c0264264>] ? trace_hardirqs_on_thunk+0xc/0x10
[  117.957980]  [<c0103e22>] syscall_call+0x7/0xb
[  117.958049] Sched Debug Version: v0.07, 2.6.27-smp #5
[  117.958117] now at 117958.053607 msecs
[  117.958183]   .sysctl_sched_latency                    : 40.000000
[  117.958253]   .sysctl_sched_min_granularity            : 8.000000
[  117.958322]   .sysctl_sched_wakeup_granularity         : 10.000000
[  117.958392]   .sysctl_sched_child_runs_first           : 0.000001
[  117.958461]   .sysctl_sched_features                   : 7935
[  117.958530]
[  117.958531] cpu#0, 2792.711 MHz
[  117.958655]   .nr_running                    : 1
[  117.958722]   .load                          : 3121
[  117.958789]   .nr_switches                   : 40067
[  117.958831]   .nr_load_updates               : 3106
[  117.958831]   .nr_uninterruptible            : 4294967260
[  117.958831]   .jiffies                       : 4294921784
[  117.958831]   .next_balance                  : 4294.921774
[  117.958831]   .curr->pid                     : 0
[  117.958831]   .clock                         : 117954.854961
[  117.958831]   .cpu_load[0]                   : 0
[  117.958831]   .cpu_load[1]                   : 0
[  117.958831]   .cpu_load[2]                   : 0
[  117.958831]   .cpu_load[3]                   : 0
[  117.958831]   .cpu_load[4]                   : 0
[  117.958831]
[  117.958831] cfs_rq[0]:
[  117.958831]   .exec_clock                    : 0.000000
[  117.958831]   .MIN_vruntime                  : 47101.787051
[  117.958831]   .min_vruntime                  : 47141.329297
[  117.958831]   .max_vruntime                  : 47101.787051
[  117.958831]   .spread                        : 0.000000
[  117.958831]   .spread0                       : 0.000000
[  117.958831]   .nr_running                    : 1
[  117.958831]   .load                          : 3121
[  117.958831]   .nr_spread_over                : 0
[  117.958831]
[  117.958831] rt_rq[0]:
[  117.958831]   .rt_nr_running                 : 0
[  117.958831]   .rt_throttled                  : 0
[  117.958831]   .rt_time                       : 0.000000
[  117.958831]   .rt_runtime                    : 950.000000
[  117.958831]
[  117.958831] runnable tasks:
[  117.958831]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  117.958831] ----------------------------------------------------------------------------------------------------------
[  117.958831]         events/0     9     47101.787051       137   115
              0               0               0.000000
0.000000               0.000000
[  117.958831]
[  117.958831] cpu#1, 2792.711 MHz
[  117.958831]   .nr_running                    : 0
[  117.958831]   .load                          : 0
[  117.958831]   .nr_switches                   : 12371
[  117.958831]   .nr_load_updates               : 1847
[  117.958831]   .nr_uninterruptible            : 37
[  117.958831]   .jiffies                       : 4294921784
[  117.958831]   .next_balance                  : 4294.920669
[  117.958831]   .curr->pid                     : 0
[  117.958831]   .clock                         : 117952.009013
[  117.958831]   .cpu_load[0]                   : 0
[  117.958831]   .cpu_load[1]                   : 0
[  117.958831]   .cpu_load[2]                   : 0
[  117.958831]   .cpu_load[3]                   : 0
[  117.958831]   .cpu_load[4]                   : 5
[  117.958831]
[  117.958831] cfs_rq[1]:
[  117.958831]   .exec_clock                    : 0.000000
[  117.958831]   .MIN_vruntime                  : 0.000001
[  117.958831]   .min_vruntime                  : 48215.087202
[  117.958831]   .max_vruntime                  : 0.000001
[  117.958831]   .spread                        : 0.000000
[  117.958831]   .spread0                       : 1073.757905
[  117.958831]   .nr_running                    : 0
[  117.958831]   .load                          : 0
[  117.958831]   .nr_spread_over                : 0
[  117.958831]
[  117.958831] rt_rq[1]:
[  117.958831]   .rt_nr_running                 : 0
[  117.958831]   .rt_throttled                  : 0
[  117.958831]   .rt_time                       : 0.000000
[  117.958831]   .rt_runtime                    : 950.000000
[  117.958831]
[  117.958831] runnable tasks:
[  117.958831]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  117.958831] ----------------------------------------------------------------------------------------------------------
[  117.958831]
[  129.740364] Adding 1116476k swap on /dev/sda8.  Priority:-1
extents:1 across:1116476k
[  129.856704] fuse init (API version 7.9)
[  131.131832] EXT3 FS on sda5, internal journal
[  135.276330] kjournald starting.  Commit interval 5 seconds
[  135.276735] EXT3 FS on sda7, internal journal
[  135.276846] EXT3-fs: mounted filesystem with ordered data mode.
[  136.484067] eth1:  setting full-duplex.
[  194.563265] Bluetooth: Core ver 2.13
[  194.566089] NET: Registered protocol family 31
[  194.566158] Bluetooth: HCI device and connection manager initialized
[  194.566230] Bluetooth: HCI socket layer initialized
[  194.653181] Bluetooth: L2CAP ver 2.11
[  194.653255] Bluetooth: L2CAP socket layer initialized
[  194.878311] Bluetooth: RFCOMM socket layer initialized
[  194.878419] Bluetooth: RFCOMM TTY layer initialized
[  194.878487] Bluetooth: RFCOMM ver 1.10
[  320.040017] thermal: gave up waiting for init of module processor.
[  320.040093] thermal: Unknown symbol acpi_processor_set_thermal_limit
[ 4284.368060] hub 5-0:1.0: port 1 disabled by hub (EMI?), re-enabling...
[ 4284.368069] usb 5-1: USB disconnect, address 2
[ 4284.369634] pl2303 5-1:1.0: device disconnected
[ 4284.468669] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
[ 4284.608028] usb 5-1: new full speed USB device using uhci_hcd and address 3
[ 4284.767182] usb 5-1: configuration #1 chosen from 1 choice
[ 4284.770032] pl2303 5-1:1.0: pl2303 converter detected
[ 4284.794181] usb 5-1: pl2303 converter now attached to ttyUSB0
[ 4286.988130] e100: eth0: e100_watchdog: link up, 100Mbps, full-duplex

-- 
Regards
dave
