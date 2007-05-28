Return-Path: <linux-kernel-owner+w=401wt.eu-S1759803AbXE1OIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759803AbXE1OIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 10:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191AbXE1OHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 10:07:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:34859 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbXE1OHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 10:07:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Pr5ibDWAuj6Phj/nKhwPc0CDrD8KFbqn3b9NDCOWqxXey2qpbyu5n2DQDd6g+MOvR14GG4xtFLLtWyiCBHwFy81y4/5hZmAC9mrynZ7mkDBHlBqXhTCfTElbuQTX9aLOfce3YDmFLpiiZSgmWfaer0rMSInDj3PWP9aMsEzdQUI=
Message-ID: <9d2cd630705280707h4921900fxc93a07a87f0bdf66@mail.gmail.com>
Date: Mon, 28 May 2007 16:07:48 +0200
From: "Gregor Jasny" <gjasny@googlemail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: Linux v2.6.22-rc3
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <465AA536.6080608@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.98.0705252008210.26602@woody.linux-foundation.org>
	 <9d2cd630705270801m2826be60p3f802c502b26c531@mail.gmail.com>
	 <46599E6B.1000209@pobox.com>
	 <9d2cd630705270907y4722653cpf79f073fa8f12f08@mail.gmail.com>
	 <alpine.LFD.0.98.0705270922030.26602@woody.linux-foundation.org>
	 <9d2cd630705271315x7030c91ew2f175c921c022880@mail.gmail.com>
	 <465AA536.6080608@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

2007/5/28, Tejun Heo <htejun@gmail.com>:
> I can't find the rest of this thread.
http://lkml.org/lkml/2007/5/27/63
Old report:
http://lkml.org/lkml/2007/3/1/243

>  Can you post the result of 'dmesg' and 'lspci -nn'?

