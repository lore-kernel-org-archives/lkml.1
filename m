Return-Path: <linux-kernel-owner+w=401wt.eu-S1761321AbZEMTUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761321AbZEMTUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 15:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZEMTT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 15:19:56 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33475 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759944AbZEMTTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 15:19:54 -0400
Date: Wed, 13 May 2009 20:19:53 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: EeePC 900 trackpad often not detected at boot in 2.6.30-rc4
Message-ID: <20090513191953.GA10629@sucs.org>
References: <20090511072135.GA4682@sucs.org> <20090513032053.GA29919@dtor-d630.eng.vmware.com> <20090513185356.GA20140@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513185356.GA20140@sucs.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> On Tue, May 12, 2009 at 08:20:54PM -0700, Dmitry Torokhov wrote:
> > 
> > Could you try booting with i8042.debug and send me dmesg of the case

See below:

.000999]     soft-safe-A + unsafe-B #1/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #1/321:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/123:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/132:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/213:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/231:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/312:  ok  |  ok  |  ok  |
[    0.000999]     hard-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]     soft-safe-A + unsafe-B #2/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/123:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/132:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/213:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/231:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/312:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       soft-irq lock-inversion/321:  ok  |  ok  |  ok  |
[    0.000999]       hard-irq read-recursion/123:  ok  |
[    0.000999]       soft-irq read-recursion/123:  ok  |
[    0.000999]       hard-irq read-recursion/132:  ok  |
[    0.000999]       soft-irq read-recursion/132:  ok  |
[    0.000999]       hard-irq read-recursion/213:  ok  |
[    0.000999]       soft-irq read-recursion/213:  ok  |
[    0.000999]       hard-irq read-recursion/231:  ok  |
[    0.000999]       soft-irq read-recursion/231:  ok  |
[    0.000999]       hard-irq read-recursion/312:  ok  |
[    0.000999]       soft-irq read-recursion/312:  ok  |
[    0.000999]       hard-irq read-recursion/321:  ok  |
[    0.000999]       soft-irq read-recursion/321:  ok  |
[    0.000999] -------------------------------------------------------
[    0.000999] Good, all 218 testcases passed! |
[    0.000999] ---------------------------------
[    0.000999] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000999] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000999] Initializing HighMem for node 0 (000377fe:0003f780)
[    0.000999] Memory: 1019992k/1039872k available (3287k kernel code, 19164k reserved, 1505k data, 304k init, 130568k highmem)
[    0.000999] virtual kernel memory layout:
[    0.000999]     fixmap  : 0xfff9c000 - 0xfffff000   ( 396 kB)
[    0.000999]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000999]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000999]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000999]       .init : 0xc05b2000 - 0xc05fe000   ( 304 kB)
[    0.000999]       .data : 0xc0435f95 - 0xc05ae4b8   (1505 kB)
[    0.000999]       .text : 0xc0100000 - 0xc0435f95   (3287 kB)
[    0.000999] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
[    0.000999] ODEBUG: 4 of 4 active objects replaced
[    0.000999] ODEBUG: selftest passed
[    0.001040] Calibrating delay loop (skipped), value calculated using timer frequency.. 1799.97 BogoMIPS (lpj=899987)
[    0.001341] Security Framework initialized
[    0.001511] Mount-cache hash table entries: 512
[    0.003975] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004075] CPU: L2 cache: 512K
[    0.004149] Intel machine check architecture supported.
[    0.004229] Intel machine check reporting enabled on CPU#0.
[    0.004316] CPU: Intel(R) Celeron(R) M processor          900MHz stepping 08
[    0.004500] Checking 'hlt' instruction... OK.
[    0.008933] ACPI: Core revision 20090320
[    0.060022] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.060110] ftrace: allocating 14714 entries in 29 pages
[    0.063664] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.076579] net_namespace: 396 bytes
[    0.077785] Time: 19:10:26  Date: 05/13/09
[    0.078461] NET: Registered protocol family 16
[    0.083549] ACPI: bus type pci registered
[    0.083702] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.083786] PCI: Not using MMCONFIG.
[    0.084239] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=5
[    0.084321] PCI: Using configuration type 1 for base access
[    0.132258] bio: create slab <bio-0> at 0
[    0.140057] ACPI: EC: Look up EC in DSDT
[    0.214700] ACPI: Interpreter enabled
[    0.214793] ACPI: (supports S0 S1 S3 S5)
[    0.215325] ACPI: Using IOAPIC for interrupt routing
[    0.215731] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.229686] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.229771] PCI: Using MMCONFIG for extended config space
[    0.291945] ACPI: EC: GPE = 0x18, I/O: command/status = 0x66, data = 0x62
[    0.291961] ACPI: EC: driver started in poll mode
[    0.294462] ACPI: No dock devices found.
[    0.294923] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.296044] pci 0000:00:02.0: reg 10 32bit mmio: [0xf7f00000-0xf7f7ffff]
[    0.296061] pci 0000:00:02.0: reg 14 io port: [0xec00-0xec07]
[    0.296077] pci 0000:00:02.0: reg 18 32bit mmio: [0xd0000000-0xdfffffff]
[    0.296092] pci 0000:00:02.0: reg 1c 32bit mmio: [0xf7ec0000-0xf7efffff]
[    0.296217] pci 0000:00:02.1: reg 10 32bit mmio: [0xf7f80000-0xf7ffffff]
[    0.296505] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf7eb8000-0xf7ebbfff]
[    0.296619] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.296708] pci 0000:00:1b.0: PME# disabled
[    0.296932] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.297108] pci 0000:00:1c.0: PME# disabled
[    0.297345] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.297430] pci 0000:00:1c.1: PME# disabled
[    0.297686] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.297771] pci 0000:00:1c.2: PME# disabled
[    0.298044] pci 0000:00:1d.0: reg 20 io port: [0xe400-0xe41f]
[    0.298172] pci 0000:00:1d.1: reg 20 io port: [0xe480-0xe49f]
[    0.298297] pci 0000:00:1d.2: reg 20 io port: [0xe800-0xe81f]
[    0.298423] pci 0000:00:1d.3: reg 20 io port: [0xe880-0xe89f]
[    0.298558] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf7eb7c00-0xf7eb7fff]
[    0.298676] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.298761] pci 0000:00:1d.7: PME# disabled
[    0.299115] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.299131] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.299240] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.299328] pci 0000:00:1f.0: LPC Generic IO decode 2 PIO at 0380-038f
[    0.299489] pci 0000:00:1f.2: reg 10 io port: [0x00-0x07]
[    0.299505] pci 0000:00:1f.2: reg 14 io port: [0x00-0x03]
[    0.299521] pci 0000:00:1f.2: reg 18 io port: [0x00-0x07]
[    0.299537] pci 0000:00:1f.2: reg 1c io port: [0x00-0x03]
[    0.299553] pci 0000:00:1f.2: reg 20 io port: [0xffa0-0xffaf]
[    0.299617] pci 0000:00:1f.2: PME# supported from D3hot
[    0.299698] pci 0000:00:1f.2: PME# disabled
[    0.299872] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.300197] pci 0000:03:00.0: reg 10 64bit mmio: [0xfbfc0000-0xfbffffff]
[    0.300264] pci 0000:03:00.0: reg 30 32bit mmio: [0xfbfa0000-0xfbfbffff]
[    0.300342] pci 0000:03:00.0: PME# supported from D3hot D3cold
[    0.300427] pci 0000:03:00.0: PME# disabled
[    0.302385] pci 0000:00:1c.1: bridge 32bit mmio: [0xfbf00000-0xfbffffff]
[    0.302524] pci 0000:01:00.0: reg 10 64bit mmio: [0xfbef0000-0xfbefffff]
[    0.303132] pci 0000:00:1c.2: bridge 32bit mmio: [0xf8000000-0xfbefffff]
[    0.303149] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xf0000000-0xf6ffffff]
[    0.303282] pci 0000:00:1e.0: transparent bridge
[    0.303422] pci_bus 0000:00: on NUMA node 0
[    0.303470] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.305468] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P3._PRT]
[    0.305860] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P5._PRT]
[    0.306239] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.364640] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.365942] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.367296] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.368680] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.370034] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.371473] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.372884] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.374392] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.378303] SCSI subsystem initialized
[    0.378613] libata version 3.00 loaded.
[    0.380143] usbcore: registered new interface driver usbfs
[    0.380630] usbcore: registered new interface driver hub
[    0.381392] usbcore: registered new device driver usb
[    0.384385] PCI: Using ACPI for IRQ routing
[    0.388732] cfg80211: Using static regulatory domain info
[    0.388818] cfg80211: Regulatory domain: US
[    0.388891] 	(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[    0.389106] 	(2402000 KHz - 2472000 KHz @ 40000 KHz), (600 mBi, 2700 mBm)
[    0.389190] 	(5170000 KHz - 5190000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.389274] 	(5190000 KHz - 5210000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.389356] 	(5210000 KHz - 5230000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.389439] 	(5230000 KHz - 5330000 KHz @ 40000 KHz), (600 mBi, 2300 mBm)
[    0.389521] 	(5735000 KHz - 5835000 KHz @ 40000 KHz), (600 mBi, 3000 mBm)
[    0.389929] cfg80211: Calling CRDA for country: GB
[    0.390839] hpet clockevent registered
[    0.390854] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.390947] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.391285] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.399238] pnp: PnP ACPI init
[    0.399416] ACPI: bus type pnp registered
[    0.419223] pnp: PnP ACPI: found 13 devices
[    0.419309] ACPI: ACPI bus type pnp unregistered
[    0.419460] system 00:01: iomem range 0xfed13000-0xfed19fff has been reserved
[    0.419587] system 00:08: ioport range 0x380-0x383 has been reserved
[    0.419673] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.419758] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.419844] system 00:08: ioport range 0x480-0x4bf has been reserved
[    0.419930] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.420031] system 00:08: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.420164] system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
[    0.420299] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.420386] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.420516] system 00:0a: iomem range 0xe0000000-0xefffffff has been reserved
[    0.420627] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.420742] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.420833] system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
[    0.420924] system 00:0c: iomem range 0x100000-0x3f7fffff could not be reserved
[    0.461264] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.461353] pci 0000:00:1c.0:   IO window: disabled
[    0.461438] pci 0000:00:1c.0:   MEM window: disabled
[    0.461518] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.461605] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.461683] pci 0000:00:1c.1:   IO window: disabled
[    0.461767] pci 0000:00:1c.1:   MEM window: 0xfbf00000-0xfbffffff
[    0.461851] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.461938] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:01
[    0.462027] pci 0000:00:1c.2:   IO window: disabled
[    0.462111] pci 0000:00:1c.2:   MEM window: 0xf8000000-0xfbefffff
[    0.462196] pci 0000:00:1c.2:   PREFETCH window: 0x000000f0000000-0x000000f6ffffff
[    0.462311] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.462389] pci 0000:00:1e.0:   IO window: disabled
[    0.462471] pci 0000:00:1e.0:   MEM window: disabled
[    0.462550] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.462670] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.462759] pci 0000:00:1c.0: setting latency timer to 64
[    0.462784] pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.462870] pci 0000:00:1c.1: setting latency timer to 64
[    0.462893] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.462979] pci 0000:00:1c.2: setting latency timer to 64
[    0.463007] pci 0000:00:1e.0: setting latency timer to 64
[    0.463018] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.463025] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.463033] pci_bus 0000:03: resource 1 mem: [0xfbf00000-0xfbffffff]
[    0.463041] pci_bus 0000:01: resource 1 mem: [0xf8000000-0xfbefffff]
[    0.463048] pci_bus 0000:01: resource 2 pref mem [0xf0000000-0xf6ffffff]
[    0.463055] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.463062] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffff]
[    0.463160] NET: Registered protocol family 2
[    0.463606] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.464652] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.466832] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.481425] TCP: Hash tables configured (established 131072 bind 65536)
[    0.481615] TCP reno registered
[    0.482140] NET: Registered protocol family 1
[    0.485397] Machine check exception polling timer started.
[    0.490047] Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.490160] Scanning for low memory corruption every 60 seconds
[    0.492907] ====[ backtrace testing ]===========
[    0.493132] Testing a backtrace from process context.
[    0.493209] The following trace is a kernel self test and not a bug!
[    0.493292] Pid: 1, comm: swapper Not tainted 2.6.30-rc4-00336-g8c9ed89 #140
[    0.493374] Call Trace:
[    0.493456]  [<c0153820>] ? backtrace_regression_test+0x0/0xe0
[    0.493538]  [<c0153855>] backtrace_regression_test+0x35/0xe0
[    0.493621]  [<c01d0cc6>] ? proc_create_data+0x66/0xb0
[    0.493702]  [<c05c3a20>] ? kallsyms_init+0x0/0x30
[    0.493780]  [<c05c3a44>] ? kallsyms_init+0x24/0x30
[    0.493859]  [<c0153820>] ? backtrace_regression_test+0x0/0xe0
[    0.493940]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.495267]  [<c014ca29>] ? validate_chain+0xe9/0xfd0
[    0.495347]  [<c014dc49>] ? __lock_acquire+0x339/0x5e0
[    0.495428]  [<c014dc49>] ? __lock_acquire+0x339/0x5e0
[    0.495510]  [<c018edd6>] ? check_bytes_and_report+0x26/0xd0
[    0.495591]  [<c018f2a4>] ? slab_pad_check+0x74/0x110
[    0.495671]  [<c014ca29>] ? validate_chain+0xe9/0xfd0
[    0.495750]  [<c018fe5f>] ? check_object+0xef/0x1f0
[    0.495830]  [<c014dc49>] ? __lock_acquire+0x339/0x5e0
[    0.495909]  [<c01d0431>] ? proc_register+0x121/0x1e0
[    0.496000]  [<c0434c62>] ? _spin_unlock+0x22/0x30
[    0.496079]  [<c01d0431>] ? proc_register+0x121/0x1e0
[    0.496160]  [<c01d0c4b>] ? __proc_create+0xeb/0x100
[    0.496239]  [<c01d0d6a>] ? create_proc_entry+0x5a/0xa0
[    0.496319]  [<c0156712>] ? register_irq_proc+0x92/0xb0
[    0.496401]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.496479]  [<c05b27f0>] ? kernel_init+0x0/0xf0
[    0.496557]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.496633] Testing a backtrace from irq context.
[    0.496707] The following trace is a kernel self test and not a bug!
[    0.496800] Pid: 3, comm: ksoftirqd/0 Not tainted 2.6.30-rc4-00336-g8c9ed89 #140
[    0.496902] Call Trace:
[    0.496975]  [<c014c62b>] ? trace_hardirqs_on_caller+0x5b/0x180
[    0.497103]  [<c015380d>] backtrace_test_irq_callback+0xd/0x20
[    0.497186]  [<c012d5e4>] tasklet_action+0x44/0x90
[    0.497263]  [<c012d0c5>] __do_softirq+0x75/0x1a0
[    0.497341]  [<c012d320>] ? ksoftirqd+0x0/0xb0
[    0.497418]  [<c012d245>] do_softirq+0x55/0x60
[    0.497494]  [<c012d365>] ksoftirqd+0x45/0xb0
[    0.497573]  [<c013bd62>] kthread+0x52/0x80
[    0.497650]  [<c013bd10>] ? kthread+0x0/0x80
[    0.497727]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.497815] Testing a saved backtrace.
[    0.497886] The following trace is a kernel self test and not a bug!
[    0.497973]  [<c010bae0>] save_stack_trace+0x30/0x50
[    0.498195]  [<c01538dd>] backtrace_regression_test+0xbd/0xe0
[    0.498313]  [<c0101122>] do_one_initcall+0x32/0x1d0
[    0.498428]  [<c05b288a>] kernel_init+0x9a/0xf0
[    0.498545]  [<c010366b>] kernel_thread_helper+0x7/0x10
[    0.498663]  [<ffffffff>] 0xffffffff
[    0.498773] ====[ end of backtrace testing ]====
[    0.499937] highmem bounce pool size: 64 pages
[    0.553356] fuse init (API version 7.11)
[    0.555146] msgmni has been set to 1737
[    0.557105] alg: No test for stdrng (krng)
[    0.557321] io scheduler noop registered
[    0.557395] io scheduler deadline registered
[    0.558715] io scheduler cfq registered (default)
[    0.558878] pci 0000:00:02.0: Boot video device
[    0.560421] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.560458] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.562114] pcieport-driver 0000:00:1c.1: irq 25 for MSI/MSI-X
[    0.562149] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.563661] pcieport-driver 0000:00:1c.2: irq 26 for MSI/MSI-X
[    0.563696] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    0.569031] ACPI: AC Adapter [AC0] (on-line)
[    0.571076] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.571297] ACPI: Power Button [PWRF]
[    0.572264] input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
[    0.573683] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.580190] ACPI: Lid Switch [LID]
[    0.580969] input: Sleep Button as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input2
[    0.581102] ACPI: Sleep Button [SLPB]
[    0.581813] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input3
[    0.581928] ACPI: Power Button [PWRB]
[    0.585797] Marking TSC unstable due to TSC halts in idle
[    0.585973] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    0.587237] Switched to high resolution mode on CPU 0
[    0.588132] processor ACPI_CPU:00: registered as cooling_device0
[    0.588234] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.609426] thermal LNXTHERM:01: registered as thermal_zone0
[    0.609605] ACPI: Thermal Zone [TZ00] (51 C)
[    0.857444] Non-volatile memory driver v1.3
[    0.857531] Linux agpgart interface v0.103
[    0.857681] agpgart-intel 0000:00:00.0: Intel 915GM Chipset
[    0.858345] agpgart-intel 0000:00:00.0: detected 7932K stolen memory
[    0.862686] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
[    0.863904] [drm] Initialized drm 1.1.0 20060810
[    0.864364] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.864454] pci 0000:00:02.0: setting latency timer to 64
[    0.870753] [drm:i915_gem_detect_bit_6_swizzle] *ERROR* Couldn't read from MCHBAR.  Disabling tiling.
[    0.870923] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    1.087776] loop: module loaded
[    1.088419] Driver 'sd' needs updating - please use bus_type methods
[    1.088962] ahci 0000:00:1f.2: version 3.0
[    1.089038] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.089183] ahci 0000:00:1f.2: PCI INT B disabled
[    1.089292] ahci: probe of 0000:00:1f.2 failed with error -22
[    1.089840] ata_piix 0000:00:1f.2: version 2.12
[    1.089865] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.089961] ata_piix 0000:00:1f.2: MAP [ P0 P2 IDE IDE ]
[    1.090576] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.090910] scsi0 : ata_piix
[    1.094356] scsi1 : ata_piix
[    1.117768] ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    1.117860] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    1.118812] Atheros(R) L2 Ethernet Driver - version 2.2.3
[    1.118894] Copyright (c) 2007 Atheros Corporation.
[    1.119122] atl2 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    1.119220] atl2 0000:03:00.0: setting latency timer to 64
[    3.014740] ath5k 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    3.014854] ath5k 0000:01:00.0: setting latency timer to 64
[    3.014940] ath5k 0000:01:00.0: registered as 'phy0'
[    3.091493] phy0: Selected rate control algorithm 'minstrel'
[    3.092896] ath5k phy0: Atheros AR2425 chip found (MAC: 0xe2, PHY: 0x70)
[    3.093554] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    3.093775] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.093902] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    3.093912] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    3.096848] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
[    3.101113] ehci_hcd 0000:00:1d.7: debug port 1
[    3.101199] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    3.101273] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7eb7c00
[    3.111072] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    3.112680] usb usb1: configuration #1 chosen from 1 choice
[    3.113730] hub 1-0:1.0: USB hub found
[    3.114133] hub 1-0:1.0: 8 ports detected
[    3.118717] uhci_hcd: USB Universal Host Controller Interface driver
[    3.119559] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    3.119671] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    3.119681] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    3.120298] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    3.120491] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e400
[    3.121665] usb usb2: configuration #1 chosen from 1 choice
[    3.122392] hub 2-0:1.0: USB hub found
[    3.122651] hub 2-0:1.0: 2 ports detected
[    3.124503] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    3.124614] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    3.124623] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    3.125342] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
[    3.125587] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e480
[    3.126682] usb usb3: configuration #1 chosen from 1 choice
[    3.127448] hub 3-0:1.0: USB hub found
[    3.127595] hub 3-0:1.0: 2 ports detected
[    3.129180] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    3.129293] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    3.129303] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    3.129891] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
[    3.130098] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e800
[    3.131379] usb usb4: configuration #1 chosen from 1 choice
[    3.131986] hub 4-0:1.0: USB hub found
[    3.132212] hub 4-0:1.0: 2 ports detected
[    5.716408] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    5.716525] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[    5.716535] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[    5.717304] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
[    5.717516] uhci_hcd 0000:00:1d.3: irq 16, io base 0x0000e880
[    5.718630] usb usb5: configuration #1 chosen from 1 choice
[    5.719341] hub 5-0:1.0: USB hub found
[    5.719467] hub 5-0:1.0: 2 ports detected
[    5.721318] Initializing USB Mass Storage driver...
[    5.721822] usbcore: registered new interface driver usb-storage
[    5.721912] USB Mass Storage support registered.
[    5.722952] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    5.724164] drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
[    5.724177] drivers/input/serio/i8042.c: 65 <- i8042 (return) [3]
[    5.724213] drivers/input/serio/i8042.c: 60 -> i8042 (command) [3]
[    5.724948] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [3]
[    5.725016] drivers/input/serio/i8042.c: d3 -> i8042 (command) [3]
[    5.725016] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [3]
[    5.725016] drivers/input/serio/i8042.c: 5a <- i8042 (return) [3]
[    5.729226] drivers/input/serio/i8042.c: a7 -> i8042 (command) [8]
[    5.730011] drivers/input/serio/i8042.c: 20 -> i8042 (command) [8]
[    5.730011] drivers/input/serio/i8042.c: 74 <- i8042 (return) [8]
[    5.730462] drivers/input/serio/i8042.c: a8 -> i8042 (command) [9]
[    5.731452] drivers/input/serio/i8042.c: 20 -> i8042 (command) [9]
[    5.731452] drivers/input/serio/i8042.c: 54 <- i8042 (return) [9]
[    5.733191] drivers/input/serio/i8042.c: 60 -> i8042 (command) [12]
[    5.734139] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [12]
[    5.735513] drivers/input/serio/i8042.c: d3 -> i8042 (command) [13]
[    5.735513] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [13]
[    5.740314] drivers/input/serio/i8042.c: 60 -> i8042 (command) [18]
[    5.740933] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [18]
[    5.744008] drivers/input/serio/i8042.c: d3 -> i8042 (command) [22]
[    5.744064] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [22]
[    5.744064] drivers/input/serio/i8042.c: f0 <- i8042 (return) [22]
[    5.749426] drivers/input/serio/i8042.c: d3 -> i8042 (command) [28]
[    5.750076] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [28]
[    5.750076] drivers/input/serio/i8042.c: 56 <- i8042 (return) [28]
[    5.752998] drivers/input/serio/i8042.c: d3 -> i8042 (command) [31]
[    5.753676] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [31]
[    5.753676] drivers/input/serio/i8042.c: a4 <- i8042 (return) [31]
[    5.755882] drivers/input/serio/i8042.c: Interrupt 12, without any data [34]
[    5.756155] drivers/input/serio/i8042.c: 60 -> i8042 (command) [34]
[    5.756833] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [34]
[    5.757414] drivers/input/serio/i8042.c: Interrupt 1, without any data [36]
[    5.757429] drivers/input/serio/i8042.c: Interrupt 1, without any data [36]
[    5.758374] drivers/input/serio/i8042.c: 60 -> i8042 (command) [36]
[    5.758374] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [36]
[    5.760895] serio: i8042 KBD port at 0x60,0x64 irq 1
[    5.761077] serio: i8042 AUX port at 0x60,0x64 irq 12
[    5.763323] mice: PS/2 mouse device common for all mice
[    5.767444] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [46]
[    5.768198] rtc_cmos 00:03: RTC can wake from S4
[    5.769448] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    5.769588] rtc0: alarms up to one month, 114 bytes nvram, hpet irqs
[    5.770115] Linux video capture interface: v2.00
[    5.771484] usbcore: registered new interface driver uvcvideo
[    5.771579] USB Video Class driver (v0.1.0)
[    5.775168] ACPI: Battery Slot [BAT0] (battery present)
[    5.776251] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [55]
[    5.777313] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [56]
[    5.777370] cpuidle: using governor ladder
[    5.780233] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [59]
[    5.780272] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [59]
[    5.781483] cpuidle: using governor menu
[    5.781682] eeepc: Eee PC Hotkey Driver
[    5.782454] eeepc: Hotkey init flags 0x41
[    5.785069] eeepc: Get control methods supported: 0x101711
[    5.785834] input: Asus EeePC extra buttons as /devices/virtual/input/input4
[    5.786976] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [65]
[    5.789945] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [68]
[    5.791859] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [70]
[    5.792195] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [71]
[    5.796597] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [75]
[    5.797609] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [76]
[    5.799594] Advanced Linux Sound Architecture Driver Version 1.0.19.
[    5.801279] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [80]
[    5.801489] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    5.801717] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    5.801814] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [80]
[    5.808128] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [87]
[    5.810915] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input5
[    5.811941] drivers/input/serio/i8042.c: d4 -> i8042 (command) [90]
[    5.812042] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [90]
[    5.823550] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [102]
[    5.826798] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [105]
[    5.827246] drivers/input/serio/i8042.c: d4 -> i8042 (command) [106]
[    5.828066] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [106]
[    5.831190] hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
[    5.831314] autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
[    5.831393]    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
[    5.831469]    hp_outs=1 (0x1b/0x0/0x0/0x0/0x0)
[    5.831543]    mono: mono_out=0x0
[    5.831614]    inputs: mic=0x18, fmic=0x19, line=0x0, fline=0x0, cd=0x0, aux=0x0
[    5.837152] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [116]
[    5.837794] ALSA device list:
[    5.837872]   #0: HDA Intel at 0xf7eb8000 irq 16
[    5.838198] TCP cubic registered
[    5.838274] NET: Registered protocol family 17
[    5.838474] Using IPI Shortcut mode
[    5.840893]   Magic number: 9:601:192
[    5.842254] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [121]
[    5.842629] rtc_cmos 00:03: setting system clock to 2009-05-13 19:10:32 UTC (1242241832)
[    8.713386] ata2.00: CFA: ASUS-PHISON OB SSD, TST2.04P, max UDMA/66
[    8.713474] ata2.00: 7880544 sectors, multi 0: LBA 
[    8.713624] ata2.01: CFA: ASUS-PHISON SSD, TST2.04P, max UDMA/66
[    8.713705] ata2.01: 31522176 sectors, multi 0: LBA 
[    8.717419] ata2.00: configured for UDMA/66
[    8.720348] ata2.01: configured for UDMA/66
[    8.721809] scsi 1:0:0:0: Direct-Access     ATA      ASUS-PHISON OB S TST2 PQ: 0 ANSI: 5
[    8.726947] scsi 1:0:1:0: Direct-Access     ATA      ASUS-PHISON SSD  TST2 PQ: 0 ANSI: 5
[    8.729375] sd 1:0:0:0: [sda] 7880544 512-byte hardware sectors: (4.03 GB/3.75 GiB)
[    8.729586] sd 1:0:0:0: [sda] Write Protect is off
[    8.729664] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.729855] sd 1:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.731204]  sda: sda1 sda2 sda3 sda4
[    8.735390] sd 1:0:1:0: [sdb] 31522176 512-byte hardware sectors: (16.1 GB/15.0 GiB)
[    8.735605] sd 1:0:1:0: [sdb] Write Protect is off
[    8.735683] sd 1:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    8.735874] sd 1:0:1:0: [sdb] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[    8.736713]  sdb: sdb1 sdb2
[    8.743995] sd 1:0:1:0: [sdb] Attached SCSI disk
[    8.744395] sd 1:0:0:0: [sda] Attached SCSI disk
[    8.748907] EXT2-fs warning (device sdb2): ext2_fill_super: mounting ext3 filesystem as ext2
[    8.749433] VFS: Mounted root (ext2 filesystem) readonly on device 8:18.
[    8.749707] Freeing unused kernel memory: 304k freed
[    8.750797] Write protecting the kernel text: 3288k
[    8.750877] Testing CPA: Reverting c0100000-c0436000
[    8.751590] Testing CPA: write protecting again
[    8.752510] Write protecting the kernel read-only data: 1108k
[    8.752595] Testing CPA: undo c0436000-c054b000
[    8.752881] Testing CPA: write protecting again
[    8.890040] Clocksource tsc unstable (delta = -73924977 ns)
[    8.930132] usb 1-5: new high speed USB device using ehci_hcd and address 2
[    9.049346] usb 1-5: configuration #1 chosen from 1 choice
[    9.055746] scsi2 : SCSI emulation for USB Mass Storage devices
[    9.063592] usb-storage: device found at 2
[    9.064434] usb-storage: device scan complete
[    9.065867] scsi 2:0:0:0: Direct-Access     USB2.0   CardReader SD0   0100 PQ: 0 ANSI: 0
[    9.605877] sd 2:0:0:0: [sdc] 15661056 512-byte hardware sectors: (8.01 GB/7.46 GiB)
[    9.606775] sd 2:0:0:0: [sdc] Write Protect is on
[    9.606858] sd 2:0:0:0: [sdc] Mode Sense: 03 00 80 00
[    9.606865] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    9.611306] sd 2:0:0:0: [sdc] Assuming drive cache: write through
[    9.611432]  sdc: sdc1 sdc2
[    9.617625] sd 2:0:0:0: [sdc] Attached SCSI removable disk
[   21.604366] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [15883]
[   21.607593] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [15886]
[   21.706985] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [15985]
[   21.711530] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [15990]
[   21.823263] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [16102]
[   21.825624] drivers/input/serio/i8042.c: 50 <- i8042 (interrupt, 0, 1) [16104]
[   21.889989] drivers/input/serio/i8042.c: e0 <- i8042 (interrupt, 0, 1) [16168]
[   21.894572] drivers/input/serio/i8042.c: d0 <- i8042 (interrupt, 0, 1) [16173]
[   22.209620] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [16488]
[   22.317639] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [16596]
[   24.202896] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18481]
[   24.442850] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18721]
[   24.474277] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18753]
[   24.506309] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18785]
[   24.536584] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18815]
[   24.555510] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [18834]
[   24.695577] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [18974]
[   24.871870] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [19150]
[   25.251201] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [19530]
[   25.320294] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [19599]
[   25.392088] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [19671]
[   25.461550] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [19740]
[   25.551697] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 0, 1) [19830]
[   25.727424] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [20006]
[   25.798621] drivers/input/serio/i8042.c: 91 <- i8042 (interrupt, 0, 1) [20077]
[   25.803259] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [20082]
[   25.806433] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [20085]
[   25.867086] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [20146]
[   26.438729] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [20717]
[   26.578459] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [20857]
[   26.719831] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [20998]
[   27.069840] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [21348]
[   27.211886] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [21490]
[   27.281151] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [21560]
[   27.387636] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [21666]
[   27.633213] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [21912]
[   27.739168] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [22018]
[   27.742960] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [22021]
[   27.884597] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 0, 1) [22163]
[   28.022636] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [22301]
[   28.131410] drivers/input/serio/i8042.c: 91 <- i8042 (interrupt, 0, 1) [22410]
[   28.134508] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [22413]
[   28.200267] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [22479]
[   28.234218] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [22513]
[   28.379620] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [22658]
[   28.484470] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [22763]
[   28.519894] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [22798]
[   28.589078] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [22868]
[   28.660915] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [22939]
[   28.765787] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [23044]
[   28.789548] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [23068]
[   28.965340] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [23244]
[   29.001566] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [23280]
[   29.105540] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [23384]
[   29.167530] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [23446]
[   29.273314] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [23552]
[   29.483915] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [23762]
[   29.553989] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [23832]
[   29.785378] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [24064]
[   29.855808] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [24134]
[   29.943405] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [24222]
[   30.016651] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [24295]
[   30.019826] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [24298]
[   30.120425] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [24399]
[   30.198815] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [24477]
[   30.269855] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [24548]
[   30.383101] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [24662]
[   30.490065] CPA self-test:
[   30.490257]  4k 4094 large 218 gb 0 x 4312[c0000000-f77fd000] miss 0
[   30.517584]  4k 192510 large 34 gb 0 x 192544[c0000000-f77fd000] miss 0
[   30.523476] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [24802]
[   30.540250]  4k 192510 large 34 gb 0 x 192544[c0000000-f77fd000] miss 0
[   30.540257] ok.
[   30.672630] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [24951]
[   30.777772] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [25056]
[   30.781025] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [25060]
[   30.848536] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [25127]
[   30.883771] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [25162]
[   30.988611] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [25267]
[   31.050808] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [25329]
[   31.155629] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [25434]
[   31.228909] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [25507]
[   31.232070] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [25511]
[   31.298202] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [25577]
[   31.332226] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [25611]
[   31.416606] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [25695]
[   31.488630] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [25767]
[   41.907434] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 0, 1) [36186]
[   42.011943] drivers/input/serio/i8042.c: 90 <- i8042 (interrupt, 0, 1) [36290]
[   42.677853] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [36956]
[   42.850964] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [37129]
[   42.992909] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [37271]
[   43.027465] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [37306]
[   43.323681] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [37602]
[   43.429808] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [37708]
[   43.439754] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [37718]
[   43.546668] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [37825]
[   43.563116] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [37842]
[   43.666993] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [37945]
[   43.740533] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [38019]
[   43.745348] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [38024]
[   43.748514] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [38027]
[   43.809258] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [38088]
[   43.812468] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [38091]
[   43.878625] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [38157]
[   46.079416] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [40358]
[   46.181954] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [40460]
[   46.220078] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [40499]
[   46.222497] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [40501]
[   46.289493] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [40568]
[   46.324339] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [40603]
[   46.453209] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [40732]
[   46.523357] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [40802]
[   46.559045] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [40838]
[   46.663089] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [40942]
[   46.748553] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [41027]
[   46.891314] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [41170]
[   46.893641] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [41172]
[   46.960794] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [41239]
[   47.011801] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [41290]
[   47.152197] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [41431]
[   47.300232] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [41579]
[   47.406234] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [41685]
[   47.426559] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [41705]
[   47.460553] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [41739]
[   47.593234] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [41872]
[   47.733382] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [42012]
[   47.928538] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [42207]
[   48.034081] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [42313]
[   49.105415] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [43384]
[   49.210658] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [43489]
[   49.213818] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [43492]
[   49.244935] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [43523]
[   49.290711] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [43569]
[   49.394782] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [43673]
[   49.465375] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [43744]
[   49.500912] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [43779]
[   49.504172] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [43783]
[   49.569468] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [43848]
[   49.591124] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [43870]
[   49.695152] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [43974]
[   49.867945] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [44146]
[   49.971855] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [44250]
[   50.042744] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [44321]
[   50.113980] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [44392]
[   50.218899] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [44497]
[   50.223745] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [44502]
[   50.358607] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [44637]
[   50.464764] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [44743]
[   50.503076] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [44782]
[   50.610129] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [44889]
[   50.613630] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [44892]
[   50.678240] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [44957]
[   50.751363] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [45030]
[   50.753733] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [45032]
[   50.785423] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [45064]
[   50.855317] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [45134]
[   51.507018] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [45786]
[   51.647400] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [45926]
[   51.763618] drivers/input/serio/i8042.c: 30 <- i8042 (interrupt, 0, 1) [46042]
[   51.905992] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 0, 1) [46184]
[   52.068847] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [46347]
[   52.245716] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [46524]
[   52.279553] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [46558]
[   52.385718] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [46664]
[   52.555832] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [46834]
[   52.624621] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [46903]
[   52.665607] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [46944]
[   52.702729] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [46981]
[   55.785497] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [50064]
[   55.890106] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [50169]
[   55.905062] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [50184]
[   56.011564] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [50290]
[   56.047064] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [50326]
[   56.151365] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [50430]
[   56.228659] drivers/input/serio/i8042.c: 0c <- i8042 (interrupt, 0, 1) [50507]
[   56.299582] drivers/input/serio/i8042.c: 8c <- i8042 (interrupt, 0, 1) [50578]
[   56.346443] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [50625]
[   56.452214] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [50731]
[   56.466941] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [50745]
[   56.573319] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [50852]
[   56.608912] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [50887]
[   56.714557] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [50993]
[   56.788327] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [51067]
[   56.858978] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [51137]
[   56.912419] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [51191]
[   57.018383] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [51297]
[   57.027907] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [51306]
[   57.167749] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [51446]
[   57.617599] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [51896]
[   57.756591] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [52035]
[   62.975653] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [57254]
[   63.046000] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [57324]
[   63.117647] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [57396]
[   63.159664] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [57438]
[   63.284000] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [57562]
[   63.424993] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [57703]
[   64.083924] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [58362]
[   64.226208] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [58505]
[   64.261787] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [58540]
[   64.331398] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [58610]
[   64.367922] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [58646]
[   64.437279] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [58716]
[   65.647667] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [59926]
[   65.824734] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [60103]
[   65.930240] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [60209]
[   65.999882] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [60278]
[   68.028398] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [62307]
[   68.131519] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [62410]
[   68.205042] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [62484]
[   68.208289] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [62487]
[   68.239162] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [62518]
[   68.308795] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [62587]
[   68.353007] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [62631]
[   68.456404] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [62735]
[   68.493821] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [62772]
[   68.562612] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [62841]
[   68.593312] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [62872]
[   68.663366] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [62942]
[   68.765226] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [63044]
[   68.870640] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [63149]
[   69.251981] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [63530]
[   69.355559] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [63634]
[   69.470827] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [63749]
[   69.613508] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [63892]
[   75.480589] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [69759]
[   75.550997] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [69829]
[   75.608429] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [69887]
[   75.676851] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [69955]
[   75.686665] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [69965]
[   75.825315] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [70104]
[   75.860363] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [70139]
[   75.964925] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [70243]
[   76.095122] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [70374]
[   76.165011] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [70443]
[   82.077800] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [76356]
[   82.255154] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [76534]
[   82.291397] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [76570]
[   82.396512] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [76675]
[   82.488869] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [76767]
[   82.560124] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [76839]
[   82.596516] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [76875]
[   82.665660] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [76944]
[   82.736994] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [77015]
[   82.740221] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [77019]
[   82.771467] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [77050]
[   82.840926] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [77119]
[   82.868186] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [77147]
[   83.009680] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [77288]
[   83.603330] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [77882]
[   83.672934] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [77951]
[   83.780071] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [78059]
[   83.784713] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [78063]
[   83.842913] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [78121]
[   83.948193] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [78227]
[   83.951422] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [78230]
[   84.053167] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [78332]
[   84.360100] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [78639]
[   84.431283] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [78710]
[   84.502877] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [78781]
[   84.507368] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [78786]
[   84.573141] drivers/input/serio/i8042.c: 21 <- i8042 (interrupt, 0, 1) [78852]
[   84.642988] drivers/input/serio/i8042.c: a1 <- i8042 (interrupt, 0, 1) [78921]
[   84.646285] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [78925]
[   84.747974] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [79026]
[   84.819663] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [79098]
[   84.824385] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [79103]
[   84.827566] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [79106]
[   84.888344] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [79167]
[   84.922949] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [79201]
[   85.029813] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [79308]
[   85.117282] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [79396]
[   85.256369] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [79535]
[   85.280557] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [79559]
[   85.385388] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [79664]
[   85.416022] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [79695]
[   85.486538] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [79765]
[   85.509324] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [79788]
[   85.615780] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [79894]
[   85.836045] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [80115]
[   85.939596] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [80218]
[   86.077728] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [80356]
[   86.181306] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [80460]
[   87.038952] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [81317]
[   87.108181] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [81387]
[   87.138433] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [81417]
[   87.280196] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [81559]
[   87.363147] drivers/input/serio/i8042.c: 0c <- i8042 (interrupt, 0, 1) [81642]
[   87.467399] drivers/input/serio/i8042.c: 8c <- i8042 (interrupt, 0, 1) [81746]
[   87.649527] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [81928]
[   87.791919] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [82070]
[   87.827589] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [82106]
[   87.897227] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [82176]
[   87.968300] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [82247]
[   88.002822] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [82281]
[   88.061366] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [82340]
[   88.166984] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [82445]
[   88.298977] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [82577]
[   88.404348] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [82683]
[   88.474600] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [82753]
[   88.545878] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [82824]
[   88.682665] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 0, 1) [82961]
[   88.787694] drivers/input/serio/i8042.c: 89 <- i8042 (interrupt, 0, 1) [83066]
[   88.826869] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [83105]
[   88.931548] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 0, 1) [83210]
[   89.004434] drivers/input/serio/i8042.c: 89 <- i8042 (interrupt, 0, 1) [83283]
[   89.038293] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [83317]
[   89.127279] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [83406]
[   89.268374] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [83547]
[   90.148058] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [84427]
[   90.286719] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [84565]
[   90.324160] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [84603]
[   90.358756] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [84637]
[   90.394620] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [84673]
[   90.428952] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [84707]
[   91.007520] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [85286]
[   91.146968] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [85425]
[   91.185165] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [85464]
[   91.292332] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [85571]
[   91.404165] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [85683]
[   91.510730] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [85789]
[   91.548969] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [85827]
[   91.655712] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [85934]
[   93.421076] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [87700]
[   93.527153] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [87806]
[   93.685672] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [87964]
[   93.763460] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [88042]
[   93.797314] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [88076]
[   93.832203] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [88111]
[   94.003908] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [88282]
[   94.109385] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [88388]
[   94.296046] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [88575]
[   94.403290] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [88682]
[   94.405723] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [88684]
[   94.508148] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [88787]
[   94.571108] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [88850]
[   94.755934] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [89034]
[   95.881860] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 0, 1) [90160]
[   95.952386] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [90231]
[   96.025165] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [90304]
[   96.129059] drivers/input/serio/i8042.c: b8 <- i8042 (interrupt, 0, 1) [90408]
[   96.551173] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [90830]
[   96.656119] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [90935]
[   96.763918] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [91042]
[   96.871750] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [91150]
[   96.958593] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [91237]
[   97.098479] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [91377]
[   97.176288] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [91455]
[   97.316366] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [91595]
[   97.506570] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [91785]
[   97.614953] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [91893]
[   97.618150] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [91897]
[   97.719692] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [91998]
[   97.731787] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [92010]
[   97.872135] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [92151]
[   97.966904] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [92245]
[   98.071063] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [92350]
[   98.080206] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [92359]
[   98.184424] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [92463]
[   99.323516] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [93602]
[   99.426992] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [93705]
[   99.753486] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [94032]
[   99.860814] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [94139]
[  100.096502] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [94375]
[  100.165466] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [94444]
[  100.170237] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [94449]
[  100.309385] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [94588]
[  100.437988] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [94716]
[  100.509446] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [94788]
[  100.518796] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [94797]
[  100.657875] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [94936]
[  100.781857] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [95060]
[  100.888405] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [95167]
[  101.017478] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [95296]
[  101.087457] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [95366]
[  101.102939] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [95381]
[  101.208538] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [95487]
[  101.220276] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [95499]
[  101.325763] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [95604]
[  105.187809] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [99466]
[  105.325713] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [99604]
[  105.364061] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [99643]
[  105.366577] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [99645]
[  105.398702] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [99677]
[  105.467429] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [99746]
[  105.583640] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [99862]
[  105.689519] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [99968]
[  105.747048] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [100026]
[  105.819556] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [100098]
[  105.830585] drivers/input/serio/i8042.c: 15 <- i8042 (interrupt, 0, 1) [100109]
[  105.900598] drivers/input/serio/i8042.c: 95 <- i8042 (interrupt, 0, 1) [100179]
[  106.011935] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [100290]
[  106.116506] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [100395]
[  106.496895] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [100775]
[  106.605557] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [100884]
[  106.715479] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [100994]
[  106.748349] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [101027]
[  106.795324] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [101074]
[  106.900719] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [101179]
[  107.030937] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [101309]
[  107.170947] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [101449]
[  108.823999] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [103102]
[  108.894358] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [103173]
[  108.908561] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [103187]
[  109.015290] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [103294]
[  110.231191] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [104510]
[  110.335310] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [104614]
[  110.388687] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [104667]
[  110.461155] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [104740]
[  110.516357] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [104795]
[  110.593367] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [104872]
[  110.652410] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [104931]
[  110.722108] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [105001]
[  110.785118] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [105064]
[  110.855236] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [105134]
[  110.927794] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [105206]
[  111.000509] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [105279]
[  111.084037] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [105363]
[  111.152646] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [105431]
[  111.405679] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [105684]
[  111.476967] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [105755]
[  111.772591] drivers/input/serio/i8042.c: 30 <- i8042 (interrupt, 0, 1) [106051]
[  111.913958] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 0, 1) [106192]
[  112.034540] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [106313]
[  112.105460] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [106384]
[  112.162392] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [106441]
[  112.266547] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [106545]
[  114.118965] drivers/input/serio/i8042.c: 19 <- i8042 (interrupt, 0, 1) [108397]
[  114.223891] drivers/input/serio/i8042.c: 99 <- i8042 (interrupt, 0, 1) [108502]
[  114.272966] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [108551]
[  114.382261] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [108661]
[  114.385430] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [108664]
[  114.450627] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [108729]
[  114.640368] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [108919]
[  114.747442] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [109026]
[  114.836468] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [109115]
[  114.906944] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [109185]
[  114.963529] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [109242]
[  115.032969] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [109311]
[  115.121291] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [109400]
[  115.262586] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [109541]
[  115.665757] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [109944]
[  115.736166] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [110015]
[  116.014548] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 0, 1) [110293]
[  116.083680] drivers/input/serio/i8042.c: 8e <- i8042 (interrupt, 0, 1) [110362]
[  116.295621] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [110574]
[  116.399646] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [110678]
[  116.489799] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [110768]
[  116.561674] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [110840]
[  116.564970] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [110843]
[  116.665224] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [110944]
[  116.860124] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [111139]
[  116.931168] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [111210]
[  117.095478] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [111374]
[  117.166376] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [111445]
[  117.200113] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [111479]
[  117.307208] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [111586]
[  117.543280] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [111822]
[  117.685975] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [111964]
[  120.695828] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [114974]
[  120.835207] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [115114]
[  120.913909] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [115192]
[  120.982767] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [115261]
[  121.020956] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [115299]
[  121.023342] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [115302]
[  121.125306] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [115404]
[  121.195230] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [115474]
[  121.229949] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [115508]
[  121.300495] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [115579]
[  122.043126] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [116322]
[  122.113215] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [116392]
[  122.252026] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [116531]
[  122.324172] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [116603]
[  122.879161] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [117158]
[  123.019674] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [117298]
[  123.051984] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [117330]
[  123.155426] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [117434]
[  123.297793] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [117576]
[  123.300899] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [117579]
[  123.332182] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [117611]
[  123.402724] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [117681]
[  123.433364] drivers/input/serio/i8042.c: 16 <- i8042 (interrupt, 0, 1) [117712]
[  123.538621] drivers/input/serio/i8042.c: 96 <- i8042 (interrupt, 0, 1) [117817]
[  123.692117] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [117971]
[  123.761205] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [118040]
[  123.842539] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [118121]
[  123.984874] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [118263]
[  125.315062] drivers/input/serio/i8042.c: 27 <- i8042 (interrupt, 0, 1) [119594]
[  125.454100] drivers/input/serio/i8042.c: a7 <- i8042 (interrupt, 0, 1) [119733]
[  125.499862] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [119778]
[  125.606479] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [119885]
[  125.806456] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [120085]
[  125.910642] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [120189]
[  126.026010] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [120304]
[  126.094691] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [120373]
[  126.130245] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [120409]
[  126.166093] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [120445]
[  126.272160] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [120551]
[  126.306445] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [120585]
[  126.308939] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [120587]
[  126.411510] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [120690]
[  126.490442] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [120769]
[  126.596210] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [120875]
[  126.599440] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [120878]
[  126.700209] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [120979]
[  127.173336] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [121452]
[  127.242410] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [121521]
[  127.315526] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [121594]
[  127.453460] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [121732]
[  127.560659] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [121839]
[  127.630855] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [121909]
[  127.665565] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [121944]
[  127.670202] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [121949]
[  127.821265] drivers/input/serio/i8042.c: 30 <- i8042 (interrupt, 0, 1) [122100]
[  127.928025] drivers/input/serio/i8042.c: 17 <- i8042 (interrupt, 0, 1) [122207]
[  127.963346] drivers/input/serio/i8042.c: b0 <- i8042 (interrupt, 0, 1) [122242]
[  128.103758] drivers/input/serio/i8042.c: 97 <- i8042 (interrupt, 0, 1) [122382]
[  128.107190] drivers/input/serio/i8042.c: 31 <- i8042 (interrupt, 0, 1) [122386]
[  128.208890] drivers/input/serio/i8042.c: b1 <- i8042 (interrupt, 0, 1) [122487]
[  128.212396] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [122491]
[  128.320105] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [122599]
[  128.817245] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [123096]
[  128.829992] drivers/input/serio/i8042.c: Interrupt 12, without any data [123108]
[  128.830046] drivers/input/serio/i8042.c: Interrupt 1, without any data [123109]
[  128.830062] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123109]
[  128.830849] drivers/input/serio/i8042.c: 65 -> i8042 (parameter) [123109]
[  128.832014] drivers/input/serio/i8042.c: 20 -> i8042 (command) [123110]
[  128.832014] drivers/input/serio/i8042.c: 65 <- i8042 (return) [123110]
[  128.832749] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123111]
[  128.833662] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [123111]
[  128.834814] drivers/input/serio/i8042.c: d3 -> i8042 (command) [123112]
[  128.834814] drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [123112]
[  128.834814] drivers/input/serio/i8042.c: 5a <- i8042 (return) [123112]
[  128.838074] drivers/input/serio/i8042.c: a7 -> i8042 (command) [123116]
[  128.839090] drivers/input/serio/i8042.c: 20 -> i8042 (command) [123117]
[  128.839090] drivers/input/serio/i8042.c: 74 <- i8042 (return) [123117]
[  128.839324] drivers/input/serio/i8042.c: a8 -> i8042 (command) [123118]
[  128.840314] drivers/input/serio/i8042.c: 20 -> i8042 (command) [123118]
[  128.840314] drivers/input/serio/i8042.c: 54 <- i8042 (return) [123118]
[  128.853217] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123132]
[  128.854007] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [123132]
[  128.855027] drivers/input/serio/i8042.c: d3 -> i8042 (command) [123133]
[  128.855027] drivers/input/serio/i8042.c: a5 -> i8042 (parameter) [123133]
[  128.858719] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123137]
[  128.859352] drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [123137]
[  128.860835] drivers/input/serio/i8042.c: d3 -> i8042 (command) [123138]
[  128.860835] drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [123138]
[  128.860835] drivers/input/serio/i8042.c: f0 <- i8042 (return) [123138]
[  128.864028] drivers/input/serio/i8042.c: d3 -> i8042 (command) [123142]
[  128.864698] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [123142]
[  128.864698] drivers/input/serio/i8042.c: 56 <- i8042 (return) [123142]
[  128.867242] drivers/input/serio/i8042.c: d3 -> i8042 (command) [123145]
[  128.867915] drivers/input/serio/i8042.c: a4 -> i8042 (parameter) [123145]
[  128.867915] drivers/input/serio/i8042.c: a4 <- i8042 (return) [123145]
[  128.869458] drivers/input/serio/i8042.c: Interrupt 12, without any data [123148]
[  128.869730] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123148]
[  128.870403] drivers/input/serio/i8042.c: 56 -> i8042 (parameter) [123148]
[  128.871672] drivers/input/serio/i8042.c: Interrupt 1, without any data [123150]
[  128.872621] drivers/input/serio/i8042.c: 60 -> i8042 (command) [123150]
[  128.872621] drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [123150]
[  128.874472] serio: i8042 KBD port at 0x60,0x64 irq 1
[  128.874523] serio: i8042 AUX port at 0x60,0x64 irq 12
[  128.875457] drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [123153]
[  128.881650] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123160]
[  128.882652] drivers/input/serio/i8042.c: ab <- i8042 (interrupt, 0, 1) [123161]
[  128.883644] drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, 0, 1) [123162]
[  128.883690] drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [123162]
[  128.887748] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123166]
[  128.887788] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [123166]
[  128.892065] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123171]
[  128.892117] drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [123171]
[  128.894925] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123173]
[  128.894958] drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [123173]
[  128.898612] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123177]
[  128.898649] drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [123177]
[  128.902227] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 0, 1) [123181]
[  128.902881] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio2/input/input6
[  128.903579] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123182]
[  128.904021] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [123182]
[  128.911401] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123190]
[  128.912387] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [123191]
[  128.912576] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123191]
[  128.913016] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [123191]
[  128.922238] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123201]
[  128.923207] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [123202]
[  128.923255] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123202]
[  128.924034] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [123202]
[  128.930817] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123209]
[  128.930878] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123209]
[  128.931015] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123209]
[  128.933485] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [123212]
[  128.937857] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123216]
[  128.937904] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123216]
[  128.938018] drivers/input/serio/i8042.c: 0a -> i8042 (parameter) [123216]
[  128.945013] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123223]
[  128.945094] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123224]
[  128.946047] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123224]
[  128.950770] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123229]
[  128.950819] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123229]
[  128.951019] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123229]
[  128.956647] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123235]
[  128.956702] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123235]
[  128.957015] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123235]
[  128.963358] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123242]
[  128.963419] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123242]
[  128.964030] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [123242]
[  128.969966] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123248]
[  128.970109] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123249]
[  128.971013] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123249]
[  128.975979] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123254]
[  128.976038] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123255]
[  128.976965] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [123255]
[  128.981714] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123260]
[  128.981756] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123260]
[  128.982702] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123260]
[  128.989278] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123268]
[  128.989314] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123268]
[  128.990266] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [123268]
[  128.995126] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123274]
[  128.995167] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123274]
[  128.996113] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123274]
[  129.000927] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123279]
[  129.000964] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123279]
[  129.001915] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [123279]
[  129.007310] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123286]
[  129.007351] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123286]
[  129.008296] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123286]
[  129.014400] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123293]
[  129.014437] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123293]
[  129.015388] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [123293]
[  129.020594] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123299]
[  129.020635] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123299]
[  129.021582] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123299]
[  129.027313] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123306]
[  129.027350] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123306]
[  129.028301] drivers/input/serio/i8042.c: 3c -> i8042 (parameter) [123306]
[  129.034268] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123313]
[  129.034309] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123313]
[  129.035254] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123313]
[  129.040399] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123319]
[  129.040434] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123319]
[  129.041386] drivers/input/serio/i8042.c: 28 -> i8042 (parameter) [123319]
[  129.047039] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123326]
[  129.047080] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123326]
[  129.048027] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123326]
[  129.054221] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123333]
[  129.054257] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123333]
[  129.055209] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [123333]
[  129.060111] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123339]
[  129.060152] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123339]
[  129.061099] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [123339]
[  129.066444] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123345]
[  129.066480] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123345]
[  129.067432] drivers/input/serio/i8042.c: 14 -> i8042 (parameter) [123345]
[  129.073089] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123352]
[  129.073130] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123352]
[  129.074077] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [123352]
[  129.080958] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123359]
[  129.082687] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [123361]
[  129.082730] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123361]
[  129.083675] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123361]
[  129.088910] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123367]
[  129.088946] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123367]
[  129.089896] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123367]
[  129.094558] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123373]
[  129.094599] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123373]
[  129.095546] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123373]
[  129.100872] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123379]
[  129.100908] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123379]
[  129.101860] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123379]
[  129.107999] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123386]
[  129.108043] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123387]
[  129.108986] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123387]
[  129.114215] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123393]
[  129.114251] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123393]
[  129.115203] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123393]
[  129.120926] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123399]
[  129.120967] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123399]
[  129.121914] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123399]
[  129.127984] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123406]
[  129.128035] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123407]
[  129.128971] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123407]
[  129.133781] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123412]
[  129.133823] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123412]
[  129.134769] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [123412]
[  129.146909] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123425]
[  129.147934] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [123426]
[  129.148994] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [123427]
[  129.149918] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 1, 12) [123428]
[  129.149957] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123428]
[  129.150907] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [123428]
[  129.156963] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123435]
[  129.157021] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123436]
[  129.158009] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123436]
[  129.163020] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123442]
[  129.163056] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123442]
[  129.164008] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [123442]
[  129.168687] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123447]
[  129.168729] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123447]
[  129.169675] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123447]
[  129.175002] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123453]
[  129.175046] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123454]
[  129.175991] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123454]
[  129.182003] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123460]
[  129.182046] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123461]
[  129.182991] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123461]
[  129.187816] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123466]
[  129.187857] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123466]
[  129.188804] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [123466]
[  129.201101] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123480]
[  129.202092] drivers/input/serio/i8042.c: 3c <- i8042 (interrupt, 1, 12) [123481]
[  129.203144] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [123482]
[  129.204064] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 1, 12) [123483]
[  129.204104] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123483]
[  129.205053] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123483]
[  129.211157] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123490]
[  129.211193] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123490]
[  129.212145] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123490]
[  129.216916] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123495]
[  129.216958] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123495]
[  129.217904] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123495]
[  129.222637] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123501]
[  129.222679] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123501]
[  129.223625] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123501]
[  129.229288] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123508]
[  129.229329] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123508]
[  129.230276] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123508]
[  129.236372] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123515]
[  129.236413] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123515]
[  129.237360] drivers/input/serio/i8042.c: e9 -> i8042 (parameter) [123515]
[  129.247783] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123526]
[  129.248758] drivers/input/serio/i8042.c: 3c <- i8042 (interrupt, 1, 12) [123527]
[  129.250463] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [123529]
[  129.251564] drivers/input/serio/i8042.c: c8 <- i8042 (interrupt, 1, 12) [123530]
[  129.251604] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123530]
[  129.252553] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [123530]
[  129.257608] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123536]
[  129.257649] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123536]
[  129.258596] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123536]
[  129.265325] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123544]
[  129.265362] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123544]
[  129.266310] drivers/input/serio/i8042.c: 00 -> i8042 (parameter) [123544]
[  129.271147] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123550]
[  129.271189] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123550]
[  129.272135] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123550]
[  129.276835] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123555]
[  129.276872] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123555]
[  129.277821] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [123555]
[  129.283585] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123562]
[  129.283627] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123562]
[  129.284573] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123562]
[  129.290311] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123569]
[  129.290347] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123569]
[  129.291298] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [123569]
[  129.296435] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123575]
[  129.296477] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123575]
[  129.297423] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [123575]
[  129.303212] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123582]
[  129.303248] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123582]
[  129.304199] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [123582]
[  129.315064] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123594]
[  129.315106] drivers/input/serio/i8042.c: d4 -> i8042 (command) [123594]
[  129.316052] drivers/input/serio/i8042.c: eb -> i8042 (parameter) [123594]
[  129.321012] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [123600]
[  129.821105] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124100]
[  129.822054] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [124100]
[  129.826980] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124105]
[  129.827038] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124106]
[  129.828010] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [124106]
[  129.833150] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124112]
[  129.833188] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124112]
[  129.834138] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [124112]
[  129.839778] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124118]
[  129.839819] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124118]
[  129.840765] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [124118]
[  129.846905] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124125]
[  129.846941] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124125]
[  129.847893] drivers/input/serio/i8042.c: 01 -> i8042 (parameter) [124125]
[  129.852448] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124131]
[  129.852489] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124131]
[  129.853436] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [124131]
[  129.858113] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124137]
[  129.858149] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124137]
[  129.859101] drivers/input/serio/i8042.c: 02 -> i8042 (parameter) [124137]
[  129.864446] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124143]
[  129.864488] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124143]
[  129.865434] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [124143]
[  129.871565] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124150]
[  129.871601] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124150]
[  129.872553] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [124150]
[  129.877290] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124156]
[  129.877331] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124156]
[  129.878278] drivers/input/serio/i8042.c: eb -> i8042 (parameter) [124156]
[  129.884067] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124163]
[  129.972950] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [124251]
[  130.079645] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [124358]
[  130.150543] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [124429]
[  130.186213] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [124465]
[  130.321882] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 0, 1) [124600]
[  130.384103] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124663]
[  130.385057] drivers/input/serio/i8042.c: f6 -> i8042 (parameter) [124663]
[  130.390581] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124669]
[  130.390624] drivers/input/serio/i8042.c: d4 -> i8042 (command) [124669]
[  130.391568] drivers/input/serio/i8042.c: ff -> i8042 (parameter) [124669]
[  130.397254] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [124676]
[  130.782304] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 1, 12) [125061]
[  130.783995] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [125062]
[  130.784037] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125063]
[  130.784981] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125063]
[  130.786577] drivers/input/serio/i8042.c: 1e <- i8042 (interrupt, 0, 1) [125065]
[  130.790897] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125069]
[  130.790939] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125069]
[  130.791881] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [125069]
[  130.797989] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125076]
[  130.798035] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125077]
[  130.798976] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125077]
[  130.801310] drivers/input/serio/i8042.c: 91 <- i8042 (interrupt, 0, 1) [125080]
[  130.805668] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125084]
[  130.805705] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125084]
[  130.806655] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [125084]
[  130.808922] drivers/input/serio/i8042.c: 14 <- i8042 (interrupt, 0, 1) [125087]
[  130.814081] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125093]
[  130.814130] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125093]
[  130.815065] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125093]
[  130.820685] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125099]
[  130.820725] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125099]
[  130.821672] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [125099]
[  130.823894] drivers/input/serio/i8042.c: 9e <- i8042 (interrupt, 0, 1) [125102]
[  130.828748] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125107]
[  130.828791] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125107]
[  130.829735] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [125107]
[  130.837168] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125116]
[  130.838913] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [125117]
[  130.838954] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125117]
[  130.839899] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125117]
[  130.841547] drivers/input/serio/i8042.c: 94 <- i8042 (interrupt, 0, 1) [125120]
[  130.845842] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125124]
[  130.845879] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125124]
[  130.846829] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [125124]
[  130.853526] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125132]
[  130.853567] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125132]
[  130.854513] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125132]
[  130.859438] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125138]
[  130.859474] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125138]
[  130.860426] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [125138]
[  130.865454] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125144]
[  130.865496] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125144]
[  130.866442] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125144]
[  130.873051] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125152]
[  130.873087] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125152]
[  130.874039] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [125152]
[  130.878883] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125157]
[  130.878925] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125157]
[  130.879871] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [125157]
[  130.886671] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125165]
[  130.888357] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [125167]
[  130.888398] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125167]
[  130.889345] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125167]
[  130.894590] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125173]
[  130.894627] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125173]
[  130.895577] drivers/input/serio/i8042.c: c8 -> i8042 (parameter) [125173]
[  130.901197] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125180]
[  130.901240] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125180]
[  130.902185] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125180]
[  130.908243] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125187]
[  130.908279] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125187]
[  130.909231] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [125187]
[  130.914359] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125193]
[  130.914401] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125193]
[  130.915347] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125193]
[  130.921125] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125200]
[  130.921161] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125200]
[  130.922113] drivers/input/serio/i8042.c: 50 -> i8042 (parameter) [125200]
[  130.927800] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125206]
[  130.927841] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125206]
[  130.928788] drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [125206]
[  130.935727] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125214]
[  130.937520] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [125216]
[  130.937566] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125216]
[  130.938507] drivers/input/serio/i8042.c: f3 -> i8042 (parameter) [125216]
[  130.943537] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125222]
[  130.943575] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125222]
[  130.944524] drivers/input/serio/i8042.c: 64 -> i8042 (parameter) [125222]
[  130.950122] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125229]
[  130.950163] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125229]
[  130.951109] drivers/input/serio/i8042.c: e8 -> i8042 (parameter) [125229]
[  130.957256] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125236]
[  130.957292] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125236]
[  130.958243] drivers/input/serio/i8042.c: 03 -> i8042 (parameter) [125236]
[  130.962877] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125241]
[  130.962918] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125241]
[  130.963864] drivers/input/serio/i8042.c: e6 -> i8042 (parameter) [125241]
[  130.968805] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125247]
[  130.981821] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio3/input/input7
[  130.982632] drivers/input/serio/i8042.c: d4 -> i8042 (command) [125261]
[  130.983021] drivers/input/serio/i8042.c: f4 -> i8042 (parameter) [125261]
[  130.988094] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [125267]
[  131.134019] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [125413]
[  131.205735] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [125484]
[  133.432247] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127711]
[  133.434187] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [127713]
[  133.436828] drivers/input/serio/i8042.c: f3 <- i8042 (interrupt, 1, 12) [127715]
[  133.438955] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127717]
[  133.445644] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127724]
[  133.447642] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [127726]
[  133.450439] drivers/input/serio/i8042.c: f7 <- i8042 (interrupt, 1, 12) [127729]
[  133.452758] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127731]
[  133.456959] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127735]
[  133.459316] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [127738]
[  133.462097] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [127741]
[  133.464085] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127743]
[  133.468923] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127747]
[  133.470981] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [127749]
[  133.473481] drivers/input/serio/i8042.c: f9 <- i8042 (interrupt, 1, 12) [127752]
[  133.476288] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127755]
[  133.480970] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127759]
[  133.483022] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [127762]
[  133.485652] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [127764]
[  133.487776] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127766]
[  133.493074] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127772]
[  133.495109] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [127774]
[  133.497617] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [127776]
[  133.500319] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127779]
[  133.505196] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127784]
[  133.507688] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [127786]
[  133.510368] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [127789]
[  133.512376] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127791]
[  133.517295] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127796]
[  133.520032] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [127799]
[  133.522098] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [127801]
[  133.524743] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127803]
[  133.529555] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127808]
[  133.531969] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127810]
[  133.534527] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 1, 12) [127813]
[  133.536552] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127815]
[  133.541390] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [127820]
[  133.544051] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [127823]
[  133.546402] drivers/input/serio/i8042.c: 0d <- i8042 (interrupt, 1, 12) [127825]
[  133.548971] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127827]
[  133.553844] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [127832]
[  133.555898] drivers/input/serio/i8042.c: fc <- i8042 (interrupt, 1, 12) [127834]
[  133.559046] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 1, 12) [127838]
[  133.561446] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127840]
[  133.565505] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [127844]
[  133.567455] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [127846]
[  133.569490] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [127848]
[  133.571943] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127850]
[  133.577619] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [127856]
[  133.579650] drivers/input/serio/i8042.c: f9 <- i8042 (interrupt, 1, 12) [127858]
[  133.582180] drivers/input/serio/i8042.c: 03 <- i8042 (interrupt, 1, 12) [127861]
[  133.584933] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127863]
[  133.589717] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127868]
[  133.592186] drivers/input/serio/i8042.c: f8 <- i8042 (interrupt, 1, 12) [127871]
[  133.594935] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [127873]
[  133.596928] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127875]
[  133.601770] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127880]
[  133.603870] drivers/input/serio/i8042.c: f6 <- i8042 (interrupt, 1, 12) [127882]
[  133.606078] drivers/input/serio/i8042.c: f9 <- i8042 (interrupt, 1, 12) [127885]
[  133.608201] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127887]
[  133.614521] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127893]
[  133.616944] drivers/input/serio/i8042.c: f7 <- i8042 (interrupt, 1, 12) [127895]
[  133.619630] drivers/input/serio/i8042.c: f6 <- i8042 (interrupt, 1, 12) [127898]
[  133.621559] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127900]
[  133.625932] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127904]
[  133.628643] drivers/input/serio/i8042.c: f8 <- i8042 (interrupt, 1, 12) [127907]
[  133.630705] drivers/input/serio/i8042.c: f4 <- i8042 (interrupt, 1, 12) [127909]
[  133.632813] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127911]
[  133.637993] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127916]
[  133.639893] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127918]
[  133.642465] drivers/input/serio/i8042.c: f3 <- i8042 (interrupt, 1, 12) [127921]
[  133.644950] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127923]
[  133.650095] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127929]
[  133.652759] drivers/input/serio/i8042.c: fd <- i8042 (interrupt, 1, 12) [127931]
[  133.654887] drivers/input/serio/i8042.c: f4 <- i8042 (interrupt, 1, 12) [127933]
[  133.657651] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127936]
[  133.662374] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [127941]
[  133.664658] drivers/input/serio/i8042.c: fe <- i8042 (interrupt, 1, 12) [127943]
[  133.667242] drivers/input/serio/i8042.c: f7 <- i8042 (interrupt, 1, 12) [127946]
[  133.669370] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127948]
[  133.674354] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127953]
[  133.677093] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127956]
[  133.679383] drivers/input/serio/i8042.c: fa <- i8042 (interrupt, 1, 12) [127958]
[  133.681967] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127960]
[  133.686840] drivers/input/serio/i8042.c: 28 <- i8042 (interrupt, 1, 12) [127965]
[  133.689201] drivers/input/serio/i8042.c: 04 <- i8042 (interrupt, 1, 12) [127968]
[  133.691901] drivers/input/serio/i8042.c: fd <- i8042 (interrupt, 1, 12) [127970]
[  133.694004] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127972]
[  133.698666] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127977]
[  133.701826] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 1, 12) [127980]
[  133.704132] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127983]
[  133.706821] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127985]
[  133.711648] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [127990]
[  133.714055] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 1, 12) [127993]
[  133.716693] drivers/input/serio/i8042.c: 05 <- i8042 (interrupt, 1, 12) [127995]
[  133.718705] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [127997]
[  133.723036] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128002]
[  133.725371] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 1, 12) [128004]
[  133.727582] drivers/input/serio/i8042.c: 0b <- i8042 (interrupt, 1, 12) [128006]
[  133.729759] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128008]
[  133.734906] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128013]
[  133.737031] drivers/input/serio/i8042.c: 0d <- i8042 (interrupt, 1, 12) [128016]
[  133.739542] drivers/input/serio/i8042.c: 0c <- i8042 (interrupt, 1, 12) [128018]
[  133.742272] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128021]
[  133.746926] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128025]
[  133.749276] drivers/input/serio/i8042.c: 10 <- i8042 (interrupt, 1, 12) [128028]
[  133.752056] drivers/input/serio/i8042.c: 11 <- i8042 (interrupt, 1, 12) [128031]
[  133.754446] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128033]
[  133.758720] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128037]
[  133.760765] drivers/input/serio/i8042.c: 0a <- i8042 (interrupt, 1, 12) [128039]
[  133.763262] drivers/input/serio/i8042.c: 0d <- i8042 (interrupt, 1, 12) [128042]
[  133.765917] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128044]
[  133.771056] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128050]
[  133.773465] drivers/input/serio/i8042.c: 07 <- i8042 (interrupt, 1, 12) [128052]
[  133.775642] drivers/input/serio/i8042.c: 0e <- i8042 (interrupt, 1, 12) [128054]
[  133.777631] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128056]
[  133.782984] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128061]
[  133.785560] drivers/input/serio/i8042.c: 02 <- i8042 (interrupt, 1, 12) [128064]
[  133.787979] drivers/input/serio/i8042.c: 09 <- i8042 (interrupt, 1, 12) [128066]
[  133.790709] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128069]
[  133.795461] drivers/input/serio/i8042.c: 08 <- i8042 (interrupt, 1, 12) [128074]
[  133.797493] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128076]
[  133.800137] drivers/input/serio/i8042.c: 01 <- i8042 (interrupt, 1, 12) [128079]
[  133.802180] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128081]
[  133.807016] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [128086]
[  133.808956] drivers/input/serio/i8042.c: f5 <- i8042 (interrupt, 1, 12) [128087]
[  133.811036] drivers/input/serio/i8042.c: 04 <- i8042 (interrupt, 1, 12) [128090]
[  133.813313] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128092]
[  133.819821] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [128098]
[  133.822171] drivers/input/serio/i8042.c: f4 <- i8042 (interrupt, 1, 12) [128101]
[  133.824816] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128103]
[  133.826836] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128105]
[  133.831202] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [128110]
[  133.833106] drivers/input/serio/i8042.c: f0 <- i8042 (interrupt, 1, 12) [128112]
[  133.835153] drivers/input/serio/i8042.c: fd <- i8042 (interrupt, 1, 12) [128114]
[  133.837733] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128116]
[  133.844756] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [128123]
[  133.847163] drivers/input/serio/i8042.c: f3 <- i8042 (interrupt, 1, 12) [128126]
[  133.849828] drivers/input/serio/i8042.c: fc <- i8042 (interrupt, 1, 12) [128128]
[  133.851955] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128130]
[  133.855902] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [128134]
[  133.858321] drivers/input/serio/i8042.c: f3 <- i8042 (interrupt, 1, 12) [128137]
[  133.861097] drivers/input/serio/i8042.c: fc <- i8042 (interrupt, 1, 12) [128140]
[  133.863066] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128142]
[  133.867709] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [128146]
[  133.870408] drivers/input/serio/i8042.c: f8 <- i8042 (interrupt, 1, 12) [128149]
[  133.872815] drivers/input/serio/i8042.c: fc <- i8042 (interrupt, 1, 12) [128151]
[  133.875530] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128154]
[  133.879454] drivers/input/serio/i8042.c: 38 <- i8042 (interrupt, 1, 12) [128158]
[  133.881420] drivers/input/serio/i8042.c: fd <- i8042 (interrupt, 1, 12) [128160]
[  133.884100] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [128163]
[  133.886453] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128165]
[  133.891572] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 1, 12) [128170]
[  133.894252] drivers/input/serio/i8042.c: ff <- i8042 (interrupt, 1, 12) [128173]
[  133.896337] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128175]
[  133.899040] drivers/input/serio/i8042.c: 00 <- i8042 (interrupt, 1, 12) [128178]
[  136.009390] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [130288]
[  136.183338] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [130462]
[  136.360168] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [130639]
[  136.364890] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [130643]
[  137.272019] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [131551]
[  137.339199] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [131618]
[  137.376929] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [131655]
[  137.410712] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [131689]
[  137.446775] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [131725]
[  137.516178] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [131795]
[  137.604996] drivers/input/serio/i8042.c: 35 <- i8042 (interrupt, 0, 1) [131883]
[  137.711821] drivers/input/serio/i8042.c: b5 <- i8042 (interrupt, 0, 1) [131990]
[  137.947228] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [132226]
[  138.051777] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [132330]
[  138.135409] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [132414]
[  138.279303] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [132558]
[  138.281677] drivers/input/serio/i8042.c: 2f <- i8042 (interrupt, 0, 1) [132560]
[  138.383975] drivers/input/serio/i8042.c: af <- i8042 (interrupt, 0, 1) [132662]
[  138.437073] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [132716]
[  138.540220] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [132819]
[  138.690310] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [132969]
[  138.763840] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [133042]
[  138.766942] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [133045]
[  138.867653] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [133146]
[  138.940642] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [133219]
[  139.048008] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [133326]
[  139.068094] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [133347]
[  139.172929] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [133451]
[  139.634451] drivers/input/serio/i8042.c: 26 <- i8042 (interrupt, 0, 1) [133913]
[  139.739581] drivers/input/serio/i8042.c: a6 <- i8042 (interrupt, 0, 1) [134018]
[  139.773032] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [134052]
[  139.880383] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [134159]
[  139.886452] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [134165]
[  139.989827] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [134268]
[  140.831444] drivers/input/serio/i8042.c: 1d <- i8042 (interrupt, 0, 1) [135110]
[  140.969576] drivers/input/serio/i8042.c: 13 <- i8042 (interrupt, 0, 1) [135248]
[  141.005621] drivers/input/serio/i8042.c: 93 <- i8042 (interrupt, 0, 1) [135284]
[  141.040255] drivers/input/serio/i8042.c: 9d <- i8042 (interrupt, 0, 1) [135319]
[  141.153032] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [135432]
[  141.260046] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [135539]
[  141.315299] drivers/input/serio/i8042.c: 2e <- i8042 (interrupt, 0, 1) [135594]
[  141.418990] drivers/input/serio/i8042.c: 23 <- i8042 (interrupt, 0, 1) [135697]
[  141.456603] drivers/input/serio/i8042.c: ae <- i8042 (interrupt, 0, 1) [135735]
[  141.491568] drivers/input/serio/i8042.c: a3 <- i8042 (interrupt, 0, 1) [135770]
[  141.494695] drivers/input/serio/i8042.c: 18 <- i8042 (interrupt, 0, 1) [135773]
[  141.560771] drivers/input/serio/i8042.c: 98 <- i8042 (interrupt, 0, 1) [135839]
[  142.198799] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [136477]
[  142.302653] drivers/input/serio/i8042.c: 9c <- i8042 (interrupt, 0, 1) [136581]
[  146.116390] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [140395]
[  146.222530] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [140501]
[  146.225698] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [140504]
[  146.327878] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [140606]
[  146.333641] drivers/input/serio/i8042.c: 12 <- i8042 (interrupt, 0, 1) [140612]
[  146.438667] drivers/input/serio/i8042.c: 92 <- i8042 (interrupt, 0, 1) [140717]
[  146.441839] drivers/input/serio/i8042.c: 1f <- i8042 (interrupt, 0, 1) [140720]
[  146.508288] drivers/input/serio/i8042.c: 9f <- i8042 (interrupt, 0, 1) [140787]
[  146.511510] drivers/input/serio/i8042.c: 22 <- i8042 (interrupt, 0, 1) [140790]
[  146.579586] drivers/input/serio/i8042.c: a2 <- i8042 (interrupt, 0, 1) [140858]
[  146.581986] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [140860]
[  146.683469] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [140962]
[  146.803996] drivers/input/serio/i8042.c: 2a <- i8042 (interrupt, 0, 1) [141082]
[  146.874665] drivers/input/serio/i8042.c: 34 <- i8042 (interrupt, 0, 1) [141153]
[  146.980139] drivers/input/serio/i8042.c: 39 <- i8042 (interrupt, 0, 1) [141259]
[  147.088728] drivers/input/serio/i8042.c: aa <- i8042 (interrupt, 0, 1) [141367]
[  147.093379] drivers/input/serio/i8042.c: b4 <- i8042 (interrupt, 0, 1) [141372]
[  147.097190] drivers/input/serio/i8042.c: b9 <- i8042 (interrupt, 0, 1) [141376]
[  147.578874] drivers/input/serio/i8042.c: 20 <- i8042 (interrupt, 0, 1) [141857]
[  147.683024] drivers/input/serio/i8042.c: a0 <- i8042 (interrupt, 0, 1) [141962]
[  147.725491] drivers/input/serio/i8042.c: 32 <- i8042 (interrupt, 0, 1) [142004]
[  147.796394] drivers/input/serio/i8042.c: b2 <- i8042 (interrupt, 0, 1) [142075]
[  147.858137] drivers/input/serio/i8042.c: 0f <- i8042 (interrupt, 0, 1) [142137]
[  147.965003] drivers/input/serio/i8042.c: 8f <- i8042 (interrupt, 0, 1) [142243]
[  148.253345] drivers/input/serio/i8042.c: 1c <- i8042 (interrupt, 0, 1) [142532]

-- 
Sitsofe | http://sucs.org/~sits/
