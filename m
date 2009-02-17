Return-Path: <linux-kernel-owner+w=401wt.eu-S1751732AbZBQNhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732AbZBQNhu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZBQNhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 08:37:35 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:43758 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbZBQNhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 08:37:21 -0500
X-Greylist: delayed 13269 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Feb 2009 08:37:18 EST
Message-ID: <499ABD80.9020904@free.fr>
Date: Tue, 17 Feb 2009 14:37:04 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: linux-input@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: linux-next: USB mouse won't work after resume.
References: <20090216172016.f1d159a7.sfr@canb.auug.org.au> <499A89AD.6010704@free.fr> <200902171135.13329.oliver@neukum.org>
In-Reply-To: <200902171135.13329.oliver@neukum.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 17.02.2009 11:35, Oliver Neukum a écrit :
> Am Tuesday 17 February 2009 10:55:57 schrieb Laurent Riffard:
>> My USB mouse won't work after suspend to disk and resume. I must unload and reload the ohci_hcd module to get it back.
> 
> Please recompile your kernel with CONFIG_USB_DEBUG and
> send me your dmesg.
> 
> 	Regards
> 		Oliver
> 

Here is it:

[    0.000000] Linux version 2.6.29-rc5-next-20090216 (laurent@calimero) (gcc version 4.3.2 (Ubuntu 4.3.2-1ubuntu12) ) #130 SMP PREEMPT Tue Feb 17 14:18:15 CET 2009
[    0.000000] KERNEL supported cpus:
[    0.000000]   AMD AuthenticAMD
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003bef0000 (usable)
[    0.000000]  BIOS-e820: 000000003bef0000 - 000000003bef3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003bef3000 - 000000003bf00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003c000000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f2000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] DMI 2.4 present.
[    0.000000] last_pfn = 0x3bef0 max_arch_pfn = 0x1000000
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] kernel direct mapping tables up to 379fe000 @ 7000-d000
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] RAMDISK: 37c2d000 - 37fef683
[    0.000000] Allocated new RAMDISK: 00905000 - 00cc7683
[    0.000000] Move RAMDISK from 0000000037c2d000 - 0000000037fef682 to 00905000 - 00cc7682
[    0.000000] ACPI: RSDP 000F6340, 0014 (r0 GBT   )
[    0.000000] ACPI: RSDT 3BEF3000, 0038 (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: FACP 3BEF3040, 0074 (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN (4)
[    0.000000] ACPI: DSDT 3BEF30C0, 5272 (r1 GBT    NVDAACPI     1000 MSFT  3000000)
[    0.000000] ACPI: FACS 3BEF1800, 0040
[    0.000000] ACPI: SSDT 3BEF8400, 028A (r1 PTLTD  POWERNOW        1  LTP        1)
[    0.000000] ACPI: HPET 3BEF86C0, 0038 (r1 GBT    NVDAACPI 42302E31 NVDA       98)
[    0.000000] ACPI: MCFG 3BEF8700, 003C (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: APIC 3BEF8340, 008E (r1 GBT    NVDAACPI 42302E31 NVDA  1010101)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] 68MB HIGHMEM available.
[    0.000000] 889MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 379fe000
[    0.000000]   low ram: 00000000 - 379fe000
[    0.000000]   bootmap 00009000 - 0000ff40
[    0.000000] (9 early reservations) ==> bootmem [0000000000 - 00379fe000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
[    0.000000]   #3 [0000200000 - 00008fb04c]    TEXT DATA BSS ==> [0000200000 - 00008fb04c]
[    0.000000]   #4 [00008fc000 - 0000905000]    INIT_PG_TABLE ==> [00008fc000 - 0000905000]
[    0.000000]   #5 [000009f400 - 0000100000]    BIOS reserved ==> [000009f400 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000009000]          PGTABLE ==> [0000007000 - 0000009000]
[    0.000000]   #7 [0000905000 - 0000cc7683]      NEW RAMDISK ==> [0000905000 - 0000cc7683]
[    0.000000]   #8 [0000009000 - 0000010000]          BOOTMAP ==> [0000009000 - 0000010000]
[    0.000000] found SMP MP-table at [c00f4970] f4970
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x000379fe
[    0.000000]   HighMem  0x000379fe -> 0x0003bef0
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003bef0
[    0.000000] On node 0 totalpages: 245391
[    0.000000] free_area_init_node: node 0, pgdat c04c63c0, node_mem_map c1000000
[    0.000000]   DMA zone: 52 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3947 pages, LIFO batch:0
[    0.000000]   Normal zone: 2841 pages used for memmap
[    0.000000]   Normal zone: 220901 pages, LIFO batch:31
[    0.000000]   HighMem zone: 225 pages used for memmap
[    0.000000]   HighMem zone: 17425 pages, LIFO batch:3
[    0.000000] Using APIC driver default
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfeff0000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap: 40000000:b0000000)
[    0.000000] NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 32768 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 242273
[    0.000000] Kernel command line: root=/dev/mapper/vglinux1-lv_ubuntu2 ro locale=fr_FR vga=795 resume=/dev/mapper/vglinux1-lvswap 
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] Preemptible RCU implementation.
[    0.000000] NR_IRQS:2304 nr_irqs:440
[    0.000000] CPU 0 irqstacks, hard=c0529000 soft=c0521000
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2600.076 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour dummy device 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.004000] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.004000] ... MAX_LOCK_DEPTH:          48
[    0.004000] ... MAX_LOCKDEP_KEYS:        8191
[    0.004000] ... CLASSHASH_SIZE:          4096
[    0.004000] ... MAX_LOCKDEP_ENTRIES:     8192
[    0.004000] ... MAX_LOCKDEP_CHAINS:      16384
[    0.004000] ... CHAINHASH_SIZE:          8192
[    0.004000]  memory used by lock dependency info: 2335 kB
[    0.004000]  per task-struct memory footprint: 1152 bytes
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 956732k/981952k available (1853k kernel code, 24520k reserved, 1036k data, 284k init, 70600k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff50000 - 0xfffff000   ( 700 kB)
[    0.004000]     pkmap   : 0xffa00000 - 0xffc00000   (2048 kB)
[    0.004000]     vmalloc : 0xf81fe000 - 0xff9fe000   ( 120 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf79fe000   ( 889 MB)
[    0.004000]       .init : 0xc04d7000 - 0xc051e000   ( 284 kB)
[    0.004000]       .data : 0xc03cf58d - 0xc04d26d8   (1036 kB)
[    0.004000]       .text : 0xc0200000 - 0xc03cf58d   (1853 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] kmemleak: Early log buffer exceeded
[    0.004000] Pid: 0, comm: swapper Not tainted 2.6.29-rc5-next-20090216 #130
[    0.004000] Call Trace:
[    0.004000]  [<c03cc15c>] ? printk+0xf/0x13
[    0.004000]  [<c04ec3b9>] log_early+0x2b/0xa6
[    0.004000]  [<c027e1bf>] kmemleak_alloc+0x23c/0x249
[    0.004000]  [<c027a2f9>] ? cache_alloc_debugcheck_after+0x2f/0x186
[    0.004000]  [<c027bacf>] __kmalloc+0x14c/0x184
[    0.004000]  [<c027bd64>] ? kmalloc_node+0x8/0xa
[    0.004000]  [<c027bd64>] kmalloc_node+0x8/0xa
[    0.004000]  [<c027bd85>] alloc_arraycache+0x1f/0x56
[    0.004000]  [<c027bdfd>] do_tune_cpucache+0x41/0x24e
[    0.004000]  [<c027c15f>] enable_cpucache+0x5d/0x9b
[    0.004000]  [<c04ec274>] kmem_cache_init+0x348/0x3ed
[    0.004000]  [<c023980a>] ? __mutex_init+0x3f/0x45
[    0.004000]  [<c04d7763>] start_kernel+0x25f/0x2d8
[    0.004000]  [<c04d7085>] __init_begin+0x85/0x8d
[    0.004000] Kernel memory leak detector disabled
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 5200.15 BogoMIPS (lpj=10400304)
[    0.004000] Mount-cache hash table entries: 512
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#0.
[    0.004000] using C1E aware idle routine
[    0.004000] Checking 'hlt' instruction... OK.
[    0.016683] ACPI: Core revision 20090123
[    0.028562] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.069651] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.072001] lockdep: fixing up alternatives.
[    0.072001] CPU 1 irqstacks, hard=c052a000 soft=c0522000
[    0.072001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 5200.02 BogoMIPS (lpj=10400059)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] Intel machine check architecture supported.
[    0.004000] Intel machine check reporting enabled on CPU#1.
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.160558] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.160674] Brought up 2 CPUs
[    0.160680] Total of 2 processors activated (10400.18 BogoMIPS).
[    0.160841] khelper used greatest stack depth: 3040 bytes left
[    0.160841] net_namespace: 852 bytes
[    0.160841] Booting paravirtualized kernel on bare hardware
[    0.160841] NET: Registered protocol family 16
[    0.160841] khelper used greatest stack depth: 2820 bytes left
[    0.160841] ACPI: bus type pci registered
[    0.160841] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 31
[    0.160841] PCI: MCFG area at f0000000 reserved in E820
[    0.164004] PCI: Using MMCONFIG for extended config space
[    0.164012] PCI: Using configuration type 1 for base access
[    0.168211] bio: create slab <bio-0> at 0
[    0.170324] ACPI: EC: Look up EC in DSDT
[    0.183387] ACPI: Denied BIOS AML access to invalid port 0x4d0+0x2 (ELCR)
[    0.183401] ACPI Exception (dsopcode-0419): AE_AML_ILLEGAL_ADDRESS, During address validation of OpRegion [ELCR] [20090123]
[    0.186614] ACPI: Interpreter enabled
[    0.186624] ACPI: (supports S0 S3 S4 S5)
[    0.186685] ACPI: Using IOAPIC for interrupt routing
[    0.208360] ACPI: No dock devices found.
[    0.208396] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.208510] pci 0000:00:01.1: reg 10 io port: [0xc800-0xc83f]
[    0.208510] pci 0000:00:01.1: reg 20 io port: [0x1c00-0x1c3f]
[    0.208510] pci 0000:00:01.1: reg 24 io port: [0x1c40-0x1c7f]
[    0.208510] pci 0000:00:01.1: PME# supported from D3hot D3cold
[    0.208510] pci 0000:00:01.1: PME# disabled
[    0.208510] pci 0000:00:02.0: reg 10 32bit mmio: [0xf700a000-0xf700afff]
[    0.208510] pci 0000:00:02.0: supports D1 D2
[    0.208510] pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208510] pci 0000:00:02.0: PME# disabled
[    0.208515] pci 0000:00:02.1: reg 10 32bit mmio: [0xf700b000-0xf700b0ff]
[    0.208555] pci 0000:00:02.1: supports D1 D2
[    0.208557] pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208568] pci 0000:00:02.1: PME# disabled
[    0.208611] pci 0000:00:04.0: reg 10 32bit mmio: [0xf700c000-0xf700cfff]
[    0.208645] pci 0000:00:04.0: supports D1 D2
[    0.208647] pci 0000:00:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208658] pci 0000:00:04.0: PME# disabled
[    0.208696] pci 0000:00:04.1: reg 10 32bit mmio: [0xf7009000-0xf70090ff]
[    0.208737] pci 0000:00:04.1: supports D1 D2
[    0.208739] pci 0000:00:04.1: PME# supported from D0 D1 D2 D3hot D3cold
[    0.208750] pci 0000:00:04.1: PME# disabled
[    0.208804] pci 0000:00:06.0: reg 20 io port: [0xf000-0xf00f]
[    0.208861] pci 0000:00:07.0: reg 10 32bit mmio: [0xf7000000-0xf7003fff]
[    0.208902] pci 0000:00:07.0: PME# supported from D3hot D3cold
[    0.208912] pci 0000:00:07.0: PME# disabled
[    0.209013] pci 0000:00:09.0: reg 10 io port: [0x9f0-0x9f7]
[    0.209018] pci 0000:00:09.0: reg 14 io port: [0xbf0-0xbf3]
[    0.209023] pci 0000:00:09.0: reg 18 io port: [0x970-0x977]
[    0.209027] pci 0000:00:09.0: reg 1c io port: [0xb70-0xb73]
[    0.209032] pci 0000:00:09.0: reg 20 io port: [0xdc00-0xdc0f]
[    0.209037] pci 0000:00:09.0: reg 24 32bit mmio: [0xf7004000-0xf7005fff]
[    0.209114] pci 0000:00:0a.0: reg 10 32bit mmio: [0xf7006000-0xf7006fff]
[    0.209119] pci 0000:00:0a.0: reg 14 io port: [0xe000-0xe007]
[    0.209124] pci 0000:00:0a.0: reg 18 32bit mmio: [0xf7007000-0xf70070ff]
[    0.209129] pci 0000:00:0a.0: reg 1c 32bit mmio: [0xf7008000-0xf700800f]
[    0.209160] pci 0000:00:0a.0: supports D1 D2
[    0.209162] pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.209174] pci 0000:00:0a.0: PME# disabled
[    0.209219] pci 0000:00:12.0: reg 10 32bit mmio: [0xf2000000-0xf2ffffff]
[    0.209226] pci 0000:00:12.0: reg 14 64bit mmio: [0xe0000000-0xefffffff]
[    0.209234] pci 0000:00:12.0: reg 1c 64bit mmio: [0xf5000000-0xf5ffffff]
[    0.209241] pci 0000:00:12.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.209451] pci 0000:01:07.0: reg 10 io port: [0xa000-0xa007]
[    0.209458] pci 0000:01:07.0: reg 14 io port: [0xa400-0xa403]
[    0.209464] pci 0000:01:07.0: reg 18 io port: [0xa800-0xa807]
[    0.209471] pci 0000:01:07.0: reg 1c io port: [0xac00-0xac03]
[    0.209478] pci 0000:01:07.0: reg 20 io port: [0xb000-0xb00f]
[    0.209484] pci 0000:01:07.0: reg 24 32bit mmio: [0xf4000000-0xf40000ff]
[    0.209491] pci 0000:01:07.0: reg 30 32bit mmio: [0x000000-0x07ffff]
[    0.209509] pci 0000:01:07.0: supports D1 D2
[    0.209542] pci 0000:00:08.0: transparent bridge
[    0.209551] pci 0000:00:08.0: bridge io port: [0xa000-0xbfff]
[    0.209555] pci 0000:00:08.0: bridge 32bit mmio: [0xf3000000-0xf4ffffff]
[    0.209563] pci_bus 0000:00: on NUMA node 0
[    0.209572] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.210251] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.281026] ACPI: PCI Interrupt Link [LNK1] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281026] ACPI: PCI Interrupt Link [LNK2] (IRQs 5 7 9 *10 11 14 15)
[    0.281026] ACPI: PCI Interrupt Link [LNK3] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281026] ACPI: PCI Interrupt Link [LNK4] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281093] ACPI: PCI Interrupt Link [LNK5] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281309] ACPI: PCI Interrupt Link [LNK6] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281524] ACPI: PCI Interrupt Link [LNK7] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281748] ACPI: PCI Interrupt Link [LNK8] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.281971] ACPI: PCI Interrupt Link [LP2P] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.282191] ACPI: PCI Interrupt Link [LIGP] (IRQs 5 7 9 10 *11 14 15)
[    0.282407] ACPI: PCI Interrupt Link [LUBA] (IRQs *5 7 9 10 11 14 15)
[    0.284091] ACPI: PCI Interrupt Link [LUB2] (IRQs 5 7 9 *10 11 14 15)
[    0.284307] ACPI: PCI Interrupt Link [LU1B] (IRQs 5 7 9 10 *11 14 15)
[    0.284523] ACPI: PCI Interrupt Link [LU2B] (IRQs *5 7 9 10 11 14 15)
[    0.284739] ACPI: PCI Interrupt Link [LMAC] (IRQs 5 7 9 10 11 14 *15)
[    0.284955] ACPI: PCI Interrupt Link [LAZA] (IRQs 5 7 9 *10 11 14 15)
[    0.285169] ACPI: PCI Interrupt Link [LPMU] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.285389] ACPI: PCI Interrupt Link [LSMB] (IRQs 5 7 9 10 *11 14 15)
[    0.285602] ACPI: PCI Interrupt Link [LIDE] (IRQs 5 7 9 10 11 14 15) *0, disabled.
[    0.285822] ACPI: PCI Interrupt Link [LSID] (IRQs 5 7 9 10 *11 14 15)
[    0.286132] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.286431] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0
[    0.286728] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0, disabled.
[    0.287028] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.287326] ACPI: PCI Interrupt Link [APC5] (IRQs 16) *0, disabled.
[    0.287625] ACPI: PCI Interrupt Link [APC6] (IRQs 16) *0, disabled.
[    0.287924] ACPI: PCI Interrupt Link [APC7] (IRQs 16) *0, disabled.
[    0.288238] ACPI: PCI Interrupt Link [APC8] (IRQs 16) *0, disabled.
[    0.288542] ACPI: PCI Interrupt Link [AIGP] (IRQs 20 21 22 23) *0
[    0.288844] ACPI: PCI Interrupt Link [AUBA] (IRQs 20 21 22 23) *0
[    0.289145] ACPI: PCI Interrupt Link [AUB2] (IRQs 20 21 22 23) *0
[    0.289445] ACPI: PCI Interrupt Link [AU1B] (IRQs 20 21 22 23) *0
[    0.289746] ACPI: PCI Interrupt Link [AU2B] (IRQs 20 21 22 23) *0
[    0.290046] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.290346] ACPI: PCI Interrupt Link [APMU] (IRQs 20 21 22 23) *0, disabled.
[    0.290648] ACPI: PCI Interrupt Link [AAZA] (IRQs 20 21 22 23) *0
[    0.290950] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.291250] ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22 23) *0, disabled.
[    0.291552] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.291855] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.292429] PCI: Using ACPI for IRQ routing
[    0.308072] hpet0: at MMIO 0xfeff0000, IRQs 2, 8, 31
[    0.308085] hpet0: 3 comparators, 32-bit 25.000000 MHz counter
[    0.316016] Switched to NOHz mode on CPU #0
[    0.316677] Switched to NOHz mode on CPU #1
[    0.328037] pnp: PnP ACPI init
[    0.328075] ACPI: bus type pnp registered
[    0.336611] pnp: PnP ACPI: found 14 devices
[    0.336621] ACPI: ACPI bus type pnp unregistered
[    0.336644] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.336655] system 00:01: ioport range 0x1080-0x10ff has been reserved
[    0.336665] system 00:01: ioport range 0x1400-0x147f has been reserved
[    0.336675] system 00:01: ioport range 0x1480-0x14ff has been reserved
[    0.336685] system 00:01: ioport range 0x1800-0x187f has been reserved
[    0.336695] system 00:01: ioport range 0x1880-0x18ff has been reserved
[    0.336706] system 00:01: iomem range 0xfefe0000-0xfefe01ff has been reserved
[    0.336717] system 00:01: iomem range 0xfefe1000-0xfefe10ff has been reserved
[    0.336728] system 00:01: iomem range 0x3c000000-0x3fffffff has been reserved
[    0.336747] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.336757] system 00:02: ioport range 0x800-0x87f has been reserved
[    0.336767] system 00:02: ioport range 0x295-0x314 has been reserved
[    0.336777] system 00:02: ioport range 0x290-0x294 has been reserved
[    0.336797] system 00:0c: iomem range 0xf0000000-0xf1ffffff has been reserved
[    0.336813] system 00:0d: iomem range 0xd4600-0xd7fff has been reserved
[    0.336824] system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
[    0.336835] system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
[    0.336846] system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
[    0.336857] system 00:0d: iomem range 0x3bef0000-0x3befffff could not be reserved
[    0.336869] system 00:0d: iomem range 0xffff0000-0xffffffff has been reserved
[    0.336880] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.336891] system 00:0d: iomem range 0x100000-0x3beeffff could not be reserved
[    0.336903] system 00:0d: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.336914] system 00:0d: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.372795] pci 0000:00:08.0: PCI bridge, secondary bus 0000:01
[    0.372806] pci 0000:00:08.0:   IO window: 0xa000-0xbfff
[    0.372817] pci 0000:00:08.0:   MEM window: 0xf3000000-0xf4ffffff
[    0.372827] pci 0000:00:08.0:   PREFETCH window: 0x00000050000000-0x000000500fffff
[    0.372847] pci 0000:00:08.0: setting latency timer to 64
[    0.372852] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.372854] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.372857] pci_bus 0000:01: resource 0 io:  [0xa000-0xbfff]
[    0.372859] pci_bus 0000:01: resource 1 mem: [0xf3000000-0xf4ffffff]
[    0.372862] pci_bus 0000:01: resource 2 mem: [0x50000000-0x500fffff]
[    0.372864] pci_bus 0000:01: resource 3 io:  [0x00-0xffff]
[    0.372866] pci_bus 0000:01: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.372993] NET: Registered protocol family 2
[    0.440177] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.440940] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.441755] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.446008] TCP: Hash tables configured (established 131072 bind 65536)
[    0.446055] TCP reno registered
[    0.468312] NET: Registered protocol family 1
[    0.469050] Unpacking initramfs... done
[    0.624691] Freeing initrd memory: 3849k freed
[    0.628059] highmem bounce pool size: 64 pages
[    0.628646] msgmni has been set to 1738
[    0.629070] alg: No test for stdrng (krng)
[    0.629115] io scheduler noop registered
[    0.629126] io scheduler anticipatory registered
[    0.629133] io scheduler deadline registered
[    0.629181] io scheduler cfq registered (default)
[    0.629223] pci 0000:00:00.0: Enabling HT MSI Mapping
[    0.629481] pci 0000:00:07.0: Enabling HT MSI Mapping
[    0.629508] pci 0000:00:08.0: Enabling HT MSI Mapping
[    0.629536] pci 0000:00:09.0: Enabling HT MSI Mapping
[    0.629564] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    0.629590] pci 0000:00:12.0: Boot video device
[    0.631422] vesafb: framebuffer at 0xe0000000, mapped to 0xf8280000, using 10240k, total 65536k
[    0.631436] vesafb: mode is 1280x1024x32, linelength=5120, pages=0
[    0.631445] vesafb: protected mode interface info at c000:cfb0
[    0.631454] vesafb: pmi: set display start = c00ccfe6, set palette = c00cd050
[    0.631463] vesafb: pmi: ports = b4c3 b503 ba03 c003 c103 c403 c503 c603 c703 c803 c903 cc03 ce03 cf03 d003 d103 d203 d303 d403 d503 da03 ff03 
[    0.631500] vesafb: scrolling: redraw
[    0.631507] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.655832] Console: switching to colour frame buffer device 160x64
[    0.677872] fb0: VESA VGA frame buffer device
[    0.694243] Linux agpgart interface v0.103
[    0.694914] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.695086] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.695686] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.696261] mice: PS/2 mouse device common for all mice
[    0.696845] cpuidle: using governor ladder
[    0.696960] cpuidle: using governor menu
[    0.697629] TCP cubic registered
[    0.697720] Using IPI No-Shortcut mode
[    0.698574] BIOS EDD facility v0.16 2004-Jun-25, 3 devices found
[    0.699419] Freeing unused kernel memory: 284k freed
[    0.699706] Write protecting the kernel text: 1856k
[    0.699916] Write protecting the kernel read-only data: 868k
[    0.715537] all_generic_ide used greatest stack depth: 2708 bytes left
[    0.716333] brltty used greatest stack depth: 2516 bytes left
[    0.717607] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.770715] setfont used greatest stack depth: 2348 bytes left
[    0.853256] device-mapper: uevent: version 1.0.3
[    0.853646] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    0.874170] SCSI subsystem initialized
[    0.886515] libata version 3.00 loaded.
[    0.888446] pata_amd 0000:00:06.0: version 0.3.11
[    0.888644] pata_amd 0000:00:06.0: setting latency timer to 64
[    0.888774] scsi0 : pata_amd
[    0.889246] scsi1 : pata_amd
[    0.890746] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
[    0.890940] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
[    1.068327] ata1.00: HPA unlocked: 78163247 -> 78165360, native 78165360
[    1.068513] ata1.00: ATA-5: ST340016A, 3.75, max UDMA/100
[    1.068662] ata1.00: 78165360 sectors, multi 16: LBA 
[    1.068826] ata1.01: ATAPI: HL-DT-ST DVDRAM GSA-4165B, DL05, max UDMA/33
[    1.069029] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c00000) ACPI=0x3f01f (20:60:0x1f)
[    1.069033] ata1: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc6c00000) ACPI=0x701f (20:60:0x1f)
[    1.084400] ata1.00: configured for UDMA/100
[    1.100244] ata1.01: configured for UDMA/33
[    1.103113] scsi 0:0:0:0: Direct-Access     ATA      ST340016A        3.75 PQ: 0 ANSI: 5
[    1.113882] scsi 0:0:1:0: CD-ROM            HL-DT-ST DVDRAM GSA-4165B DL05 PQ: 0 ANSI: 5
[    1.120845] ata2: port disabled. ignoring.
[    1.121121] modprobe used greatest stack depth: 2036 bytes left
[    1.134069] pata_sil680 0000:01:07.0: version 0.4.9
[    1.134631] ACPI: PCI Interrupt Link [APC2] enabled at IRQ 17
[    1.141518]   alloc irq_desc for 17 on cpu 0 node 0
[    1.141521]   alloc kstat_irqs on cpu 0 node 0
[    1.141529] pata_sil680 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[    1.148647] sil680: 133MHz clock.
[    1.155878] scsi2 : pata_sil680
[    1.163066] scsi3 : pata_sil680
[    1.170100] ata3: PATA max UDMA/133 cmd 0xa000 ctl 0xa400 bmdma 0xb000 irq 17
[    1.177159] ata4: PATA max UDMA/133 cmd 0xa800 ctl 0xac00 bmdma 0xb008 irq 17
[    1.356502] ata3.01: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
[    1.363521] ata3.01: 160086528 sectors, multi 16: LBA 
[    1.384376] ata3.01: configured for UDMA/133
[    1.391554] scsi 2:0:1:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
[    1.612025] ata4.01: ATA-7: MAXTOR STM3802110A, 3.AAJ, max UDMA/100
[    1.619355] ata4.01: 156301488 sectors, multi 16: LBA48 
[    1.686808] ata4.01: configured for UDMA/100
[    1.694272] scsi 3:0:1:0: Direct-Access     ATA      MAXTOR STM380211 3.AA PQ: 0 ANSI: 5
[    1.709821] Driver 'sd' needs updating - please use bus_type methods
[    1.717930] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors: (40.0 GB/37.2 GiB)
[    1.725864] sd 0:0:0:0: [sda] Write Protect is off
[    1.733701] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.733744] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.741939] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors: (40.0 GB/37.2 GiB)
[    1.749800] sd 0:0:0:0: [sda] Write Protect is off
[    1.757595] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.757637] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.765537]  sda: sda1 sda2 sda3 < sda5 sda6 sda7 >
[    1.813188] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.821258] sd 2:0:1:0: [sdb] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[    1.829172] sd 2:0:1:0: [sdb] Write Protect is off
[    1.837030] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.837073] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.845137] sd 2:0:1:0: [sdb] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[    1.853138] sd 2:0:1:0: [sdb] Write Protect is off
[    1.861030] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    1.861074] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.869142]  sdb: sdb1 sdb2 < sdb5 sdb6 >
[    1.916557] sd 2:0:1:0: [sdb] Attached SCSI disk
[    1.924595] sd 3:0:1:0: [sdc] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    1.932540] sd 3:0:1:0: [sdc] Write Protect is off
[    1.940425] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    1.940467] sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.948658] sd 3:0:1:0: [sdc] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[    1.956852] sd 3:0:1:0: [sdc] Write Protect is off
[    1.964987] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[    1.965030] sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.973331]  sdc: sdc1 sdc2 < sdc5 >
[    2.008372] sd 3:0:1:0: [sdc] Attached SCSI disk
[    2.066755] processor ACPI_CPU:00: registered as cooling_device0
[    2.075327] processor ACPI_CPU:01: registered as cooling_device1
[    2.115752] md: linear personality registered for level -1
[    2.134098] md: raid0 personality registered for level 0
[    2.148998] md: raid1 personality registered for level 1
[    2.177517] md: raid10 personality registered for level 10
[    2.476596] md: md0 stopped.
[    2.879248] md: bind<sdc1>
[    2.888427] md: bind<sda1>
[    2.900567] raid1: raid set md0 active with 2 out of 2 mirrors
[    2.910325] md: md127 stopped.
[    2.918079]  md0:
[    2.984367] md: bind<sdb6>
[    3.040333] md: md127 stopped.
[    3.047875] md: unbind<sdb6>
[    3.068199] md: export_rdev(sdb6)
[    3.204400] md: bind<sdc5>
[    3.212400] md: bind<sdb6>
[    3.223844] raid1: raid set md127 active with 2 out of 2 mirrors
[    3.233652]  md127: unknown partition table
[    4.378603] PM: Starting manual resume from disk
[    4.432347] EXT3-fs: mounted filesystem with ordered data mode.
[    4.439817] kjournald starting.  Commit interval 5 seconds
[    5.706738] grep used greatest stack depth: 1964 bytes left
[    6.667880] loadkeys used greatest stack depth: 1808 bytes left
[    8.087022] udevd version 124 started
[    9.571348] usbcore: registered new interface driver usbfs
[    9.584064] usbcore: registered new interface driver hub
[    9.594809] usbcore: registered new device driver usb
[    9.606215] input: PC Speaker as /class/input/input1
[    9.649779] k8temp 0000:00:18.3: Temperature readouts might be wrong - check erratum #141
[    9.673937] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.63.
[    9.680947] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[    9.687579]   alloc irq_desc for 23 on cpu 0 node 0
[    9.687582]   alloc kstat_irqs on cpu 0 node 0
[    9.687592] forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
[    9.694087] forcedeth 0000:00:0a.0: setting latency timer to 64
[    9.702545] parport_pc 00:0a: reported by Plug and Play ACPI
[    9.710003] parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
[    9.730482] input: Power Button (FF) as /class/input/input2
[    9.750965] ACPI: Power Button (FF) [PWRF]
[    9.757753] input: Power Button (CM) as /class/input/input3
[    9.786106] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    9.793134] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.800746] ACPI: Power Button (CM) [PWRB]
[    9.861278] rtc_cmos 00:05: RTC can wake from S4
[    9.868474] rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
[    9.875515] rtc0: alarms up to one year, y3k, 242 bytes nvram, hpet irqs
[    9.916031] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    9.948123] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    9.955445] ohci_hcd: block sizes: ed 64 td 64
[    9.969082] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    9.976257] Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
[    9.983813] ehci_hcd: block sizes: qh 128 qtd 96 itd 160 sitd 96
[   10.006399] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   10.013871] scsi 0:0:1:0: Attached scsi generic sg1 type 5
[   10.021516] sd 2:0:1:0: Attached scsi generic sg2 type 0
[   10.028993] sd 3:0:1:0: Attached scsi generic sg3 type 0
[   10.127789] modprobe used greatest stack depth: 1604 bytes left
[   10.213837] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x732 @ 1, addr 00:1f:d0:53:49:ae
[   10.221445] forcedeth 0000:00:0a.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
[   10.229207] ahci 0000:00:09.0: version 3.0
[   10.229764] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 22
[   10.237471]   alloc irq_desc for 22 on cpu 0 node 0
[   10.237473]   alloc kstat_irqs on cpu 0 node 0
[   10.237482] ahci 0000:00:09.0: PCI INT A -> Link[APSI] -> GSI 22 (level, low) -> IRQ 22
[   10.246157]   alloc irq_desc for 24 on cpu 0 node 0
[   10.246161]   alloc kstat_irqs on cpu 0 node 0
[   10.246172] ahci 0000:00:09.0: irq 24 for MSI/MSI-X
[   10.246446] ahci 0000:00:09.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[   10.254454] ahci 0000:00:09.0: flags: 64bit ncq sntf led clo pmp pio 
[   10.262319] ahci 0000:00:09.0: setting latency timer to 64
[   10.262908] scsi4 : ahci
[   10.271246] scsi5 : ahci
[   10.279459] scsi6 : ahci
[   10.287555] scsi7 : ahci
[   10.295653] ata5: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004100 irq 24
[   10.303345] ata6: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004180 irq 24
[   10.310983] ata7: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004200 irq 24
[   10.318512] ata8: SATA max UDMA/133 abar m8192@0xf7004000 port 0xf7004280 irq 24
[   10.644667] ata5: SATA link down (SStatus 0 SControl 300)
[   10.968017] ata6: SATA link down (SStatus 0 SControl 300)
[   11.292015] ata7: SATA link down (SStatus 0 SControl 300)
[   11.616015] ata8: SATA link down (SStatus 0 SControl 300)
[   11.623889] ACPI: PCI Interrupt Link [AUBA] enabled at IRQ 21
[   11.631255]   alloc irq_desc for 21 on cpu 0 node 0
[   11.631258]   alloc kstat_irqs on cpu 0 node 0
[   11.631268] ohci_hcd 0000:00:02.0: PCI INT A -> Link[AUBA] -> GSI 21 (level, low) -> IRQ 21
[   11.638797] ohci_hcd 0000:00:02.0: setting latency timer to 64
[   11.638801] ohci_hcd 0000:00:02.0: OHCI Host Controller
[   11.647332] drivers/usb/core/inode.c: creating file 'devices'
[   11.647492] drivers/usb/core/inode.c: creating file '001'
[   11.647555] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[   11.654964] ohci_hcd 0000:00:02.0: created debug files
[   11.654966] ohci_hcd 0000:00:02.0: supports USB remote wakeup
[   11.655006] ohci_hcd 0000:00:02.0: irq 21, io mem 0xf700a000
[   11.718795] ohci_hcd 0000:00:02.0: OHCI controller state
[   11.718801] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[   11.718804] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[   11.718807] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[   11.718810] ohci_hcd 0000:00:02.0: intrstatus 0x00000044 RHSC SF
[   11.718813] ohci_hcd 0000:00:02.0: intrenable 0x8000001a MIE UE RD WDH
[   11.718817] ohci_hcd 0000:00:02.0: hcca frame #0003
[   11.718821] ohci_hcd 0000:00:02.0: roothub.a 01000205 POTPGT=1 NPS NDP=5(5)
[   11.718824] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[   11.718826] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[   11.718830] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[   11.718833] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[   11.718836] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[   11.718839] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[   11.718843] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00010301 CSC LSDA PPS CCS
[   11.719035] usb usb1: default language 0x0409
[   11.719061] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[   11.726437] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.733753] usb usb1: Product: OHCI Host Controller
[   11.741095] usb usb1: Manufacturer: Linux 2.6.29-rc5-next-20090216 ohci_hcd
[   11.748512] usb usb1: SerialNumber: 0000:00:02.0
[   11.756280] usb usb1: uevent
[   11.756398] usb usb1: usb_probe_device
[   11.756401] usb usb1: configuration #1 chosen from 1 choice
[   11.764029] usb usb1: adding 1-0:1.0 (config #1, interface 0)
[   11.764083] usb 1-0:1.0: uevent
[   11.764247] hub 1-0:1.0: usb_probe_interface
[   11.764249] hub 1-0:1.0: usb_probe_interface - got id
[   11.764252] hub 1-0:1.0: USB hub found
[   11.771752] hub 1-0:1.0: 5 ports detected
[   11.778909] hub 1-0:1.0: standalone hub
[   11.778911] hub 1-0:1.0: no power switching (usb 1.0)
[   11.778913] hub 1-0:1.0: global over-current protection
[   11.778916] hub 1-0:1.0: power on to power good time: 2ms
[   11.779145] hub 1-0:1.0: local power source is good
[   11.779147] hub 1-0:1.0: no over-current condition exists
[   11.779150] hub 1-0:1.0: trying to enable port power on non-switchable hub
[   11.780625] drivers/usb/core/inode.c: creating file '001'
[   11.781380] ACPI: PCI Interrupt Link [AUB2] enabled at IRQ 20
[   11.788651]   alloc irq_desc for 20 on cpu 0 node 0
[   11.788653]   alloc kstat_irqs on cpu 0 node 0
[   11.788662] ehci_hcd 0000:00:02.1: PCI INT B -> Link[AUB2] -> GSI 20 (level, low) -> IRQ 20
[   11.796134] ehci_hcd 0000:00:02.1: setting latency timer to 64
[   11.796137] ehci_hcd 0000:00:02.1: EHCI Host Controller
[   11.803597] drivers/usb/core/inode.c: creating file '002'
[   11.803615] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
[   11.811255] ehci_hcd 0000:00:02.1: reset hcs_params 0x101c85 dbg=1 cc=1 pcc=12 !ppc ports=5
[   11.811261] ehci_hcd 0000:00:02.1: reset portroute 0 0 0 0 0 
[   11.811264] ehci_hcd 0000:00:02.1: reset hcc_params a087 caching frame 256/512/1024 park 64 bit addr
[   11.811302] ehci_hcd 0000:00:02.1: park 0
[   11.811307] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   11.811318] ehci_hcd 0000:00:02.1: debug port 1
[   11.818668] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[   11.818671] ehci_hcd 0000:00:02.1: supports USB remote wakeup
[   11.818701] ehci_hcd 0000:00:02.1: irq 20, io mem 0xf700b000
[   11.826127] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   11.826133] ehci_hcd 0000:00:02.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   11.836735] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00
[   11.844286] usb usb2: default language 0x0409
[   11.844306] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[   11.851822] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   11.859274] usb usb2: Product: EHCI Host Controller
[   11.866595] usb usb2: Manufacturer: Linux 2.6.29-rc5-next-20090216 ehci_hcd
[   11.874123] usb usb2: SerialNumber: 0000:00:02.1
[   11.881453] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00010300 CSC LSDA PPS
[   11.881617] usb usb2: uevent
[   11.881686] usb usb2: usb_probe_device
[   11.881689] usb usb2: configuration #1 chosen from 1 choice
[   11.888929] usb usb2: adding 2-0:1.0 (config #1, interface 0)
[   11.888976] usb 2-0:1.0: uevent
[   11.889022] hub 2-0:1.0: usb_probe_interface
[   11.889025] hub 2-0:1.0: usb_probe_interface - got id
[   11.889028] hub 2-0:1.0: USB hub found
[   11.896229] hub 2-0:1.0: 5 ports detected
[   11.903277] hub 2-0:1.0: standalone hub
[   11.903279] hub 2-0:1.0: no power switching (usb 1.0)
[   11.903280] hub 2-0:1.0: individual port over-current protection
[   11.903284] hub 2-0:1.0: power on to power good time: 20ms
[   11.903347] hub 2-0:1.0: local power source is good
[   11.903351] hub 2-0:1.0: trying to enable port power on non-switchable hub
[   11.903631] drivers/usb/core/inode.c: creating file '001'
[   11.904383] ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
[   11.911497] HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 23 (level, low) -> IRQ 23
[   11.918780] HDA Intel 0000:00:07.0: setting latency timer to 64
[   11.980802] hub 1-0:1.0: state 7 ports 5 chg 0000 evt 0000
[   12.000779] ehci_hcd 0000:00:02.1: GetStatus port 5 status 001403 POWER sig=k CSC CONNECT
[   12.000784] hub 2-0:1.0: port 5: status 0501 change 0001
[   12.100757] hub 2-0:1.0: state 7 ports 5 chg 0020 evt 0000
[   12.100772] hub 2-0:1.0: port 5, status 0501, change 0000, 480 Mb/s
[   12.100891] ehci_hcd 0000:00:02.1: port 5 low speed --> companion
[   12.156038] ehci_hcd 0000:00:02.1: GetStatus port 5 status 003402 POWER OWNER sig=k CSC
[   12.156130] hub 1-0:1.0: state 7 ports 5 chg 0000 evt 0020
[   12.156138] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00010301 CSC LSDA PPS CCS
[   12.156147] hub 1-0:1.0: port 5, status 0301, change 0001, 1.5 Mb/s
[   12.284019] hub 1-0:1.0: debounce: port 5: total 100ms stable 100ms status 0x301
[   12.404780] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00100303 PRSC LSDA PPS PES CCS
[   12.460791] usb 1-5: new low speed USB device using ohci_hcd and address 2
[   12.493547] ACPI: PCI Interrupt Link [AU1B] enabled at IRQ 22
[   12.500934] ohci_hcd 0000:00:04.0: PCI INT A -> Link[AU1B] -> GSI 22 (level, low) -> IRQ 22
[   12.509319] ohci_hcd 0000:00:04.0: setting latency timer to 64
[   12.509324] ohci_hcd 0000:00:04.0: OHCI Host Controller
[   12.517184] drivers/usb/core/inode.c: creating file '003'
[   12.517204] ohci_hcd 0000:00:04.0: new USB bus registered, assigned bus number 3
[   12.524942] ohci_hcd 0000:00:04.0: created debug files
[   12.524944] ohci_hcd 0000:00:04.0: supports USB remote wakeup
[   12.524975] ohci_hcd 0000:00:04.0: irq 22, io mem 0xf700c000
[   12.536107] Driver 'sr' needs updating - please use bus_type methods
[   12.556350] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[   12.563820] Uniform CD-ROM driver Revision: 3.20
[   12.571505] sr 0:0:1:0: Attached scsi CD-ROM sr0
[   12.580801] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00100303 PRSC LSDA PPS PES CCS
[   12.590789] ohci_hcd 0000:00:04.0: OHCI controller state
[   12.590795] ohci_hcd 0000:00:04.0: OHCI 1.0, NO legacy support registers
[   12.590798] ohci_hcd 0000:00:04.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[   12.590801] ohci_hcd 0000:00:04.0: cmdstatus 0x00000 SOC=0
[   12.590804] ohci_hcd 0000:00:04.0: intrstatus 0x00000044 RHSC SF
[   12.590807] ohci_hcd 0000:00:04.0: intrenable 0x8000001a MIE UE RD WDH
[   12.590811] ohci_hcd 0000:00:04.0: hcca frame #0003
[   12.590815] ohci_hcd 0000:00:04.0: roothub.a 01000205 POTPGT=1 NPS NDP=5(5)
[   12.590818] ohci_hcd 0000:00:04.0: roothub.b 00000000 PPCM=0000 DR=0000
[   12.590821] ohci_hcd 0000:00:04.0: roothub.status 00008000 DRWE
[   12.590824] ohci_hcd 0000:00:04.0: roothub.portstatus [0] 0x00000100 PPS
[   12.590827] ohci_hcd 0000:00:04.0: roothub.portstatus [1] 0x00010101 CSC PPS CCS
[   12.590831] ohci_hcd 0000:00:04.0: roothub.portstatus [2] 0x00000100 PPS
[   12.590834] ohci_hcd 0000:00:04.0: roothub.portstatus [3] 0x00000100 PPS
[   12.590837] ohci_hcd 0000:00:04.0: roothub.portstatus [4] 0x00000100 PPS
[   12.590879] usb usb3: default language 0x0409
[   12.590900] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[   12.598261] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.605508] usb usb3: Product: OHCI Host Controller
[   12.612884] usb usb3: Manufacturer: Linux 2.6.29-rc5-next-20090216 ohci_hcd
[   12.620200] usb usb3: SerialNumber: 0000:00:04.0
[   12.627758] usb usb3: uevent
[   12.627830] usb usb3: usb_probe_device
[   12.627833] usb usb3: configuration #1 chosen from 1 choice
[   12.635231] usb usb3: adding 3-0:1.0 (config #1, interface 0)
[   12.635289] usb 3-0:1.0: uevent
[   12.635333] hub 3-0:1.0: usb_probe_interface
[   12.635335] hub 3-0:1.0: usb_probe_interface - got id
[   12.635339] hub 3-0:1.0: USB hub found
[   12.642655] hub 3-0:1.0: 5 ports detected
[   12.649849] hub 3-0:1.0: standalone hub
[   12.649851] hub 3-0:1.0: no power switching (usb 1.0)
[   12.649853] hub 3-0:1.0: global over-current protection
[   12.649856] hub 3-0:1.0: power on to power good time: 2ms
[   12.649868] hub 3-0:1.0: local power source is good
[   12.649870] hub 3-0:1.0: no over-current condition exists
[   12.649873] hub 3-0:1.0: trying to enable port power on non-switchable hub
[   12.650108] drivers/usb/core/inode.c: creating file '001'
[   12.650861] ACPI: PCI Interrupt Link [AU2B] enabled at IRQ 21
[   12.658099] ehci_hcd 0000:00:04.1: PCI INT B -> Link[AU2B] -> GSI 21 (level, low) -> IRQ 21
[   12.665368] ehci_hcd 0000:00:04.1: setting latency timer to 64
[   12.665372] ehci_hcd 0000:00:04.1: EHCI Host Controller
[   12.672671] drivers/usb/core/inode.c: creating file '004'
[   12.672689] ehci_hcd 0000:00:04.1: new USB bus registered, assigned bus number 4
[   12.679865] ehci_hcd 0000:00:04.1: reset hcs_params 0x101c85 dbg=1 cc=1 pcc=12 !ppc ports=5
[   12.679872] ehci_hcd 0000:00:04.1: reset portroute 0 0 0 0 0 
[   12.679875] ehci_hcd 0000:00:04.1: reset hcc_params a087 caching frame 256/512/1024 park 64 bit addr
[   12.679914] ehci_hcd 0000:00:04.1: park 0
[   12.679918] ehci_hcd 0000:00:04.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   12.679929] ehci_hcd 0000:00:04.1: debug port 1
[   12.680818] usb 1-5: skipped 1 descriptor after interface
[   12.683812] usb 1-5: default language 0x0409
[   12.687016] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
[   12.687018] ehci_hcd 0000:00:04.1: supports USB remote wakeup
[   12.687030] ehci_hcd 0000:00:04.1: irq 21, io mem 0xf7009000
[   12.694284] ehci_hcd 0000:00:04.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[   12.694291] ehci_hcd 0000:00:04.1: init command 010009 (park)=0 ithresh=1 period=256 RUN
[   12.694295] usb 1-5: New USB device found, idVendor=04f3, idProduct=0210
[   12.694299] usb 1-5: New USB device strings: Mfr=0, Product=2, SerialNumber=0
[   12.694302] usb 1-5: Product: PS/2+USB Mouse
[   12.694460] usb 1-5: uevent
[   12.694499] usb 1-5: usb_probe_device
[   12.694502] usb 1-5: configuration #1 chosen from 1 choice
[   12.724842] usb 1-5: adding 1-5:1.0 (config #1, interface 0)
[   12.724916] usb 1-5:1.0: uevent
[   12.725186] drivers/usb/core/inode.c: creating file '002'
[   12.725322] hub 2-0:1.0: state 7 ports 5 chg 0000 evt 0020
[   12.725341] hub 1-0:1.0: state 7 ports 5 chg 0000 evt 0020
[   12.732804] ehci_hcd 0000:00:04.1: USB 2.0 started, EHCI 1.00
[   12.740619] usb usb4: default language 0x0409
[   12.740639] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[   12.748344] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [1] = 0x00010100 CSC PPS
[   12.748370] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[   12.756007] usb usb4: Product: EHCI Host Controller
[   12.764073] usb usb4: Manufacturer: Linux 2.6.29-rc5-next-20090216 ehci_hcd
[   12.772731] usb usb4: SerialNumber: 0000:00:04.1
[   12.780816] usb usb4: uevent
[   12.780855] usb usb4: usb_probe_device
[   12.780858] usb usb4: configuration #1 chosen from 1 choice
[   12.796291] usb usb4: adding 4-0:1.0 (config #1, interface 0)
[   12.796369] usb 4-0:1.0: uevent
[   12.796408] hub 4-0:1.0: usb_probe_interface
[   12.796410] hub 4-0:1.0: usb_probe_interface - got id
[   12.796413] hub 4-0:1.0: USB hub found
[   12.813841] hub 4-0:1.0: 5 ports detected
[   12.821861] hub 4-0:1.0: standalone hub
[   12.821863] hub 4-0:1.0: no power switching (usb 1.0)
[   12.821865] hub 4-0:1.0: individual port over-current protection
[   12.821871] hub 4-0:1.0: power on to power good time: 20ms
[   12.821886] hub 4-0:1.0: local power source is good
[   12.821889] hub 4-0:1.0: trying to enable port power on non-switchable hub
[   12.822124] drivers/usb/core/inode.c: creating file '001'
[   12.848862] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0000
[   12.860209] usbhid 1-5:1.0: usb_probe_interface
[   12.860212] usbhid 1-5:1.0: usb_probe_interface - got id
[   12.866267] input: PS/2+USB Mouse as /class/input/input4
[   12.896888] generic-usb 0003:04F3:0210.0001: input: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:02.0-5/input0
[   12.905041] usbcore: registered new interface driver usbhid
[   12.913376] usbhid: v2.6:USB HID core driver
[   12.921608] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[   12.921614] hub 4-0:1.0: port 2: status 0501 change 0001
[   13.020828] hub 4-0:1.0: state 7 ports 5 chg 0004 evt 0000
[   13.020846] hub 4-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[   13.077091] ehci_hcd 0000:00:04.1: port 2 high speed
[   13.077096] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   13.132832] usb 4-2: new high speed USB device using ehci_hcd and address 2
[   13.197070] ehci_hcd 0000:00:04.1: port 2 high speed
[   13.197074] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[   13.275311] usb 4-2: default language 0x0409
[   13.275686] usb 4-2: New USB device found, idVendor=05e3, idProduct=0606
[   13.283703] usb 4-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[   13.291719] usb 4-2: Product: USB2.0 Hub
[   13.299892] usb 4-2: uevent
[   13.299927] usb 4-2: usb_probe_device
[   13.299930] usb 4-2: configuration #1 chosen from 1 choice
[   13.308570] usb 4-2: adding 4-2:1.0 (config #1, interface 0)
[   13.308622] usb 4-2:1.0: uevent
[   13.308649] hub 4-2:1.0: usb_probe_interface
[   13.308651] hub 4-2:1.0: usb_probe_interface - got id
[   13.308654] hub 4-2:1.0: USB hub found
[   13.317059] hub 4-2:1.0: 4 ports detected
[   13.324964] hub 4-2:1.0: standalone hub
[   13.324965] hub 4-2:1.0: ganged power switching
[   13.324967] hub 4-2:1.0: global over-current protection
[   13.324972] hub 4-2:1.0: Single TT
[   13.324974] hub 4-2:1.0: TT requires at most 32 FS bit times (2664 ns)
[   13.324976] hub 4-2:1.0: Port indicators are supported
[   13.324978] hub 4-2:1.0: power on to power good time: 100ms
[   13.325559] hub 4-2:1.0: local power source is good
[   13.325561] hub 4-2:1.0: no over-current condition exists
[   13.325564] hub 4-2:1.0: enabling power on all ports
[   13.326719] drivers/usb/core/inode.c: creating file '002'
[   13.425971] usb 4-2: link qh256-0001/f612d100 start 255 [1/0 us]
[   13.425984] hub 4-2:1.0: state 7 ports 4 chg 0000 evt 0000
[   13.674674] it87: Found IT8716F chip at 0x290, revision 3
[   14.040891] ohci_hcd 0000:00:04.0: auto-stop root hub
[   14.805037] hub 2-0:1.0: hub_suspend
[   14.805183] usb usb2: bus auto-suspend
[   14.805185] ehci_hcd 0000:00:02.1: suspend root hub
[   14.862101] EXT3 FS on dm-5, internal journal
[   15.804992] hub 3-0:1.0: hub_suspend
[   15.805004] usb usb3: bus auto-suspend
[   15.805033] ohci_hcd 0000:00:04.0: suspend root hub
[   15.805052] hub 4-2:1.0: hub_suspend
[   15.805116] usb 4-2: unlink qh256-0001/f612d100 start 255 [1/0 us]
[   15.805594] usb 4-2: usb auto-suspend
[   16.134988] kjournald starting.  Commit interval 5 seconds
[   16.147286] EXT3 FS on md0, internal journal
[   16.147296] EXT3-fs: mounted filesystem with ordered data mode.
[   16.228191] ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
[   16.228267] ReiserFS: dm-0: using ordered data mode
[   16.236024] ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   16.236598] ReiserFS: dm-0: checking transaction log (dm-0)
[   16.315895] ReiserFS: dm-0: Using r5 hash to sort names
[   16.628143] kjournald starting.  Commit interval 5 seconds
[   16.628157] EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
[   16.628392] EXT3 FS on sda5, internal journal
[   16.628401] EXT3-fs: mounted filesystem with ordered data mode.
[   16.746970] ReiserFS: sda6: found reiserfs format "3.6" with standard journal
[   16.747003] ReiserFS: sda6: using ordered data mode
[   16.755291] ReiserFS: sda6: journal params: device sda6, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[   16.755850] ReiserFS: sda6: checking transaction log (sda6)
[   16.793054] ReiserFS: sda6: Using r5 hash to sort names
[   16.889846] kjournald starting.  Commit interval 5 seconds
[   16.907659] EXT3 FS on dm-1, internal journal
[   16.907669] EXT3-fs: mounted filesystem with ordered data mode.
[   17.107298] Adding 1048568k swap on /dev/mapper/vglinux1-lvswap.  Priority:-1 extents:1 across:1048568k 
[   17.995365]   alloc irq_desc for 25 on cpu 0 node 0
[   17.995370]   alloc kstat_irqs on cpu 0 node 0
[   17.995393] forcedeth 0000:00:0a.0: irq 25 for MSI/MSI-X
[   17.995667] eth0: no link during initialization.
[   18.553737] NET: Registered protocol family 10
[   18.556860] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   18.805179] hub 4-0:1.0: hub_suspend
[   18.805192] usb usb4: bus auto-suspend
[   18.805195] ehci_hcd 0000:00:04.1: suspend root hub
[   19.450540] ttyS1: LSR safety check engaged!
[   19.451649] ttyS1: LSR safety check engaged!
[   19.672186] eth0: link up.
[   19.672747] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   21.665653] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[   21.666202] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0xa
[   21.666206] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xc
[   21.666209] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xe
[   21.666211] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0x10
[   21.666213] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[   21.666215] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[   22.001394] Clocksource tsc unstable (delta = -137339594 ns)
[   24.291460] lp0: using parport0 (interrupt-driven).
[   29.961872] eth0: no IPv6 routers present
[   31.644356] ttyS1: LSR safety check engaged!
[   44.215834] 
[   44.215840] =========================================================
[   44.215850] [ INFO: possible irq lock inversion dependency detected ]
[   44.215858] 2.6.29-rc5-next-20090216 #130
[   44.215864] ---------------------------------------------------------
[   44.215870] swapper/0 just changed the state of lock:
[   44.215876]  (fasync_lock){..+.}, at: [<c0289103>] kill_fasync+0x1b/0x35
[   44.215899] but this lock took another, hard-irq-unsafe lock in the past:
[   44.215905]  (&f->f_lock){--..}
[   44.215911] 
[   44.215913] and interrupts could create inverse lock ordering between them.
[   44.215915] 
[   44.215921] 
[   44.215922] other info that might help us debug this:
[   44.215928] 2 locks held by swapper/0:
[   44.215932]  #0:  (&serio->lock){+...}, at: [<c035c186>] serio_interrupt+0x1b/0x69
[   44.215951]  #1:  (&dev->event_lock){+...}, at: [<c035f922>] input_event+0x30/0x62
[   44.215968] 
[   44.215970] the first lock's dependencies:
[   44.215975] -> (fasync_lock){..+.} ops: 0 {
[   44.215987]    initial-use  at:
[   44.215994]                                        [<c02440d1>] __lock_acquire+0x2d6/0xafe
[   44.216008]                                        [<c024494c>] lock_acquire+0x53/0x75
[   44.216018]                                        [<c03ce6fa>] _write_lock_irq+0x30/0x3f
[   44.216030]                                        [<c0288dc4>] fasync_helper+0x3f/0xdf
[   44.216039]                                        [<c033fd23>] tty_fasync+0x4b/0xe5
[   44.216052]                                        [<c0341cbe>] tty_release_dev+0x52/0x3fb
[   44.216062]                                        [<c0342079>] tty_release+0x12/0x1c
[   44.216071]                                        [<c02808d1>] __fput+0xca/0x153
[   44.216081]                                        [<c0280973>] fput+0x19/0x1b
[   44.216090]                                        [<c027e412>] filp_close+0x51/0x5b
[   44.216099]                                        [<c022862f>] put_files_struct+0x68/0xaa
[   44.216109]                                        [<c02286a8>] exit_files+0x37/0x3c
[   44.216118]                                        [<c0229a7f>] do_exit+0x199/0x6f2
[   44.216127]                                        [<c022a036>] do_group_exit+0x5e/0x85
[   44.216136]                                        [<c022a070>] sys_exit_group+0x13/0x17
[   44.216145]                                        [<c0202eea>] syscall_call+0x7/0xb
[   44.216156]                                        [<ffffffff>] 0xffffffff
[   44.216170]    in-hardirq-R at:
[   44.216176]                                        [<c0243fde>] __lock_acquire+0x1e3/0xafe
[   44.216186]                                        [<c024494c>] lock_acquire+0x53/0x75
[   44.216195]                                        [<c03ce838>] _read_lock+0x25/0x34
[   44.216204]                                        [<c0289103>] kill_fasync+0x1b/0x35
[   44.216214]                                        [<f96f6bd3>] evdev_pass_event+0x5b/0x61 [evdev]
[   44.216231]                                        [<f96f6e85>] evdev_event+0x3e/0x99 [evdev]
[   44.216244]                                        [<c035e6f9>] input_pass_event+0x2d/0x7a
[   44.216254]                                        [<c035f876>] input_handle_event+0x33c/0x345
[   44.216264]                                        [<c035f941>] input_event+0x4f/0x62
[   44.216273]                                        [<c0362559>] atkbd_interrupt+0x233/0x506
[   44.216285]                                        [<c035c19e>] serio_interrupt+0x33/0x69
[   44.216294]                                        [<c035cff1>] i8042_interrupt+0x1d6/0x1e7
[   44.216304]                                        [<c0251b62>] handle_IRQ_event+0x1a/0x4b
[   44.216318]                                        [<c0252c8d>] handle_edge_irq+0xab/0xec
[   44.216328]                                        [<ffffffff>] 0xffffffff
[   44.216338]  }
[   44.216342]  ... key      at: [<c04b0434>] fasync_lock+0x10/0x1c
[   44.216354]  -> (&f->f_lock){--..} ops: 0 {
[   44.216366]     initial-use  at:
[   44.216372]                                          [<c02440d1>] __lock_acquire+0x2d6/0xafe
[   44.216382]                                          [<c024494c>] lock_acquire+0x53/0x75
[   44.216391]                                          [<c03ce58d>] _spin_lock+0x25/0x34
[   44.216400]                                          [<c0288e34>] fasync_helper+0xaf/0xdf
[   44.216410]                                          [<c033fd23>] tty_fasync+0x4b/0xe5
[   44.216420]                                          [<c0341cbe>] tty_release_dev+0x52/0x3fb
[   44.216430]                                          [<c0342079>] tty_release+0x12/0x1c
[   44.216438]                                          [<c02808d1>] __fput+0xca/0x153
[   44.216448]                                          [<c0280973>] fput+0x19/0x1b
[   44.216457]                                          [<c027e412>] filp_close+0x51/0x5b
[   44.216466]                                          [<c022862f>] put_files_struct+0x68/0xaa
[   44.216475]                                          [<c02286a8>] exit_files+0x37/0x3c
[   44.216484]                                          [<c0229a7f>] do_exit+0x199/0x6f2
[   44.216492]                                          [<c022a036>] do_group_exit+0x5e/0x85
[   44.216501]                                          [<c022a070>] sys_exit_group+0x13/0x17
[   44.216510]                                          [<c0202eea>] syscall_call+0x7/0xb
[   44.216520]                                          [<ffffffff>] 0xffffffff
[   44.216532]     softirq-on-W at:
[   44.216538]                                          [<c02440bc>] __lock_acquire+0x2c1/0xafe
[   44.216548]                                          [<c024494c>] lock_acquire+0x53/0x75
[   44.216558]                                          [<c03ce58d>] _spin_lock+0x25/0x34
[   44.216567]                                          [<c0289448>] do_fcntl+0x21d/0x2b1
[   44.216576]                                          [<c0289531>] sys_fcntl64+0x55/0x69
[   44.216586]                                          [<c0202eea>] syscall_call+0x7/0xb
[   44.216595]                                          [<ffffffff>] 0xffffffff
[   44.216605]     hardirq-on-W at:
[   44.216611]                                          [<c0244099>] __lock_acquire+0x29e/0xafe
[   44.216622]                                          [<c024494c>] lock_acquire+0x53/0x75
[   44.216632]                                          [<c03ce58d>] _spin_lock+0x25/0x34
[   44.216641]                                          [<c0289448>] do_fcntl+0x21d/0x2b1
[   44.216650]                                          [<c0289531>] sys_fcntl64+0x55/0x69
[   44.216659]                                          [<c0202eea>] syscall_call+0x7/0xb
[   44.216668]                                          [<ffffffff>] 0xffffffff
[   44.216678]   }
[   44.216681]   ... key      at: [<c08ef778>] __key.21217+0x0/0x8
[   44.216693]  ... acquired at:
[   44.216697]    [<c0244786>] __lock_acquire+0x98b/0xafe
[   44.216705]    [<c024494c>] lock_acquire+0x53/0x75
[   44.216714]    [<c03ce58d>] _spin_lock+0x25/0x34
[   44.216721]    [<c0288e34>] fasync_helper+0xaf/0xdf
[   44.216729]    [<c033fd23>] tty_fasync+0x4b/0xe5
[   44.216738]    [<c0341cbe>] tty_release_dev+0x52/0x3fb
[   44.216746]    [<c0342079>] tty_release+0x12/0x1c
[   44.216753]    [<c02808d1>] __fput+0xca/0x153
[   44.216761]    [<c0280973>] fput+0x19/0x1b
[   44.216769]    [<c027e412>] filp_close+0x51/0x5b
[   44.216776]    [<c022862f>] put_files_struct+0x68/0xaa
[   44.216784]    [<c02286a8>] exit_files+0x37/0x3c
[   44.216791]    [<c0229a7f>] do_exit+0x199/0x6f2
[   44.216799]    [<c022a036>] do_group_exit+0x5e/0x85
[   44.216806]    [<c022a070>] sys_exit_group+0x13/0x17
[   44.216814]    [<c0202eea>] syscall_call+0x7/0xb
[   44.216821]    [<ffffffff>] 0xffffffff
[   44.216833] 
[   44.216836] 
[   44.216838] the second lock's dependencies:
[   44.216842] -> (&f->f_lock){--..} ops: 0 {
[   44.216854]    initial-use  at:
[   44.216859]                                        [<c02440d1>] __lock_acquire+0x2d6/0xafe
[   44.216870]                                        [<c024494c>] lock_acquire+0x53/0x75
[   44.216879]                                        [<c03ce58d>] _spin_lock+0x25/0x34
[   44.216889]                                        [<c0288e34>] fasync_helper+0xaf/0xdf
[   44.216898]                                        [<c033fd23>] tty_fasync+0x4b/0xe5
[   44.216908]                                        [<c0341cbe>] tty_release_dev+0x52/0x3fb
[   44.216917]                                        [<c0342079>] tty_release+0x12/0x1c
[   44.216926]                                        [<c02808d1>] __fput+0xca/0x153
[   44.216935]                                        [<c0280973>] fput+0x19/0x1b
[   44.216943]                                        [<c027e412>] filp_close+0x51/0x5b
[   44.216952]                                        [<c022862f>] put_files_struct+0x68/0xaa
[   44.216961]                                        [<c02286a8>] exit_files+0x37/0x3c
[   44.216970]                                        [<c0229a7f>] do_exit+0x199/0x6f2
[   44.216979]                                        [<c022a036>] do_group_exit+0x5e/0x85
[   44.216988]                                        [<c022a070>] sys_exit_group+0x13/0x17
[   44.216998]                                        [<c0202eea>] syscall_call+0x7/0xb
[   44.217007]                                        [<ffffffff>] 0xffffffff
[   44.217018]    softirq-on-W at:
[   44.217024]                                        [<c02440bc>] __lock_acquire+0x2c1/0xafe
[   44.217034]                                        [<c024494c>] lock_acquire+0x53/0x75
[   44.217043]                                        [<c03ce58d>] _spin_lock+0x25/0x34
[   44.217052]                                        [<c0289448>] do_fcntl+0x21d/0x2b1
[   44.217062]                                        [<c0289531>] sys_fcntl64+0x55/0x69
[   44.217071]                                        [<c0202eea>] syscall_call+0x7/0xb
[   44.217080]                                        [<ffffffff>] 0xffffffff
[   44.217090]    hardirq-on-W at:
[   44.217095]                                        [<c0244099>] __lock_acquire+0x29e/0xafe
[   44.217105]                                        [<c024494c>] lock_acquire+0x53/0x75
[   44.217115]                                        [<c03ce58d>] _spin_lock+0x25/0x34
[   44.217124]                                        [<c0289448>] do_fcntl+0x21d/0x2b1
[   44.217133]                                        [<c0289531>] sys_fcntl64+0x55/0x69
[   44.217142]                                        [<c0202eea>] syscall_call+0x7/0xb
[   44.217151]                                        [<ffffffff>] 0xffffffff
[   44.217161]  }
[   44.217164]  ... key      at: [<c08ef778>] __key.21217+0x0/0x8
[   44.217173] 
[   44.217174] stack backtrace:
[   44.217181] Pid: 0, comm: swapper Not tainted 2.6.29-rc5-next-20090216 #130
[   44.217187] Call Trace:
[   44.217199]  [<c03cc15c>] ? printk+0xf/0x13
[   44.217207]  [<c024320b>] print_irq_inversion_bug+0xea/0xf7
[   44.217216]  [<c024324e>] check_usage_forwards+0x36/0x3f
[   44.217224]  [<c024346c>] mark_lock+0x1d6/0x349
[   44.217232]  [<c0243fde>] __lock_acquire+0x1e3/0xafe
[   44.217240]  [<c0241f49>] ? graph_unlock+0x64/0x70
[   44.217249]  [<c024494c>] lock_acquire+0x53/0x75
[   44.217256]  [<c0289103>] ? kill_fasync+0x1b/0x35
[   44.217264]  [<c03ce838>] _read_lock+0x25/0x34
[   44.217271]  [<c0289103>] ? kill_fasync+0x1b/0x35
[   44.217278]  [<c0289103>] kill_fasync+0x1b/0x35
[   44.217292]  [<f96f6bd3>] evdev_pass_event+0x5b/0x61 [evdev]
[   44.217304]  [<f96f6e85>] evdev_event+0x3e/0x99 [evdev]
[   44.217314]  [<c035e6f9>] input_pass_event+0x2d/0x7a
[   44.217322]  [<c035f876>] input_handle_event+0x33c/0x345
[   44.217331]  [<c0361cf9>] ? atkbd_event+0x0/0x42
[   44.217338]  [<c035f941>] input_event+0x4f/0x62
[   44.217347]  [<c0362559>] atkbd_interrupt+0x233/0x506
[   44.217354]  [<c03ce654>] ? _spin_lock_irqsave+0x40/0x49
[   44.217362]  [<c035c19e>] serio_interrupt+0x33/0x69
[   44.217369]  [<c035cff1>] i8042_interrupt+0x1d6/0x1e7
[   44.217379]  [<c02fab15>] ? _raw_spin_unlock+0x17/0x7e
[   44.217388]  [<c0251b62>] handle_IRQ_event+0x1a/0x4b
[   44.217396]  [<c0252c8d>] handle_edge_irq+0xab/0xec
[   44.217403]  [<c0252be2>] ? handle_edge_irq+0x0/0xec
[   44.217407]  <IRQ>  [<c020486e>] ? do_IRQ+0x45/0x87
[   44.217422]  [<c02034ac>] ? common_interrupt+0x2c/0x34
[   44.217434]  [<c0216eff>] ? native_safe_halt+0x5/0x7
[   44.217442]  [<c0208c45>] ? default_idle+0x35/0x5f
[   44.217449]  [<c0208e56>] ? c1e_idle+0x101/0x106
[   44.217457]  [<c020210d>] ? cpu_idle+0x5f/0x96
[   44.217465]  [<c03ca219>] ? start_secondary+0x19a/0x1a1