2.6.22-rc3 dmesg:
[    0.000000] On node 0 totalpages: 65499
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 479 pages used for memmap
[    0.000000]   Normal zone: 60924 pages, LIFO batch:15
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F4040, 0014 (r0 DELL  )
[    0.000000] ACPI: RSDT 0FFF0000, 0028 (r1 DELL    CPi R   27D2051C
ASL        61)
[    0.000000] ACPI: FACP 0FFF0400, 0074 (r1 DELL    CPi R   27D2051C
ASL        61)
[    0.000000] ACPI: DSDT 0FFF0800, 29A6 (r1 INT430 SYSFexxx     1001
MSFT  100000D)
[    0.000000] ACPI: FACS 0FFFF800, 0040
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
10100000:efd00000)
[    0.000000] Built 1 zonelists.  Total pages: 64988
[    0.000000] Kernel command line: root=/dev/sda1 ro vga=0x317 resume=/dev/sda3
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 1024 (order: 10, 4096 bytes)
[    0.000000] Detected 497.852 MHz processor.
[   17.951694] Console: colour dummy device 80x25
[   17.952386] Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
[   17.953014] Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
[   17.986017] Memory: 256764k/261996k available (1555k kernel code,
4684k reserved, 564k data, 124k init, 0k highmem)
[   17.986078] virtual kernel memory layout:
[   17.986083]     fixmap  : 0xffff8000 - 0xfffff000   (  28 kB)
[   17.986089]     vmalloc : 0xd0800000 - 0xffff6000   ( 759 MB)
[   17.986096]     lowmem  : 0xc0000000 - 0xcffdb000   ( 255 MB)
[   17.986102]       .init : 0xc0314000 - 0xc0333000   ( 124 kB)
[   17.986107]       .data : 0xc0284d5d - 0xc0311e94   ( 564 kB)
[   17.986113]       .text : 0xc0100000 - 0xc0284d5d   (1555 kB)
[   17.986177] Checking if this processor honours the WP bit even in
supervisor mode... Ok.
[   17.986342] SLUB: Genslabs=23, HWalign=32, Order=0-1, MinObjects=4,
Processors=1, Nodes=1
[   18.069679] Calibrating delay using timer specific routine.. 996.72
BogoMIPS (lpj=1660367)
[   18.069779] Mount-cache hash table entries: 512
[   18.070072] CPU: After generic identify, caps: 0383f9ff 00000000
00000000 00000000 00000000 00000000 00000000
[   18.070110] CPU: L1 I cache: 16K, L1 D cache: 16K
[   18.070130] CPU: L2 cache: 256K
[   18.070145] CPU: After all inits, caps: 0383f9ff 00000000 00000000
00000040 00000000 00000000 00000000
[   18.070168] Intel machine check architecture supported.
[   18.070189] Intel machine check reporting enabled on CPU#0.
[   18.070215] Compat vDSO mapped to ffffe000.
[   18.070260] CPU: Intel Pentium III (Coppermine) stepping 01
[   18.070287] Checking 'hlt' instruction... OK.
[   18.083143] ACPI: Core revision 20070126
[   18.087856] ACPI: setting ELCR to 0200 (from 0820)
[   18.090228] NET: Registered protocol family 16
[   18.090500] ACPI: bus type pci registered
[   18.094673] PCI: PCI BIOS revision 2.10 entry at 0xfc0ae, last bus=1
[   18.094693] PCI: Using configuration type 1
[   18.094708] Setting up standard PCI resources
[   18.130663] ACPI: Interpreter enabled
[   18.130700] ACPI: (supports S0 S1 S3 S4 S5)
[   18.130775] ACPI: Using PIC for interrupt routing
[   18.168609] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   18.168698] PCI: Probing PCI hardware (bus 00)
[   18.169221] PCI quirk: region 0800-083f claimed by PIIX4 ACPI
[   18.169246] PCI quirk: region 0840-084f claimed by PIIX4 SMB
[   18.169267] PIIX4 devres B PIO at 00e0-00e7
[   18.169284] PIIX4 devres C PIO at 0850-085f
[   18.169888] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   18.170186] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
[   18.253152] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10
*11 12 14 15)
[   18.253575] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10
11 12 14 15)
[   18.253923] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 11
12 14 15) *0, disabled.
[   18.254333] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10
*11 12 14 15)
[   18.254760] ACPI: Power Resource [PADA] (on)
[   18.254800] Linux Plug and Play Support v0.97 (c) Adam Belay
[   18.254842] pnp: PnP ACPI init
[   18.254880] ACPI: bus type pnp registered
[   18.324625] pnp: PnP ACPI: found 13 devices
[   18.324657] ACPI: ACPI bus type pnp unregistered
[   18.325044] SCSI subsystem initialized
[   18.325126] libata version 2.21 loaded.
[   18.325204] PCI: Using ACPI for IRQ routing
[   18.325225] PCI: If a device doesn't work, try "pci=routeirq".  If
it helps, post a report
[   18.328448] pnp: 00:00: iomem range 0x0-0x9fbff could not be reserved
[   18.328475] pnp: 00:00: iomem range 0x9fc00-0x9ffff could not be reserved
[   18.328497] pnp: 00:00: iomem range 0xc0000-0xcffff could not be reserved
[   18.328519] pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
[   18.328551] pnp: 00:02: ioport range 0x4d0-0x4d1 has been reserved
[   18.328572] pnp: 00:02: ioport range 0x800-0x805 has been reserved
[   18.328592] pnp: 00:02: ioport range 0x808-0x80f has been reserved
[   18.328636] pnp: 00:03: ioport range 0x806-0x807 has been reserved
[   18.328656] pnp: 00:03: ioport range 0x850-0x853 has been reserved
[   18.328676] pnp: 00:03: ioport range 0x856-0x85f has been reserved
[   18.328696] pnp: 00:03: ioport range 0x810-0x83f has been reserved
[   18.328716] pnp: 00:03: ioport range 0x840-0x84f has been reserved
[   18.328736] pnp: 00:03: ioport range 0x600-0x67f has been reserved
[   18.328756] pnp: 00:03: ioport range 0x680-0x6ff has been reserved
[   18.328786] pnp: 00:04: ioport range 0xf000-0xf0fe has been reserved
[   18.328807] pnp: 00:04: ioport range 0xf100-0xf1fe has been reserved
[   18.328828] pnp: 00:04: ioport range 0xf200-0xf2fe has been reserved
[   18.328848] pnp: 00:04: ioport range 0xf400-0xf4fe has been reserved
[   18.328868] pnp: 00:04: ioport range 0xf500-0xf5fe has been reserved
[   18.328889] pnp: 00:04: ioport range 0xf600-0xf6fe has been reserved
[   18.328909] pnp: 00:04: ioport range 0xf800-0xf8fe has been reserved
[   18.328929] pnp: 00:04: ioport range 0xf900-0xf9fe has been reserved
[   18.328951] pnp: 00:04: iomem range 0xed000000-0xedffffff has been reserved
[   18.328988] pnp: 00:09: ioport range 0x3f0-0x3f1 has been reserved
[   18.329549] Time: tsc clocksource has been installed.
[   18.360100] PCI: Bridge: 0000:00:01.0
[   18.360122]   IO window: e000-efff
[   18.360140]   MEM window: fc000000-feffffff
[   18.360159]   PREFETCH window: 30000000-300fffff
[   18.360178] PCI: Bus 2, cardbus bridge: 0000:00:03.0
[   18.360195]   IO window: 00001000-000010ff
[   18.360212]   IO window: 00001400-000014ff
[   18.360229]   PREFETCH window: 20000000-23ffffff
[   18.360247]   MEM window: 24000000-27ffffff
[   18.360265] PCI: Bus 6, cardbus bridge: 0000:00:03.1
[   18.360281]   IO window: 00001800-000018ff
[   18.360298]   IO window: 00001c00-00001cff
[   18.360315]   PREFETCH window: 28000000-2bffffff
[   18.360334]   MEM window: 2c000000-2fffffff
[   18.360380] PCI: Enabling device 0000:00:03.0 (0000 -> 0003)
[   18.361012] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
[   18.361034] PCI: setting IRQ 11 as level-triggered
[   18.361045] ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKD] ->
GSI 11 (level, low) -> IRQ 11
[   18.361093] PCI: Enabling device 0000:00:03.1 (0000 -> 0003)
[   18.361113] ACPI: PCI Interrupt 0000:00:03.1[A] -> Link [LNKD] ->
GSI 11 (level, low) -> IRQ 11
[   18.361179] NET: Registered protocol family 2
[   18.392920] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[   18.393035] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[   18.393248] TCP bind hash table entries: 8192 (order: 3, 32768 bytes)
[   18.393361] TCP: Hash tables configured (established 8192 bind 8192)
[   18.393381] TCP reno registered
[   18.413562] io scheduler noop registered
[   18.413602] io scheduler anticipatory registered (default)
[   18.413619] io scheduler deadline registered
[   18.413871] io scheduler cfq registered
[   18.413896] Limiting direct PCI/PCI transfers.
[   18.413959] Boot video device is 0000:01:00.0
[   18.414312] vesafb: framebuffer at 0xfd000000, mapped to
0xd0880000, using 3072k, total 8128k
[   18.414346] vesafb: mode is 1024x768x16, linelength=2048, pages=4
[   18.414365] vesafb: protected mode interface info at c000:5044
[   18.414385] vesafb: pmi: set display start = c00c50aa, set palette = c00c5104
[   18.414403] vesafb: pmi: ports = ec85 ec1f ecb4 ecb8 ec18 ec14 ecc0 ecc3 ecc1
[   18.414441] vesafb: scrolling: redraw
[   18.414460] vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
[   18.453475] Console: switching to colour frame buffer device 128x48
[   18.492137] fb0: VESA VGA frame buffer device
[   18.493594] ACPI: AC Adapter [AC] (on-line)
[   18.578801] ACPI: Battery Slot [BAT0] (battery present)
[   18.579831] ACPI: Battery Slot [BAT1] (battery absent)
[   18.580614] input: Lid Switch as /class/input/input0
[   18.580999] ACPI: Lid Switch [LID]
[   18.581473] input: Power Button (CM) as /class/input/input1
[   18.581896] ACPI: Power Button (CM) [PBTN]
[   18.582436] input: Sleep Button (CM) as /class/input/input2
[   18.582872] ACPI: Sleep Button (CM) [SBTN]
[   18.583593] ACPI: CPU0 (power states: C1[C1] C2[C2])
[   18.628870] ACPI: Thermal Zone [THM] (25 C)
[   18.637506] i8k: unable to get SMM BIOS version
[   18.637887] Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal
Zotto (dz@debian.org)
[   18.639188] ata_piix 0000:00:07.1: version 2.11
[   18.639718] scsi0 : ata_piix
[   18.640189] scsi1 : ata_piix
[   18.640541] ata1: PATA max UDMA/33 cmd 0x000101f0 ctl 0x000103f6
bmdma 0x00010860 irq 14
[   18.641148] ata2: PATA max UDMA/33 cmd 0x00010170 ctl 0x00010376
bmdma 0x00010868 irq 15
[    0.653333] Marking TSC unstable due to: possible TSC halt in C2.
[    0.656666] Time: acpi_pm clocksource has been installed.
[    0.656666] Switched to NOHz mode on CPU #0
[    0.779999] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.779999] ata1.00: ATA-7: SAMSUNG MP0402H, UC100-14, max UDMA/100
[    0.796666] ata1.00: 78242976 sectors, multi 8: LBA48
[    0.816666] ata1.00: ata_hpa_resize 1: sectors = 78242976,
hpa_sectors = 78242976
[    0.829999] ata1.00: configured for UDMA/33
[    1.376666] Clocksource tsc unstable (delta = -496294688 ns)
[   10.866665] ata2: SRST failed (errno=-16)
[   20.899997] ata2: SRST failed (errno=-16)
[   55.946661] ata2: SRST failed (errno=-16)
[   60.966660] ata2: SRST failed (errno=-16)
[   60.979993] ata2: reset failed, giving up
[   60.993327] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG
MP0402H  UC10 PQ: 0 ANSI: 5
[   61.009993] sd 0:0:0:0: [sda] 78242976 512-byte hardware sectors (40060 MB)
[   61.023327] sd 0:0:0:0: [sda] Write Protect is off
[   61.039993] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   61.039993] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   61.056660] sd 0:0:0:0: [sda] 78242976 512-byte hardware sectors (40060 MB)
[   61.069993] sd 0:0:0:0: [sda] Write Protect is off
[   61.086660] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   61.086660] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   61.103327]  sda: sda1 sda2 sda3 sda4
[   61.559993] sd 0:0:0:0: [sda] Attached SCSI disk
[   61.576660] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   61.589993] PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:PS2M] at
0x60,0x64 irq 1,12
[   61.616660] serio: i8042 KBD port at 0x60,0x64 irq 1
[   61.629993] serio: i8042 AUX port at 0x60,0x64 irq 12
[   61.646660] mice: PS/2 mouse device common for all mice
[   61.666660] input: AT Translated Set 2 keyboard as /class/input/input3
[   61.683327] TCP cubic registered
[   61.699993] NET: Registered protocol family 1
[   61.713327] NET: Registered protocol family 17
[   61.729993] Using IPI Shortcut mode
[   62.333327] input: DualPoint Stick as /class/input/input4
[   62.363327] input: AlpsPS/2 ALPS DualPoint TouchPad as /class/input/input5
[   62.496660] kjournald starting.  Commit interval 5 seconds
[   62.513327] EXT3-fs: mounted filesystem with ordered data mode.
[   62.526660] VFS: Mounted root (ext3 filesystem) readonly.
[   62.543327] Freeing unused kernel memory: 124k freed
[   65.916660] Yenta: CardBus bridge found at 0000:00:03.0 [1028:00aa]
[   65.933326] Yenta: Using CSCINT to route CSC interrupts to PCI
[   65.949993] Yenta: Routing CardBus interrupts to PCI
[   65.966660] Yenta TI: socket 0000:00:03.0, mfunc 0x01261222, devctl 0x66
[   66.163326] Linux agpgart interface v0.102 (c) Dave Jones
[   66.213326] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[   66.229993] Socket status: 30000010
[   66.499993] Yenta: CardBus bridge found at 0000:00:03.1 [1028:00aa]
[   66.513326] Yenta: Using CSCINT to route CSC interrupts to PCI
[   66.529993] Yenta: Routing CardBus interrupts to PCI
[   66.546660] Yenta TI: socket 0000:00:03.1, mfunc 0x01261222, devctl 0x66
[   66.589993] usbcore: registered new interface driver usbfs
[   66.606660] usbcore: registered new interface driver hub
[   66.623326] usbcore: registered new device driver usb
[   66.763326] USB Universal Host Controller Interface driver v3.0
[   66.793326] Yenta: ISA IRQ mask 0x04b8, PCI irq 11
[   66.809993] Socket status: 30000006
[   67.079993] agpgart: Detected an Intel 440BX Chipset.
[   67.099993] agpgart: AGP aperture is 64M @ 0xf4000000
[   67.146659] pccard: PCMCIA card inserted into slot 0
[   67.183326] ACPI: PCI Interrupt 0000:00:07.2[D] -> Link [LNKD] ->
GSI 11 (level, low) -> IRQ 11
[   67.199993] uhci_hcd 0000:00:07.2: UHCI Host Controller
[   67.216659] uhci_hcd 0000:00:07.2: new USB bus registered, assigned
bus number 1
[   67.233326] uhci_hcd 0000:00:07.2: irq 11, io base 0x0000dce0
[   67.249993] usb usb1: configuration #1 chosen from 1 choice
[   67.266659] hub 1-0:1.0: USB hub found
[   67.286659] hub 1-0:1.0: 2 ports detected
[   67.759993] Real Time Clock Driver v1.12ac
[   68.056659] Floppy drive(s): fd0 is 1.44M
[   68.103326] FDC 0 is a post-1991 82077
[   68.533326] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 5
[   68.549993] PCI: setting IRQ 5 as level-triggered
[   68.549993] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LNKB] ->
GSI 5 (level, low) -> IRQ 5
[   69.166659] es1968: clocking to 48000
[   69.379993] cs: IO port probe 0x100-0x4ff: clean.
[   69.396659] cs: IO port probe 0x800-0x8ff: clean.
[   69.413326] cs: IO port probe 0xc00-0xcff: clean.
[   69.429993] cs: IO port probe 0xa00-0xaff: clean.
[   69.446659] cs: memory probe 0xa0000000-0xa0ffffff: clean.
[   69.466659] pcmcia: registering new device pcmcia0.0
[   69.543326] cs: IO port probe 0x100-0x4ff: clean.
[   69.559993] cs: IO port probe 0x800-0x8ff: clean.
[   69.576659] cs: IO port probe 0xc00-0xcff: clean.
[   69.589993] cs: IO port probe 0xa00-0xaff: clean.
[   70.016659] eth0: NE2000 Compatible: io 0x300, irq 3, hw_addr
00:E0:98:8B:B5:17
[   71.556659] Adding 506036k swap on /dev/sda3.  Priority:-1
extents:1 across:506036k
[   71.843326] EXT3 FS on sda1, internal journal
[   73.346659] device-mapper: ioctl: 4.11.0-ioctl (2006-10-12)
initialised: dm-devel@redhat.com
[  220.306644] fuse init (API version 7.8)
[  220.469977] kjournald starting.  Commit interval 5 seconds
[  220.486644] EXT3 FS on dm-0, internal journal
[  220.503311] EXT3-fs: mounted filesystem with ordered data mode.

