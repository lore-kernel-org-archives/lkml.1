Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYE2GcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYE2GcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 02:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE2GcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 02:32:11 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:24282 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbYE2GcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 02:32:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=M2AkBa/Iz+ONszeICzU8elBTw4XYRbDT19CQ4ylnyYE/keAMMqEkspMaXvwXtlMDL21L5G+PeKkfeelT03Im+M/x6hmJcfkQZRB8eumULjwhmPMqJ+BPnn/x5bNP1IEdkw9Sv2fXZFZRD7MbkhHJSjpP+UdiSAIrduPknBnXJ0E=
Message-ID: <dd18b0c30805282332l540ac7e6s1afaa1a01e689e3c@mail.gmail.com>
Date: Thu, 29 May 2008 06:32:03 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: NETDEV WATCHDOG: wifi0: transmit time out
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering why the internet was reacting terrible:
below is dmesg

[    0.000000] Linux version 2.6.26-rc3-00250-gb56e981 (root@unix)
(gcc version 4.2.3 (Debian 4.2.3-3)) #8 SMP Mon May 26 23:26:28 UTC
2008
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
[    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000003f0ea000 (usable)
[    0.000000]  BIOS-e820: 000000003f0ea000 - 000000003f2eb000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003f2eb000 - 000000003febe000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003febe000 - 000000003feef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000003feef000 - 000000003ff00000 (ACPI data)
[    0.000000]  BIOS-e820: 000000003ff00000 - 0000000040000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
[    0.000000]  BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] 112MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000] Entering add_active_range(0, 0, 258282) 0 entries of 256 used
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   Normal       4096 ->   229376
[    0.000000]   HighMem    229376 ->   258282
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[1] active PFN ranges
[    0.000000]     0:        0 ->   258282
[    0.000000] On node 0 totalpages: 258282
[    0.000000]   DMA zone: 32 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 4064 pages, LIFO batch:0
[    0.000000]   Normal zone: 1760 pages used for memmap
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 225 pages used for memmap
[    0.000000]   HighMem zone: 28681 pages, LIFO batch:7
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] DMI 2.4 present.
[    0.000000] Using APIC driver default
[    0.000000] ACPI: RSDP 000FE020, 0024 (r2 APPLE )
[    0.000000] ACPI: XSDT 3FEFD1C0, 0074 (r1 APPLE   Apple00       A5
     1000013)