# suspend/resume start here

[  187.530071] PM: Syncing filesystems ... done.
[  187.539614] Freezing user space processes ... (elapsed 0.00 seconds) done.
[  187.541577] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[  187.541841] PM: Shrinking memory...  -done (0 pages freed)
[  187.601616] PM: Freed 0 kbytes in 0.05 seconds (0.00 MB/s)
[  187.601749] Suspending console(s) (use no_console_suspend to debug)
[  187.602620] hub 1-0:1.0: hub_suspend
[  187.602633] usb usb1: bus suspend
[  187.602639] ohci_hcd 0000:00:02.0: suspend root hub
[  187.602762] sd 3:0:1:0: [sdc] Synchronizing SCSI cache
[  187.634516] sd 2:0:1:0: [sdb] Synchronizing SCSI cache
[  187.634667] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  187.656253] ACPI handle has no context!
[  187.657172] parport_pc 00:0a: disabled
[  187.657881] serial 00:09: disabled
[  187.658199] pata_sil680 0000:01:07.0: PCI INT A disabled
[  187.660174] forcedeth 0000:00:0a.0: wake-up capability disabled by ACPI
[  187.660185] forcedeth 0000:00:0a.0: PME# disabled
[  187.660356] forcedeth 0000:00:0a.0: PCI INT A disabled
[  187.736272] HDA Intel 0000:00:07.0: PCI INT A disabled
[  187.736446] ata2: port disabled. ignoring.
[  187.736640] ehci_hcd 0000:00:04.1: PCI INT B disabled
[  187.736682] ehci_hcd 0000:00:04.1: PME# disabled
[  187.736686] ehci_hcd 0000:00:04.1: wakeup: 0
[  187.736690] ehci_hcd 0000:00:04.1: --> no state change
[  187.736817] ohci_hcd 0000:00:04.0: PCI INT A disabled
[  187.736853] ohci_hcd 0000:00:04.0: PME# disabled
[  187.736857] ohci_hcd 0000:00:04.0: wakeup: 0
[  187.736860] ohci_hcd 0000:00:04.0: --> no state change
[  187.736985] ehci_hcd 0000:00:02.1: PCI INT B disabled
[  187.737027] ehci_hcd 0000:00:02.1: PME# disabled
[  187.737031] ehci_hcd 0000:00:02.1: wakeup: 0
[  187.737034] ehci_hcd 0000:00:02.1: --> no state change
[  187.737160] ohci_hcd 0000:00:02.0: PCI INT A disabled
[  187.737196] ohci_hcd 0000:00:02.0: PME# disabled
[  187.737200] ohci_hcd 0000:00:02.0: wakeup: 0
[  187.737203] ohci_hcd 0000:00:02.0: --> no state change
[  187.737809] Disabling non-boot CPUs ...
[  187.740003] kvm: disabling virtualization on CPU1
[  187.740062] CPU 1 is now offline
[  187.740067] lockdep: fixing up alternatives.
[  187.740072] SMP alternatives: switching to UP code
[  187.960088] CPU1 is down
[  187.960262] PM: Creating hibernation image: 
[  187.963744] PM: Need to copy 52341 pages
[  187.963744] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[  187.963744] Intel machine check architecture supported.
[  187.963744] Intel machine check reporting enabled on CPU#0.
[  187.963744] ohci_hcd 0000:00:02.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[  187.963744] ehci_hcd 0000:00:02.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[  187.963744] ohci_hcd 0000:00:04.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00003)
[  187.963744] ehci_hcd 0000:00:04.1: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[  187.963744] pata_amd 0000:00:06.0: restoring config space at offset 0x1 (was 0xb00001, writing 0xb00005)
[  187.963744] HDA Intel 0000:00:07.0: restoring config space at offset 0x1 (was 0xb00006, writing 0xb00002)
[  187.963744] ahci 0000:00:09.0: restoring config space at offset 0x1 (was 0xb00007, writing 0xb00407)
[  187.963744] pata_sil680 0000:01:07.0: restoring config space at offset 0x1 (was 0x2900003, writing 0x2900007)
[  187.963744] Enabling non-boot CPUs ...
[  187.963744] lockdep: fixing up alternatives.
[  187.963744] SMP alternatives: switching to SMP code
[  188.103542] CPU 1 irqstacks, hard=c052a000 soft=c0522000
[  188.103551] Booting processor 1 APIC 0x1 ip 0x6000
[  187.920880] Initializing CPU#1
[  187.920880] Calibrating delay using timer specific routine.. 5200.45 BogoMIPS (lpj=10400914)
[  187.920880] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[  187.920880] CPU: L2 Cache: 512K (64 bytes/line)
[  187.920880] CPU: Physical Processor ID: 0
[  187.920880] CPU: Processor Core ID: 1
[  187.920880] Intel machine check architecture supported.
[  187.920880] Intel machine check reporting enabled on CPU#1.
[  187.920880] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[  188.192291] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[  188.192312] kvm: enabling virtualization on CPU1
[  188.196034] Switched to NOHz mode on CPU #1
[  188.235773] CPU1 is up
[  188.236002] pci 0000:00:01.1: PME# disabled
[  188.236018] ohci_hcd 0000:00:02.0: PME# disabled
[  188.236957] ohci_hcd 0000:00:02.0: PCI INT A -> Link[AUBA] -> GSI 21 (level, low) -> IRQ 21
[  188.236970] ohci_hcd 0000:00:02.0: setting latency timer to 64
[  188.236981] ohci_hcd 0000:00:02.0: PME# disabled
[  188.236989] ohci_hcd 0000:00:02.0: lost power
[  188.296009] ohci_hcd 0000:00:02.0: OHCI controller state
[  188.296009] ohci_hcd 0000:00:02.0: OHCI 1.0, NO legacy support registers
[  188.296009] ohci_hcd 0000:00:02.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[  188.296009] ohci_hcd 0000:00:02.0: cmdstatus 0x00000 SOC=0
[  188.296009] ohci_hcd 0000:00:02.0: intrstatus 0x00000044 RHSC SF
[  188.296009] ohci_hcd 0000:00:02.0: intrenable 0x8000001a MIE UE RD WDH
[  188.296009] ohci_hcd 0000:00:02.0: hcca frame #0003
[  188.296009] ohci_hcd 0000:00:02.0: roothub.a 01000205 POTPGT=1 NPS NDP=5(5)
[  188.296009] ohci_hcd 0000:00:02.0: roothub.b 00000000 PPCM=0000 DR=0000
[  188.296009] ohci_hcd 0000:00:02.0: roothub.status 00008000 DRWE
[  188.296009] ohci_hcd 0000:00:02.0: roothub.portstatus [0] 0x00000100 PPS
[  188.296009] ohci_hcd 0000:00:02.0: roothub.portstatus [1] 0x00000100 PPS
[  188.296009] ohci_hcd 0000:00:02.0: roothub.portstatus [2] 0x00000100 PPS
[  188.296009] ohci_hcd 0000:00:02.0: roothub.portstatus [3] 0x00000100 PPS
[  188.296009] ohci_hcd 0000:00:02.0: roothub.portstatus [4] 0x00010301 CSC LSDA PPS CCS
[  188.296009] ohci_hcd 0000:00:02.0: restart complete
[  188.296009] usb usb1: root hub lost power or was reset
[  188.296009] ohci_hcd 0000:00:02.0: suspend root hub
[  188.296009] ehci_hcd 0000:00:02.1: PME# disabled
[  188.296009] ehci_hcd 0000:00:02.1: PCI INT B -> Link[AUB2] -> GSI 20 (level, low) -> IRQ 20
[  188.296009] ehci_hcd 0000:00:02.1: setting latency timer to 64
[  188.296009] ehci_hcd 0000:00:02.1: PME# disabled
[  188.296009] ehci_hcd 0000:00:02.1: lost power, restarting
[  188.296009] usb usb2: root hub lost power or was reset
[  188.296009] ehci_hcd 0000:00:02.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[  188.296009] ehci_hcd 0000:00:02.1: debug port 1
[  188.296009] ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
[  188.296009] ohci_hcd 0000:00:04.0: PME# disabled
[  188.296009] ohci_hcd 0000:00:04.0: PCI INT A -> Link[AU1B] -> GSI 22 (level, low) -> IRQ 22
[  188.296009] ohci_hcd 0000:00:04.0: setting latency timer to 64
[  188.296009] ohci_hcd 0000:00:04.0: PME# disabled
[  188.296009] ohci_hcd 0000:00:04.0: lost power
[  188.350014] ohci_hcd 0000:00:04.0: OHCI controller state
[  188.350020] ohci_hcd 0000:00:04.0: OHCI 1.0, NO legacy support registers
[  188.350026] ohci_hcd 0000:00:04.0: control 0x683 RWE RWC HCFS=operational CBSR=3
[  188.350031] ohci_hcd 0000:00:04.0: cmdstatus 0x00000 SOC=0
[  188.350037] ohci_hcd 0000:00:04.0: intrstatus 0x00000044 RHSC SF
[  188.350043] ohci_hcd 0000:00:04.0: intrenable 0x8000001a MIE UE RD WDH
[  188.350050] ohci_hcd 0000:00:04.0: hcca frame #0003
[  188.350056] ohci_hcd 0000:00:04.0: roothub.a 01000205 POTPGT=1 NPS NDP=5(5)
[  188.350062] ohci_hcd 0000:00:04.0: roothub.b 00000000 PPCM=0000 DR=0000
[  188.350067] ohci_hcd 0000:00:04.0: roothub.status 00008000 DRWE
[  188.350074] ohci_hcd 0000:00:04.0: roothub.portstatus [0] 0x00000100 PPS
[  188.350080] ohci_hcd 0000:00:04.0: roothub.portstatus [1] 0x00010101 CSC PPS CCS
[  188.350087] ohci_hcd 0000:00:04.0: roothub.portstatus [2] 0x00000100 PPS
[  188.350093] ohci_hcd 0000:00:04.0: roothub.portstatus [3] 0x00000100 PPS
[  188.350099] ohci_hcd 0000:00:04.0: roothub.portstatus [4] 0x00000100 PPS
[  188.350104] ohci_hcd 0000:00:04.0: restart complete
[  188.350108] usb usb3: root hub lost power or was reset
[  188.350113] ohci_hcd 0000:00:04.0: suspend root hub
[  188.350125] ehci_hcd 0000:00:04.1: PME# disabled
[  188.351258] ehci_hcd 0000:00:04.1: PCI INT B -> Link[AU2B] -> GSI 21 (level, low) -> IRQ 21
[  188.351268] ehci_hcd 0000:00:04.1: setting latency timer to 64
[  188.351277] ehci_hcd 0000:00:04.1: PME# disabled
[  188.351282] ehci_hcd 0000:00:04.1: lost power, restarting
[  188.351286] usb usb4: root hub lost power or was reset
[  188.351294] ehci_hcd 0000:00:04.1: reset command 080b02 park=3 ithresh=8 period=1024 Reset HALT
[  188.351305] ehci_hcd 0000:00:04.1: debug port 1
[  188.351312] ehci_hcd 0000:00:04.1: cache line size of 64 is not supported
[  188.351361] pata_amd 0000:00:06.0: setting latency timer to 64
[  188.355665] ata2: port disabled. ignoring.
[  188.357156] HDA Intel 0000:00:07.0: PCI INT A -> Link[AAZA] -> GSI 23 (level, low) -> IRQ 23
[  188.357166] HDA Intel 0000:00:07.0: setting latency timer to 64
[  188.436129] pci 0000:00:08.0: setting latency timer to 64
[  188.436211] ahci 0000:00:09.0: setting latency timer to 64
[  188.436302] forcedeth 0000:00:0a.0: wake-up capability disabled by ACPI
[  188.436311] forcedeth 0000:00:0a.0: PME# disabled
[  188.441574] forcedeth 0000:00:0a.0: irq 25 for MSI/MSI-X
[  188.441803] eth0: no link during initialization.
[  188.441979] pci 0000:00:12.0: PME# disabled
[  188.443330] pata_sil680 0000:01:07.0: PCI INT A -> Link[APC2] -> GSI 17 (level, low) -> IRQ 17
[  188.443365] sil680: 133MHz clock.
[  188.446248] serial 00:09: activated
[  188.449927] parport_pc 00:0a: activated
[  188.450148] sd 0:0:0:0: [sda] Starting disk
[  188.520091] ata1.01: ACPI cmd ef/03:42:00:00:00:b0 filtered out
[  188.520098] ata1.01: ACPI cmd ef/03:0c:00:00:00:b0 filtered out
[  188.528089] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
[  188.528095] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
[  188.528323] ata1: nv_mode_filter: 0x3f01f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c00000) ACPI=0x3f01f (20:60:0x1f)
[  188.528334] ata1: nv_mode_filter: 0x701f&0x701f->0x701f, BIOS=0x7000 (0xc6c00000) ACPI=0x701f (20:60:0x1f)
[  188.544207] ata1.00: configured for UDMA/100
[  188.560060] ata1.01: configured for UDMA/33
[  188.575848] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors: (40.0 GB/37.2 GiB)
[  188.575855] sd 2:0:1:0: [sdb] Starting disk
[  188.575911] sd 0:0:0:0: [sda] Write Protect is off
[  188.575917] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  188.576001] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  188.576095] sd 0:0:0:0: [sda] 78165360 512-byte hardware sectors: (40.0 GB/37.2 GiB)
[  188.576144] sd 0:0:0:0: [sda] Write Protect is off
[  188.576149] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[  188.576228] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  188.644209] ata3.01: configured for UDMA/133
[  188.665287] sd 2:0:1:0: [sdb] 160086528 512-byte hardware sectors: (81.9 GB/76.3 GiB)
[  188.665341] sd 2:0:1:0: [sdb] Write Protect is off
[  188.665346] sd 2:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[  188.665428] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  188.665545] sd 3:0:1:0: [sdc] Starting disk
[  188.727319] ata4.01: configured for UDMA/100
[  188.752030] ata8: SATA link down (SStatus 0 SControl 300)
[  188.752050] ata6: SATA link down (SStatus 0 SControl 300)
[  188.752068] ata7: SATA link down (SStatus 0 SControl 300)
[  188.752086] ata5: SATA link down (SStatus 0 SControl 300)
[  188.775160] sd 3:0:1:0: [sdc] 156301488 512-byte hardware sectors: (80.0 GB/74.5 GiB)
[  188.775211] sd 3:0:1:0: [sdc] Write Protect is off
[  188.775216] sd 3:0:1:0: [sdc] Mode Sense: 00 3a 00 00
[  188.775297] sd 3:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  188.775650] usb usb1: usb resume
[  188.775657] ohci_hcd 0000:00:02.0: wakeup root hub
[  188.852023] hub 1-0:1.0: hub_reset_resume
[  188.852029] hub 1-0:1.0: trying to enable port power on non-switchable hub
[  188.956056] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00010300 CSC LSDA PPS
[  188.956065] hub 1-0:1.0: port 5: status 0300 change 0001
[  189.060036] usb usb2: usb resume
[  189.060042] ehci_hcd 0000:00:02.1: resume root hub after power loss
[  189.096022] ehci_hcd 0000:00:02.1: port 5 low speed --> companion
[  189.192030] ehci_hcd 0000:00:02.1: GetStatus port 5 status 003402 POWER OWNER sig=k CSC
[  189.208021] hub 2-0:1.0: hub_reset_resume
[  189.208026] hub 2-0:1.0: trying to enable port power on non-switchable hub
[  189.312107] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00010301 CSC LSDA PPS CCS
[  189.312120] usb 1-5: finish reset-resume
[  189.580034] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00100303 PRSC LSDA PPS PES CCS
[  189.636029] usb 1-5: reset low speed USB device using ohci_hcd and address 2
[  189.904036] ohci_hcd 0000:00:02.0: GetStatus roothub.portstatus [4] = 0x00100303 PRSC LSDA PPS PES CCS
[  189.998059] usb usb4: usb resume
[  189.998064] ehci_hcd 0000:00:04.1: resume root hub after power loss
[  190.027872] hub 4-0:1.0: hub_reset_resume
[  190.027877] hub 4-0:1.0: trying to enable port power on non-switchable hub
[  190.128036] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
[  190.128044] hub 4-0:1.0: port 2: status 0501 change 0001
[  191.044705] Restarting tasks ... <7>usb usb3: usb resume
[  191.047346] ohci_hcd 0000:00:04.0: wakeup root hub
[  191.050072] hub 1-0:1.0: state 7 ports 5 chg 0020 evt 0020
[  191.052648] hub 1-0:1.0: port 5, status 0303, change 0000, 1.5 Mb/s
[  191.055180] hub 2-0:1.0: state 7 ports 5 chg 0000 evt 0000
[  191.057699] hub 4-0:1.0: state 7 ports 5 chg 0004 evt 0000
[  191.060209] hub 4-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
[  191.062711] usb 4-2: usb wakeup-resume
[  191.065223] usb 4-2: finish reset-resume
[  191.081802] done.
[  191.124176] ehci_hcd 0000:00:04.1: port 2 high speed
[  191.126243] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[  191.128337] hub 3-0:1.0: hub_reset_resume
[  191.130515] hub 3-0:1.0: trying to enable port power on non-switchable hub
[  191.191944] usb 4-2: reset high speed USB device using ehci_hcd and address 2
[  191.236492] ohci_hcd 0000:00:04.0: GetStatus roothub.portstatus [1] = 0x00010100 CSC PPS
[  191.248170] ehci_hcd 0000:00:04.1: port 2 high speed
[  191.251940] ehci_hcd 0000:00:04.1: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
[  191.333722] hub 4-2:1.0: hub_reset_resume
[  191.338850] hub 4-2:1.0: enabling power on all ports
[  191.445107] usb 4-2: link qh256-0001/f612d100 start 255 [1/0 us]
[  191.450269] hub 3-0:1.0: state 7 ports 5 chg 0000 evt 0000
[  191.455397] hub 4-2:1.0: state 7 ports 4 chg 0000 evt 0000
[  192.352023] ohci_hcd 0000:00:04.0: auto-stop root hub
[  193.816040] hub 2-0:1.0: hub_suspend
[  193.821291] usb usb2: bus auto-suspend
[  193.826158] ehci_hcd 0000:00:02.1: suspend root hub
[  193.831061] hub 3-0:1.0: hub_suspend
[  193.836382] usb usb3: bus auto-suspend
[  193.841213] ohci_hcd 0000:00:04.0: suspend root hub
[  193.846355] hub 4-2:1.0: hub_suspend
[  193.851493] usb 4-2: unlink qh256-0001/f612d100 start 255 [1/0 us]
[  193.857118] usb 4-2: usb auto-suspend
[  196.816043] hub 4-0:1.0: hub_suspend
[  196.821307] usb usb4: bus auto-suspend
[  196.826213] ehci_hcd 0000:00:04.1: suspend root hub

At this point, mouse is frozen
Let's rmmod/insmod usbhib module:

[  300.013402] usbcore: deregistering interface driver usbhid
[  309.037589] usbhid 1-5:1.0: usb_probe_interface
[  309.042590] usbhid 1-5:1.0: usb_probe_interface - got id
[  309.053038] input: PS/2+USB Mouse as /class/input/input5
[  309.097719] generic-usb 0003:04F3:0210.0002: input: USB HID v1.11 Mouse [PS/2+USB Mouse] on usb-0000:00:02.0-5/input0
[  309.102419] usbcore: registered new interface driver usbhid
[  309.106799] usbhid: v2.6:USB HID core driver

Good, mouse is back now.

Fwiw, here is lsusb output:

Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 004 Device 002: ID 05e3:0606 Genesys Logic, Inc. USB 2.0 Hub / D-Link DUB-H4 USB 2.0 Hub
Bus 004 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 001 Device 002: ID 04f3:0210 Elan Microelectronics Corp. AM-400 Hama Optical Mouse
Bus 001 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub

laurent
