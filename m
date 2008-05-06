Return-Path: <linux-kernel-owner+w=401wt.eu-S1756396AbYEFSRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756396AbYEFSRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 14:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751521AbYEFSRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 14:17:12 -0400
Received: from www17.your-server.de ([213.133.104.17]:40145 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYEFSRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 14:17:04 -0400
Subject: BUG: unable to handle kernel paging request at xxx
From: Thomas Meyer <thomas@m3y3r.de>
To: travis@sgi.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 May 2008 20:15:35 +0200
Message-Id: <1210097735.3644.6.camel@dhcppc1>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 8BIT
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Linux version 2.6.26-rc1-next-20080506 (thomas@dhcppc1) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-33)) #23 SMP Tue May 6 19:04:11 CEST 2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ffd0000 (usable)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 000000007ffde000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ffde000 - 0000000080000000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] After WB checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 0000000000080000
[    0.000000] After UC checking
[    0.000000] MTRR MAP PFN: 0000000000000000 - 0000000000080000
[    0.000000] After sorting
[    0.000000] MTRR MAP PFN: 0000000000000000 - 0000000000080000
[    0.000000] 1151MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] found SMP MP-table at [c00ff780] 000ff780
[    0.000000] Entering add_active_range(0, 0, 524240) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   524240
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   524240
[    0.000000] On node 0 totalpages: 524240
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 2303 pages used for memmap
[    0.000000]   HighMem zone: 292561 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000F92B0, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT 7FFD0000, 003C (r1 MSIISM OEMRSDT  10000704 MSFT       97)
[    0.000000] ACPI: FACP 7FFD0200, 0084 (r2 MSIISM OEMFACP  10000704 MSFT       97)
[    0.000000] ACPI: DSDT 7FFD0440, 5045 (r1  1ADGH 1ADGH013       13 INTL 20051117)
[    0.000000] ACPI: FACS 7FFDE000, 0040
[    0.000000] ACPI: APIC 7FFD0390, 0070 (r1 MSIISM OEMAPIC  10000704 MSFT       97)
[    0.000000] ACPI: MCFG 7FFD0400, 003C (r1 MSIISM OEMMCFG  10000704 MSFT       97)
[    0.000000] ACPI: OEMB 7FFDE040, 0061 (r1 MSIISM AMI_OEM  10000704 MSFT       97)
[    0.000000] ACPI: HPET 7FFD5490, 0038 (r1 MSIISM OEMHPET0 10000704 MSFT       97)
[    0.000000] ACPI: SSDT 7FFD54D0, 028A (r1 A M I  POWERNOW        1 AMD         1)
[    0.000000] Detected use of extended apic ids on hypertransport bus
[    0.000000] ACPI: PM-Timer IO Port: 0x2008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to 0x10. (tell your hw vendor)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 00, APIC ID 2, APIC INT 02
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] Int: type 0, pol 1, trig 3, bus 00, IRQ 09, APIC ID 2, APIC INT 09
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0e, APIC ID 2, APIC INT 0e
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
[    0.000000] Int: type 0, pol 1, trig 1, bus 00, IRQ 0f, APIC ID 2, APIC INT 0f
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 01, APIC ID 2, APIC INT 01
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 03, APIC ID 2, APIC INT 03
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 04, APIC ID 2, APIC INT 04
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 05, APIC ID 2, APIC INT 05
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 06, APIC ID 2, APIC INT 06
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 07, APIC ID 2, APIC INT 07
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 08, APIC ID 2, APIC INT 08
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0a, APIC ID 2, APIC INT 0a
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0b, APIC ID 2, APIC INT 0b
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0c, APIC ID 2, APIC INT 0c
[    0.000000] Int: type 0, pol 0, trig 0, bus 00, IRQ 0d, APIC ID 2, APIC INT 0d
[    0.000000] ACPI: IRQ14 used by override.
[    0.000000] ACPI: IRQ15 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x10de8201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 80000000:50000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 32552 bytes of per cpu data
[    0.000000] NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
[    0.693310] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520145
[    0.693310] Kernel command line: ro root=LABEL=ROOT rhgb
[    0.693310] mapped APIC to ffffb000 (fee00000)
[    0.693310] mapped IOAPIC to ffffa000 (fec00000)
[    0.693310] Enabling fast FPU save and restore... done.
[    0.693310] Enabling unmasked SIMD FPU exception support... done.
[    0.693310] Initializing CPU#0
[    0.693310] CPU 0 irqstacks, hard=c07b7000 soft=c0797000
[    0.693310] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.693310] Detected 2600.026 MHz processor.
[    0.693310] spurious 8259A interrupt: IRQ7.
[    0.693310] Console: colour VGA+ 80x25
[    0.693310] console [tty0] enabled
[    0.693310] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.693310] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.693310] Memory: 2070832k/2096960k available (2199k kernel code, 24884k reserved, 1162k data, 280k init, 1179456k highmem)
[    0.693310] virtual kernel memory layout:
[    0.693310]     fixmap  : 0xffe17000 - 0xfffff000   (1952 kB)
[    0.693310]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.693310]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.693310]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.693310]       .init : 0xc074e000 - 0xc0794000   ( 280 kB)
[    0.693310]       .data : 0xc0625ea1 - 0xc07486e0   (1162 kB)
[    0.693310]       .text : 0xc0400000 - 0xc0625ea1   (2199 kB)
[    0.693310] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.693310] CPA: page pool initialized 1 of 1 pages preallocated
[    0.693310] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
[    0.693310] hpet clockevent registered
[    0.753178] Calibrating delay using timer specific routine.. 5203.04 BogoMIPS (lpj=2601524)
[    0.753301] Security Framework initialized
[    0.753301] SELinux:  Initializing.
[    0.753301] SELinux:  Starting in permissive mode
[    0.753301] selinux_register_security:  Registering secondary module capability
[    0.753301] Capability LSM initialized as secondary
[    0.753301] Mount-cache hash table entries: 512
[    0.753301] Initializing cgroup subsys ns
[    0.753301] Initializing cgroup subsys cpuacct
[    0.753301] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.753368] CPU: L2 Cache: 512K (64 bytes/line)
[    0.753425] CPU 0(2) -> Core 0
[    0.753481] Intel machine check architecture supported.
[    0.753539] Intel machine check reporting enabled on CPU#0.
[    0.753603] Checking 'hlt' instruction... OK.
[    0.758276] ACPI: Core revision 20080321
[    0.764518] ENABLING IO-APIC IRQs
[    0.764779] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.774825] CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.775298] CPU 1 irqstacks, hard=c07b8000 soft=c0798000
[    0.775298] Booting processor 1/1 ip 6000
[    0.775298] Initializing CPU#1
[    0.775298] Calibrating delay using timer specific routine.. 5199.66 BogoMIPS (lpj=2599831)
[    0.775298] CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
[    0.775298] CPU: L2 Cache: 512K (64 bytes/line)
[    0.775298] CPU 1(2) -> Core 1
[    0.775298] Intel machine check architecture supported.
[    0.775298] Intel machine check reporting enabled on CPU#1.
[    0.775298] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.846287] CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ stepping 02
[    0.846874] Brought up 2 CPUs
[    0.846930] Total of 2 processors activated (10402.71 BogoMIPS).
[    0.847026] CPU0 attaching sched-domain:
[    0.847029]  domain 0: span 0-1
[    0.847030]   groups: 0 1
[    0.847033] CPU1 attaching sched-domain:
[    0.847035]  domain 0: span 0-1
[    0.847037]   groups: 1 0
[    0.847287] net_namespace: 660 bytes
[    0.847287] Booting paravirtualized kernel on bare hardware
[    0.847287] NET: Registered protocol family 16
[    0.847287] No dock devices found.
[    0.848287] ACPI: bus type pci registered
[    0.848287] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.848287] PCI: Not using MMCONFIG.
[    0.848287] PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=7
[    0.848287] PCI: Using configuration type 1 for base access
[    0.848348] Setting up standard PCI resources
[    0.853770] ACPI: EC: Look up EC in DSDT
[    0.861792] ACPI: Interpreter enabled
[    0.861850] ACPI: (supports S0 S1 S3 S4 S5)
[    0.862013] ACPI: Using IOAPIC for interrupt routing
[    0.862108] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.866587] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.866646] PCI: Using MMCONFIG for extended config space
[    0.874283] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.874820] PCI: Transparent bridge - 0000:00:06.0
[    0.875113] bus 00 -> node 0
[    0.875118] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.875387] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.875539] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR10._PRT]
[    0.875618] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
[    0.875696] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
[    0.875775] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR13._PRT]
[    0.875853] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR14._PRT]
[    0.875931] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR15._PRT]
[    0.884281] ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
[    0.884665] ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
[    0.885043] ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
[    0.885281] ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
[    0.885661] ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
[    0.886040] ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *10
[    0.886399] ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
[    0.886777] ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *0, disabled.
[    0.887156] ACPI: PCI Interrupt Link [LUB0] (IRQs 21 22 23) *7
[    0.887496] ACPI: PCI Interrupt Link [LMAD] (IRQs 20) *5
[    0.887795] ACPI: PCI Interrupt Link [LUB2] (IRQs 21 22 23) *10
[    0.888133] ACPI: PCI Interrupt Link [LMAC] (IRQs 20) *11
[    0.888434] ACPI: PCI Interrupt Link [LAZA] (IRQs 21 22 23) *10
[    0.889462] ACPI: PCI Interrupt Link [LSMB] (IRQs 21 22 23) *11
[    0.889801] ACPI: PCI Interrupt Link [LPMU] (IRQs 21 22 23) *5
[    0.890139] ACPI: PCI Interrupt Link [LSA0] (IRQs 21 22 23) *11
[    0.890479] ACPI: PCI Interrupt Link [LSA1] (IRQs 21 22 23) *5
[    0.890848] ACPI: PCI Interrupt Link [LATA] (IRQs 21 22 23) *0, disabled.
[    0.891206] ACPI: PCI Interrupt Link [LSA2] (IRQs 21 22 23) *10
[    0.892280] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.892280] pnp: PnP ACPI init
[    0.892280] ACPI: bus type pnp registered
[    0.896212] pnp: PnP ACPI: found 14 devices
[    0.896269] ACPI: ACPI bus type pnp unregistered
[    0.896279] usbcore: registered new interface driver usbfs
[    0.896279] usbcore: registered new interface driver hub
[    0.896279] usbcore: registered new device driver usb
[    0.896279] PCI: Using ACPI for IRQ routing
[    0.898190] NetLabel: Initializing
[    0.898246] NetLabel:  domain hash size = 128
[    0.898279] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.898279] NetLabel:  unlabeled traffic allowed by default
[    0.898279] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
[    0.898279] hpet0: 3 32-bit timers, 25000000 Hz
[    0.899279] tracer: 643 pages allocated for 65536<6> entries of 40 bytes
[    0.899279]    actual entries 65586
[    0.899449] Switched to high resolution mode on CPU 0
[    0.899449] Switched to high resolution mode on CPU 1
[    0.903482] system 00:05: ioport range 0x4d0-0x4d1 has been reserved
[    0.903542] system 00:05: ioport range 0x800-0x80f has been reserved
[    0.903603] system 00:05: ioport range 0x2000-0x207f has been reserved
[    0.903662] system 00:05: ioport range 0x2080-0x20ff has been reserved
[    0.903726] system 00:05: ioport range 0x2400-0x247f has been reserved
[    0.903785] system 00:05: ioport range 0x2480-0x24ff has been reserved
[    0.903844] system 00:05: ioport range 0x2800-0x287f has been reserved
[    0.903902] system 00:05: ioport range 0x2880-0x28ff has been reserved
[    0.903961] system 00:05: ioport range 0x2c00-0x2c7f has been reserved
[    0.904020] system 00:05: ioport range 0x2c80-0x2cff has been reserved
[    0.904080] system 00:05: iomem range 0xfbf80000-0xfbfbffff has been reserved
[    0.904139] system 00:05: iomem range 0xfee01000-0xfeefffff could not be reserved
[    0.904236] system 00:07: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.904316] system 00:07: iomem range 0xfee00000-0xfee00fff could not be reserved
[    0.904316] system 00:0a: ioport range 0xa00-0xa0f has been reserved
[    0.904381] system 00:0a: ioport range 0xa10-0xa1f has been reserved
[    0.904444] system 00:0b: iomem range 0xe0000000-0xefffffff has been reserved
[    0.904506] system 00:0c: iomem range 0xd0000000-0xdfffffff could not be reserved
[    0.904601] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.904665] system 00:0d: iomem range 0xc0000-0xcffff could not be reserved
[    0.904724] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.904783] system 00:0d: iomem range 0x100000-0x7fffffff could not be reserved
[    0.904875] system 00:0d: iomem range 0xfec00000-0xffffffff could not be reserved
[    0.935444] PCI: Bridge: 0000:00:06.0
[    0.935500]   IO window: disabled.
[    0.935557]   MEM window: disabled.
[    0.936314]   PREFETCH window: disabled.
[    0.936314] PCI: Bridge: 0000:00:0a.0
[    0.936314]   IO window: disabled.
[    0.936314]   MEM window: disabled.
[    0.936314]   PREFETCH window: disabled.
[    0.936314] PCI: Bridge: 0000:00:0b.0
[    0.936314]   IO window: disabled.
[    0.936314]   MEM window: disabled.
[    0.936314]   PREFETCH window: disabled.
[    0.936314] PCI: Bridge: 0000:00:0c.0
[    0.936314]   IO window: disabled.
[    0.936314]   MEM window: disabled.
[    0.936314]   PREFETCH window: disabled.
[    0.936351] PCI: Bridge: 0000:00:0d.0
[    0.936406]   IO window: disabled.
[    0.936462]   MEM window: disabled.
[    0.936518]   PREFETCH window: disabled.
[    0.937348] PCI: Bridge: 0000:00:0e.0
[    0.937348]   IO window: disabled.
[    0.937348]   MEM window: disabled.
[    0.937348]   PREFETCH window: disabled.
[    0.937348] PCI: Bridge: 0000:00:0f.0
[    0.937348]   IO window: e000-efff
[    0.937348]   MEM window: 0xfc000000-0xfebfffff
[    0.937348]   PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
[    0.937348] PCI: Setting latency timer of device 0000:00:06.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    0.937348] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    0.937348] NET: Registered protocol family 2
[    0.940384] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.941315] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.941315] TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
[    0.942353] TCP: Hash tables configured (established 131072 bind 65536)
[    0.942353] TCP reno registered
[    0.943417] NET: Registered protocol family 1
[    0.943572] checking if image is initramfs... it is
[    1.120318] Freeing initrd memory: 2990k freed
[    1.120670] audit: initializing netlink socket (disabled)
[    1.120744] type=2000 audit(1210102074.428:1): initialized
[    1.125318] highmem bounce pool size: 64 pages
[    1.125318] Total HugeTLB memory allocated, 0
[    1.127317] VFS: Disk quotas dquot_6.5.1
[    1.127317] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    1.127348] msgmni has been set to 1748 for ipc namespace c0721360
[    1.127348] SELinux:  Registering netfilter hooks
[    1.128317] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    1.128317] io scheduler noop registered
[    1.128317] io scheduler anticipatory registered
[    1.128317] io scheduler deadline registered
[    1.128317] io scheduler cfq registered (default)
[    1.128317] pci 0000:00:00.0: Enabling HT MSI Mapping
[    1.138808] pci 0000:00:05.0: Enabling HT MSI Mapping
[    1.138875] pci 0000:00:05.1: Enabling HT MSI Mapping
[    1.138941] pci 0000:00:05.2: Enabling HT MSI Mapping
[    1.139007] pci 0000:00:06.0: Enabling HT MSI Mapping
[    1.139074] pci 0000:00:06.1: Enabling HT MSI Mapping
[    1.139143] pci 0000:00:08.0: Enabling HT MSI Mapping
[    1.139211] pci 0000:00:09.0: Enabling HT MSI Mapping
[    1.139277] pci 0000:00:0a.0: Enabling HT MSI Mapping
[    1.139344] pci 0000:00:0b.0: Enabling HT MSI Mapping
[    1.139355] pci 0000:00:0c.0: Enabling HT MSI Mapping
[    1.139427] pci 0000:00:0d.0: Enabling HT MSI Mapping
[    1.139427] pci 0000:00:0e.0: Enabling HT MSI Mapping
[    1.139427] pci 0000:00:0f.0: Enabling HT MSI Mapping
[    1.139427] pci 0000:07:00.0: Boot video device
[    1.139963] PCI: Setting latency timer of device 0000:00:0a.0 to 64
[    1.139981] assign_interrupt_mode Found MSI capability
[    1.140052] Allocate Port Service[0000:00:0a.0:pcie00]
[    1.140318] Allocate Port Service[0000:00:0a.0:pcie03]
[    1.140318] PCI: Setting latency timer of device 0000:00:0b.0 to 64
[    1.140318] assign_interrupt_mode Found MSI capability
[    1.140318] Allocate Port Service[0000:00:0b.0:pcie00]
[    1.140318] Allocate Port Service[0000:00:0b.0:pcie03]
[    1.140318] PCI: Setting latency timer of device 0000:00:0c.0 to 64
[    1.140318] assign_interrupt_mode Found MSI capability
[    1.140318] Allocate Port Service[0000:00:0c.0:pcie00]
[    1.140318] Allocate Port Service[0000:00:0c.0:pcie03]
[    1.140318] PCI: Setting latency timer of device 0000:00:0d.0 to 64
[    1.140318] assign_interrupt_mode Found MSI capability
[    1.140318] Allocate Port Service[0000:00:0d.0:pcie00]
[    1.140318] Allocate Port Service[0000:00:0d.0:pcie03]
[    1.140348] PCI: Setting latency timer of device 0000:00:0e.0 to 64
[    1.140348] assign_interrupt_mode Found MSI capability
[    1.140348] Allocate Port Service[0000:00:0e.0:pcie00]
[    1.140348] Allocate Port Service[0000:00:0e.0:pcie03]
[    1.140348] PCI: Setting latency timer of device 0000:00:0f.0 to 64
[    1.140348] assign_interrupt_mode Found MSI capability
[    1.140362] Allocate Port Service[0000:00:0f.0:pcie00]
[    1.140903] Allocate Port Service[0000:00:0f.0:pcie03]
[    1.141323] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.141323] ACPI: ACPI0007:00 is registered as cooling_device0
[    1.141323] ACPI: ACPI0007:01 is registered as cooling_device1
[    1.144863] isapnp: Scanning for PnP cards...
[    1.499680] isapnp: No Plug & Play device found
[    1.502319] Real Time Clock Driver v1.12ac
[    1.502327] hpet_resources: 0xfed00000 is busy
[    1.502327] Non-volatile memory driver v1.2
[    1.502331] Linux agpgart interface v0.103
[    1.502695] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
[    1.504324] brd: module loaded
[    1.504406] input: Macintosh mouse button emulation as /class/input/input0
[    1.504635] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[    1.507534] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.507534] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.509070] mice: PS/2 mouse device common for all mice
[    1.551786] cpuidle: using governor ladder
[    1.551786] cpuidle: using governor menu
[    1.551786] usbcore: registered new interface driver hiddev
[    1.551786] usbcore: registered new interface driver usbhid
[    1.551786] usbhid: v2.6:USB HID core driver
[    1.552694] TCP cubic registered
[    1.552750] Initializing XFRM netlink socket
[    1.552813] NET: Registered protocol family 17
[    1.553317] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 5000+ processors (2 cpu cores) (version 2.20.00)
[    1.553317] powernow-k8:    0 : fid 0x12 (2600 MHz), vid 0x8
[    1.553383] powernow-k8:    1 : fid 0x10 (2400 MHz), vid 0xa
[    1.553441] powernow-k8:    2 : fid 0xe (2200 MHz), vid 0xc
[    1.553498] powernow-k8:    3 : fid 0xc (2000 MHz), vid 0xe
[    1.553556] powernow-k8:    4 : fid 0xa (1800 MHz), vid 0x10
[    1.553618] powernow-k8:    5 : fid 0x2 (1000 MHz), vid 0x12
[    1.554186] Using IPI No-Shortcut mode
[    1.554337] registered taskstats version 1
[    1.554337] Freeing unused kernel memory: 280k freed
[    1.554460] Write protecting the kernel text: 2200k
[    1.554540] Write protecting the kernel read-only data: 956k
[    1.814677] ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
[    1.814745] ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 23 (level, low) -> IRQ 23
[    1.814890] PCI: Setting latency timer of device 0000:00:02.1 to 64
[    1.814892] ehci_hcd 0000:00:02.1: EHCI Host Controller
[    1.815022] ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
[    1.815134] ehci_hcd 0000:00:02.1: debug port 1
[    1.815191] PCI: cache line size of 64 is not supported by device 0000:00:02.1
[    1.815208] ehci_hcd 0000:00:02.1: irq 23, io mem 0xfbffac00
[    1.820506] ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[    1.820680] usb usb1: configuration #1 chosen from 1 choice
[    1.821317] hub 1-0:1.0: USB hub found
[    1.821385] hub 1-0:1.0: 10 ports detected
[    2.025061] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.025367] ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 22
[    2.025433] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 22 (level, low) -> IRQ 22
[    2.025574] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    2.025577] ohci_hcd 0000:00:02.0: OHCI Host Controller
[    2.025697] ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
[    2.025807] ohci_hcd 0000:00:02.0: irq 22, io mem 0xfbffb000
[    2.078403] usb usb2: configuration #1 chosen from 1 choice
[    2.078482] hub 2-0:1.0: USB hub found
[    2.078544] hub 2-0:1.0: 10 ports detected
[    2.136572] usb 1-3: new high speed USB device using ehci_hcd and address 2
[    2.181321] USB Universal Host Controller Interface driver v3.0
[    2.245257] SCSI subsystem initialized
[    2.260920] Driver 'sd' needs updating - please use bus_type methods
[    2.268157] libata version 3.00 loaded.
[    2.288419] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    2.288693] ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
[    2.288760] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
[    2.288903] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    2.288910] ACPI: PCI interrupt for device 0000:00:05.0 disabled
[    2.289189] ACPI: PCI Interrupt Link [LSA1] enabled at IRQ 23
[    2.289247] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23 (level, low) -> IRQ 23
[    2.289397] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    2.289404] ACPI: PCI interrupt for device 0000:00:05.1 disabled
[    2.289681] ACPI: PCI Interrupt Link [LSA2] enabled at IRQ 22
[    2.289738] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22 (level, low) -> IRQ 22
[    2.289880] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    2.289886] ACPI: PCI interrupt for device 0000:00:05.2 disabled
[    2.336317] usb 1-3: configuration #1 chosen from 1 choice
[    2.437637] usb 1-4: new high speed USB device using ehci_hcd and address 3
[    2.554317] usb 1-4: configuration #1 chosen from 1 choice
[    2.554317] hub 1-4:1.0: USB hub found
[    2.554317] hub 1-4:1.0: 4 ports detected
[    2.821317] usb 1-4.1: new low speed USB device using ehci_hcd and address 4
[    2.917317] usb 1-4.1: configuration #1 chosen from 1 choice
[    2.925317] input: Microsoft Microsoft IntelliMouse® Optical as /class/input/input1
[    2.930965] input,hidraw0: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse® Optical] on usb-0000:00:02.1-4.1
[    2.994317] usb 1-4.2: new low speed USB device using ehci_hcd and address 5
[    3.080317] usb 1-4.2: configuration #1 chosen from 1 choice
[    3.084254] input: DELL DELL USB Keyboard as /class/input/input2
[    3.088406] input,hidraw1: USB HID v1.10 Keyboard [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[    3.099317] input: DELL DELL USB Keyboard as /class/input/input3
[    3.105068] input,hidraw2: USB HID v1.10 Device [DELL DELL USB Keyboard] on usb-0000:00:02.1-4.2
[    4.792321] pata_amd 0000:00:04.0: version 0.3.10
[    4.792321] PCI: Setting latency timer of device 0000:00:04.0 to 64
[    4.802916] scsi0 : pata_amd
[    4.803033] scsi1 : pata_amd
[    4.804056] ata1: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xffa0 irq 14
[    4.804115] ata2: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xffa8 irq 15
[    5.018326] ata1.00: ATA-6: IC35L090AVV207-0, V23OA63A, max UDMA/100
[    5.018387] ata1.00: 160836480 sectors, multi 16: LBA48 
[    5.029323] ata1.01: ATA-6: Maxtor 32049H2, YAH814Y0, max UDMA/100
[    5.029382] ata1.01: 39062500 sectors, multi 16: LBA 
[    5.029446] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c60000) ACPI=0x3f01f (20:20:0x15)
[    5.029450] ata1: nv_mode_filter: 0x3f39f&0x3f01f->0x3f01f, BIOS=0x3f000 (0xc6c60000) ACPI=0x3f01f (20:20:0x15)
[    5.083327] ata1.00: configured for UDMA/100
[    5.116327] ata1.01: configured for UDMA/100
[    5.116835] ata2: port disabled. ignoring.
[    5.116921] scsi 0:0:0:0: Direct-Access     ATA      IC35L090AVV207-0 V23O PQ: 0 ANSI: 5
[    5.117072] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
[    5.117139] sd 0:0:0:0: [sda] Write Protect is off
[    5.117196] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.117211] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.117317] sd 0:0:0:0: [sda] 160836480 512-byte hardware sectors (82348 MB)
[    5.117317] sd 0:0:0:0: [sda] Write Protect is off
[    5.117317] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.117317] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.117417]  sda: sda1
[    5.123153] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.123291] scsi 0:0:1:0: Direct-Access     ATA      Maxtor 32049H2   YAH8 PQ: 0 ANSI: 5
[    5.123439] sd 0:0:1:0: [sdb] 39062500 512-byte hardware sectors (20000 MB)
[    5.123505] sd 0:0:1:0: [sdb] Write Protect is off
[    5.123562] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.123576] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.123699] sd 0:0:1:0: [sdb] 39062500 512-byte hardware sectors (20000 MB)
[    5.123764] sd 0:0:1:0: [sdb] Write Protect is off
[    5.123821] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    5.123835] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.123929]  sdb: sdb1 sdb2 sdb3
[    5.167317] sd 0:0:1:0: [sdb] Attached SCSI disk
[    7.675317] sata_nv 0000:00:05.0: version 3.5
[    7.675317] ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
[    7.675317] sata_nv 0000:00:05.0: Using SWNCQ mode
[    7.675317] PCI: Setting latency timer of device 0000:00:05.0 to 64
[    7.675317] scsi2 : sata_nv
[    7.675317] scsi3 : sata_nv
[    7.675317] ata3: SATA max UDMA/133 cmd 0xd480 ctl 0xd400 bmdma 0xcc00 irq 21
[    7.675317] ata4: SATA max UDMA/133 cmd 0xd080 ctl 0xd000 bmdma 0xcc08 irq 21
[    8.131327] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.134417] ata3.00: ATAPI: PIONEER DVD-RW  DVR-215, 1.18, max UDMA/66
[    8.140418] ata3.00: configured for UDMA/66
[    8.445323] ata4: SATA link down (SStatus 0 SControl 300)
[    8.461317] scsi 2:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-215  1.18 PQ: 0 ANSI: 5
[    8.461501] ACPI: PCI Interrupt 0000:00:05.1[B] -> Link [LSA1] -> GSI 23 (level, low) -> IRQ 23
[    8.461637] sata_nv 0000:00:05.1: Using SWNCQ mode
[    8.461892] PCI: Setting latency timer of device 0000:00:05.1 to 64
[    8.462008] scsi4 : sata_nv
[    8.462098] scsi5 : sata_nv
[    8.462251] ata5: SATA max UDMA/133 cmd 0xc880 ctl 0xc800 bmdma 0xc080 irq 23
[    8.462311] ata6: SATA max UDMA/133 cmd 0xc480 ctl 0xc400 bmdma 0xc088 irq 23
[    8.767323] ata5: SATA link down (SStatus 0 SControl 300)
[    9.082323] ata6: SATA link down (SStatus 0 SControl 300)
[    9.092661] ACPI: PCI Interrupt 0000:00:05.2[C] -> Link [LSA2] -> GSI 22 (level, low) -> IRQ 22
[    9.092793] sata_nv 0000:00:05.2: Using SWNCQ mode
[    9.093043] PCI: Setting latency timer of device 0000:00:05.2 to 64
[    9.093317] scsi6 : sata_nv
[    9.093409] scsi7 : sata_nv
[    9.093731] ata7: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb480 irq 22
[    9.093790] ata8: SATA max UDMA/133 cmd 0xb880 ctl 0xb800 bmdma 0xb488 irq 22
[    9.423325] ata7: SATA link down (SStatus 0 SControl 300)
[    9.738324] ata8: SATA link down (SStatus 0 SControl 300)
[   12.459166] kjournald starting.  Commit interval 5 seconds
[   12.459234] EXT3-fs: mounted filesystem with ordered data mode.
[   13.041199] type=1404 audit(1210102086.348:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
[   13.439756] SELinux: 8192 avtab hash slots, 222567 rules.
[   13.469118] SELinux: 8192 avtab hash slots, 222567 rules.
[   13.492114] SELinux:  6 users, 12 roles, 2420 types, 115 bools, 1 sens, 1024 cats
[   13.492118] SELinux:  67 classes, 222567 rules
[   13.493503] SELinux:  class peer not defined in policy
[   13.493564] SELinux:  class capability2 not defined in policy
[   13.493631] SELinux:  permission open in class dir not defined in policy
[   13.493691] SELinux:  permission open in class file not defined in policy
[   13.493751] SELinux:  permission open in class chr_file not defined in policy
[   13.493810] SELinux:  permission open in class blk_file not defined in policy
[   13.493869] SELinux:  permission open in class fifo_file not defined in policy
[   13.493966] SELinux:  permission recvfrom in class node not defined in policy
[   13.494025] SELinux:  permission sendto in class node not defined in policy
[   13.494086] SELinux:  permission ingress in class netif not defined in policy
[   13.494145] SELinux:  permission egress in class netif not defined in policy
[   13.494233] SELinux:  permission setfcap in class capability not defined in policy
[   13.494317] SELinux:  permission forward_in in class packet not defined in policy
[   13.494414] SELinux:  permission forward_out in class packet not defined in policy
[   13.494603] SELinux:  Completing initialization.
[   13.494604] SELinux:  Setting up existing superblocks.
[   13.513317] SELinux: initialized (dev sdb1, type ext3), uses xattr
[   13.755317] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   13.755317] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   13.755387] SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
[   13.755411] SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
[   13.755417] SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
[   13.755422] SELinux: initialized (dev devpts, type devpts), uses transition SIDs
[   13.755429] SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
[   13.755432] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   13.755438] SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
[   13.755441] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[   13.755446] SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
[   13.755474] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[   13.755480] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[   13.755489] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[   13.755493] SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
[   13.755510] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[   13.762709] SELinux: policy loaded with handle_unknown=allow
[   13.762777] type=1403 audit(1210102087.070:3): policy loaded auid=4294967295 ses=4294967295
[   19.038319] Driver 'sr' needs updating - please use bus_type methods
[   19.048321] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   19.048321] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   19.048321] sr 2:0:0:0: Attached scsi generic sg2 type 5
[   19.064318] sr0: scsi3-mmc drive: 12x/12x writer dvd-ram cd/rw xa/form2 cdda tray
[   19.064318] Uniform CD-ROM driver Revision: 3.20
[   19.064318] sr 2:0:0:0: Attached scsi CD-ROM sr0
[   19.710318] input: PC Speaker as /class/input/input4
[   19.942568] input: Power Button (FF) as /class/input/input5
[   19.956465] ACPI: Power Button (FF) [PWRF]
[   19.956540] input: Power Button (CM) as /class/input/input6
[   19.961427] ACPI: Power Button (CM) [PWRB]
[   20.129319] i2c-adapter i2c-0: nForce2 SMBus adapter at 0x2d00
[   20.129319] i2c-adapter i2c-1: nForce2 SMBus adapter at 0x2e00
[   20.140320] forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
[   20.140635] ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 20
[   20.140643] ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LMAC] -> GSI 20 (level, low) -> IRQ 20
[   20.140648] PCI: Setting latency timer of device 0000:00:08.0 to 64
[   20.352318] ck804xrom ck804xrom_init_one(): Unable to register resource 0x0000000000000000-0x00000000ffffffff - kernel bug?
[   20.352318] ck804xrom: ioremap(00000000, 00000000) failed
[   20.655823] forcedeth 0000:00:08.0: ifname eth0, PHY OUI 0x1c1 @ 0, addr 00:16:17:45:c9:df
[   20.655827] forcedeth 0000:00:08.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   20.656122] ACPI: PCI Interrupt Link [LMAD] enabled at IRQ 20
[   20.656125] ACPI: PCI Interrupt 0000:00:09.0[A] -> Link [LMAD] -> GSI 20 (level, low) -> IRQ 20
[   20.656130] PCI: Setting latency timer of device 0000:00:09.0 to 64
[   21.169634] forcedeth 0000:00:09.0: ifname eth1, PHY OUI 0x1c1 @ 1, addr 00:16:17:45:c9:de
[   21.169637] forcedeth 0000:00:09.0: highdma csum vlan pwrctl mgmt timirq gbit lnktim msi desc-v3
[   21.169964] ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 21
[   21.169967] ACPI: PCI Interrupt 0000:00:06.1[B] -> Link [LAZA] -> GSI 21 (level, low) -> IRQ 21
[   21.169991] PCI: Setting latency timer of device 0000:00:06.1 to 64
[   21.169994] ALSA sound/pci/hda/hda_intel.c:1904: chipset global capabilities = 0x4401
[   21.177318] ALSA sound/pci/hda/hda_intel.c:745: codec_mask = 0x1
[   21.180067] ALSA sound/pci/hda/hda_codec.c:2350: hda_codec: model '6stack-dig' is selected for config 1462:7250 (MSI)
[   21.203398] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
[   21.203402] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Volume, skipped
[   21.203404] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Mono Playback Volume, skipped
[   21.203407] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Line-Out Playback Volume, skipped
[   21.203414] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Switch, skipped
[   21.203417] ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Mono Playback Switch, skipped
[   23.481347] SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
[   24.636318] NET: Registered protocol family 10
[   24.636318] lo: Disabled Privacy Extensions
[   25.362683] ACPI: PCI Interrupt Link [LNEB] enabled at IRQ 19
[   25.362692] ACPI: PCI Interrupt 0000:07:00.0[A] -> Link [LNEB] -> GSI 19 (level, low) -> IRQ 19
[   30.787236] device-mapper: uevent: version 1.0.3
[   30.788323] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
[   31.239321] device-mapper: multipath: version 1.0.5 loaded
[   32.953682] EXT3 FS on sdb1, internal journal
[   33.448318] SELinux: initialized (dev sdb3, type ext2), uses xattr
[   33.454529] SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
[   35.485162] Adding 1004052k swap on /dev/mapper/crypt-swap.  Priority:-1 extents:1 across:1004052k
[   35.489016] SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
[   36.403578] warning: process `kudzu' used the deprecated sysctl system call with 1.23.
[   36.899319] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   37.137319] ip_tables: (C) 2000-2006 Netfilter Core Team
[   37.286318] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   37.692320] Clocksource tsc unstable (delta = -157216094 ns)
[   39.750322] eth1: no link during initialization.
[   39.750634] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   46.641321] warning: `mcstransd' uses 32-bit capabilities (legacy support in use)
[   47.487854] RPC: Registered udp transport module.
[   47.487857] RPC: Registered tcp transport module.
[   47.494321] SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
[   48.503864] fuse init (API version 7.9)
[   48.527321] SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
[   49.286327] eth0: no IPv6 routers present
[   56.986678] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   57.740319] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   57.752321] SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
[   58.274983] Bluetooth: Core ver 2.11
[   58.275771] NET: Registered protocol family 31
[   58.275775] Bluetooth: HCI device and connection manager initialized
[   58.275778] Bluetooth: HCI socket layer initialized
[   58.592409] Bluetooth: L2CAP ver 2.9
[   58.592413] Bluetooth: L2CAP socket layer initialized
[   58.863727] Bluetooth: RFCOMM socket layer initialized
[   58.863741] Bluetooth: RFCOMM TTY layer initialized
[   58.863743] Bluetooth: RFCOMM ver 1.8
[   64.382320] ALSA sound/pci/hda/hda_intel.c:1318: azx_pcm_prepare: bufsize=0x1800, format=0x4011
[   64.382320] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[   64.388320] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[   64.390548] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[   64.392390] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[   64.394326] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[   64.396332] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
[   64.396335] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
[   64.396338] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
[   64.396340] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
[   64.396342] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
[  257.677734] ALSA sound/pci/hda/hda_intel.c:1318: azx_pcm_prepare: bufsize=0x4400, format=0x4011
[  257.677805] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  257.684836] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  257.686376] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  257.688378] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  257.690350] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  257.692466] ALSA sound/pci/hda/hda_intel.c:1318: azx_pcm_prepare: bufsize=0x4400, format=0x4011
[  257.692534] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x5, channel=0, format=0x4011
[  257.694325] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
[  257.696323] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
[  257.698394] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
[  257.700385] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
[  257.827320] ALSA sound/pci/hda/hda_intel.c:1318: azx_pcm_prepare: bufsize=0x4400, format=0x4011
[  257.827320] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x1, channel=0, format=0x4011
[  257.829330] ALSA sound/pci/hda/hda_intel.c:1318: azx_pcm_prepare: bufsize=0x4400, format=0x4011
[  257.829338] ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x1, channel=0, format=0x4011
[  259.309488] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
[  259.309495] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
[  259.309499] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
[  259.309503] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
[  259.309506] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
[  259.309521] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
[  259.309524] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
[  259.309526] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
[  259.309529] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
[  259.309587] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
[  259.309600] ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
[  260.202343] ISO 9660 Extensions: Microsoft Joliet Level 3
[  260.433319] ISOFS: changing to secondary root
[  260.434412] SELinux: initialized (dev sr0, type iso9660), uses genfs_contexts
[ 1419.506769] oprofile: using NMI interrupt.
[ 1419.534319] SELinux: initialized (dev oprofilefs, type oprofilefs), uses genfs_contexts
[ 1424.524530] BUG: unable to handle kernel paging request at fa4433d8
[ 1424.524534] IP: [<f8bc04f3>] :oprofile:alloc_cpu_buffers+0x39/0xce
[ 1424.524542] *pde = 00000000 
[ 1424.524545] Oops: 0002 [#1] SMP 
[ 1424.524547] last sysfs file: /sys/devices/pci0000:00/0000:00:09.0/irq
[ 1424.524549] Modules linked in: oprofile cpufreq_stats nls_utf8 rfcomm l2cap bluetooth autofs4 fuse sunrpc nf_conntrack_netbios_ns nf_conntrack_ipv4 xt_state nf_conntrack ipt_REJECT iptable_filter ip_tables xt_tcpudp ip6t_REJECT ip6table_filter ip6_tables x_tables cpufreq_ondemand dm_crypt ext2 dm_mirror dm_log dm_multipath scsi_dh dm_mod ipv6 snd_hda_intel snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd_page_alloc snd_hwdep forcedeth i2c_nforce2 i2c_core k8temp hwmon serio_raw button mtd chipreg snd soundcore pcspkr map_funcs sg sr_mod cdrom sata_nv pata_amd pata_acpi ata_generic libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd [last unloaded: scsi_wait_scan]
[ 1424.524579] 
[ 1424.524581] Pid: 3571, comm: oprofiled Not tainted (2.6.26-rc1-next-20080506 #23)
[ 1424.524583] EIP: 0060:[<f8bc04f3>] EFLAGS: 00010286 CPU: 0
[ 1424.524589] EIP is at alloc_cpu_buffers+0x39/0xce [oprofile]
[ 1424.524591] EAX: f8bc8000 EBX: fa4433c0 ECX: f8bc04f1 EDX: 00000000
[ 1424.524593] ESI: 00000000 EDI: 00002000 EBP: 00010000 ESP: f48fee98
[ 1424.524595]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[ 1424.524597] Process oprofiled (pid: 3571, ti=f48fe000 task=f63389e0 task.ti=f48fe000)
[ 1424.524598] Stack: ffffffea f4867a80 00000000 f8bc0c99 f8bc0119 ffffffea f4867a80 f8bc0cd2 
[ 1424.524603]        f4867a80 f4cb5830 c047f291 f4894700 f4e88660 f48fef14 f4867a80 f48fef14 
[ 1424.524608]        00000001 c047f3a7 f4867a80 00000000 00000000 f48fef14 c0489d6d 00000000 
[ 1424.524612] Call Trace:
[ 1424.524615]  [<f8bc0c99>] event_buffer_open+0x0/0x55 [oprofile]
[ 1424.524621]  [<f8bc0119>] oprofile_setup+0x11/0x84 [oprofile]
[ 1424.524628]  [<f8bc0cd2>] event_buffer_open+0x39/0x55 [oprofile]
[ 1424.524635]  [<c047f291>] __dentry_open+0x118/0x212
[ 1424.524642]  [<c047f3a7>] nameidata_to_filp+0x1c/0x2c
[ 1424.524648]  [<c0489d6d>] do_filp_open+0x35a/0x6c3
[ 1424.524653]  [<c041bcf8>] kunmap_atomic+0x67/0x87
[ 1424.524659]  [<c046e384>] handle_mm_fault+0x6e7/0x6f8
[ 1424.524663]  [<c0470c78>] mmap_region+0x2de/0x394
[ 1424.524679]  [<c047f0a3>] do_sys_open+0x40/0xb0
[ 1424.524685]  [<c047f157>] sys_open+0x1e/0x23
[ 1424.524690]  [<c0404a92>] syscall_call+0x7/0xb
[ 1424.524704]  =======================
[ 1424.524705] Code: 8d 2c fd 00 00 00 00 53 e8 60 07 93 c7 89 c6 e9 8d 00 00 00 bb c0 63 bc f8 31 d2 89 e8 03 1c b5 c0 5e 74 c0 e8 36 35 8b c7 85 c0 <89> 43 18 74 7e 8d 43 34 c7 43 04 00 00 00 00 89 73 2c c7 43 0c 
[ 1424.524724] EIP: [<f8bc04f3>] alloc_cpu_buffers+0x39/0xce [oprofile] SS:ESP 0068:f48fee98
[ 1424.524731] ---[ end trace 4087bd8dc21f6171 ]---

