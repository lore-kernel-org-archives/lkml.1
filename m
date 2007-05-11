Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbXEKX7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbXEKX7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 19:59:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755568AbXEKX7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 19:59:09 -0400
Received: from simmts7-qfe0.srvr.bell.ca ([206.47.199.165]:45407 "EHLO
	simmts7-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754892AbXEKX7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 19:59:07 -0400
Message-ID: <4645032E.1030109@gmail.com>
Date: Fri, 11 May 2007 20:58:38 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070509)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86 setup rewrite tree ready for flamage^W review
References: <464158E9.2000207@zytor.com>
In-Reply-To: <464158E9.2000207@zytor.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Hello all,
>
> I believe the x86 setup tree is now finished.  I will turn it into a
> "clean patchset" later this week, but I wanted to get flamed^W feedback
> on it first.
>
> The git tree is at:
>
> http://git.kernel.org/?p=linux/kernel/git/hpa/linux-2.6-newsetup.git;a=summary
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-newsetup.git
> ...
>
> ... and a flat patch at ...
>
> http://www.kernel.org/pub/linux/kernel/people/hpa/newsetup-36f021b5.patch
>
> 	-hpa
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
>   
Not sure if you were looking for testing, but I fuzzed it to apply to
2.6.21-git and gave it a spin.  Worked just like a normal boot (which I
assume was the point).