[    0.000000] ACPI: FACP 3FEFB000, 00F4 (r3 APPLE   Apple00       A5
Loki       5F)
[    0.000000] ACPI: DSDT 3FEF0000, 48D1 (r1 APPLE  MacBookP    20002
INTL 20050309)
[    0.000000] ACPI: FACS 3FEC0000, 0040
[    0.000000] ACPI: HPET 3FEFA000, 0038 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: APIC 3FEF9000, 0068 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: MCFG 3FEF8000, 003C (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ASF! 3FEF7000, 00A0 (r32 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SBST 3FEF6000, 0030 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: ECDT 3FEF5000, 0053 (r1 APPLE   Apple00        1
Loki       5F)
[    0.000000] ACPI: SSDT 3FEEF000, 04DC (r1 APPLE     CpuPm     3000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBD000, 064F (r1 SataRe  SataPri     1000
INTL 20050309)
[    0.000000] ACPI: SSDT 3FEBC000, 069C (r1 SataRe  SataSec     1000
INTL 20050309)
[    0.000000] ACPI: DMI detected: Apple
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to
0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] BIOS bug, APIC version is 0 for CPU#0! fixing up to
0x10. (tell your hw vendor)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1 already used, trying 2
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b0000000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] PERCPU: Allocating 46824 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2
[    0.647710] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 256265
[    0.647710] Kernel command line: root=/dev/sda1 ro quiet splash
vga=773 selinux=1 audit=1 enforcing=1 debug acpi_osi=Linux pnpacpi=off
pci=routeirq usbcore.autosuspend=1 nmi_watchdog=0
[    0.647710] audit: enabled (after initialization)
[    0.647710] ACPI: Added _OSI(Linux)
[    0.647710] mapped APIC to ffffb000 (fee00000)
[    0.647710] mapped IOAPIC to ffffa000 (fec00000)
[    0.647710] Enabling fast FPU save and restore... done.
[    0.647710] Enabling unmasked SIMD FPU exception support... done.
[    0.647710] Initializing CPU#0
[    0.647710] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.647710] Extended CMOS year: 2000
[    0.647710] Detected 2161.306 MHz processor.
[    0.647710] Console: colour dummy device 80x25
[    0.647710] console [tty0] enabled
[    0.647710] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.647710] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.647710] Memory: 1018712k/1033128k available (2555k kernel code,
13800k reserved, 1280k data, 328k init, 115624k highmem)
[    0.647710] virtual kernel memory layout:
[    0.647710]     fixmap  : 0xfff7e000 - 0xfffff000   ( 516 kB)
[    0.647710]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.647710]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.647710]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.647710]       .init : 0xc04c5000 - 0xc0517000   ( 328 kB)
[    0.647710]       .data : 0xc037ed85 - 0xc04beda8   (1280 kB)
[    0.647710]       .text : 0xc0100000 - 0xc037ed85   (2555 kB)
[    0.647710] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.647710] CPA: page pool initialized 1 of 1 pages preallocated
[    0.647710] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.647710] hpet clockevent registered
[    0.797242] Calibrating delay using timer specific routine..
4348.05 BogoMIPS (lpj=21740253)
[    0.797292] Security Framework initialized
[    0.797298] SELinux:  Initializing.
[    0.797310] SELinux:  Starting in enforcing mode
[    0.797316] selinux_register_security:  Registering secondary
module capability
[    0.797321] Capability LSM initialized as secondary
[    0.797345] Mount-cache hash table entries: 512
[    0.797632] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.797637] CPU: L2 cache: 4096K
[    0.797641] CPU: Physical Processor ID: 0
[    0.797644] CPU: Processor Core ID: 0
[    0.797649] Intel machine check architecture supported.
[    0.797654] Intel machine check reporting enabled on CPU#0.
[    0.797658] using mwait in idle threads.
[    0.797674] Checking 'hlt' instruction... OK.
[    0.837710] ACPI: Core revision 20080321
[    0.847710] ENABLING IO-APIC IRQs
[    0.847710] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.947710] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.947710] Booting processor 1/1 ip 6000
[    0.957551] Initializing CPU#1
[    0.957551] Calibrating delay using timer specific routine..
4322.52 BogoMIPS (lpj=21612645)
[    0.957551] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.957551] CPU: L2 cache: 4096K
[    0.957551] CPU: Physical Processor ID: 0
[    0.957551] CPU: Processor Core ID: 1
[    0.957551] Intel machine check architecture supported.
[    0.957551] Intel machine check reporting enabled on CPU#1.
[    1.107710] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    1.107710] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    1.107741] Brought up 2 CPUs
[    1.107747] Total of 2 processors activated (8670.57 BogoMIPS).
[    1.107771] CPU0 attaching sched-domain:
[    1.107776]  domain 0: span 0-1
[    1.107780]   groups: 0 1
[    1.107787] CPU1 attaching sched-domain:
[    1.107792]  domain 0: span 0-1
[    1.107795]   groups: 1 0
[    1.117710] net_namespace: 516 bytes
[    1.117710] Booting paravirtualized kernel on bare hardware
[    1.117710] NET: Registered protocol family 16
[    1.117710] No dock devices found.
[    1.117710] EISA bus registered
[    1.117710] ACPI: bus type pci registered
[    1.117710] PCI: Using configuration type 1 for base access
[    1.117710] Setting up standard PCI resources
[    1.117711] ACPI: EC: EC description table is found, configuring boot EC
[    1.117711] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    1.121377] ACPI: BIOS _OSI(Linux) query honored via cmdline
[    1.122219] ACPI: Interpreter enabled
[    1.122224] ACPI: (supports S0 S3 S4 S5)
[    1.122281] ACPI: Using IOAPIC for interrupt routing
[    1.147710] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    1.147710] ACPI: EC: driver started in interrupt mode
[    1.147710] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    1.148615] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    1.148624] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    1.149608] PCI: Transparent bridge - 0000:00:1e.0
[    1.149660] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    1.151149] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    1.151619] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    1.152081] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    1.152541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    1.153021] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    1.177710] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    1.177710] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.177710] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    1.177710] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    1.177710] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    1.177710] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    1.177710] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    1.177710] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    1.177710] Linux Plug and Play Support v0.97 (c) Adam Belay
[    1.177710] pnp: PnP ACPI: disabled
[    1.177710] SCSI subsystem initialized
[    1.177710] libata version 3.00 loaded.
[    1.177710] usbcore: registered new interface driver usbfs
[    1.177710] usbcore: registered new interface driver hub
[    1.177710] usbcore: registered new device driver usb
[    1.177711] PCI: Using ACPI for IRQ routing
[    1.177711] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    1.177711] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:00:07.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 22
[    1.177711] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[    1.177711] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level,
low) -> IRQ 18
[    1.177711] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 23
[    1.177711] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[    1.177711] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[    1.177711] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 23
[    1.177711] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[    1.177711] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[    1.177711] ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level,
low) -> IRQ 19
[    1.177711] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    1.177711] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[    1.177711] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level,
low) -> IRQ 19
[    1.207588] NetLabel: Initializing
[    1.207592] NetLabel:  domain hash size = 128
[    1.207595] NetLabel:  protocols = UNLABELED CIPSOv4
[    1.207662] NetLabel:  unlabeled traffic allowed by default
[    1.207673] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    1.207680] hpet0: 3 64-bit timers, 14318180 Hz
[    1.216517] Switched to high resolution mode on CPU 0
[    1.218430] Switched to high resolution mode on CPU 1
[    1.251423] PCI: Bridge: 0000:00:01.0
[    1.251428]   IO window: 3000-3fff
[    1.251434]   MEM window: 0x50300000-0x503fffff
[    1.251439]   PREFETCH window: 0x0000000040000000-0x0000000047ffffff
[    1.251447] PCI: Bridge: 0000:00:1c.0
[    1.251452]   IO window: 2000-2fff
[    1.251459]   MEM window: 0x50200000-0x502fffff
[    1.251466]   PREFETCH window: 0x0000000050500000-0x00000000505fffff
[    1.251476] PCI: Bridge: 0000:00:1c.1
[    1.251479]   IO window: disabled.
[    1.251486]   MEM window: 0x50100000-0x501fffff
[    1.251493]   PREFETCH window: disabled.
[    1.251502] PCI: Bridge: 0000:00:1c.2
[    1.251506]   IO window: 1000-1fff
[    1.251514]   MEM window: 0x4c100000-0x500fffff
[    1.251520]   PREFETCH window: 0x0000000048000000-0x000000004bffffff
[    1.251530] PCI: Bridge: 0000:00:1e.0
[    1.251533]   IO window: disabled.
[    1.251541]   MEM window: 0x4c000000-0x4c0fffff
[    1.251547]   PREFETCH window: disabled.
[    1.251566] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level,
low) -> IRQ 16
[    1.251575] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    1.251601] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level,
low) -> IRQ 17
[    1.251611] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    1.251637] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level,
low) -> IRQ 16
[    1.251647] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    1.251673] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level,
low) -> IRQ 18
[    1.251683] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    1.251699] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    1.251715] NET: Registered protocol family 2
[    1.280229] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    1.280508] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    1.280934] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    1.281488] TCP: Hash tables configured (established 131072 bind 65536)
[    1.281494] TCP reno registered
[    1.290293] NET: Registered protocol family 1
[    1.300167] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    1.310165] Initializing RT-Tester: OK
[    1.310165] audit: initializing netlink socket (enabled)
[    1.310165] type=2000 audit(1212027039.650:1): initialized
[    1.310165] highmem bounce pool size: 64 pages
[    1.310165] Total HugeTLB memory allocated, 0
[    1.330165] fuse init (API version 7.9)
[    1.330165] msgmni has been set to 1764 for ipc namespace c0498e80
[    1.330165] SELinux:  Registering netfilter hooks
[    1.330165] io scheduler noop registered
[    1.330165] io scheduler cfq registered (default)
[    1.330165] pci 0000:01:00.0: Boot video device
[    1.330165] vesafb: framebuffer at 0x40000000, mapped to
0xf8880000, using 1536k, total 16384k
[    1.330165] vesafb: mode is 1024x768x8, linelength=1024, pages=18
[    1.330165] vesafb: protected mode interface info at c000:ad0c
[    1.330165] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    1.330165] vesafb: scrolling: redraw
[    1.330165] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    1.340165] Console: switching to colour frame buffer device 128x48
[    1.350165] fb0: VESA VGA frame buffer device
[    1.350165] power_supply ADP1: uevent
[    1.350165] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    1.350165] power_supply ADP1: Static prop TYPE=Mains
[    1.350165] power_supply ADP1: 1 dynamic props
[    1.350165] power_supply ADP1: prop ONLINE=1
[    1.350165] power_supply ADP1: power_supply_changed
[    1.350165] ACPI: AC Adapter [ADP1] (on-line)
[    1.350165] power_supply ADP1: power_supply_changed_work
[    1.350165] power_supply ADP1: power_supply_update_gen_leds 1
[    1.350165] power_supply ADP1: uevent
[    1.350165] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[    1.350292] power_supply ADP1: Static prop TYPE=Mains
[    1.350415] power_supply ADP1: 1 dynamic props
[    1.350524] power_supply ADP1: prop ONLINE=1
[    1.480199] power_supply BAT0: uevent
[    1.480199] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    1.480199] power_supply BAT0: Static prop TYPE=Battery
[    1.480199] power_supply BAT0: 12 dynamic props
[    1.562837] power_supply BAT0: prop STATUS=Full
[    1.566387] power_supply BAT0: prop PRESENT=1
[    1.567344] power_supply BAT0: prop TECHNOLOGY=Unknown
[    1.570774] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    1.577440] power_supply BAT0: prop VOLTAGE_NOW=12449000
[    1.580763] power_supply BAT0: prop CURRENT_NOW=0
[    1.584035] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    1.587308] power_supply BAT0: prop ENERGY_FULL=53130000
[    1.590513] power_supply BAT0: prop ENERGY_NOW=51250000
[    1.593682] power_supply BAT0: prop MODEL_NAME=ASMB012
[    1.604881] power_supply BAT0: prop MANUFACTURER=SMPN012
[    1.607977] power_supply BAT0: prop SERIAL_NUMBER=
[    1.620256] power_supply BAT0: power_supply_changed
[    1.620256] ACPI: Battery Slot [BAT0] (battery present)
[    1.620256] power_supply BAT0: power_supply_changed_work
[    1.620259] power_supply BAT0: power_supply_update_bat_leds 4
[    1.629536] power_supply BAT0: uevent
[    1.629536] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[    1.629536] power_supply BAT0: Static prop TYPE=Battery
[    1.631078] power_supply BAT0: 12 dynamic props
[    1.641075] power_supply BAT0: prop STATUS=Full
[    1.641075] power_supply BAT0: prop PRESENT=1
[    1.641079] power_supply BAT0: prop TECHNOLOGY=Unknown
[    1.649089] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[    1.649089] power_supply BAT0: prop VOLTAGE_NOW=12449000
[    1.649089] power_supply BAT0: prop CURRENT_NOW=0
[    1.649138] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[    1.659135] power_supply BAT0: prop ENERGY_FULL=53130000
[    1.659135] power_supply BAT0: prop ENERGY_NOW=51250000
[    1.659135] power_supply BAT0: prop MODEL_NAME=ASMB012
[    1.659138] power_supply BAT0: prop MANUFACTURER=SMPN012
[    1.669076] power_supply BAT0: prop SERIAL_NUMBER=
[    1.678696] hpet_resources: 0xfed00000 is busy
[    1.678696] loop: module loaded
[    1.680179] Linux video capture interface: v2.00
[    1.692114] input: Macintosh mouse button emulation as /class/input/input0
[    1.692114] Driver 'sd' needs updating - please use bus_type methods
[    1.692114] Driver 'sr' needs updating - please use bus_type methods
[    1.702996] ata_piix 0000:00:1f.1: version 2.12
[    1.702996] ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level,
low) -> IRQ 18
[    1.702996] PCI: Setting latency timer of device 0000:00:1f.1 to 64
[    1.703074] scsi0 : ata_piix
[    1.711674] scsi1 : ata_piix
[    1.711674] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    1.712296] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    1.892774] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    1.932724] ata1.00: configured for UDMA/66
[    2.107369] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R
UJ-857D  KCV9 PQ: 0 ANSI: 5
[    2.117388] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    2.123486] Uniform CD-ROM driver Revision: 3.20
[    2.129916] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    2.140307] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    2.140307] ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level,
low) -> IRQ 19
[    2.140307] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    2.299930] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    2.309916] scsi2 : ata_piix
[    2.309916] scsi3 : ata_piix
[    2.320638] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    2.320638] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    2.527385] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    2.527385] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    2.566944] ata3.01: configured for UDMA/100
[    2.706438] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU
MHW2120B 0081 PQ: 0 ANSI: 5
[    2.706438] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    2.706438] sd 2:0:1:0: [sda] Write Protect is off
[    2.756468] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.760409] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.766532] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    2.770709] sd 2:0:1:0: [sda] Write Protect is off
[    2.774513] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    2.778721] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    2.783085]  sda: sda1 sda2 < sda5 >
[    2.804297] sd 2:0:1:0: [sda] Attached SCSI disk
[    2.806213] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    2.811699] usbcore: registered new interface driver usblcd
[    2.815827] usbcore: registered new interface driver usbled
[    2.824986] PNP: No PS/2 controller found. Probing ports directly.
[    2.824986] i8042.c: No controller found.
[    2.843113] mice: PS/2 mouse device common for all mice
[    2.843113] device-mapper: ioctl: 4.13.0-ioctl (2007-10-18)
initialised: dm-devel@redhat.com
[    2.843113] EDAC MC: Ver: 2.1.0 May 21 2008
[    2.872170] cpuidle: using governor ladder
[    2.872170] cpuidle: using governor menu
[    2.879080] usbcore: registered new interface driver hiddev
[    2.881448] usbcore: registered new interface driver usbhid
[    2.885853] usbhid: v2.6:USB HID core driver
[    2.890443] Advanced Linux Sound Architecture Driver Version 1.0.16.
[    2.890445] ALSA device list:
[    2.899420]   No soundcards found.
[    2.908185] oprofile: using NMI interrupt.
[    2.908185] IPVS: Registered protocols (TCP, AH, ESP)
[    2.908185] IPVS: Connection hash table configured (size=4096,
memory=32Kbytes)
[    2.920774] IPVS: ipvs loaded.
[    2.925044] Initializing XFRM netlink socket
[    2.930743] NET: Registered protocol family 17
[    2.935035] NET: Registered protocol family 15
[    2.939229] Using IPI No-Shortcut mode
[    2.948181] kjournald starting.  Commit interval 5 seconds
[    2.947877] EXT3-fs: mounted filesystem with ordered data mode.
[    2.947877] VFS: Mounted root (ext3 filesystem) readonly.
[    2.947877] Freeing unused kernel memory: 328k freed
[    3.663179] SELinux: 8192 avtab hash slots, 205733 rules.
[    3.792958] SELinux: 8192 avtab hash slots, 205733 rules.
[    3.970800] SELinux:  7 users, 7 roles, 3017 types, 90 bools
[    3.974989] SELinux:  72 classes, 205733 rules
[    3.984964] SELinux:  Completing initialization.
[    3.989024] SELinux:  Setting up existing superblocks.
[    4.008130] SELinux: initialized (dev sda1, type ext3), uses xattr
[    4.048127] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    4.048127] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    4.132082] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses genfs_contexts
[    4.136177] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    4.142086] SELinux: initialized (dev inotifyfs, type inotifyfs),
uses genfs_contexts
[    4.146079] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.150239] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    4.154323] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    4.158256] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    4.162437] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    4.166570] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    4.170689] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    4.174736] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    4.178730] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    4.232357] SELinux: policy loaded with handle_unknown=deny
[    4.234260] type=1403 audit(1212027042.380:2): policy loaded
auid=4294967295 ses=4294967295
[    5.294664] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    5.315531] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   11.298586] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   11.543774] power_supply ADP1: uevent
[   11.552377] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   11.562358] power_supply ADP1: Static prop TYPE=Mains
[   11.562362] power_supply ADP1: 1 dynamic props
[   11.566504] power_supply ADP1: prop ONLINE=1
[   11.579285] power_supply BAT0: uevent
[   11.579285] power_supply BAT0: POWER_SUPPLY_NAME=BAT0
[   11.583509] power_supply BAT0: Static prop TYPE=Battery
[   11.587655] power_supply BAT0: 12 dynamic props
[   12.089505] power_supply BAT0: prop STATUS=Full
[   12.089505] power_supply BAT0: prop PRESENT=1
[   12.090072] power_supply BAT0: prop TECHNOLOGY=Unknown
[   12.099507] power_supply BAT0: prop VOLTAGE_MIN_DESIGN=10800000
[   12.103418] power_supply BAT0: prop VOLTAGE_NOW=12449000
[   12.107410] power_supply BAT0: prop CURRENT_NOW=0
[   12.111354] power_supply BAT0: prop ENERGY_FULL_DESIGN=55000000
[   12.117386] power_supply BAT0: prop ENERGY_FULL=53130000
[   12.123567] power_supply BAT0: prop ENERGY_NOW=51250000
[   12.125233] power_supply BAT0: prop MODEL_NAME=ASMB012
[   12.129007] power_supply BAT0: prop MANUFACTURER=SMPN012
[   12.132743] power_supply BAT0: prop SERIAL_NUMBER=
[   13.252679] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000
INTL 20050309)
[   13.259061] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001
INTL 20050309)
[   13.266709] Monitor-Mwait will be used to enter C-1 state
[   13.270463] Monitor-Mwait will be used to enter C-2 state
[   13.271594] Monitor-Mwait will be used to enter C-3 state
[   13.275265] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   13.278804] ACPI: ACPI0007:00 is registered as cooling_device0
[   13.282254] ACPI: Processor [CPU0] (supports 8 throttling states)
[   13.287592] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)
[   13.291711] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[   13.323128] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   13.327490] ACPI: ACPI0007:01 is registered as cooling_device1
[   13.332423] Marking TSC unstable due to: TSC halts in idle.
[   13.333989] ACPI: Processor [CPU1] (supports 8 throttling states)
[   13.347546] input: Power Button (FF) as /class/input/input1
[   13.422995] ACPI: Power Button (FF) [PWRF]
[   13.431936] input: Lid Switch as /class/input/input2
[   13.435562] ACPI: Lid Switch [LID0]
[   13.435690] input: Power Button (CM) as /class/input/input3
[   13.485972] ACPI: Power Button (CM) [PWRB]
[   13.491928] input: Sleep Button (CM) as /class/input/input4
[   13.550762] ACPI: Sleep Button (CM) [SLPB]
[   13.574184] input: Video Bus as /class/input/input5
[   13.623080] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   13.851834] USB Universal Host Controller Interface driver v3.0
[   13.855788] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level,
low) -> IRQ 23
[   13.862567] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   13.865727] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   13.869837] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   13.873905] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   13.878051] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   13.882368] usb usb1: configuration #1 chosen from 1 choice
[   13.885931] hub 1-0:1.0: USB hub found
[   13.890065] hub 1-0:1.0: 2 ports detected
[   13.997087] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level,
low) -> IRQ 19
[   14.001466] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   14.004877] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   14.009441] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   14.014135] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   14.019027] usb usb2: configuration #1 chosen from 1 choice
[   14.023753] hub 2-0:1.0: USB hub found
[   14.028490] hub 2-0:1.0: 2 ports detected
[   14.101539] ath_hal: module license 'Proprietary' taints kernel.
[   14.151081] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level,
low) -> IRQ 18
[   14.151081] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416,
RF5111, RF5112, RF2413, RF5413, RF2133)
[   14.151081] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   14.161120] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   14.166219] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   14.171384] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   14.181314] usb usb3: configuration #1 chosen from 1 choice
[   14.186170] hub 3-0:1.0: USB hub found
[   14.191234] hub 3-0:1.0: 2 ports detected
[   14.284012] wlan: svn r3626
[   14.304969] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   14.304969] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 16 (level,
low) -> IRQ 16
[   14.304981] PCI: Setting latency timer of device 0000:00:1d.3 to 64
[   14.304985] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   14.305046] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   14.305088] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   14.305335] usb usb4: configuration #1 chosen from 1 choice
[   14.305402] hub 4-0:1.0: USB hub found
[   14.305412] hub 4-0:1.0: 2 ports detected
[   14.410794] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level,
low) -> IRQ 23
[   14.410808] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   14.410811] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   14.410868] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   14.414786] ehci_hcd 0000:00:1d.7: debug port 1
[   14.414792] PCI: cache line size of 32 is not supported by device
0000:00:1d.7
[   14.414799] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   14.430410] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   14.430609] usb usb5: configuration #1 chosen from 1 choice
[   14.430686] hub 5-0:1.0: USB hub found
[   14.430697] hub 5-0:1.0: 8 ports detected
[   14.594721] Linux agpgart interface v0.103
[   14.607991] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level,
low) -> IRQ 19
[   14.658639] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   14.706870] hub 1-0:1.0: unable to enumerate USB device on port 2
[   14.835712] ath_pci: svn r3626
[   14.841966] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level,
low) -> IRQ 17
[   14.845714] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   14.981558] MadWifi: ath_attach: HAL managed transmit power control
(TPC) disabled.
[   14.986719] MadWifi: ath_attach: Interference mitigation is
supported.  Currently disabled.
[   14.994262] MadWifi: ath_attach: Switching rfkill capability off.
[   15.326688] ath_rate_sample: 1.2 (svn r3626)
[   15.331926] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   15.340840] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   15.344025] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps
9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   15.349432] wifi0: turboA rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   15.354653] wifi0: turboG rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   15.360031] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   15.365191] wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
[   15.370514] wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
[   15.375970] wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
[   15.380999] wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
[   15.385949] wifi0: ath_announce: Use hw queue 4 for XR traffic
[   15.390865] wifi0: ath_announce: Use hw queue 7 for UAPSD traffic
[   15.395721] wifi0: ath_announce: Use hw queue 8 for CAB traffic
[   15.400441] wifi0: ath_announce: Use hw queue 9 for beacons
[   15.461220] ath_pci: wifi0: Atheros 5418: mem=0x50100000, irq=17
[   15.472096] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level,
low) -> IRQ 22
[   15.476808] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   15.561595] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   15.578565] hub 5-0:1.0: unable to enumerate USB device on port 2
[   15.867772] usb 5-4: new high speed USB device using ehci_hcd and address 3
[   16.028109] usb 5-4: configuration #1 chosen from 1 choice
[   16.073681] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   16.330632] hub 5-0:1.0: unable to enumerate USB device on port 6
[   16.574501] hda_intel: azx_get_response timeout, switching to
polling mode: last cmd=0x00af1c00
[   16.612682] hub 5-0:1.0: unable to enumerate USB device on port 7
[   16.907694] usb 1-2: new full speed USB device using uhci_hcd and address 3
[   17.086437] Clocksource tsc unstable (delta = -444060315 ns)
[   17.099476] usb 1-2: configuration #1 chosen from 1 choice
[   17.115976] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input6
[   17.151274] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   17.167808] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input7
[   17.190681] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   17.518138] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   17.705384] usb 3-2: configuration #1 chosen from 1 choice
[   17.717009] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR
Receiver] on usb-0000:00:1d.2-2
[   18.006367] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   18.209138] usb 4-1: configuration #1 chosen from 1 choice
[   18.244473] input: HID 05ac:1000 as /class/input/input8
[   18.251693] input: USB HID v1.11 Keyboard [HID 05ac:1000] on
usb-0000:00:1d.3-1
[   18.281178] input: HID 05ac:1000 as /class/input/input9
[   18.311352] input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
[   18.317479] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   18.328441] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[   18.336047] input: Built-in iSight as /class/input/input10
[   18.360069] appletouch: Geyser mode initialized.
[   18.360069] input: appletouch as /class/input/input11
[   18.381380] usbcore: registered new interface driver uvcvideo
[   18.381427] USB Video Class driver (SVN r209)
[   18.413032] usbcore: registered new interface driver appletouch
[   18.897185] usb 5-4: USB disconnect, address 3
[   18.924103] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   19.059005] applesmc: Apple MacBook Pro detected:
[   19.063751] applesmc:  - Model with accelerometer
[   19.073750] applesmc:  - Model with light sensors and backlight
[   19.079522] applesmc:  - Model with 12 temperature sensors
[   19.091074] applesmc: device has already been initialized (0xe0, 0x00).
[   19.091074] applesmc: device successfully initialized.
[   19.097175] applesmc: 2 fans found.
[   19.104268] input: applesmc as /class/input/input12
[   19.144311] Registered led device: smc::kbd_backlight
[   19.144311] applesmc: driver successfully loaded.
[   19.245196] Symbol init_mm is marked as UNUSED, however this module
is using it.
[   19.253486] This symbol will go away in the future.
[   19.263473] Please evalute if this is the right api to use and if
it really is, submit a report the linux kernel mailinglist together
with submitting your code for inclusion.
[   19.294632] [fglrx] Maximum main memory to use for locked dma
buffers: 913 MBytes.
[   19.300548] [fglrx] ASYNCIO init succeed!
[   19.313263] [fglrx] PAT is enabled successfully!
[   19.316160] [fglrx] module loaded - fglrx 8.47.3 [Mar 29 2008] on minor 0
[   19.575287] intelfb: Framebuffer driver for Intel(R)
830M/845G/852GM/855GM/865G/915G/915GM/945G/945GM/965G/965GM chipsets
[   19.575287] intelfb: Version 0.9.5
[   19.669407] ip_tables: (C) 2000-2006 Netfilter Core Team
[   19.769586] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   19.835754] arp_tables: (C) 2002 David S. Miller
[   19.911382] ieee80211_crypt: registered algorithm 'NULL'
[   19.945416] ieee80211_crypt: registered algorithm 'TKIP'
[   20.051994] ipmi message handler version 39.2
[   20.071814] IPMI Watchdog: driver initialized
[   20.229119] Adding 2988048k swap on
/dev/disk/by-uuid/c58cdc7c-b94b-4116-9cca-bf154269e4d8.  Priority:-1
extents:1 across:2988048k
[   20.356339] EXT3 FS on sda1, internal journal
[   20.981766] usb 5-4: new high speed USB device using ehci_hcd and address 6
[   21.182585] usb 5-4: configuration #1 chosen from 1 choice
[   21.182890] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   21.185512] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[   21.192215] input: Built-in iSight as /class/input/input13
[   23.524265] appletouch: incomplete data package (first byte: 2, length: 4).
[   25.287541] input: Pommed beeper device as /class/input/input14
[   25.491782] Bluetooth: Core ver 2.11
[   25.492348] NET: Registered protocol family 31
[   25.492353] Bluetooth: HCI device and connection manager initialized
[   25.492356] Bluetooth: HCI socket layer initialized
[   25.540670] Bluetooth: L2CAP ver 2.9
[   25.540670] Bluetooth: L2CAP socket layer initialized
[   25.628243] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   25.652257] usb 4-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[   25.697031] Bluetooth: RFCOMM socket layer initialized
[   25.697031] Bluetooth: RFCOMM TTY layer initialized
[   25.697031] Bluetooth: RFCOMM ver 1.8
[   26.005906] hub 5-0:1.0: unable to enumerate USB device on port 7
[   26.014523] usb 4-1: USB disconnect, address 2
[   26.334789] usb 4-1: new full speed USB device using uhci_hcd and address 3
[   26.587717] usb 4-1: configuration #1 chosen from 1 choice
[   26.686810] Bluetooth: HCI USB driver ver 2.9
[   26.686810] usbcore: registered new interface driver hci_usb
[   33.719369] CPA self-test:
[   33.719431]  4k 0 large 224 gb 0 x 224[c0000000-f7c00000] miss 0
[   33.739341]  4k 192512 large 36 gb 0 x 192548[c0000000-f7fff000] miss 0
[   33.758297]  4k 192512 large 36 gb 0 x 192548[c0000000-f7fff000] miss 0
[   33.758304] ok.
[   34.580632] input: Apple Computer, Inc. Mighty Mouse as /class/input/input15
[   39.204871] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level,
low) -> IRQ 16
[   42.371657] [fglrx] Reserve Block - 0 offset =  0X7ffb000 length = 0X5000
[   42.371657] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
[   42.371657] [fglrx] Reserve Block - 2 offset =  0X7fbb000 length = 0X40000
[   42.451934] [fglrx] interrupt source 20008000 successfully enabled
[   42.451939] [fglrx] enable ID = 0x00000008
[   42.451948] [fglrx] Receive enable interrupt message with
irqEnableMask: 20008000
[   42.452040] [fglrx] interrupt source 10000000 successfully enabled
[   42.452043] [fglrx] enable ID = 0x00000009
[   42.452047] [fglrx] Receive enable interrupt message with
irqEnableMask: 10000000
[  689.955419] ACPI: EC: GPE storm detected, disabling EC GPE
[  919.918712] applesmc: wait status failed: 5 != 4
[  920.137465] applesmc: wait status failed: c != 8
[ 1330.252757] applesmc: wait status failed: 5 != 4
[ 1330.463020] applesmc: wait status failed: c != 8
[ 1505.326451] applesmc: wait status failed: 5 != 4
[ 1505.535449] applesmc: wait status failed: c != 8
[ 2252.182055] applesmc: wait status failed: 5 != 4
[ 2252.389094] applesmc: wait status failed: c != 8
[ 2788.321555] applesmc: wait status failed: 5 != 4
[ 2788.526926] applesmc: wait status failed: c != 8
[ 2811.300350] applesmc: wait status failed: 5 != 4
[ 2811.521738] applesmc: wait status failed: c != 8
[ 3054.387763] applesmc: wait status failed: 5 != 4
[ 3054.611654] applesmc: wait status failed: c != 8
[ 3279.751435] applesmc: wait status failed: 5 != 4
[ 3279.975203] applesmc: wait status failed: c != 8
[ 4351.560970] applesmc: wait status failed: 5 != 4
[ 4351.766803] applesmc: wait status failed: c != 8
[ 4424.236870] applesmc: wait status failed: 5 != 4
[ 4424.453503] applesmc: wait status failed: c != 8
[ 4601.285523] applesmc: wait status failed: 5 != 4
[ 4601.511445] applesmc: wait status failed: c != 8
[ 5231.655162] applesmc: wait status failed: 5 != 4
[ 5231.872459] applesmc: wait status failed: c != 8
[ 6149.896186] applesmc: wait status failed: 5 != 4
[ 6150.123249] applesmc: wait status failed: c != 8
[ 6522.614057] applesmc: wait status failed: 5 != 4
[ 6522.818413] applesmc: wait status failed: c != 8
[ 6585.623750] applesmc: wait status failed: 5 != 4
[ 6585.844331] applesmc: wait status failed: c != 8
[ 6739.529179] applesmc: wait status failed: 5 != 4
[ 6739.771195] applesmc: wait status failed: c != 8
[ 7076.805174] applesmc: wait status failed: 5 != 4
[ 7077.039146] applesmc: wait status failed: c != 8
[ 8046.230902] applesmc: wait status failed: 5 != 4
[ 8046.466454] applesmc: wait status failed: c != 8
[ 8186.580769] applesmc: wait status failed: 5 != 4
[ 8186.814503] applesmc: wait status failed: c != 8
[ 8415.222241] applesmc: wait status failed: 5 != 4
[ 8415.455867] applesmc: wait status failed: c != 8
[ 8875.586639] applesmc: wait status failed: 5 != 4
[ 8875.821857] applesmc: wait status failed: c != 8
[ 9335.691105] NETDEV WATCHDOG: wifi0: transmit timed out
[ 9335.697786] ------------[ cut here ]------------
[ 9335.697792] WARNING: at net/sched/sch_generic.c:222 dev_watchdog+0x95/0xe7()
[ 9335.697797] Modules linked in: hci_usb cpufreq_ondemand
cpufreq_performance cpufreq_powersave rfcomm hidp l2cap bluetooth fan
ipmi_watchdog ipmi_msghandler uinput wlan_tkip ieee80211_crypt_tkip
ieee80211_crypt arpt_mangle arptable_filter arp_tables
nf_conntrack_ipv4 nf_conntrack iptable_mangle iptable_filter ip_tables
x_tables intelfb i2c_i810 i2c_algo_bit coretemp eeprom acpi_cpufreq
fglrx(P) applesmc joydev appletouch uvcvideo firewire_ohci
wlan_scan_sta firewire_core ath_rate_sample snd_hda_intel intel_agp
ath_pci snd_pcm agpgart wlan ath_hal(P) ohci1394 evdev snd_timer
ieee1394 ehci_hcd uhci_hcd pata_acpi snd_page_alloc thermal video
snd_hwdep button processor
[ 9335.697894] Pid: 0, comm: swapper Tainted: P
2.6.26-rc3-00250-gb56e981 #8
[ 9335.697904]  [<c0122656>] warn_on_slowpath+0x41/0x6c
[ 9335.697939]  [<f8a5d711>] ? ath_reset+0x250/0x290 [ath_pci]
[ 9335.697966]  [<f8a5da78>] ? ath_tx_timeout+0x1fd/0x219 [ath_pci]
[ 9335.697988]  [<c0123001>] ? printk+0x15/0x17
[ 9335.698000]  [<c03043ad>] dev_watchdog+0x95/0xe7
[ 9335.698010]  [<c0129b04>] run_timer_softirq+0x133/0x193
[ 9335.698018]  [<c0304318>] ? dev_watchdog+0x0/0xe7
[ 9335.698030]  [<c0304318>] ? dev_watchdog+0x0/0xe7
[ 9335.698041]  [<c0126656>] __do_softirq+0x76/0xe4
[ 9335.698054]  [<c012670c>] do_softirq+0x48/0x57
[ 9335.698062]  [<c01269fa>] irq_exit+0x38/0x6b
[ 9335.698062]  [<c01058a7>] do_IRQ+0x76/0x8b
[ 9335.698062]  [<c01042d3>] common_interrupt+0x23/0x28
[ 9335.698062]  [<c013007b>] ? schedule_on_each_cpu+0x4e/0xa3
[ 9335.698062]  [<f88391ed>] ? acpi_idle_enter_bm+0x2ad/0x31e [processor]
[ 9335.698062]  [<c02d0942>] cpuidle_idle_call+0x61/0x93
[ 9335.698062]  [<c02d08e1>] ? cpuidle_idle_call+0x0/0x93
[ 9335.698062]  [<c0102507>] cpu_idle+0xae/0xce
[ 9335.698062]  [<c036eb76>] rest_init+0x4e/0x50
[ 9335.698062]  =======================
[ 9335.698062] ---[ end trace c31cfc4af4926eee ]---
[ 9428.182752] applesmc: wait status failed: 5 != 4
[ 9428.443691] applesmc: wait status failed: c != 8
[ 9502.548057] applesmc: wait status failed: 5 != 4
[ 9502.773390] applesmc: wait status failed: c != 8
[10736.724058] applesmc: wait status failed: 5 != 4
[10736.970865] applesmc: wait status failed: c != 8
[11940.459407] applesmc: wait status failed: 5 != 4
[11940.710157] applesmc: wait status failed: c != 8
[12047.819259] applesmc: wait status failed: 5 != 4
[12048.075589] applesmc: wait status failed: c != 8
[12367.583769] applesmc: wait status failed: 5 != 4
[12367.811270] applesmc: wait status failed: c != 8
[14100.534232] applesmc: wait status failed: 5 != 4
[14100.806695] applesmc: wait status failed: c != 8
[14505.203036] applesmc: wait status failed: 5 != 4
[14505.422206] applesmc: wait status failed: c != 8
[14671.459493] applesmc: wait status failed: 5 != 4
[14671.675211] applesmc: wait status failed: c != 8
[14839.394946] applesmc: wait status failed: 5 != 4
[14839.641391] applesmc: wait status failed: c != 8
[15141.539041] applesmc: wait status failed: 5 != 4
[15141.800768] applesmc: wait status failed: c != 8
[15208.711566] type=1400 audit(1212040487.235:3): avc:  denied  {
write } for  pid=3324 comm="xmms"
path=2F6465762F7074732F32202864656C6574656429 dev=devpts ino=4
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_devpts_t
tclass=chr_file
[15208.711617] type=1300 audit(1212040487.235:3): arch=40000003
syscall=4 success=no exit=-13 a0=1 a1=b7d9e233 a2=9 a3=20 items=0
ppid=1 pid=3324 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000
fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295
comm="xmms" exe="/usr/bin/xmms" subj=a-12:user_r:user_t key=(null)
[15208.716722] type=1400 audit(1212040487.235:4): avc:  denied  {
write } for  pid=3324 comm="xmms"
path=2F6465762F7074732F32202864656C6574656429 dev=devpts ino=4
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_devpts_t
tclass=chr_file
[15208.716760] type=1300 audit(1212040487.235:4): arch=40000003
syscall=4 success=no exit=-13 a0=1 a1=bf9712e7 a2=14 a3=20 items=0
ppid=1 pid=3324 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000
fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295
comm="xmms" exe="/usr/bin/xmms" subj=a-12:user_r:user_t key=(null)
[15208.716810] type=1400 audit(1212040487.235:5): avc:  denied  {
write } for  pid=3324 comm="xmms"
path=2F6465762F7074732F32202864656C6574656429 dev=devpts ino=4
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_devpts_t
tclass=chr_file
[15208.716847] type=1300 audit(1212040487.235:5): arch=40000003
syscall=4 success=no exit=-13 a0=1 a1=b7d9e8c6 a2=1 a3=20 items=0
ppid=1 pid=3324 auid=4294967295 uid=1000 gid=1000 euid=1000 suid=1000
fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=(none) ses=4294967295
comm="xmms" exe="/usr/bin/xmms" subj=a-12:user_r:user_t key=(null)
[15490.663710] input: Apple Computer, Inc. Mighty Mouse as /class/input/input16
[15596.530323] input: Apple Computer, Inc. Mighty Mouse as /class/input/input17

I'm going to let madwifi know of this, from my perspective I'm unsure
if this was kernel or madwifi's issue.
regards;

-- 
Justin P. Mattock
