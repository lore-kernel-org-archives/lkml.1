Return-Path: <linux-kernel-owner+w=401wt.eu-S1755306AbYBIKeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbYBIKeb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 05:34:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYBIKeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 05:34:21 -0500
Received: from qmta01.emeryville.ca.mail.comcast.net ([76.96.30.16]:52389 "EHLO
	QMTA01.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750990AbYBIKeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 05:34:16 -0500
X-Authority-Analysis: v=1.0 c=1 a=p2x4BU3veD_Tb7pJ_wwA:9
 a=M-89pjFEp0FrGuHgsBQA:7 a=7WaKRMqqXXcMd2D3jB81BtEwuDcA:4 a=XF7b4UCPwd8A:10
Subject: Re: 2.6.24-git15 Keyboard Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiri Kosina <jkosina@suse.cz>, Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de>
References: <1202302978.9058.13.camel@popeye>
	 <Pine.LNX.4.64.0802061427410.30873@twin.jikos.cz>
	 <1202305740.9058.22.camel@popeye>
	 <Pine.LNX.4.64.0802061452210.30873@twin.jikos.cz>
	 <1202318666.6406.13.camel@popeye>
	 <Pine.LNX.4.64.0802071016220.30873@twin.jikos.cz>
	 <1202381094.6179.0.camel@popeye>
	 <Pine.LNX.4.64.0802071149260.30955@jikos.suse.cz>
	 <alpine.LFD.1.00.0802071324410.9204@apollo.tec.linutronix.de>
	 <1202396868.6087.8.camel@popeye>
	 <alpine.LFD.1.00.0802071629350.9204@apollo.tec.linutronix.de>
	 <1202402704.6087.12.camel@popeye>
	 <alpine.LFD.1.00.0802071838110.9204@apollo.tec.linutronix.de>
	 <1202448975.6538.2.camel@popeye>
	 <alpine.LFD.1.00.0802091053350.3145@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Sat, 09 Feb 2008 04:37:44 -0600
Message-Id: <1202553464.6386.7.camel@popeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas - 

Attached is the output I believe you requested (standard boot - ommiting
the NOHPET directive)

Unless you want to try something else i will run in this configuration
today to try and verify that the problem is still with us.

Thanks for th good wishes - it is going to be a while - I had an open
heart procedure about two weeks ago and they are not subtle  when they
split your chest open.

This is why I said that I would be more than happy to do the bisect
thing if it comes to that - since I can't go out and chase the ladies I
might as well do something useful.

However, as previously stated I would need a little instruction on how
to accoomplish this.

Chris

By the way - the big gap in timestamps in the dmesg output is because
several "routine" fsck operations were performed during this boot cycle.




[    0.000000] Linux version 2.6.24-git15-ch2 (root@popeye) (gcc version
4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)) #3 SMP PREEMPT Thu
Feb 7 22:00:10 CST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
[    0.000000]  BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00f5380] 000f5380
[    0.000000] Entering add_active_range(0, 0, 524272) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   524272
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   524272
[    0.000000] On node 0 totalpages: 524272
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2303 pages used for memmap
[    0.000000]   HighMem zone: 292593 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.3 present.
[    0.000000] ACPI: RSDP 000F9260, 0014 (r0 Nvidia)
[    0.000000] ACPI: RSDT 7FFF3040, 0030 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: DSDT 7FFF3180, 63C4 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
[    0.000000] ACPI: FACS 7FFF0000, 0040
[    0.000000] ACPI: MCFG 7FFF9680, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] ACPI: APIC 7FFF95C0, 0072 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
[    0.000000] Nvidia board detected. Ignoring ACPI timer override.
[    0.000000] If you got timer trouble try acpi_use_timer_override
[    0.000000] ACPI: PM-Timer IO Port: 0x4008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] Processor #0 15:11 APIC version 16
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] Processor #1 15:11 APIC version 16
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520177
[    0.000000] Kernel command line: root=UUID=4dc2e6b0-c980-418b-8ad0-98358e7ec47d ro quiet splash
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Detected 2412.382 MHz processor.
[    0.004000] spurious 8259A interrupt: IRQ7.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.004000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.004000] Memory: 2034196k/2097088k available (2071k kernel code, 61568k reserved, 952k data, 336k init, 1179584k highmem)
[    0.004000] virtual kernel memory layout:
[    0.004000]     fixmap  : 0xfff9b000 - 0xfffff000   ( 400 kB)
[    0.004000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.004000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.004000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.004000]       .init : 0xc03f9000 - 0xc044d000   ( 336 kB)
[    0.004000]       .data : 0xc0305f42 - 0xc03f3f60   ( 952 kB)
[    0.004000]       .text : 0xc0100000 - 0xc0305f42   (2071 kB)
[    0.004000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.004000] HPET not available
[    0.084006] Calibrating delay using timer specific routine.. 4827.74 BogoMIPS (lpj=9655497)
[    0.084047] Security Framework initialized
[    0.084054] SELinux:  Disabled at boot.
[    0.084069] Mount-cache hash table entries: 512
[    0.084197] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.084198] CPU: L2 Cache: 512K (64 bytes/line)
[    0.084200] CPU 0(2) -> Core 0
[    0.084206] Compat vDSO mapped to ffffe000.
[    0.084213] Checking 'hlt' instruction... OK.
[    0.100223] ACPI: Core revision 20070126
[    0.109782] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 01
[    0.109800] Booting processor 1/1 ip 4000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4825.07 BogoMIPS (lpj=9650141)
[    0.004000] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.004000] CPU: L2 Cache: 512K (64 bytes/line)
[    0.004000] CPU 1(2) -> Core 1
[    0.200189] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ stepping 01
[    0.200199] Total of 2 processors activated (9652.81 BogoMIPS).
[    0.200337] ENABLING IO-APIC IRQs
[    0.200528] ..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
[    0.248015] Brought up 2 CPUs
[    0.248015] CPU0 attaching sched-domain:
[    0.248015]  domain 0: span 3
[    0.248015]   groups: 1 2
[    0.248015] CPU1 attaching sched-domain:
[    0.248015]  domain 0: span 3
[    0.248015]   groups: 2 1
[    0.248015] net_namespace: 552 bytes
[    0.248015] NET: Registered protocol family 16
[    0.248015] EISA bus registered
[    0.248015] ACPI: bus type pci registered
[    0.248015] PCI: Using MMCONFIG
[    0.248015] PCI: No mmconfig possible on device 00:18
[    0.248015] Setting up standard PCI resources
[    0.249887] ACPI: EC: Look up EC in DSDT
[    0.256197] ACPI: Interpreter enabled
[    0.256198] ACPI: (supports S0 S1 S5)
[    0.256208] ACPI: Using IOAPIC for interrupt routing
[    0.263376] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.263729] PCI: Transparent bridge - 0000:00:09.0
[    0.264150] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.264371] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
[    0.316996] ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.317153] ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.317310] ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.317465] ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.317621] ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.317777] ACPI: PCI Interrupt Link [LUBA] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    0.317934] ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.318090] ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.318246] ACPI: PCI Interrupt Link [LACI] (IRQs *3 4 5 7 9 10 11 12 14 15)
[    0.318402] ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.318558] ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.318714] ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 *5 7 9 10 11 12 14 15)
[    0.318869] ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.319034] ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 *10 11 12 14 15)
[    0.319197] ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
[    0.319360] ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
[    0.319533] ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
[    0.319702] ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
[    0.319871] ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
[    0.320109] ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0, disabled.
[    0.320219] ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
[    0.320392] ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0
[    0.320566] ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
[    0.320740] ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
[    0.320913] ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
[    0.321085] ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0
[    0.321257] ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0
[    0.321430] ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0
[    0.321602] ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
[    0.321783] ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
[    0.321963] ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
[    0.322144] ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
[    0.322259] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.322275] pnp: PnP ACPI init
[    0.322281] ACPI: bus type pnp registered
[    0.326763] pnpacpi: exceeded the max number of mem resources: 12
[    0.326845] pnp: PnP ACPI: found 13 devices
[    0.326846] ACPI: ACPI bus type pnp unregistered
[    0.326849] PnPBIOS: Disabled by ACPI PNP
[    0.326945] PCI: Using ACPI for IRQ routing
[    0.326948] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.336022] NET: Registered protocol family 8
[    0.336022] NET: Registered protocol family 20
[    0.340026] system 00:01: ioport range 0x4000-0x407f has been reserved
[    0.340026] system 00:01: ioport range 0x4080-0x40ff has been reserved
[    0.340026] system 00:01: ioport range 0x4400-0x447f has been reserved
[    0.340026] system 00:01: ioport range 0x4480-0x44ff has been reserved
[    0.340026] system 00:01: ioport range 0x4800-0x487f has been reserved
[    0.340026] system 00:01: ioport range 0x4880-0x48ff has been reserved
[    0.340026] system 00:02: ioport range 0x4d0-0x4d1 has been reserved
[    0.340026] system 00:02: ioport range 0x290-0x29e has been reserved
[    0.340026] system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
[    0.340026] system 00:0c: iomem range 0xf0000-0xf3fff could not be reserved
[    0.340026] system 00:0c: iomem range 0xf4000-0xf7fff could not be reserved
[    0.340026] system 00:0c: iomem range 0xf8000-0xfbfff could not be reserved
[    0.340026] system 00:0c: iomem range 0xfc000-0xfffff could not be reserved
[    0.340026] system 00:0c: iomem range 0x7fff0000-0x7fffffff could not be reserved
[    0.340026] system 00:0c: iomem range 0xffff0000-0xffffffff could not be reserved
[    0.340026] system 00:0c: iomem range 0x0-0x9ffff could not be reserved
[    0.340026] system 00:0c: iomem range 0x100000-0x7ffeffff could not be reserved
[    0.340026] system 00:0c: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.340026] system 00:0c: iomem range 0xfee00000-0xfeefffff could not be reserved
[    0.340026] system 00:0c: iomem range 0xfefff000-0xfeffffff could not be reserved
[    0.340026] system 00:0c: iomem range 0xfff80000-0xfff80fff could not be reserved
[    0.366554] PCI: Bridge: 0000:00:09.0
[    0.366556]   IO window: a000-afff
[    0.366559]   MEM window: 0xfde00000-0xfdefffff
[    0.366561]   PREFETCH window: 0x00000000fdf00000-0x00000000fdffffff
[    0.366563] PCI: Bridge: 0000:00:0b.0
[    0.366565]   IO window: 9000-9fff
[    0.366567]   MEM window: 0xfdd00000-0xfddfffff
[    0.366569]   PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
[    0.366571] PCI: Bridge: 0000:00:0c.0
[    0.366573]   IO window: 8000-8fff
[    0.366575]   MEM window: 0xfdb00000-0xfdbfffff
[    0.366577]   PREFETCH window: 0x00000000fda00000-0x00000000fdafffff
[    0.366579] PCI: Bridge: 0000:00:0d.0
[    0.366581]   IO window: 7000-7fff
[    0.366583]   MEM window: 0xfd900000-0xfd9fffff
[    0.366585]   PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
[    0.366587] PCI: Bridge: 0000:00:0e.0
[    0.366589]   IO window: 6000-6fff
[    0.366591]   MEM window: 0xfa000000-0xfcffffff
[    0.366592]   PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
[    0.366599] PCI: Setting latency timer of device 0000:00:09.0 to 64
[    0.366606] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.366611] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.366616] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.366620] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.366653] NET: Registered protocol family 2
[    0.368027] Time: acpi_pm clocksource has been installed.
[    0.368040] Switched to high resolution mode on CPU 0
[    0.136022] Switched to high resolution mode on CPU 1
[    0.384058] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.384058] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.384058] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.384058] TCP: Hash tables configured (established 131072 bind 65536)
[    0.384058] TCP reno registered
[    0.392059] checking if image is initramfs... it is
[    3.069519] Freeing initrd memory: 40475k freed
[    2.850497] audit: initializing netlink socket (disabled)
[    2.850497] type=2000 audit(1202530678.068:1): initialized
[    2.850497] highmem bounce pool size: 64 pages
[    2.850497] VFS: Disk quotas dquot_6.5.1
[    2.850497] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    2.850497] io scheduler noop registered
[    2.850497] io scheduler anticipatory registered
[    2.850497] io scheduler deadline registered
[    2.850497] io scheduler cfq registered (default)
[    2.856227] pci 0000:00:0b.0: Linking AER extended capability
[    2.856231] pci 0000:00:0c.0: Linking AER extended capability
[    2.856234] pci 0000:00:0d.0: Linking AER extended capability
[    2.856237] pci 0000:00:0e.0: Linking AER extended capability
[    2.856243] pci 0000:05:00.0: Boot video device
[    2.856338] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    2.856352] assign_interrupt_mode Found MSI capability
[    2.856354] Allocate Port Service[0000:00:0b.0:pcie00]
[    2.856391] Allocate Port Service[0000:00:0b.0:pcie03]
[    2.856445] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    2.856458] assign_interrupt_mode Found MSI capability
[    2.856460] Allocate Port Service[0000:00:0c.0:pcie00]
[    2.856496] Allocate Port Service[0000:00:0c.0:pcie03]
[    2.856548] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    2.856560] assign_interrupt_mode Found MSI capability
[    2.856562] Allocate Port Service[0000:00:0d.0:pcie00]
[    2.856597] Allocate Port Service[0000:00:0d.0:pcie03]
[    2.856650] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    2.856662] assign_interrupt_mode Found MSI capability
[    2.856664] Allocate Port Service[0000:00:0e.0:pcie00]
[    2.856701] Allocate Port Service[0000:00:0e.0:pcie03]
[    2.856990] isapnp: Scanning for PnP cards...
[    3.207827] isapnp: No Plug & Play device found
[    3.232228] Real Time Clock Driver v1.12ac
[    3.232351] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    3.232462] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.232954] 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    3.233786] RAMDISK driver initialized: 16 RAM disks of 65536K size 1024 blocksize
[    3.233792] Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
[    3.233795] ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
[    3.234038] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    3.236963] serio: i8042 KBD port at 0x60,0x64 irq 1
[    3.236969] serio: i8042 AUX port at 0x60,0x64 irq 12
[    3.471677] mice: PS/2 mouse device common for all mice
[    3.471831] EISA: Probing bus 0 at eisa.0
[    3.471842] Cannot allocate resource for EISA slot 4
[    3.471846] Cannot allocate resource for EISA slot 6
[    3.471848] Cannot allocate resource for EISA slot 7
[    3.471849] Cannot allocate resource for EISA slot 8
[    3.471851] EISA: Detected 0 cards.
[    3.472227] TCP cubic registered
[    3.472239] NET: Registered protocol family 1
[    3.472266] Starting balanced_irq
[    3.472303] Using IPI No-Shortcut mode
[    3.472807] Freeing unused kernel memory: 336k freed
[    3.262972] input: AT Translated Set 2 keyboard as /class/input/input0
[    4.417268] fuse init (API version 7.9)
[    4.687665] ACPI: Fan [FAN] (on)
[    4.428053] ACPI: Thermal Zone [THRM] (22 C)
[    5.091228] usbcore: registered new interface driver usbfs
[    5.091257] usbcore: registered new interface driver hub
[    5.113830] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[    5.114158] ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
[    5.114166] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [APCH] -> GSI 23 (level, low) -> IRQ 23
[    5.114171] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    5.151814] usbcore: registered new device driver usb
[    5.172076] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    5.647091] forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 1, addr 00:19:db:6d:3f:1b
[    5.647091] forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
[    5.651521] NFORCE-CK804: 0000:00:06.0 (rev f3) UDMA133 controller
[    5.651525] NFORCE-CK804: IDE controller (0x10de:0x0053 rev 0xf3) at  PCI slot 0000:00:06.0
[    5.651546] NFORCE-CK804: not 100% native mode: will probe irqs later
[    5.651550] NFORCE-CK804: BIOS didn't set cable bits correctly. Enabling workaround.
[    5.651557]     ide0: BM-DMA at 0xe000-0xe007, BIOS settings: hda:DMA, hdb:DMA
[    5.651564]     ide1: BM-DMA at 0xe008-0xe00f, BIOS settings: hdc:DMA, hdd:DMA
[    5.651575] Probing IDE interface ide0...
[    5.401102] SCSI subsystem initialized
[    5.408093] libata version 3.00 loaded.
[    5.947946] hdb: Maxtor 6L250R0, ATA DISK drive
[    6.292902] hda: WDC WD2500JB-55REA0, ATA DISK drive
[    6.292902] hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.292902] hda: UDMA/100 mode selected
[    6.292902] hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.292902] hdb: UDMA/133 mode selected
[    6.292902] Probing IDE interface ide1...
[    6.589402] hdd: Maxtor 6Y120P0, ATA DISK drive
[    6.936725] hdc: WDC WD2000BB-22GUC0, ATA DISK drive
[    6.936725] hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.936725] hdc: UDMA/100 mode selected
[    6.936725] hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
[    6.936725] hdd: UDMA/133 mode selected
[    6.936725] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    6.977117] ide1 at 0x170-0x177,0x376 on irq 15
[    6.753336] ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
[    6.753336] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [APCF] -> GSI 22 (level, low) -> IRQ 22
[    6.753336] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    6.753336] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    6.753336] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
[    6.753336] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfe02f000
[    6.814274] usb usb1: configuration #1 chosen from 1 choice
[    6.814274] hub 1-0:1.0: USB hub found
[    6.814274] hub 1-0:1.0: 10 ports detected
[    6.921411] ACPI: PCI Interrupt Link [APCL] enabled at IRQ 21
[    6.921411] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [APCL] -> GSI 21 (level, low) -> IRQ 21
[    6.921411] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    6.921411] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    6.921411] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
[    6.921411] ehci_hcd 0000:00:02.1: debug port 1
[    6.921411] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    6.921411] ehci_hcd 0000:00:02.1: irq 21, io mem 0xfe02e000
[    6.931202] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    6.931312] usb usb2: configuration #1 chosen from 1 choice
[    6.931330] hub 2-0:1.0: USB hub found
[    6.931339] hub 2-0:1.0: 10 ports detected
[    7.043362] sata_nv 0000:00:07.0: version 3.5
[    7.043764] ACPI: PCI Interrupt Link [APSI] enabled at IRQ 20
[    7.043772] ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [APSI] -> GSI 20 (level, low) -> IRQ 20
[    7.043776] sata_nv 0000:00:07.0: Using ADMA mode
[    7.043821] PCI: Setting latency timer of device 0000:00:07.0 to 64
[    7.047950] scsi0 : sata_nv
[    7.295406] hda: max request size: 512KiB
[    7.050157] scsi1 : sata_nv
[    7.050345] ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xcc00 irq 20
[    7.050347] ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xcc08 irq 20
[    7.300924] hda: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63
[    7.300999] hda: cache flushes supported
[    7.301050]  hda: hda1
[    7.313419] hdb: max request size: 512KiB
[    7.314751] hdb: 490234752 sectors (251000 MB) w/16384KiB Cache, CHS=30515/255/63
[    7.317069] hdb: cache flushes supported
[    7.317101]  hdb: hdb1
[    7.319268] hdc: max request size: 512KiB
[    7.320362] hdc: 390721968 sectors (200049 MB) w/2048KiB Cache, CHS=24321/255/63
[    7.323026] hdc: cache flushes supported
[    7.323041]  hdc: hdc1 hdc2
[    7.371028] hdd: max request size: 128KiB
[    7.371028] hdd: 240121728 sectors (122942 MB) w/7936KiB Cache, CHS=65535/16/63
[    7.371028] hdd: cache flushes supported
[    7.371028]  hdd: hdd1
[    7.393750] kjournald starting.  Commit interval 5 seconds
[    7.659088] EXT3-fs: mounted filesystem with ordered data mode.
[    7.571281] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    7.580189] ata1.00: ATA-7: Maxtor 7L250S0, BACE1G20, max UDMA/133
[    7.580189] ata1.00: 490234752 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.879448] ata1.00: configured for UDMA/133
[    8.068995] usb 2-7: new high speed USB device using ehci_hcd and address 3
[    8.309918] usb 2-7: configuration #1 chosen from 1 choice
[    8.452153] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.505964] ata2.00: ATA-7: ST3750640NS, 3.AEG, max UDMA/133
[    8.505967] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    8.581196] ata2.00: configured for UDMA/133
[    8.210002] scsi 0:0:0:0: Direct-Access     ATA      Maxtor 7L250S0   BACE PQ: 0 ANSI: 5
[    8.210002] ata1: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    8.210002] scsi 1:0:0:0: Direct-Access     ATA      ST3750640NS      3.AE PQ: 0 ANSI: 5
[    8.210002] ata2: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[    8.210002] ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 23
[    8.210002] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [APSJ] -> GSI 23 (level, low) -> IRQ 23
[    8.210002] sata_nv 0000:00:08.0: Using ADMA mode
[    8.210002] PCI: Setting latency timer of device 0000:00:08.0 to 64
[    8.210023] scsi2 : sata_nv
[    8.210034] scsi3 : sata_nv
[    8.210148] ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xb800 irq 23
[    8.210150] ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xb808 irq 23
[    8.653698] usb 1-3: new full speed USB device using ohci_hcd and address 2
[    8.914784] usb 1-3: configuration #1 chosen from 1 choice
[    8.547093] ata3: SATA link down (SStatus 0 SControl 300)
[    9.041458] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    9.093418] ata4.00: ATA-7: ST3320620AS, 3.AAE, max UDMA/133
[    9.093418] ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.661502] ata4.00: configured for UDMA/133
[    9.163074] scsi 3:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
[    9.163074] ata4: bounce limit 0xFFFFFFFFFFFFFFFF, segment boundary 0xFFFFFFFF, hw segs 61
[   13.810920] input: Power Button (FF) as /class/input/input1
[   13.855154] ACPI: Power Button (FF) [PWRF]
[   13.855216] input: Power Button (CM) as /class/input/input2
[   13.915125] ACPI: Power Button (CM) [PWRB]
[   15.229172] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
[   15.229191] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
[   15.623143] NET: Registered protocol family 10
[   15.623524] lo: Disabled Privacy Extensions
[   15.879878] input: PC Speaker as /class/input/input3
[   15.900353] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[   15.926744] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   16.612198] Driver 'sd' needs updating - please use bus_type methods
[   16.612313] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
[   16.612332] sd 0:0:0:0: [sda] Write Protect is off
[   16.612334] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.612363] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   16.612431] sd 0:0:0:0: [sda] 490234752 512-byte hardware sectors (251000 MB)
[   16.612445] sd 0:0:0:0: [sda] Write Protect is off
[   16.612447] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   16.612471] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[   16.612475]  sda: sda1
[   16.633367] sd 0:0:0:0: [sda] Attached SCSI disk
[   16.633431] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   16.633444] sd 1:0:0:0: [sdb] Write Protect is off
[   16.633446] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   16.633465] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.633510] sd 1:0:0:0: [sdb] 1465149168 512-byte hardware sectors (750156 MB)
[   16.633520] sd 1:0:0:0: [sdb] Write Protect is off
[   16.633522] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[   16.633540] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.633542]  sdb:<6>usbcore: registered new interface driver libusual
[   16.654849]  sdb1 sdb2
[   16.654939] sd 1:0:0:0: [sdb] Attached SCSI disk
[   16.655114] sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[   16.655134] sd 3:0:0:0: [sdc] Write Protect is off
[   16.655136] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   16.655168] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.655229] sd 3:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
[   16.655248] sd 3:0:0:0: [sdc] Write Protect is off
[   16.655250] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[   16.655281] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   16.655283]  sdc: sdc1
[   16.681568] sd 3:0:0:0: [sdc] Attached SCSI disk
[   16.779430] Initializing USB Mass Storage driver...
[   16.784045] scsi4 : SCSI emulation for USB Mass Storage devices
[   16.784221] usb-storage: device found at 3
[   16.784222] usb-storage: waiting for device to settle before scanning
[   16.784271] scsi5 : SCSI emulation for USB Mass Storage devices
[   16.784368] usbcore: registered new interface driver usb-storage
[   16.784370] USB Mass Storage support registered.
[   16.784388] usb-storage: device found at 2
[   16.784389] usb-storage: waiting for device to settle before scanning
[   16.818077] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   16.818100] sd 1:0:0:0: Attached scsi generic sg1 type 0
[   16.818118] sd 3:0:0:0: Attached scsi generic sg2 type 0
[   16.925921] input: ImPS/2 Generic Wheel Mouse as /class/input/input4
[   16.962325] parport_pc 00:08: reported by Plug and Play ACPI
[   16.962338] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[   17.117006] ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
[   17.117011] ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [APCJ] -> GSI 22 (level, low) -> IRQ 22
[   17.117033] PCI: Setting latency timer of device 0000:00:04.0 to 64
[   17.498435] intel8x0_measure_ac97_clock: measured 54724 usecs
[   17.498435] intel8x0: clocking to 46906
[   17.744708] lp0: using parport0 (interrupt-driven).
[   17.828840] Adding 10241428k swap on /dev/hdc2.  Priority:-1 extents:1 across:10241428k
[   18.178849] EXT3 FS on hda1, internal journal
[   22.416116] usb-storage: device scan complete
[   22.418112] scsi 4:0:0:0: CD-ROM            MAD DOG  MD-16XDVD9       2.FD PQ: 0 ANSI: 0
[   22.418429] scsi 4:0:0:0: Attached scsi generic sg3 type 5
[   22.419350] usb-storage: device scan complete
[   20.715144] scsi 5:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[   20.722136] scsi 5:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[   20.730719] scsi 5:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[   20.740507] scsi 5:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[   20.749834] sd 5:0:0:0: [sdd] Attached SCSI removable disk
[   20.749872] sd 5:0:0:0: Attached scsi generic sg4 type 0
[   20.760475] sd 5:0:0:1: [sde] Attached SCSI removable disk
[   20.760512] sd 5:0:0:1: Attached scsi generic sg5 type 0
[   20.771477] sd 5:0:0:2: [sdf] Attached SCSI removable disk
[   20.771517] sd 5:0:0:2: Attached scsi generic sg6 type 0
[   20.782456] sd 5:0:0:3: [sdg] Attached SCSI removable disk
[   20.782487] sd 5:0:0:3: Attached scsi generic sg7 type 0
[   22.575143] Driver 'sr' needs updating - please use bus_type methods
[   22.603314] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   22.603319] Uniform CD-ROM driver Revision: 3.20
[   22.603390] sr 4:0:0:0: Attached scsi CD-ROM sr0
[   27.297276] eth1: no IPv6 routers present
[  501.352293] kjournald starting.  Commit interval 5 seconds
[  501.361158] EXT3 FS on hdb1, internal journal
[  501.361158] EXT3-fs: mounted filesystem with ordered data mode.
[  501.424539] kjournald starting.  Commit interval 5 seconds
[  501.430189] EXT3 FS on hdc1, internal journal
[  501.430192] EXT3-fs: mounted filesystem with ordered data mode.
[  501.454377] kjournald starting.  Commit interval 5 seconds
[  501.464902] EXT3 FS on hdd1, internal journal
[  501.464902] EXT3-fs: mounted filesystem with ordered data mode.
[  501.481409] kjournald starting.  Commit interval 5 seconds
[  494.053258] EXT3 FS on sda1, internal journal
[  494.053258] EXT3-fs: mounted filesystem with ordered data mode.
[  501.536644] kjournald starting.  Commit interval 5 seconds
[  494.095922] EXT3 FS on sdb1, internal journal
[  494.095922] EXT3-fs: mounted filesystem with ordered data mode.
[  501.585943] kjournald starting.  Commit interval 5 seconds
[  494.142663] EXT3 FS on sdb2, internal journal
[  494.142663] EXT3-fs: mounted filesystem with ordered data mode.
[  501.636607] kjournald starting.  Commit interval 5 seconds
[  501.646948] EXT3 FS on sdc1, internal journal
[  501.646948] EXT3-fs: mounted filesystem with ordered data mode.
[  503.240222] No dock devices found.
[  503.269482] toshiba_acpi: Unknown parameter `hotkeys_over_acpi'
[  495.995849] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4600+ processors (2 cpu cores) (version 2.20.00)
[  503.681952] powernow-k8: MP systems not supported by PSB BIOS structure
[  495.995863] powernow-k8: MP systems not supported by PSB BIOS structure
[  499.375089] ppdev: user-space parallel port driver
[  501.143613] apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
[  501.143620] apm: disabled - APM is not SMP safe.
[  527.097926] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[  527.097934] vboxdrv: Successfully done.
[  515.705964] vboxdrv: Successfully loaded version 1.5.4 (interface 0x00050002).
[  527.784486] warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)