[    0.000000] Linux version 2.6.21-g0a3fd051-dirty (kevin@kevin) (gcc
version 4.1.2 (Gentoo 4.1.2)) #9 PREEMPT Fri May 11 20:50:02 ADT 2007
[    0.000000] Command line: root=/dev/sda3
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
[    0.000000]  BIOS-e820: 000000001fef0000 - 000000001fef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000001fef3000 - 000000001ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of
256 used
[    0.000000] end_pfn_map = 1048576
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F77D0, 0014 (r0 VIAK8T)
[    0.000000] ACPI: RSDT 1FEF3040, 0034 (r1 VIAK8T AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: FACP 1FEF30C0, 0074 (r1 VIAK8T AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: DSDT 1FEF3180, 4F8A (r1 VIAK8T AWRDACPI     1000
MSFT  100000E)
[    0.000000] ACPI: FACS 1FEF0000, 0040
[    0.000000] ACPI: BOOT 1FEF8180, 0028 (r1 VIAK8T AWRDACPI 42302E31
AWRD        0)
[    0.000000] ACPI: SSDT 1FEF82C0, 00B5 (r1 PTLTD  POWERNOW        1 
LTP        1)
[    0.000000] ACPI: APIC 1FEF8200, 0068 (r1 VIAK8T AWRDACPI 42302E31
AWRD        0)
[    0.000000] Entering add_active_range(0, 0, 159) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 130800) 1 entries of
256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  1048576
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0:        0 ->      159
[    0.000000]     0:      256 ->   130800
[    0.000000] On node 0 totalpages: 130703
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1356 pages reserved
[    0.000000]   DMA zone: 2587 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 1732 pages used for memmap
[    0.000000]   DMA32 zone: 124972 pages, LIFO batch:31
[    0.000000]   Normal zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 20000000 (gap:
1ff00000:ded00000)
[    0.000000] Built 1 zonelists.  Total pages: 127559
[    0.000000] Kernel command line: root=/dev/sda3
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 2048 (order: 11, 16384 bytes)
[   13.327158] time.c: Detected 1838.853 MHz processor.
[   13.328328] Console: colour VGA+ 80x25
[   13.331709] Dentry cache hash table entries: 65536 (order: 7, 524288
bytes)
[   13.332048] Inode-cache hash table entries: 32768 (order: 6, 262144
bytes)
[   13.332193] Checking aperture...
[   13.332264] CPU 0: aperture @ e0000000 size 128 MB
[   13.337619] Memory: 509000k/523200k available (3246k kernel code,
13476k reserved, 1225k data, 184k init)
[   13.337752] SLUB: Genslabs=18, HWalign=64, Order=0-1, MinObjects=4,
Processors=1, Nodes=1
[   13.397023] Calibrating delay using timer specific routine.. 3680.25
BogoMIPS (lpj=1840129)
[   13.397189] Mount-cache hash table entries: 256
[   13.397348] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64
bytes/line)
[   13.397424] CPU: L2 Cache: 512K (64 bytes/line)
[   13.397505] CPU: AMD Athlon(tm) 64 Processor 3000+ stepping 00
[   13.397659] ACPI: Core revision 20070126
[   13.411535] Using local APIC timer interrupts.
[   13.465907] result 12769821
[   13.465976] Detected 12.769 MHz APIC timer.
[   13.466993] NET: Registered protocol family 16
[   13.467130] ACPI: bus type pci registered
[   13.467207] PCI: Using configuration type 1
[   13.472008] ACPI: Interpreter enabled
[   13.472083] ACPI: (supports S0 S3 S4 S5)
[   13.472356] ACPI: Using IOAPIC for interrupt routing
[   13.478091] ACPI: PCI Root Bridge [PCI0] (0000:00)
[   13.478167] PCI: Probing PCI hardware (bus 00)
[   13.478958] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[   13.530494] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 6 7 10 11 12) *5
[   13.531113] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 6 7 10 *11 12)
[   13.531689] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 *4 6 7 10 11 12)
[   13.532251] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 6 7 10 11 12)
*0, disabled.
[   13.532909] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 6 7 10 11 12)
*0, disabled.
[   13.533558] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 6 7 10 11 12)
*0, disabled.
[   13.534222] ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 6 7 *10 11 12)
[   13.534768] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 6 7 10 11 12)
*0, disabled.
[   13.535454] ACPI: PCI Interrupt Link [ALKA] (IRQs *20)
[   13.535798] ACPI: PCI Interrupt Link [ALKB] (IRQs *21)
[   13.536141] ACPI: PCI Interrupt Link [ALKC] (IRQs *22)
[   13.536512] ACPI: PCI Interrupt Link [ALKD] (IRQs *23), disabled.
[   13.536801] Linux Plug and Play Support v0.97 (c) Adam Belay
[   13.536883] pnp: PnP ACPI init
[   13.536957] ACPI: bus type pnp registered
[   13.539749] pnp: PnP ACPI: found 8 devices
[   13.539822] ACPI: ACPI bus type pnp unregistered
[   13.539959] SCSI subsystem initialized
[   13.540050] libata version 2.20 loaded.
[   13.540090] usbcore: registered new interface driver usbfs
[   13.540184] usbcore: registered new interface driver hub
[   13.540283] usbcore: registered new device driver usb
[   13.540393] PCI: Using ACPI for IRQ routing
[   13.540465] PCI: If a device doesn't work, try "pci=routeirq".  If it
helps, post a report
[   13.540574] PCI: Cannot allocate resource region 0 of device 0000:00:00.0
[   13.540749] agpgart: Detected AGP bridge 0
[   13.544290] agpgart: AGP aperture is 128M @ 0xe0000000
[   13.544420] pnp: 00:00: iomem range 0xcc000-0xcffff has been reserved
[   13.544495] pnp: 00:00: iomem range 0xf0000-0xf7fff could not be reserved
[   13.544570] pnp: 00:00: iomem range 0xf8000-0xfbfff could not be reserved
[   13.544645] pnp: 00:00: iomem range 0xfc000-0xfffff could not be reserved
[   13.544723] pnp: 00:02: ioport range 0x4000-0x407f has been reserved
[   13.544798] Time: tsc clocksource has been installed.
[   13.544873] pnp: 00:02: ioport range 0x5000-0x500f has been reserved
[   13.545178] PCI: Bridge: 0000:00:01.0
[   13.545250]   IO window: c000-cfff
[   13.545321]   MEM window: f8000000-f80fffff
[   13.545394]   PREFETCH window: e8000000-f7ffffff
[   13.545476] PCI: Setting latency timer of device 0000:00:01.0 to 64
[   13.545485] NET: Registered protocol family 2
[   13.553759] IP route cache hash table entries: 4096 (order: 3, 32768
bytes)
[   13.553861] TCP established hash table entries: 16384 (order: 6,
262144 bytes)
[   13.554076] TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
[   13.554224] TCP: Hash tables configured (established 16384 bind 16384)
[   13.554299] TCP reno registered
[   13.556858] Simple Boot Flag at 0x37 set to 0x80
[   13.559287] NTFS driver 2.1.28 [Flags: R/O].
[   13.559504] io scheduler noop registered
[   13.559657] io scheduler cfq registered (default)
[   13.559834] Boot video device is 0000:01:00.0
[   13.559918] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   13.560110] radeonfb: Found Intel x86 BIOS ROM Image
[   13.560184] radeonfb: Retrieved PLL infos from BIOS
[   13.560257] radeonfb: Reference=27.00 MHz (RefDiv=12) Memory=200.00
Mhz, System=166.00 MHz
[   13.560359] radeonfb: PLL min 20000 max 40000
[   13.636315] i2c-adapter i2c-1: unable to read EDID block.
[   13.755068] i2c-adapter i2c-1: unable to read EDID block.
[   13.873859] i2c-adapter i2c-1: unable to read EDID block.
[   13.992712] i2c-adapter i2c-3: unable to read EDID block.
[   14.111487] i2c-adapter i2c-3: unable to read EDID block.
[   14.230259] i2c-adapter i2c-3: unable to read EDID block.
[   14.483117] radeonfb: Monitor 1 type CRT found
[   14.483187] radeonfb: EDID probed
[   14.483257] radeonfb: Monitor 2 type no found
[   14.483556] radeonfb (0000:01:00.0): ATI Radeon Yd
[   14.483757] input: Power Button (FF) as /class/input/input0
[   14.483830] ACPI: Power Button (FF) [PWRF]
[   14.483948] input: Power Button (CM) as /class/input/input1
[   14.484021] ACPI: Power Button (CM) [PWRB]
[   14.485986] Real Time Clock Driver v1.12ac
[   14.486085] Software Watchdog Timer: 0.07 initialized. soft_noboot=0
soft_margin=60 sec (nowayout= 0)
[   14.486208] Linux agpgart interface v0.102 (c) Dave Jones
[   14.486323] [drm] Initialized drm 1.1.0 20060810
[   14.486505] [drm] Initialized radeon 1.27.0 20060524 on minor 0
[   14.486589] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180
seconds, margin is 60 seconds).
[   14.486693] Hangcheck: Using get_cycles().
[   14.486764] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ
sharing disabled
[   14.487136] loop: module loaded
[   14.487240] via-rhine: Broken BIOS detected, avoid_D3 enabled.
[   14.487363] VIA Networking Velocity Family Gigabit Ethernet Adapter
Driver Ver. 1.14
[   14.487465] Copyright (c) 2002, 2003 VIA Networking Technologies, Inc.
[   14.487539] Copyright (c) 2004 Red Hat Inc.
[   14.487624] ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 22 (level,
low) -> IRQ 22
[   14.488499] eth0: VIA Networking Velocity Family Gigabit Ethernet Adapter
[   14.488575] eth0: Ethernet Address: 00:50:8D:D1:28:BB
[   14.499140] PPP generic driver version 2.4.2
[   14.499262] PPP MPPE Compression module registered
[   14.499421] pata_via 0000:00:0f.1: version 0.3.1
[   14.499665] ACPI: PCI Interrupt Link [ALKA] enabled at IRQ 20
[   14.499739] ACPI: PCI Interrupt 0000:00:0f.1[A] -> Link [ALKA] -> GSI
20 (level, low) -> IRQ 20
[   14.500104] scsi0 : pata_via
[   14.500215] scsi1 : pata_via
[   14.500313] ata1: PATA max UDMA/133 cmd 0x00000000000101f0 ctl
0x00000000000103f6 bmdma 0x000000000001e300 irq 14
[   14.500421] ata2: PATA max UDMA/133 cmd 0x0000000000010170 ctl
0x0000000000010376 bmdma 0x000000000001e308 irq 15
[   14.955483] ata1.00: ATAPI, max UDMA/33
[   14.955556] ata1.01: ATAPI, max UDMA/33
[   15.112201] ata1.00: configured for UDMA/33
[   15.268927] ata1.01: configured for UDMA/33
[   15.457703] ata2.00: ata_hpa_resize 1: sectors = 156301488,
hpa_sectors = 156301488
[   15.457805] ata2.00: ATA-6: WDC WD800JB-00JJA0, 05.01C05, max UDMA/100
[   15.457879] ata2.00: 156301488 sectors, multi 16: LBA
[   15.460688] ata2.00: ata_hpa_resize 1: sectors = 156301488,
hpa_sectors = 156301488
[   15.461282] ata2.00: configured for UDMA/100
[   15.461960] scsi 0:0:0:0: CD-ROM            COMPAQ   DVD-ROM DRD8120B
1.10 PQ: 0 ANSI: 5
[   15.465328] sr0: scsi3-mmc drive: 0x/40x cd/rw xa/form2 cdda tray
[   15.465404] Uniform CD-ROM driver Revision: 3.20
[   15.465519] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   15.465561] sr 0:0:0:0: Attached scsi generic sg0 type 5
[   15.465858] scsi 0:0:1:0: CD-ROM            HL-DT-ST CD-RW GCE-8525B 
1.03 PQ: 0 ANSI: 5
[   15.469540] sr1: scsi3-mmc drive: 40x/52x writer cd/rw xa/form2 cdda tray
[   15.469653] sr 0:0:1:0: Attached scsi CD-ROM sr1
[   15.469691] sr 0:0:1:0: Attached scsi generic sg1 type 5
[   15.469816] scsi 1:0:0:0: Direct-Access     ATA      WDC WD800JB-00JJ
05.0 PQ: 0 ANSI: 5
[   15.469985] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors
(80026 MB)
[   15.470067] sd 1:0:0:0: [sda] Write Protect is off
[   15.470139] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.470152] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   15.470286] sd 1:0:0:0: [sda] 156301488 512-byte hardware sectors
(80026 MB)
[   15.470366] sd 1:0:0:0: [sda] Write Protect is off
[   15.470440] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   15.470452] sd 1:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   15.470557]  sda: sda1 sda2 sda3
[   15.474730] sd 1:0:0:0: [sda] Attached SCSI disk
[   15.474839] sd 1:0:0:0: Attached scsi generic sg2 type 0
[   15.474970] ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level,
low) -> IRQ 21
[   15.475125] ehci_hcd 0000:00:10.4: EHCI Host Controller
[   15.475242] ehci_hcd 0000:00:10.4: new USB bus registered, assigned
bus number 1
[   15.475386] ehci_hcd 0000:00:10.4: irq 21, io mem 0xf8120000
[   15.475462] ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver
10 Dec 2004
[   15.475680] usb usb1: configuration #1 chosen from 1 choice
[   15.475784] hub 1-0:1.0: USB hub found
[   15.475860] hub 1-0:1.0: 8 ports detected
[   15.576246] USB Universal Host Controller Interface driver v3.0
[   15.576413] ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level,
low) -> IRQ 21
[   15.576559] uhci_hcd 0000:00:10.0: UHCI Host Controller
[   15.576654] uhci_hcd 0000:00:10.0: new USB bus registered, assigned
bus number 2
[   15.576772] uhci_hcd 0000:00:10.0: irq 21, io base 0x0000e400
[   15.576946] usb usb2: configuration #1 chosen from 1 choice
[   15.577047] hub 2-0:1.0: USB hub found
[   15.577122] hub 2-0:1.0: 2 ports detected
[   15.678072] ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level,
low) -> IRQ 21
[   15.678215] uhci_hcd 0000:00:10.1: UHCI Host Controller
[   15.678309] uhci_hcd 0000:00:10.1: new USB bus registered, assigned
bus number 3
[   15.678427] uhci_hcd 0000:00:10.1: irq 21, io base 0x0000e500
[   15.678598] usb usb3: configuration #1 chosen from 1 choice
[   15.678697] hub 3-0:1.0: USB hub found
[   15.678771] hub 3-0:1.0: 2 ports detected
[   15.778891] ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level,
low) -> IRQ 21
[   15.779034] uhci_hcd 0000:00:10.2: UHCI Host Controller
[   15.779134] uhci_hcd 0000:00:10.2: new USB bus registered, assigned
bus number 4
[   15.779250] uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e600
[   15.779420] usb usb4: configuration #1 chosen from 1 choice
[   15.779525] hub 4-0:1.0: USB hub found
[   15.779598] hub 4-0:1.0: 2 ports detected
[   15.879716] ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level,
low) -> IRQ 21
[   15.879858] uhci_hcd 0000:00:10.3: UHCI Host Controller
[   15.879955] uhci_hcd 0000:00:10.3: new USB bus registered, assigned
bus number 5
[   15.880072] uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e700
[   15.880244] usb usb5: configuration #1 chosen from 1 choice
[   15.880347] hub 5-0:1.0: USB hub found
[   15.880421] hub 5-0:1.0: 2 ports detected
[   15.980534] Initializing USB Mass Storage driver...
[   16.091298] usb 2-1: new low speed USB device using uhci_hcd and
address 2
[   16.261733] usb 2-1: configuration #1 chosen from 1 choice
[   16.469635] usb 2-2: new low speed USB device using uhci_hcd and
address 3
[   16.630081] usb 2-2: configuration #1 chosen from 1 choice
[   17.255270] usbcore: registered new interface driver usb-storage
[   17.255343] USB Mass Storage support registered.
[   17.255492] PNP: No PS/2 controller found. Probing ports directly.
[   17.257625] serio: i8042 KBD port at 0x60,0x64 irq 1
[   17.257719] serio: i8042 AUX port at 0x60,0x64 irq 12
[   17.257838] mice: PS/2 mouse device common for all mice
[   17.257999] i2c /dev entries driver
[   17.258332] w83627hf: Found W83627HF chip at 0x290
[   17.587333] w83627hf w83627hf.656: Enabling temp2, readings might not
make sense
[   17.587466] w83627hf w83627hf.656: Enabling temp3, readings might not
make sense
[   17.608879] abituguru: testing bank1 sensor 0
[   17.628992] abituguru:   alarm not raised during volt sensor test
[   17.679475] abituguru:   found temp sensor
[   17.680095] abituguru: testing bank1 sensor 1
[   17.700889] abituguru:   alarm not raised during volt sensor test
[   17.751355] abituguru:   found temp sensor
[   17.751975] abituguru: testing bank1 sensor 3
[   17.773298] abituguru:   found volt sensor
[   17.773920] abituguru: testing bank1 sensor 4
[   17.795252] abituguru:   found volt sensor
[   17.795871] abituguru: testing bank1 sensor 10
[   17.817138] abituguru:   found volt sensor
[   17.817755] abituguru: testing bank1 sensor 8
[   17.838111] abituguru:   found volt sensor
[   17.838726] abituguru: testing bank1 sensor 14
[   17.859142] abituguru:   found volt sensor
[   17.859764] abituguru: testing bank1 sensor 2
[   17.881061] abituguru:   found volt sensor
[   17.881675] abituguru: testing bank1 sensor 9
[   17.901996] abituguru:   found volt sensor
[   17.902614] abituguru: testing bank1 sensor 6
[   17.923003] abituguru:   found volt sensor
[   17.923618] abituguru: testing bank1 sensor 5
[   17.944962] abituguru:   found volt sensor
[   17.945579] abituguru: testing bank1 sensor 11
[   17.965922] abituguru:   found volt sensor
[   17.966540] abituguru: testing bank1 sensor 15
[   17.986351] abituguru:   alarm not raised during volt sensor test
[   18.036859] abituguru:   found temp sensor
[   18.037481] abituguru: testing bank1 sensor 13
[   18.058783] abituguru:   found volt sensor
[   18.059400] abituguru: testing bank1 sensor 7
[   18.080194] abituguru:   alarm not raised during volt sensor test
[   18.130127] abituguru:   alarm not raised during temp sensor test
[   18.130849] abituguru: testing bank1 sensor 12
[   18.151105] abituguru:   alarm not raised during volt sensor test
[   18.200985] abituguru:   alarm not raised during temp sensor test
[   18.201430] abituguru: detecting number of fan sensors
[   18.201432] abituguru:   bank2 sensor 5 does not seem to be a fan
sensor: the threshold (0) is below the minimum (5)
[   18.201435] abituguru:  found: 5 fan sensors
[   18.201443] abituguru: detecting number of PWM outputs
[   18.201445] abituguru:   pwm channel 3 does not seem to be a pwm
channel: settings[0] = C9
[   18.201448] abituguru:  found: 3 PWM outputs
[   18.201453] abituguru: found Abit uGuru
[   18.215405] input: Microsoft Microsoft® Digital Media Pro Keyboard as
/class/input/input2
[   18.215534] input: USB HID v1.11 Keyboard [Microsoft Microsoft®
Digital Media Pro Keyboard] on usb-0000:00:10.0-1
[   18.244293] input: Microsoft Microsoft® Digital Media Pro Keyboard as
/class/input/input3
[   18.244420] input: USB HID v1.11 Device [Microsoft Microsoft® Digital
Media Pro Keyboard] on usb-0000:00:10.0-1
[   18.259272] input: Logitech USB Mouse as /class/input/input4
[   18.259385] input: USB HID v1.10 Mouse [Logitech USB Mouse] on
usb-0000:00:10.0-2
[   18.259568] usbcore: registered new interface driver usbhid
[   18.259641] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   18.259732] Advanced Linux Sound Architecture Driver Version
1.0.14rc4 (Wed May 09 09:51:39 2007 UTC).
[   18.260011] ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level,
low) -> IRQ 22
[   18.260281] PCI: Setting latency timer of device 0000:00:11.5 to 64
[   18.773155] ALSA device list:
[   18.773227]   #0: VIA 8237 with ALC658D at 0xd800, irq 22
[   18.773324] oprofile: using NMI interrupt.
[   18.773400] GRE over IPv4 tunneling driver
[   18.773539] TCP cubic registered
[   18.773647] NET: Registered protocol family 1
[   18.773719] NET: Registered protocol family 17
[   18.773795] powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3000+
processors (version 2.00.00)
[   18.773927] powernow-k8:    0 : fid 0xa (1800 MHz), vid 0x6
[   18.774000] powernow-k8:    1 : fid 0x2 (1000 MHz), vid 0x12
[   18.810591] kjournald starting.  Commit interval 5 seconds
[   18.810671] EXT3-fs: mounted filesystem with ordered data mode.
[   18.810748] VFS: Mounted root (ext3 filesystem) readonly.
[   18.810833] Freeing unused kernel memory: 184k freed
[   21.503232] EXT3 FS on sda3, internal journal
[   21.807016] Adding 1004052k swap on /dev/sda2.  Priority:-1 extents:1
across:1004052k
[   32.207201] agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
[   32.207217] agpgart: Putting AGP V3 device at 0000:00:00.0 into 4x mode
[   32.207267] agpgart: Putting AGP V3 device at 0000:01:00.0 into 4x mode
[   32.371303] Velocity is AUTO mode
[   32.499541] [drm] Setting GART location based on new memory map
[   32.499617] [drm] Loading R200 Microcode
[   32.499682] [drm] writeback test succeeded in 1 usecs
[   33.995995] eth0: Link autonegation speed 100M bps full duplex


