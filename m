Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYIJTHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYIJTHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751781AbYIJTG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:06:57 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:44922 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbYIJTGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:06:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=KZFJ+mJTt8zED16tBSrZUbdk5/3Zm9sJufpO+BFZ3+SBxAVlW3V8falBG4OufrWrPo
         U6qF68tDa5WeAf28TxoAkqloSd40kDbzJtJALMcUGp0JeCBreVBlMd0PKSeAgH6rTDQF
         ZuRFzQ2gE4w3bwzl8pcITWchKs3GHVTkfB1mY=
Message-ID: <dd18b0c30809101206j3892e3dbpac9c48cfcaf2982f@mail.gmail.com>
Date: Wed, 10 Sep 2008 12:06:52 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [19.666764] Disabling IRQ #23
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello; I accidently erased the original thread
appologize for starting a new one of the same,
I've been noticing this message(below) appear
every "X" amount of boot's(maybe ten or so);
normally upon booting leaving me unable
to login.

below is dmesg of the message:

[    0.000000] Linux version 2.6.27-rc6 (root@unix) (gcc version 4.1.3
20080623 (prerelease) (Debian 4.1.2-23)) #22 SMP Tue Sep 9 18:46:38
PDT 2008
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
[    0.000000] last_pfn = 0x3f0ea max_arch_pfn = 0x100000
[    0.000000] kernel direct mapping tables up to 38000000 @ 7000-c000
[    0.000000] DMI 2.4 present.
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
[    0.000000] 112MB HIGHMEM available.
[    0.000000] 896MB LOWMEM available.
[    0.000000]   mapped low ram: 0 - 38000000
[    0.000000]   low ram: 00000000 - 38000000
[    0.000000]   bootmap 00008000 - 0000f000
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0038000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==>
[0000000000 - 0000001000]
[    0.000000]   #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==>
[0000001000 - 0000002000]
[    0.000000]   #2 [0000006000 - 0000007000]       TRAMPOLINE ==>
[0000006000 - 0000007000]
[    0.000000]   #3 [0000100000 - 00005eb520]    TEXT DATA BSS ==>
[0000100000 - 00005eb520]
[    0.000000]   #4 [00005ec000 - 00005ef000]    INIT_PG_TABLE ==>
[00005ec000 - 00005ef000]
[    0.000000]   #5 [000009fc00 - 0000100000]    BIOS reserved ==>
[000009fc00 - 0000100000]
[    0.000000]   #6 [0000007000 - 0000008000]          PGTABLE ==>
[0000007000 - 0000008000]
[    0.000000]   #7 [0000008000 - 000000f000]          BOOTMAP ==>
[0000008000 - 000000f000]
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000000 -> 0x00001000
[    0.000000]   Normal   0x00001000 -> 0x00038000
[    0.000000]   HighMem  0x00038000 -> 0x0003f0ea
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000000 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x0003f0ea
[    0.000000] On node 0 totalpages: 258185
[    0.000000] free_area_init_node: node 0, pgdat c04f05c0,
node_mem_map c1000000
[    0.000000]   DMA zone: 3967 pages, LIFO batch:0
[    0.000000]   Normal zone: 223520 pages, LIFO batch:31
[    0.000000]   HighMem zone: 28680 pages, LIFO batch:7
[    0.000000] Using APIC driver default
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Enabling APIC mode:  Flat.  Using 1 I/O APICs
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] mapped APIC to ffffb000 (fee00000)
[    0.000000] mapped IOAPIC to ffffa000 (fec00000)
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] Allocating PCI resources starting at 50000000 (gap:
40000000:b0000000)
[    0.000000] PERCPU: Allocating 47196 bytes of per cpu data
[    0.000000] NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.
Total pages: 256167
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.27-rc6 root=/dev/sda1 ro vga=790 debug
pnpacpi=off pci=routeirq acpi_osi=Darwin audit=1 selinux=1 enforcing=0
[    0.000000] ACPI: Added _OSI(Darwin)
[    0.000000] audit: enabled (after initialization)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] TSC: Unable to calibrate against PIT
[    0.000000] TSC: using PMTIMER reference calibration
[    0.000000] Detected 2161.243 MHz processor.
[    0.010000] Console: colour dummy device 80x25
[    0.010000] console [tty0] enabled
[    0.010000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.010000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.010000] Memory: 1018284k/1033128k available (2690k kernel code,
14096k reserved, 1409k data, 352k init, 115624k highmem)
[    0.010000] virtual kernel memory layout:
[    0.010000]     fixmap  : 0xfff82000 - 0xfffff000   ( 500 kB)
[    0.010000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.010000]     vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
[    0.010000]     lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
[    0.010000]       .init : 0xc0508000 - 0xc0560000   ( 352 kB)
[    0.010000]       .data : 0xc03a08cc - 0xc0500e90   (1409 kB)
[    0.010000]       .text : 0xc0100000 - 0xc03a08cc   (2690 kB)
[    0.010000] Checking if this processor honours the WP bit even in
supervisor mode...Ok.
[    0.010000] CPA: page pool initialized 1 of 1 pages preallocated
[    0.010000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0,
CPUs=2, Nodes=1
[    0.010000] hpet clockevent registered
[    0.010000] Calibrating delay loop (skipped), value calculated
using timer frequency.. 4322.48 BogoMIPS (lpj=21612430)
[    0.010000] Security Framework initialized
[    0.010000] SELinux:  Initializing.
[    0.010000] SELinux:  Starting in permissive mode
[    0.010000] Failure registering Root Plug module with the kernel
[    0.010000] Mount-cache hash table entries: 512
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 0
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#0.
[    0.010000] using mwait in idle threads.
[    0.010000] Checking 'hlt' instruction... OK.
[    0.041498] ACPI: Core revision 20080609
[    0.056953] Parsing all Control Methods:
[    0.057164] Table [DSDT](id 0001) - 691 Objects with 79 Devices 157
Methods 29 Regions
[    0.057643] Parsing all Control Methods:
[    0.057826] Table [SSDT](id 0002) - 13 Objects with 0 Devices 4
Methods 0 Regions
[    0.058224] Parsing all Control Methods:
[    0.058410] Table [SSDT](id 0003) - 10 Objects with 3 Devices 4
Methods 0 Regions
[    0.058834] Parsing all Control Methods:
[    0.059023] Table [SSDT](id 0004) - 11 Objects with 3 Devices 5
Methods 0 Regions
[    0.059031]  tbxface-0596 [02] tb_load_namespace     : ACPI Tables
successfully acquired
[    0.059287] evxfevnt-0091 [02] enable                : Transition
to ACPI mode successful
[    0.059564] ENABLING IO-APIC IRQs
[    0.059755] ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.159777] CPU0: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.160000] Booting processor 1/1 ip 6000
[    0.010000] Initializing CPU#1
[    0.010000] Calibrating delay using timer specific routine..
4322.51 BogoMIPS (lpj=21612565)
[    0.010000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.010000] CPU: L2 cache: 4096K
[    0.010000] CPU: Physical Processor ID: 0
[    0.010000] CPU: Processor Core ID: 1
[    0.010000] Intel machine check architecture supported.
[    0.010000] Intel machine check reporting enabled on CPU#1.
[    0.310673] CPU1: Intel(R) Core(TM)2 CPU         T7400  @ 2.16GHz stepping 06
[    0.310709] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.320025] Brought up 2 CPUs
[    0.320031] Total of 2 processors activated (8644.99 BogoMIPS).
[    0.320064] CPU0 attaching sched-domain:
[    0.320069]  domain 0: span 0-1 level MC
[    0.320073]   groups: 0 1
[    0.320082] CPU1 attaching sched-domain:
[    0.320086]  domain 0: span 0-1 level MC
[    0.320090]   groups: 1 0
[    0.320179] net_namespace: 648 bytes
[    0.320179] Booting paravirtualized kernel on bare hardware
[    0.320299] NET: Registered protocol family 16
[    0.320299] No dock devices found.
[    0.320299] EISA bus registered
[    0.320299] ACPI: bus type pci registered
[    0.320299] PCI: Using configuration type 1 for base access
[    0.320835] evgpeblk-0957 [04] ev_create_gpe_block   : GPE 00 to 1F
[_GPE] 4 regs on int 0x9
[    0.320991] ACPI: EC: EC description table is found, configuring boot EC
[    0.321229] ACPI: EC: non-query interrupt received, switching to
interrupt mode
[    0.340832] Completing Region/Field/Buffer/Package
initialization:...................................................................
[    0.344605] Initialized 27/29 Regions 0/0 Fields 21/21 Buffers
19/19 Packages (734 nodes)
[    0.344613] Initializing Device/Processor/Thermal objects by
executing _INI methods:..
[    0.345616] Executed 2 _INI methods requiring 0 _STA executions
(examined 89 objects)
[    0.346140] evgpeblk-1054 [03] ev_initialize_gpe_bloc: Found 7
Wake, Enabled 6 Runtime GPEs in this block
[    0.346192] ACPI: Interpreter enabled
[    0.346197] ACPI: (supports S0 S3 S4 S5)
[    0.346264] ACPI: Using IOAPIC for interrupt routing
[    0.361431] ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
[    0.361431] ACPI: EC: driver started in interrupt mode
[    0.361431] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.361431] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:01.0: PME# disabled
[    0.361431] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:1b.0: PME# disabled
[    0.361431] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:1c.0: PME# disabled
[    0.361431] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:1c.1: PME# disabled
[    0.361431] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:1c.2: PME# disabled
[    0.361431] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.361431] pci 0000:00:1d.7: PME# disabled
[    0.361431] pci 0000:00:1f.0: quirk: region 0400-047f claimed by
ICH6 ACPI/GPIO/TCO
[    0.361431] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.361431] pci 0000:00:1f.2: PME# supported from D3hot
[    0.361431] pci 0000:00:1f.2: PME# disabled
[    0.361431] pci 0000:01:00.0: supports D1
[    0.361431] pci 0000:01:00.0: supports D2
[    0.361468] PCI: bridge 0000:00:01.0 io port: [3000, 3fff]
[    0.361473] PCI: bridge 0000:00:01.0 32bit mmio: [50300000, 503fffff]
[    0.361481] PCI: bridge 0000:00:01.0 64bit mmio pref: [40000000, 47ffffff]
[    0.361641] pci 0000:02:00.0: supports D1
[    0.361645] pci 0000:02:00.0: supports D2
[    0.361649] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.361657] pci 0000:02:00.0: PME# disabled
[    0.361710] PCI: bridge 0000:00:1c.0 io port: [2000, 2fff]
[    0.361717] PCI: bridge 0000:00:1c.0 32bit mmio: [50200000, 502fffff]
[    0.361875] pci 0000:03:00.0: supports D1
[    0.361879] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.361888] pci 0000:03:00.0: PME# disabled
[    0.361943] PCI: bridge 0000:00:1c.1 32bit mmio: [50100000, 501fffff]
[    0.362012] PCI: bridge 0000:00:1c.2 io port: [1000, 1fff]
[    0.362019] PCI: bridge 0000:00:1c.2 32bit mmio: [4c100000, 500fffff]
[    0.362030] PCI: bridge 0000:00:1c.2 64bit mmio pref: [48000000, 4bffffff]
[    0.362154] pci 0000:0c:03.0: supports D1
[    0.362157] pci 0000:0c:03.0: supports D2
[    0.362161] pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
[    0.362169] pci 0000:0c:03.0: PME# disabled
[    0.362224] pci 0000:00:1e.0: transparent bridge
[    0.362234] PCI: bridge 0000:00:1e.0 32bit mmio: [4c000000, 4c0fffff]
[    0.362272] bus 00 -> node 0
[    0.362285] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.364070] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
[    0.370571] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.371137] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.371700] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
[    0.372288] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.391130] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.391130] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.391130] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12
14 15) *11
[    0.391130] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.391326] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12
14 15) *0, disabled.
[    0.391597] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12
14 15) *0, disabled.
[    0.391868] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.392136] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
[    0.392259] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.392259] pnp: PnP ACPI: disabled
[    0.392259] SCSI subsystem initialized
[    0.392259] libata version 3.00 loaded.
[    0.392259] usbcore: registered new interface driver usbfs
[    0.392259] usbcore: registered new interface driver hub
[    0.392259] usbcore: registered new device driver usb
[    0.400047] PCI: Using ACPI for IRQ routing
[    0.400047] PCI: Routing PCI interrupts for all devices because
"pci=routeirq" specified
[    0.400047] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.400047] pci 0000:00:07.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.400047] pci 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.400052] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.400059] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.400067] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.400075] pci 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.400083] pci 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.400090] pci 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.400097] pci 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[    0.400104] pci 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    0.400115] pci 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.400123] pci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.400130] pci 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.400137] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.400144] pci 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.400151] pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.400159] pci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.430036] NetLabel: Initializing
[    0.430040] NetLabel:  domain hash size = 128
[    0.430044] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.430111] NetLabel:  unlabeled traffic allowed by default
[    0.430122] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.430129] hpet0: 3 64-bit timers, 14318180 Hz
[    0.481350] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.481356] pci 0000:00:01.0:   IO window: 0x3000-0x3fff
[    0.481363] pci 0000:00:01.0:   MEM window: 0x50300000-0x503fffff
[    0.481369] pci 0000:00:01.0:   PREFETCH window:
0x00000040000000-0x00000047ffffff
[    0.481379] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
[    0.481385] pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
[    0.481393] pci 0000:00:1c.0:   MEM window: 0x50200000-0x502fffff
[    0.481401] pci 0000:00:1c.0:   PREFETCH window:
0x00000050500000-0x000000505fffff
[    0.481412] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
[    0.481416] pci 0000:00:1c.1:   IO window: disabled
[    0.481425] pci 0000:00:1c.1:   MEM window: 0x50100000-0x501fffff
[    0.481432] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.481442] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
[    0.481448] pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
[    0.481456] pci 0000:00:1c.2:   MEM window: 0x4c100000-0x500fffff
[    0.481464] pci 0000:00:1c.2:   PREFETCH window:
0x00000048000000-0x0000004bffffff
[    0.481476] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
[    0.481480] pci 0000:00:1e.0:   IO window: disabled
[    0.481488] pci 0000:00:1e.0:   MEM window: 0x4c000000-0x4c0fffff
[    0.481495] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.481510] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.481516] pci 0000:00:01.0: setting latency timer to 64
[    0.481527] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.481535] pci 0000:00:1c.0: setting latency timer to 64
[    0.481546] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.481554] pci 0000:00:1c.1: setting latency timer to 64
[    0.481565] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.481573] pci 0000:00:1c.2: setting latency timer to 64
[    0.486004] pci 0000:00:1e.0: power state changed by ACPI to D0
[    0.486015] pci 0000:00:1e.0: setting latency timer to 64
[    0.486021] bus: 00 index 0 io port: [0, ffff]
[    0.486026] bus: 00 index 1 mmio: [0, ffffffffffffffff]
[    0.486030] bus: 01 index 0 io port: [3000, 3fff]
[    0.486035] bus: 01 index 1 mmio: [50300000, 503fffff]
[    0.486040] bus: 01 index 2 mmio: [40000000, 47ffffff]
[    0.486044] bus: 01 index 3 mmio: [0, 0]
[    0.486048] bus: 02 index 0 io port: [2000, 2fff]
[    0.486053] bus: 02 index 1 mmio: [50200000, 502fffff]
[    0.486058] bus: 02 index 2 mmio: [50500000, 505fffff]
[    0.486062] bus: 02 index 3 mmio: [0, 0]
[    0.486066] bus: 03 index 0 mmio: [0, 0]
[    0.486070] bus: 03 index 1 mmio: [50100000, 501fffff]
[    0.486075] bus: 03 index 2 mmio: [0, 0]
[    0.486079] bus: 03 index 3 mmio: [0, 0]
[    0.486083] bus: 04 index 0 io port: [1000, 1fff]
[    0.486087] bus: 04 index 1 mmio: [4c100000, 500fffff]
[    0.486092] bus: 04 index 2 mmio: [48000000, 4bffffff]
[    0.486097] bus: 04 index 3 mmio: [0, 0]
[    0.486101] bus: 0c index 0 mmio: [0, 0]
[    0.486105] bus: 0c index 1 mmio: [4c000000, 4c0fffff]
[    0.486109] bus: 0c index 2 mmio: [0, 0]
[    0.486113] bus: 0c index 3 io port: [0, ffff]
[    0.486118] bus: 0c index 4 mmio: [0, ffffffffffffffff]
[    0.486136] NET: Registered protocol family 2
[    0.500729] Switched to high resolution mode on CPU 1
[    0.510002] Switched to high resolution mode on CPU 0
[    0.520076] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.520384] TCP established hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.520823] TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
[    0.521382] TCP: Hash tables configured (established 131072 bind 65536)
[    0.521388] TCP reno registered
[    0.530151] NET: Registered protocol family 1
[    0.532306] IA-32 Microcode Update Driver: v1.14a
<tigran@aivazian.fsnet.co.uk>
[    0.534335] Initializing RT-Tester: OK
[    0.534438] audit: initializing netlink socket (enabled)
[    0.534502] type=2000 audit(1221071091.530:1): initialized
[    0.539778] highmem bounce pool size: 64 pages
[    0.539787] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.554576] fuse init (API version 7.9)
[    0.555134] msgmni has been set to 1763
[    0.555361] SELinux:  Registering netfilter hooks
[    0.555586] io scheduler noop registered
[    0.555900] io scheduler cfq registered (default)
[    0.556033] pci 0000:01:00.0: Boot video device
[    0.556547] vesafb: framebuffer at 0x40000000, mapped to
0xf8880000, using 3072k, total 16384k
[    0.556554] vesafb: mode is 1024x768x16, linelength=2048, pages=9
[    0.556559] vesafb: protected mode interface info at c000:ad0c
[    0.556564] vesafb: pmi: set display start = c00cad94, set palette = c00cae50
[    0.556569] vesafb: scrolling: redraw
[    0.556573] vesafb: Truecolor: size=0:5:5:5, shift=0:10:5:0
[    0.580921] Console: switching to colour frame buffer device 128x48
[    0.603204] fb0: VESA VGA frame buffer device
[    0.613625] hpet_resources: 0xfed00000 is busy
[    0.615863] loop: module loaded
[    0.616016] Linux video capture interface: v2.00
[    0.616450] input: Macintosh mouse button emulation as /class/input/input0
[    0.617044] Driver 'sd' needs updating - please use bus_type methods
[    0.617419] Driver 'sr' needs updating - please use bus_type methods
[    0.618033] ata_piix 0000:00:1f.1: version 2.12
[    0.618342] ata_piix 0000:00:1f.1: power state changed by ACPI to D0
[    0.618642] ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.619017] ata_piix 0000:00:1f.1: setting latency timer to 64
[    0.619395] scsi0 : ata_piix
[    0.620186] scsi1 : ata_piix
[    0.622321] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
[    0.622652] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
[    0.800593] ata1.00: ATAPI: MATSHITADVD-R   UJ-857D, KCV9, max UDMA/66
[    0.840544] ata1.00: configured for UDMA/66
[    1.012843] scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R
UJ-857D  KCV9 PQ: 0 ANSI: 5
[    1.025810] sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
[    1.034425] Uniform CD-ROM driver Revision: 3.20
[    1.043211] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    1.051963] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    1.060361] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    1.068807] ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
[    1.230016] ata_piix 0000:00:1f.2: setting latency timer to 64
[    1.238469] scsi2 : ata_piix
[    1.246860] scsi3 : ata_piix
[    1.258393] ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
[    1.266699] ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
[    1.460505] ata3.01: ATA-8: FUJITSU MHW2120BH, 00810013, max UDMA/100
[    1.468699] ata3.01: 234441648 sectors, multi 16: LBA48 NCQ (depth 0/32)
[    1.510510] ata3.01: configured for UDMA/100
[    1.681230] scsi 2:0:1:0: Direct-Access     ATA      FUJITSU
MHW2120B 0081 PQ: 0 ANSI: 5
[    1.690079] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    1.698721] sd 2:0:1:0: [sda] Write Protect is off
[    1.707200] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.715560] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.724165] sd 2:0:1:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
[    1.732700] sd 2:0:1:0: [sda] Write Protect is off
[    1.741068] sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
[    1.749413] sd 2:0:1:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    1.758009]  sda: sda1 sda2
[    1.767144] sd 2:0:1:0: [sda] Attached SCSI disk
[    1.775763] sd 2:0:1:0: Attached scsi generic sg1 type 0
[    1.784355] usbcore: registered new interface driver usblcd
[    1.792895] usbcore: registered new interface driver usbled
[    1.801592] PNP: No PS/2 controller found. Probing ports directly.
[    1.810799] i8042.c: No controller found.
[    1.830212] mice: PS/2 mouse device common for all mice
[    1.839368] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23)
initialised: dm-devel@redhat.com
[    1.848048] EDAC MC: Ver: 2.1.0 Sep  9 2008
[    1.857129] cpuidle: using governor ladder
[    1.865761] cpuidle: using governor menu
[    1.874358] usbcore: registered new interface driver hiddev
[    1.883027] usbcore: registered new interface driver usbhid
[    1.891615] usbhid: v2.6:USB HID core driver
[    1.900228] Advanced Linux Sound Architecture Driver Version 1.0.17.
[    1.908997] ALSA device list:
[    1.917655]   No soundcards found.
[    1.926385] oprofile: using NMI interrupt.
[    1.935398] IPVS: Registered protocols (TCP, AH, ESP)
[    1.943891] IPVS: Connection hash table configured (size=4096,
memory=32Kbytes)
[    1.952397] IPVS: ipvs loaded.
[    1.960755] Initializing XFRM netlink socket
[    1.960768] NET: Registered protocol family 17
[    1.960776] NET: Registered protocol family 15
[    1.960789] Using IPI No-Shortcut mode
[    1.997023] kjournald starting.  Commit interval 5 seconds
[    2.005319] EXT3-fs: mounted filesystem with ordered data mode.
[    2.013835] VFS: Mounted root (ext3 filesystem) readonly.
[    2.022502] Freeing unused kernel memory: 352k freed
[    2.804599] SELinux: 8192 avtab hash slots, 167871 rules.
[    2.911902] SELinux: 8192 avtab hash slots, 167871 rules.
[    3.098403] SELinux:  7 users, 9 roles, 3147 types, 98 bools
[    3.106770] SELinux:  73 classes, 167871 rules
[    3.121740] SELinux:  Completing initialization.
[    3.129781] SELinux:  Setting up existing superblocks.
[    3.169143] SELinux: initialized (dev sda1, type ext3), uses xattr
[    3.281644] SELinux: initialized (dev selinuxfs, type selinuxfs),
uses genfs_contexts
[    3.289709] SELinux: initialized (dev mqueue, type mqueue), uses
transition SIDs
[    3.297769] SELinux: initialized (dev hugetlbfs, type hugetlbfs),
uses genfs_contexts
[    3.305912] SELinux: initialized (dev devpts, type devpts), uses
transition SIDs
[    3.313956] SELinux: initialized (dev inotifyfs, type inotifyfs),
uses genfs_contexts
[    3.321904] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    3.329860] SELinux: initialized (dev anon_inodefs, type
anon_inodefs), uses genfs_contexts
[    3.337996] SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
[    3.346082] SELinux: initialized (dev debugfs, type debugfs), uses
genfs_contexts
[    3.354379] SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
[    3.362595] SELinux: initialized (dev proc, type proc), uses genfs_contexts
[    3.370767] SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
[    3.378793] SELinux: initialized (dev rootfs, type rootfs), uses
genfs_contexts
[    3.386721] SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
[    3.435569] type=1403 audit(1221071094.430:2): policy loaded
auid=4294967295 ses=4294967295
[    4.454392] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    4.467776] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[    8.859873] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   10.770496] input: Power Button (FF) as /class/input/input1
[   10.808646] ACPI: Power Button (FF) [PWRF]
[   10.817684] input: Lid Switch as /class/input/input2
[   10.826682] ACPI: Lid Switch [LID0]
[   10.835844] input: Power Button (CM) as /class/input/input3
[   10.848404] USB Universal Host Controller Interface driver v3.0
[   10.857709] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   10.867186] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[   10.876344] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   10.885571] SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
[   10.894904] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 1
[   10.904218] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
[   10.913838] usb usb1: configuration #1 chosen from 1 choice
[   10.923378] hub 1-0:1.0: USB hub found
[   10.932676] hub 1-0:1.0: 2 ports detected
[   10.980723] ACPI: Power Button (CM) [PWRB]
[   10.990286] input: Sleep Button (CM) as /class/input/input4
[   11.030137] ACPI: Sleep Button (CM) [SLPB]
[   11.051390] ACPI: SSDT 3FEB8C10, 02AE (r1 APPLE   Cpu0Ist     3000
INTL 20050309)
[   11.061078] Parsing all Control Methods:
[   11.061457] Table [SSDT](id 0020) - 5 Objects with 0 Devices 3
Methods 0 Regions
[   11.080923] ACPI: SSDT 3FEB8910, 02A0 (r1 APPLE   Cpu0Cst     3001
INTL 20050309)
[   11.090677] Parsing all Control Methods:
[   11.091058] Table [SSDT](id 0021) - 1 Objects with 0 Devices 1
Methods 0 Regions
[   11.110655] Monitor-Mwait will be used to enter C-1 state
[   11.120309] Monitor-Mwait will be used to enter C-2 state
[   11.129769] Monitor-Mwait will be used to enter C-3 state
[   11.139273] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[   11.148712] processor ACPI0007:00: registered as cooling_device0
[   11.158268] ACPI: Processor [CPU0] (supports 8 throttling states)
[   11.169297] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
INTL 20050309)
[   11.179155] Parsing all Control Methods:
[   11.179527] Table [SSDT](id 0025) - 3 Objects with 0 Devices 3
Methods 0 Regions
[   11.198945] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
INTL 20050309)
[   11.208555] Parsing all Control Methods:
[   11.208928] Table [SSDT](id 0026) - 1 Objects with 0 Devices 1
Methods 0 Regions
[   11.228619] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[   11.229374] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[   11.229417] processor ACPI0007:01: registered as cooling_device1
[   11.229423] ACPI: Processor [CPU1] (supports 8 throttling states)
[   11.229669] power_supply ADP1: uevent
[   11.229670] power_supply ADP1: No power supply yet
[   11.229689] power_supply ADP1: power_supply_changed
[   11.229695] ACPI: AC Adapter [ADP1] (on-line)
[   11.229767] power_supply ADP1: power_supply_changed_work
[   11.229769] power_supply ADP1: power_supply_update_gen_leds 1
[   11.229783] power_supply ADP1: uevent
[   11.229784] power_supply ADP1: POWER_SUPPLY_NAME=ADP1
[   11.229788] power_supply ADP1: Static prop TYPE=Mains
[   11.229791] power_supply ADP1: 1 dynamic props
[   11.229793] power_supply ADP1: prop ONLINE=1
[   11.282504] Marking TSC unstable due to TSC halts in idle
[   11.366808] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[   11.366812] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   11.366884] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 2
[   11.366918] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
[   11.367102] usb usb2: configuration #1 chosen from 1 choice
[   11.367161] hub 2-0:1.0: USB hub found
[   11.367172] hub 2-0:1.0: 2 ports detected
[   11.492814] usb 1-2: new full speed USB device using uhci_hcd and address 2
[   11.520657] input: Video Bus as /class/input/input5
[   11.542967] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   11.580371] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[   11.588956] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[   11.597356] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   11.605628] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 3
[   11.613980] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
[   11.622263] usb usb3: configuration #1 chosen from 1 choice
[   11.630593] hub 3-0:1.0: USB hub found
[   11.638961] hub 3-0:1.0: 2 ports detected
[   11.639197] ath_hal: module license 'Proprietary' taints kernel.
[   11.655703] ath_hal: 0.9.30.13 (AR5210, AR5211, AR5212, AR5416,
RF5111, RF5112, RF2413, RF5413, RF2133)
[   11.722843] usb 1-2: configuration #1 chosen from 1 choice
[   11.737773] Linux agpgart interface v0.103
[   11.746556] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input6
[   11.760233] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   11.776939] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input7
[   11.788762] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   11.870464] uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
[   11.879542] uhci_hcd 0000:00:1d.3: setting latency timer to 64
[   11.888467] uhci_hcd 0000:00:1d.3: UHCI Host Controller
[   11.897279] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned
bus number 4
[   11.906222] uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
[   11.915197] usb usb4: configuration #1 chosen from 1 choice
[   11.924087] usb 2-2: new full speed USB device using uhci_hcd and address 2
[   11.924125] hub 4-0:1.0: USB hub found
[   11.924137] hub 4-0:1.0: 2 ports detected
[   12.020089] wlan: svn r3359
[   12.119258] usb 2-2: configuration #1 chosen from 1 choice
[   12.140614] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[   12.149917] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[   12.159523] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   12.168858] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 5
[   12.182246] ehci_hcd 0000:00:1d.7: debug port 1
[   12.191574] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[   12.200970] ehci_hcd 0000:00:1d.7: irq 23, io mem 0x50405400
[   12.250079] usb 3-2: new full speed USB device using uhci_hcd and address 2
[   12.270062] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00,
driver 10 Dec 2004
[   12.279955] usb usb5: configuration #1 chosen from 1 choice
[   12.289791] hub 5-0:1.0: USB hub found
[   12.299531] hub 5-0:1.0: 8 ports detected
[   12.309416] ath_pci: svn r3359
[   12.332576] hub 3-0:1.0: unable to enumerate USB device on port 2
[   12.356208] ACPI: SBS HC: EC = 0xf78c8000, offset = 0x20, query_bit = 0x10
[   12.478925] Symbol init_mm is marked as UNUSED, however this module
is using it.
[   12.488823] This symbol will go away in the future.
[   12.498834] Please evalute if this is the right api to use and if
it really is, submit a report the linux kernel mailinglist together
with submitting your code for inclusion.
[   12.521465] ohci1394 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[   12.583102] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]
MMIO=[4c004000-4c0047ff]  Max Packet=[4096]  IR/IT contexts=[4/8]
[   12.625215] [fglrx] Maximum main memory to use for locked dma
buffers: 913 MBytes.
[   12.636343] [fglrx] ASYNCIO init succeed!
[   12.648518] ath_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   12.649263] [fglrx] PAT is enabled successfully!
[   12.649322] [fglrx] module loaded - fglrx 8.47.3 [Mar 29 2008] on minor 0
[   12.681830] ath_pci 0000:03:00.0: setting latency timer to 64
[   12.722533] usb 1-2: USB disconnect, address 2
[   12.822468] MadWifi: ath_attach: Switching rfkill capability off
[   12.912800] ath_rate_sample: 1.2 (svn r3359)
[   12.981962] MadWifi: ath_attach: Switching per-packet transmit
power control off
[   12.992999] wifi0: 11a rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   13.003551] wifi0: 11b rates: 1Mbps 2Mbps 5.5Mbps 11Mbps
[   13.013807] wifi0: 11g rates: 1Mbps 2Mbps 5.5Mbps 11Mbps 6Mbps
9Mbps 12Mbps 18Mbps 24Mbps 36Mbps 48Mbps 54Mbps
[   13.017330] usb 2-2: USB disconnect, address 2
[   13.035220] wifi0: turboA rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   13.035225] wifi0: turboG rates: 6Mbps 9Mbps 12Mbps 18Mbps 24Mbps
36Mbps 48Mbps 54Mbps
[   13.035231] wifi0: H/W encryption support: WEP AES AES_CCM TKIP
[   13.035241] wifi0: ath_announce: Use hw queue 1 for WME_AC_BE traffic
[   13.035243] wifi0: ath_announce: Use hw queue 0 for WME_AC_BK traffic
[   13.035245] wifi0: ath_announce: Use hw queue 2 for WME_AC_VI traffic
[   13.035247] wifi0: ath_announce: Use hw queue 3 for WME_AC_VO traffic
[   13.035249] wifi0: ath_announce: Use hw queue 8 for CAB traffic
[   13.035250] wifi0: ath_announce: Use hw queue 9 for beacons
[   13.197145] ath_pci: wifi0: Atheros 5418: mem=0x50100000, irq=17
[   13.300084] usb 5-4: new high speed USB device using ehci_hcd and address 3
[   13.323536] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level,
low) -> IRQ 22
[   13.334118] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   13.421466] hda_codec: STAC922x, Apple subsys_id=106b1e00
[   13.461784] usb 5-4: configuration #1 chosen from 1 choice
[   13.710743] usbcore: registered new interface driver appletouch
[   13.720999] uvcvideo: Found UVC 1.00 device Built-in iSight (05ac:8501)
[   13.737280] uvcvideo: Failed to query (135) UVC control 1 (unit 0)
: -32 (exp. 26).
[   13.762303] input: Built-in iSight as /class/input/input8
[   13.840329] usbcore: registered new interface driver uvcvideo
[   13.851106] USB Video Class driver (v0.1.0)
[   13.960423] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0019e3fffe2ad87e]
[   13.990048] usb 1-2: new full speed USB device using uhci_hcd and address 3
[   14.007545] Clocksource tsc unstable (delta = -164149375 ns)
[   14.184981] usb 1-2: configuration #1 chosen from 1 choice
[   14.201076] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input9
[   14.232688] input: USB HID v1.11 Keyboard [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   14.246738] appletouch: Geyser mode initialized.
[   14.256692] input: appletouch as /class/input/input10
[   14.285802] input: Apple Computer Apple Internal Keyboard /
Trackpad as /class/input/input11
[   14.322683] input: USB HID v1.11 Device [Apple Computer Apple
Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
[   14.610070] usb 3-2: new full speed USB device using uhci_hcd and address 3
[   14.805401] usb 3-2: configuration #1 chosen from 1 choice
[   14.824413] hiddev0: USB HID v1.11 Device [Apple Computer, Inc. IR
Receiver] on usb-0000:00:1d.2-2
[   15.110069] usb 4-1: new full speed USB device using uhci_hcd and address 2
[   15.313519] usb 4-1: configuration #1 chosen from 1 choice
[   15.346683] drivers/hid/usbhid/hid-core.c: couldn't find an input
interrupt endpoint
[   15.887778] SELinux: initialized (dev tmpfs, type tmpfs), uses
transition SIDs
[   16.044479] applesmc: Apple MacBook Pro detected:
[   16.068174] ehci_hcd 0000:00:1d.7: HC died; cleaning up
[   16.078650] applesmc:  - Model with accelerometer
[   16.089021] applesmc:  - Model with light sensors and backlight
[   16.099373] applesmc:  - Model with 12 temperature sensors
[   16.110175] applesmc: device has already been initialized (0xe0, 0x00).
[   16.120862] applesmc: device successfully initialized.
[   16.132118] applesmc: 2 fans found.
[   16.144085] input: applesmc as /class/input/input12
[   16.155047] hub 5-0:1.0: hub_port_status failed (err = -19)
[   16.166001] hub 5-0:1.0: connect-debounce failed, port 4 disabled
[   16.176912] usb 5-4: USB disconnect, address 3
[   16.243763] Registered led device: smc::kbd_backlight
[   16.254874] applesmc: driver successfully loaded.
[   16.532514] ip_tables: (C) 2000-2006 Netfilter Core Team
[   16.673980] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   16.685309] CONFIG_NF_CT_ACCT is deprecated and will be removed
soon. Plase use
[   16.696181] nf_conntrack.acct=1 kernel paramater, acct=1
nf_conntrack module option or
[   16.707156] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[   16.772144] arp_tables: (C) 2002 David S. Miller
[   16.856175] ieee80211_crypt: registered algorithm 'NULL'
[   16.906033] ieee80211: 802.11 data/management/control stack, git-1.1.13
[   16.917189] ieee80211: Copyright (C) 2004-2005 Intel Corporation
<jketreno@linux.intel.com>
[   16.945082] ieee80211_crypt: registered algorithm 'TKIP'
[   17.044986] usbcore: registered new interface driver isight_firmware
[   17.096349] ipmi message handler version 39.2
[   17.128097] IPMI Watchdog: driver initialized
[   17.280392] NET: Registered protocol family 8
[   17.291283] NET: Registered protocol family 20
[   17.574033] Adding 2980048k swap on /dev/sda2.  Priority:-1
extents:1 across:2980048k
[   18.233061] EXT3 FS on sda1, internal journal
[   18.694762] SELinux: initialized (dev fusectl, type fusectl), uses
genfs_contexts
[   18.821797] irq 23: nobody cared (try booting with the "irqpoll" option)
[   18.830005] Pid: 2371, comm: swapon Tainted: P          2.6.27-rc6 #22
[   18.830005]  [<c0151748>] __report_bad_irq+0x2e/0x6f
[   18.830005]  [<c015196f>] note_interrupt+0x1e6/0x217
[   18.830005]  [<c0150d47>] ? handle_IRQ_event+0x2a/0x5a
[   18.830005]  [<c0151f20>] handle_fasteoi_irq+0x91/0xb6
[   18.830005]  [<c0104ff2>] do_IRQ+0x6c/0x86
[   18.830005]  [<c0103a6f>] common_interrupt+0x23/0x28
[   18.830005]  [<c021007b>] ? blkdev_ioctl+0x4b0/0x719
[   18.830005]  [<c0117347>] ? kunmap_atomic+0x4/0xa5
[   18.830005]  [<c015fc58>] __do_fault+0x2ca/0x32a
[   18.830005]  [<c0170cf0>] ? check_bytes_and_report+0x21/0x93
[   18.830005]  [<c0161191>] handle_mm_fault+0x2de/0x62c
[   18.830005]  [<c01635e3>] ? remove_vma+0x41/0x47
[   18.830005]  [<c01727d0>] ? kmem_cache_free+0x80/0x96
[   18.830005]  [<c039ebac>] do_page_fault+0x2d8/0x60c
[   18.830005]  [<c0127a95>] ? irq_exit+0x53/0x6d
[   18.830005]  [<c039e8d4>] ? do_page_fault+0x0/0x60c
[   18.830005]  [<c039d2a2>] error_code+0x72/0x78
[   18.830005]  =======================
[   18.830005] handlers:
[   18.830005] [<c02cc9fb>] (usb_hcd_irq+0x0/0x79)
[   18.830005] [<c02cc9fb>] (usb_hcd_irq+0x0/0x79)
[   18.830005] Disabling IRQ #23
[   24.999393] Bluetooth: Core ver 2.13
[   25.012726] NET: Registered protocol family 31
[   25.019322] Bluetooth: HCI device and connection manager initialized
[   25.025787] Bluetooth: HCI socket layer initialized
[   25.083282] Bluetooth: L2CAP ver 2.11
[   25.089601] Bluetooth: L2CAP socket layer initialized
[   25.249684] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[   25.276333] usb 4-1: usbfs: USBDEVFS_CONTROL failed cmd hid2hci rqt
64 rq 0 len 0 ret -84
[   25.304612] Bluetooth: RFCOMM socket layer initialized
[   25.311413] Bluetooth: RFCOMM TTY layer initialized
[   25.318117] Bluetooth: RFCOMM ver 1.10
[   25.450080] usb 4-1: USB disconnect, address 2
[   27.279886] type=1400 audit(1221071118.852:3): avc:  denied  {
search } for  pid=3385 comm="dhclient" name="/" dev=tmpfs ino=1668
scontext=system_u:system_r:dhcpc_t tcontext=system_u:object_r:tmpfs_t
tclass=dir
[   27.310842] type=1300 audit(1221071118.852:3): arch=40000003
syscall=5 success=yes exit=3 a0=8095756 a1=2 a2=0 a3=8095640 items=0
ppid=3377 pid=3385 auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0
egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295 comm="dhclient"
exe="/sbin/dhclient3" subj=system_u:system_r:dhcpc_t key=(null)
[   27.347165] type=1400 audit(1221071118.922:4): avc:  denied  {
write } for  pid=3385 comm="dhclient" name="log" dev=tmpfs ino=6840
scontext=system_u:system_r:dhcpc_t tcontext=system_u:object_r:tmpfs_t
tclass=sock_file
[   27.372582] type=1300 audit(1221071118.922:4): arch=40000003
syscall=102 success=yes exit=0 a0=3 a1=bf8a9d20 a2=b7f81ff4 a3=1
items=0 ppid=3377 pid=3385 auid=4294967295 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="dhclient" exe="/sbin/dhclient3" subj=system_u:system_r:dhcpc_t
key=(null)
[   30.530122] CPA self-test:
[   30.544060]  4k 1024 large 223 gb 0 x 1247[c0000000-f7c00000] miss 0
[   30.575925]  4k 200704 large 28 gb 0 x 200732[c0000000-f7fff000] miss 0
[   30.603716]  4k 200704 large 28 gb 0 x 200732[c0000000-f7fff000] miss 0
[   30.617656] ok.
[   41.176500] type=1400 audit(1221071132.752:5): avc:  denied  {
write } for  pid=3407 comm="dhclient" name="/" dev=tmpfs ino=1423
scontext=system_u:system_r:dhcpc_t tcontext=system_u:object_r:tmpfs_t
tclass=dir
[   41.206052] type=1400 audit(1221071132.752:5): avc:  denied  {
add_name } for  pid=3407 comm="dhclient" name="dhclient.pid"
scontext=system_u:system_r:dhcpc_t tcontext=system_u:object_r:tmpfs_t
tclass=dir
[   41.237733] type=1400 audit(1221071132.752:5): avc:  denied  {
create } for  pid=3407 comm="dhclient" name="dhclient.pid"
scontext=system_u:system_r:dhcpc_t tcontext=system_u:object_r:tmpfs_t
tclass=file
[   41.270956] type=1400 audit(1221071132.752:5): avc:  denied  {
write } for  pid=3407 comm="dhclient" name="dhclient.pid" dev=tmpfs
ino=8275 scontext=system_u:system_r:dhcpc_t
tcontext=system_u:object_r:tmpfs_t tclass=file
[   41.305976] type=1300 audit(1221071132.752:5): arch=40000003
syscall=5 success=yes exit=8 a0=8095bdc a1=241 a2=1a4 a3=80aed38
items=0 ppid=1 pid=3407 auid=4294967295 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="dhclient" exe="/sbin/dhclient3" subj=system_u:system_r:dhcpc_t
key=(null)
[   41.360472] type=1400 audit(1221071132.943:6): avc:  denied  {
getattr } for  pid=3407 comm="dhclient" path="/var/run/dhclient.pid"
dev=tmpfs ino=8275 scontext=system_u:system_r:dhcpc_t
tcontext=system_u:object_r:tmpfs_t tclass=file
[   41.396947] type=1300 audit(1221071132.943:6): arch=40000003
syscall=197 success=yes exit=0 a0=8 a1=bf8a8758 a2=b7f81ff4 a3=80b14c0
items=0 ppid=1 pid=3407 auid=4294967295 uid=0 gid=0 euid=0 suid=0
fsuid=0 egid=0 sgid=0 fsgid=0 tty=(none) ses=4294967295
comm="dhclient" exe="/sbin/dhclient3" subj=system_u:system_r:dhcpc_t
key=(null)
[   68.975724] type=1400 audit(1221071160.557:7): avc:  denied  {
write } for  pid=3499 comm="bash" name="a-12" dev=sda1 ino=11190274
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_home_dir_t
tclass=dir
[   69.010170] type=1400 audit(1221071160.557:7): avc:  denied  {
add_name } for  pid=3499 comm="bash" name="yes"
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_home_dir_t
tclass=dir
[   69.046605] type=1400 audit(1221071160.557:7): avc:  denied  {
create } for  pid=3499 comm="bash" name="yes"
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_home_dir_t
tclass=file
[   69.084960] type=1400 audit(1221071160.557:7): avc:  denied  {
write } for  pid=3499 comm="bash" name="yes" dev=sda1 ino=11190792
scontext=a-12:user_r:user_t tcontext=a-12:object_r:sysadm_home_dir_t
tclass=file
[   69.125169] type=1300 audit(1221071160.557:7): arch=40000003
syscall=5 success=yes exit=3 a0=80fe228 a1=8241 a2=1b6 a3=8241 items=0
ppid=3489 pid=3499 auid=4294967295 uid=1000 gid=1000 euid=1000
suid=1000 fsuid=1000 egid=1000 sgid=1000 fsgid=1000 tty=pts0
ses=4294967295 comm="bash" exe="/bin/bash" subj=a-12:user_r:user_t
key=(null)

if I need to send an attachment let me know

regards;
-- 
Justin P. Mattock