00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX
Host bridge (rev 03)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 32
        Region 0: Memory at f4000000 (32-bit, prefetchable) [size=64M]
        Capabilities: [a0] AGP version 1.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
FW- Rate=<none>

00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP
bridge (rev 03) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV+ VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
        I/O behind bridge: 0000e000-0000efff
        Memory behind bridge: fc000000-feffffff
        Prefetchable memory behind bridge: 30000000-300fffff
        Secondary status: 66MHz+ FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B+

00:03.0 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Dell Unknown device 00aa
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 30100000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=02, subordinate=05, sec-latency=176
        Memory window 0: 20000000-23fff000 (prefetchable)
        Memory window 1: 24000000-27fff000
        I/O window 0: 00001000-000010ff
        I/O window 1: 00001400-000014ff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

00:03.1 CardBus bridge: Texas Instruments PCI1225 (rev 01)
        Subsystem: Dell Unknown device 00aa
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at 30101000 (32-bit, non-prefetchable) [size=4K]
        Bus: primary=00, secondary=06, subordinate=09, sec-latency=176
        Memory window 0: 28000000-2bfff000 (prefetchable)
        Memory window 1: 2c000000-2ffff000
        I/O window 0: 00001800-000018ff
        I/O window 1: 00001c00-00001cff
        BridgeCtl: Parity- SERR- ISA- VGA- MAbort- >Reset+ 16bInt+ PostWrite+
        16-bit legacy interface ports at 0001

00:07.0 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev
01) (prog-if 80 [Master])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at 0860 [size=16]

00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB (rev
01) (prog-if 00 [UHCI])
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Interrupt: pin D routed to IRQ 11
        Region 4: I/O ports at dce0 [size=32]

00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 03)
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin ? routed to IRQ 9

00:08.0 Multimedia audio controller: ESS Technology ES1978 Maestro 2E (rev 10)
        Subsystem: Dell Unknown device 00aa
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min, 6000ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: I/O ports at d800 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: ATI Technologies Inc Rage Mobility
P/M AGP 2x (rev 64) (prog-if 00 [VGA])
        Subsystem: Dell Latitude CPt
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (2000ns min), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: I/O ports at ec00 [size=256]
        Region 2: Memory at fcfff000 (32-bit, non-prefetchable) [size=4K]
        [virtual] Expansion ROM at 30000000 [disabled] [size=128K]
        Capabilities: [50] AGP version 1.0
                Status: RQ=256 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
FW- Rate=<none>
        Capabilities: [5c] Power Management version 1
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

Thanks!
Gregor
