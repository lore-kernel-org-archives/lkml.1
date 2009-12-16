Return-Path: <linux-kernel-owner+w=401wt.eu-S933058AbZLPP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbZLPP5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 10:57:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZLPP5r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 10:57:47 -0500
Received: from smtp28.orange.fr ([80.12.242.99]:9344 "EHLO smtp28.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760170AbZLPP5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 10:57:44 -0500
X-ME-UUID: 20091216155740371.5AB737000516@mwinf2804.orange.fr
Subject: No PCI-X / PCI-E cards on Intel Bigby-P MCH / ICH9R
From: Xavier Bestel <xavier.bestel@free.fr>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Wed, 16 Dec 2009 16:57:37 +0100
Message-Id: <1260979057.23135.70.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a Tyan Bigby-P S5217, with a stock debian 2.6.31 kernel, which
apparently doesn't "see" the cards I plug (it sees its internal
peripherals fine).

I first plugged a wifi PCI card into a PCI-X slot (there's no PCI slot),
it didn't appear in lspci. As I thought it was a voltage problem (PCI-X
only accept 3.3v, not 5v IIRC) I bought a PCI-E one.
It's still not seen in lspci.

The only maybe-kind-of relevant things I see in dmesg are:

[    0.162705] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 16
[    0.164635] PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
[    0.164722] PCI: Not using MMCONFIG.

[    0.184095] PCI: Using ACPI for IRQ routing
[    0.184098] pci 0000:00:1c.0: BAR 13: can't allocate resource


Does anyone know what I can do to pinpoint the problem ?

Thanks,
	Xav


PS: lspci & dmesg follow, please Cc: me on answers.


00:00.0 Host bridge: Intel Corporation 3200/3210 Chipset DRAM Controller (rev 01)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #4 (rev 02)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #5 (rev 02)
00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #6 (rev 02)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #2 (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 1 (rev 02)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 5 (rev 02)
00:1c.5 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port 6 (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI Controller #3 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI Controller #1 (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 92)
00:1f.0 ISA bridge: Intel Corporation 82801IR (ICH9R) LPC Interface Controller (rev 02)
00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (ICH9R/DO/DH) 6 port SATA AHCI Controller (rev 02)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 02)
00:1f.6 Signal processing controller: Intel Corporation 82801I (ICH9 Family) Thermal Subsystem (rev 02)
0d:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
0f:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet Controller
11:03.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)





[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.31-1-amd64 (Debian 2.6.31-2) (ben@decadent.org.uk) (gcc version 4.3.4 (Debian 4.3.4-6) ) #1 SMP Sun Nov 15 22:05:44 UTC 2009
[    0.000000] Command line: root=/dev/md1 ro 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
[    0.000000]  BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000dfed0000 (usable)
[    0.000000]  BIOS-e820: 00000000dfed0000 - 00000000dfede000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000dfede000 - 00000000dfedf000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000dfedf000 - 00000000e0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000120000000 (usable)
[    0.000000] DMI present.
[    0.000000] Phoenix BIOS detected: BIOS may corrupt low RAM, working around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0x120000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-CBFFF write-protect
[    0.000000]   CC000-DFFFF uncachable
[    0.000000]   E0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask F80000000 write-back
[    0.000000]   1 base 080000000 mask FC0000000 write-back
[    0.000000]   2 base 0C0000000 mask FE0000000 write-back
[    0.000000]   3 base 100000000 mask FE0000000 write-back
[    0.000000]   4 base 0DFF00000 mask FFFF00000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000dff00000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xdfed0 max_arch_pfn = 0x400000000
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000dfed0000
[    0.000000]  0000000000 - 00dfe00000 page 2M
[    0.000000]  00dfe00000 - 00dfed0000 page 4k
[    0.000000] kernel direct mapping tables up to dfed0000 @ 10000-16000
[    0.000000] init_memory_mapping: 0000000100000000-0000000120000000
[    0.000000]  0100000000 - 0120000000 page 2M
[    0.000000] kernel direct mapping tables up to 120000000 @ 14000-1a000
[    0.000000] RAMDISK: 37760000 - 37fef1bc
[    0.000000] ACPI: RSDP 00000000000f6d70 00024 (v02 PTLTD )
[    0.000000] ACPI: XSDT 00000000dfed3f2f 0008C (v01 PTLTD  	 XSDT   06040000  LTP 00000000)
[    0.000000] ACPI: FACP 00000000dfedde40 000F4 (v03 INTEL  Bigby    06040000 PTL  00000002)
[    0.000000] ACPI: DSDT 00000000dfed7fa7 05E15 (v01  INTEL    BIGBY 06040000 MSFT 0100000E)
[    0.000000] ACPI: FACS 00000000dfedefc0 00040
[    0.000000] ACPI: MCFG 00000000dfeddf34 0003C (v01 PTLTD    MCFG   06040000  LTP 00000000)
[    0.000000] ACPI: APIC 00000000dfeddf70 00068 (v01 PTLTD  	 APIC   06040000  LTP 00000000)
[    0.000000] ACPI: BOOT 00000000dfeddfd8 00028 (v01 PTLTD  $SBFTBL$ 06040000  LTP 00000001)
[    0.000000] ACPI: SSDT 00000000dfed582e 0025F (v01  PmRef  Cpu0Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed5788 000A6 (v01  PmRef  Cpu7Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed56e2 000A6 (v01  PmRef  Cpu6Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed563c 000A6 (v01  PmRef  Cpu5Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed5596 000A6 (v01  PmRef  Cpu4Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed54f0 000A6 (v01  PmRef  Cpu3Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed544a 000A6 (v01  PmRef  Cpu2Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed53a4 000A6 (v01  PmRef  Cpu1Tst 00003000 INTL 20050228)
[    0.000000] ACPI: SSDT 00000000dfed3fbb 013E9 (v01  PmRef    CpuPm 00003000 INTL 20050228)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000120000000
[    0.000000] Bootmem setup node 0 0000000000000000-0000000120000000
[    0.000000]   NODE_DATA [0000000000015000 - 000000000001cfff]
[    0.000000]   bootmap [000000000001d000 -  0000000000040fff] pages 24
[    0.000000] (8 early reservations) ==> bootmem [0000000000 - 0120000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0001000000 - 0001631d2c]    TEXT DATA BSS ==> [0001000000 - 0001631d2c]
[    0.000000]   #3 [0037760000 - 0037fef1bc]          RAMDISK ==> [0037760000 - 0037fef1bc]
[    0.000000]   #4 [000009e800 - 0000100000]    BIOS reserved ==> [000009e800 - 0000100000]
[    0.000000]   #5 [0001632000 - 0001632174]              BRK ==> [0001632000 - 0001632174]
[    0.000000]   #6 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #7 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
[    0.000000] found SMP MP-table at [ffff8800000f6da0] f6da0
[    0.000000]  [ffffea0000000000-ffffea0003ffffff] PMD -> [ffff880028600000-ffff88002bffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00120000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009e
[    0.000000]     0: 0x00000100 -> 0x000dfed0
[    0.000000]     0: 0x00100000 -> 0x00120000
[    0.000000] On node 0 totalpages: 1048158
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 105 pages reserved
[    0.000000]   DMA zone: 3821 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 898824 pages, LIFO batch:31
[    0.000000]   Normal zone: 1792 pages used for memmap
[    0.000000]   Normal zone: 129280 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 high edge)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 24
[    0.000000] PM: Registered nosave memory: 000000000009e000 - 000000000009f000
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
[    0.000000] PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000dfed0000 - 00000000dfede000
[    0.000000] PM: Registered nosave memory: 00000000dfede000 - 00000000dfedf000
[    0.000000] PM: Registered nosave memory: 00000000dfedf000 - 00000000e0000000
[    0.000000] PM: Registered nosave memory: 00000000e0000000 - 00000000fec00000
[    0.000000] PM: Registered nosave memory: 00000000fec00000 - 00000000fec10000
[    0.000000] PM: Registered nosave memory: 00000000fec10000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ff000000
[    0.000000] PM: Registered nosave memory: 00000000ff000000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at e0000000 (gap: e0000000:1ec00000)
[    0.000000] NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:2 nr_node_ids:1
[    0.000000] PERCPU: Embedded 29 pages at ffff88002801f000, static data 86368 bytes
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total pages: 1031925
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: root=/dev/md1 ro 
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Initializing CPU#0
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000000] Placing 64MB software IO TLB between ffff880020000000 - ffff880024000000
[    0.000000] software IO TLB at phys 0x20000000 - 0x24000000
[    0.000000] Memory: 4051700k/4718592k available (2947k kernel code, 525960k absent, 140932k reserved, 1661k data, 648k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] NR_IRQS:4352 nr_irqs:424
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2393.470 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004010] Calibrating delay loop (skipped), value calculated using timer frequency.. 4786.94 BogoMIPS (lpj=9573880)
[    0.004218] Security Framework initialized
[    0.004286] SELinux:  Disabled at boot.
[    0.004684] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.007008] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.008202] Mount-cache hash table entries: 256
[    0.008421] Initializing cgroup subsys ns
[    0.008489] Initializing cgroup subsys cpuacct
[    0.008555] Initializing cgroup subsys devices
[    0.008621] Initializing cgroup subsys freezer
[    0.008686] Initializing cgroup subsys net_cls
[    0.008776] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.008884] CPU: L2 cache: 2048K
[    0.008948] CPU 0/0x0 -> Node 0
[    0.009011] CPU: Physical Processor ID: 0
[    0.009075] CPU: Processor Core ID: 0
[    0.009140] mce: CPU supports 6 MCE banks
[    0.009208] CPU0: Thermal monitoring handled by SMI
[    0.009211] using mwait in idle threads.
[    0.009275] Performance Counters: Core2 events, Intel PMU driver.
[    0.009432] ... version:                 2
[    0.009496] ... bit width:               40
[    0.009560] ... generic counters:        2
[    0.009624] ... value mask:              000000ffffffffff
[    0.009690] ... max period:              000000007fffffff
[    0.009757] ... fixed-purpose counters:  3
[    0.009821] ... counter mask:            0000000700000003
[    0.010764] ACPI: Core revision 20090521
[    0.020058] Setting APIC routing to flat
[    0.020436] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.061199] CPU0: Intel(R) Core(TM)2 Duo CPU     E4600  @ 2.40GHz stepping 0d
[    0.064001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4788.23 BogoMIPS (lpj=9576478)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 2048K
[    0.004000] CPU 1/0x1 -> Node 0
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.004000] mce: CPU supports 6 MCE banks
[    0.004000] CPU1: Thermal monitoring enabled (TM2)
[    0.004000] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.149291] CPU1: Intel(R) Core(TM)2 Duo CPU     E4600  @ 2.40GHz stepping 0d
[    0.150108] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.152026] Brought up 2 CPUs
[    0.152091] Total of 2 processors activated (9575.17 BogoMIPS).
[    0.152220] CPU0 attaching sched-domain:
[    0.152223]  domain 0: span 0-1 level MC
[    0.152225]   groups: 0 1
[    0.152229] CPU1 attaching sched-domain:
[    0.152231]  domain 0: span 0-1 level MC
[    0.152233]   groups: 1 0
[    0.152298] Booting paravirtualized kernel on bare hardware
[    0.152298] regulator: core version 0.5
[    0.152298] NET: Registered protocol family 16
[    0.152304] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.152390] ACPI: bus type pci registered
[    0.152517] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 16
[    0.152587] PCI: Not using MMCONFIG.
[    0.152651] PCI: Using configuration type 1 for base access
[    0.156332] bio: create slab <bio-0> at 0
[    0.156498] ACPI: EC: Look up EC in DSDT
[    0.162244] ACPI: Interpreter enabled
[    0.162310] ACPI: (supports S0 S1 S3 S4 S5)
[    0.162605] ACPI: Using IOAPIC for interrupt routing
[    0.162705] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 16
[    0.164635] PCI: BIOS Bug: MCFG area at f0000000 is not reserved in ACPI motherboard resources
[    0.164722] PCI: Not using MMCONFIG.
[    0.168525] ACPI: No dock devices found.
[    0.169496] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.169689] pci 0000:00:1a.0: reg 20 io port: [0x1820-0x183f]
[    0.169768] pci 0000:00:1a.1: reg 20 io port: [0x1840-0x185f]
[    0.169844] pci 0000:00:1a.2: reg 20 io port: [0x1860-0x187f]
[    0.169914] pci 0000:00:1a.7: reg 10 32bit mmio: [0xe8501800-0xe8501bff]
[    0.169967] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.170038] pci 0000:00:1a.7: PME# disabled
[    0.170158] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.170228] pci 0000:00:1c.0: PME# disabled
[    0.170349] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.170419] pci 0000:00:1c.4: PME# disabled
[    0.170538] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.170608] pci 0000:00:1c.5: PME# disabled
[    0.170722] pci 0000:00:1d.0: reg 20 io port: [0x1880-0x189f]
[    0.170803] pci 0000:00:1d.1: reg 20 io port: [0x18a0-0x18bf]
[    0.170879] pci 0000:00:1d.2: reg 20 io port: [0x18c0-0x18df]
[    0.170949] pci 0000:00:1d.7: reg 10 32bit mmio: [0xe8501c00-0xe8501fff]
[    0.171001] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.171072] pci 0000:00:1d.7: PME# disabled
[    0.171254] pci 0000:00:1f.0: Force enabled HPET at 0xfed00000
[    0.171259] pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
[    0.171346] pci 0000:00:1f.0: quirk: region 1180-11bf claimed by ICH6 GPIO
[    0.171417] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0600 (mask 007f)
[    0.171504] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 2 PIO at 0ca0 (mask 000f)
[    0.171648] pci 0000:00:1f.2: reg 10 io port: [0x1c78-0x1c7f]
[    0.171653] pci 0000:00:1f.2: reg 14 io port: [0x1c6c-0x1c6f]
[    0.171658] pci 0000:00:1f.2: reg 18 io port: [0x1c70-0x1c77]
[    0.171664] pci 0000:00:1f.2: reg 1c io port: [0x1c68-0x1c6b]
[    0.171669] pci 0000:00:1f.2: reg 20 io port: [0x18e0-0x18ff]
[    0.171675] pci 0000:00:1f.2: reg 24 32bit mmio: [0xe8501000-0xe85017ff]
[    0.171705] pci 0000:00:1f.2: PME# supported from D3hot
[    0.171773] pci 0000:00:1f.2: PME# disabled
[    0.171864] pci 0000:00:1f.3: reg 10 64bit mmio: [0xe8502000-0xe85020ff]
[    0.171877] pci 0000:00:1f.3: reg 20 io port: [0x1c00-0x1c1f]
[    0.171926] pci 0000:00:1f.6: reg 10 64bit mmio: [0xe8500000-0xe8500fff]
[    0.172023] pci 0000:00:1c.0: bridge io port: [0x00-0xfff]
[    0.172091] pci 0000:0d:00.0: reg 10 32bit mmio: [0xe8080000-0xe809ffff]
[    0.172102] pci 0000:0d:00.0: reg 14 32bit mmio: [0xe8000000-0xe807ffff]
[    0.172113] pci 0000:0d:00.0: reg 18 io port: [0x2000-0x201f]
[    0.172197] pci 0000:0d:00.0: PME# supported from D0 D3hot D3cold
[    0.172270] pci 0000:0d:00.0: PME# disabled
[    0.172383] pci 0000:00:1c.4: bridge io port: [0x2000-0x2fff]
[    0.172387] pci 0000:00:1c.4: bridge 32bit mmio: [0xe8000000-0xe80fffff]
[    0.172452] pci 0000:0f:00.0: reg 10 32bit mmio: [0xe8180000-0xe819ffff]
[    0.172463] pci 0000:0f:00.0: reg 14 32bit mmio: [0xe8100000-0xe817ffff]
[    0.172474] pci 0000:0f:00.0: reg 18 io port: [0x3000-0x301f]
[    0.172557] pci 0000:0f:00.0: PME# supported from D0 D3hot D3cold
[    0.172630] pci 0000:0f:00.0: PME# disabled
[    0.172743] pci 0000:00:1c.5: bridge io port: [0x3000-0x3fff]
[    0.172747] pci 0000:00:1c.5: bridge 32bit mmio: [0xe8100000-0xe81fffff]
[    0.172789] pci 0000:11:03.0: reg 10 32bit mmio: [0xe0000000-0xe7ffffff]
[    0.172796] pci 0000:11:03.0: reg 14 io port: [0x4000-0x40ff]
[    0.172802] pci 0000:11:03.0: reg 18 32bit mmio: [0xe8200000-0xe820ffff]
[    0.172823] pci 0000:11:03.0: reg 30 32bit mmio: [0x000000-0x01ffff]
[    0.172842] pci 0000:11:03.0: supports D1 D2
[    0.172883] pci 0000:00:1e.0: transparent bridge
[    0.172951] pci 0000:00:1e.0: bridge io port: [0x4000-0x4fff]
[    0.172954] pci 0000:00:1e.0: bridge 32bit mmio: [0xe8200000-0xe82fffff]
[    0.172960] pci 0000:00:1e.0: bridge 64bit mmio pref: [0xe0000000-0xe7ffffff]
[    0.172979] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.173218] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
[    0.173291] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP5._PRT]
[    0.173356] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP6._PRT]
[    0.173433] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.178179] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.178845] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.179511] ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.180180] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.180950] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.181720] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.182490] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.183159] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
[    0.183926] usbcore: registered new interface driver usbfs
[    0.184015] usbcore: registered new interface driver hub
[    0.184091] usbcore: registered new device driver usb
[    0.184095] PCI: Using ACPI for IRQ routing
[    0.184098] pci 0000:00:1c.0: BAR 13: can't allocate resource
[    0.192140] hpet clockevent registered
[    0.192145] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.192237] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.192521] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.208092] pnp: PnP ACPI init
[    0.208173] ACPI: bus type pnp registered
[    0.210720] pnp: PnP ACPI: found 10 devices
[    0.210786] ACPI: ACPI bus type pnp unregistered
[    0.210860] system 00:01: ioport range 0x600-0x63f has been reserved
[    0.210930] system 00:01: ioport range 0x800-0x80f has been reserved
[    0.211000] system 00:01: ioport range 0xca0-0xcaf has been reserved
[    0.211069] system 00:01: ioport range 0x1000-0x107f has been reserved
[    0.211139] system 00:01: ioport range 0x1180-0x11bf has been reserved
[    0.211209] system 00:01: ioport range 0x4d0-0x4d1 has been reserved
[    0.211279] system 00:01: ioport range 0xfe00-0xfe00 has been reserved
[    0.211349] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.211420] system 00:01: iomem range 0xf8000000-0xfbffffff has been reserved
[    0.211492] system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
[    0.211563] system 00:01: iomem range 0xfef00000-0xfeffffff has been reserved
[    0.216316] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:05
[    0.216385] pci 0000:00:1c.0:   IO window: disabled
[    0.216454] pci 0000:00:1c.0:   MEM window: disabled
[    0.216522] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.216591] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:0d
[    0.216660] pci 0000:00:1c.4:   IO window: 0x2000-0x2fff
[    0.216730] pci 0000:00:1c.4:   MEM window: 0xe8000000-0xe80fffff
[    0.216800] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.216869] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:0f
[    0.216937] pci 0000:00:1c.5:   IO window: 0x3000-0x3fff
[    0.217007] pci 0000:00:1c.5:   MEM window: 0xe8100000-0xe81fffff
[    0.217077] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.217148] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:11
[    0.217217] pci 0000:00:1e.0:   IO window: 0x4000-0x4fff
[    0.217287] pci 0000:00:1e.0:   MEM window: 0xe8200000-0xe82fffff
[    0.217358] pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e7ffffff
[    0.217453]   alloc irq_desc for 16 on node 0
[    0.217455]   alloc kstat_irqs on node 0
[    0.217459] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.217532] pci 0000:00:1c.0: setting latency timer to 64
[    0.217538] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.217610] pci 0000:00:1c.4: setting latency timer to 64
[    0.217616]   alloc irq_desc for 17 on node 0
[    0.217617]   alloc kstat_irqs on node 0
[    0.217620] pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.217691] pci 0000:00:1c.5: setting latency timer to 64
[    0.217697] pci 0000:00:1e.0: setting latency timer to 64
[    0.217701] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.217703] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.217705] pci_bus 0000:05: resource 0 mem: [0x0-0xfff]
[    0.217707] pci_bus 0000:0d: resource 0 io:  [0x2000-0x2fff]
[    0.217709] pci_bus 0000:0d: resource 1 mem: [0xe8000000-0xe80fffff]
[    0.217711] pci_bus 0000:0f: resource 0 io:  [0x3000-0x3fff]
[    0.217713] pci_bus 0000:0f: resource 1 mem: [0xe8100000-0xe81fffff]
[    0.217715] pci_bus 0000:11: resource 0 io:  [0x4000-0x4fff]
[    0.217717] pci_bus 0000:11: resource 1 mem: [0xe8200000-0xe82fffff]
[    0.217720] pci_bus 0000:11: resource 2 pref mem [0xe0000000-0xe7ffffff]
[    0.217722] pci_bus 0000:11: resource 3 io:  [0x00-0xffff]
[    0.217724] pci_bus 0000:11: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.217777] NET: Registered protocol family 2
[    0.218004] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.219308] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.223602] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.224228] TCP: Hash tables configured (established 524288 bind 65536)
[    0.224298] TCP reno registered
[    0.224514] NET: Registered protocol family 1
[    0.224638] Unpacking initramfs...
[    0.405817] Freeing initrd memory: 8764k freed
[    0.409841] Simple Boot Flag at 0x40 set to 0x80
[    0.410269] audit: initializing netlink socket (disabled)
[    0.410353] type=2000 audit(1260954508.408:1): initialized
[    0.410847] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.411027] VFS: Disk quotas dquot_6.5.2
[    0.411121] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.411239] msgmni has been set to 7930
[    0.411450] alg: No test for stdrng (krng)
[    0.411544] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.411630] io scheduler noop registered
[    0.411694] io scheduler anticipatory registered
[    0.411760] io scheduler deadline registered
[    0.411840] io scheduler cfq registered (default)
[    0.412070] pci 0000:11:03.0: Boot video device
[    0.412218]   alloc irq_desc for 24 on node 0
[    0.412220]   alloc kstat_irqs on node 0
[    0.412234] pcieport-driver 0000:00:1c.0: irq 24 for MSI/MSI-X
[    0.412249] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.412370]   alloc irq_desc for 25 on node 0
[    0.412372]   alloc kstat_irqs on node 0
[    0.412382] pcieport-driver 0000:00:1c.4: irq 25 for MSI/MSI-X
[    0.412393] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.412512]   alloc irq_desc for 26 on node 0
[    0.412514]   alloc kstat_irqs on node 0
[    0.412524] pcieport-driver 0000:00:1c.5: irq 26 for MSI/MSI-X
[    0.412535] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.413596] Linux agpgart interface v0.103
[    0.413729] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.414035] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.414555] 00:09: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.414777] input: Macintosh mouse button emulation as /devices/virtual/input/input0
[    0.415004] PNP: PS/2 Controller [PNP0303:KBC0,PNP0f13:MSE0] at 0x60,0x64 irq 1,12
[    0.417988] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.418125] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.418346] mice: PS/2 mouse device common for all mice
[    0.418539] rtc_cmos 00:04: RTC can wake from S4
[    0.418697] rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
[    0.418868] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.419012] cpuidle: using governor ladder
[    0.419144] cpuidle: using governor menu
[    0.419278] No iBFT detected.
[    0.419646] TCP cubic registered
[    0.419820] NET: Registered protocol family 10
[    0.420289] lo: Disabled Privacy Extensions
[    0.420626] Mobile IPv6
[    0.420756] NET: Registered protocol family 17
[    0.420947] registered taskstats version 1
[    0.421193] rtc_cmos 00:04: setting system clock to 2009-12-16 09:08:29 UTC (1260954509)
[    0.421385] Freeing unused kernel memory: 648k freed
[    0.421731] Write protecting the kernel read-only data: 4028k
[    0.543565] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.543778]   alloc irq_desc for 18 on node 0
[    0.543781]   alloc kstat_irqs on node 0
[    0.543790] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.543949] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    0.543955] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    0.544161] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    0.548293] ehci_hcd 0000:00:1a.7: debug port 1
[    0.548441] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    0.548467] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8501800
[    0.565315] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    0.565485] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.565622] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.565773] usb usb1: Product: EHCI Host Controller
[    0.565907] usb usb1: Manufacturer: Linux 2.6.31-1-amd64 ehci_hcd
[    0.566034] usb usb1: SerialNumber: 0000:00:1a.7
[    0.566215] usb usb1: configuration #1 chosen from 1 choice
[    0.566368] hub 1-0:1.0: USB hub found
[    0.566500] hub 1-0:1.0: 6 ports detected
[    0.566955] SCSI subsystem initialized
[    0.582520] e1000e: Intel(R) PRO/1000 Network Driver - 1.0.2-k2
[    0.582662] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    0.585126] uhci_hcd: USB Universal Host Controller Interface driver
[    0.585437] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.585601] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    0.585608] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    0.585799] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    0.589866] ehci_hcd 0000:00:1d.7: debug port 1
[    0.590014] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    0.590043] ehci_hcd 0000:00:1d.7: irq 16, io mem 0xe8501c00
[    0.611270] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    0.611448] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.611583] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.611735] usb usb2: Product: EHCI Host Controller
[    0.611869] usb usb2: Manufacturer: Linux 2.6.31-1-amd64 ehci_hcd
[    0.612001] usb usb2: SerialNumber: 0000:00:1d.7
[    0.612194] usb usb2: configuration #1 chosen from 1 choice
[    0.612427] hub 2-0:1.0: USB hub found
[    0.632774] libata version 3.00 loaded.
[    0.634051] hub 2-0:1.0: 6 ports detected
[    0.637524] e1000e 0000:0d:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.637664] e1000e 0000:0d:00.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[    0.637828] e1000e 0000:0d:00.0: setting latency timer to 64
[    0.638184]   alloc irq_desc for 27 on node 0
[    0.638186]   alloc kstat_irqs on node 0
[    0.638221] e1000e 0000:0d:00.0: irq 27 for MSI/MSI-X
[    0.638564] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.638706] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    0.638712] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    0.638931] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    0.639118] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001820
[    0.639283] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    0.639412] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.639563] usb usb3: Product: UHCI Host Controller
[    0.639696] usb usb3: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.639828] usb usb3: SerialNumber: 0000:00:1a.0
[    0.640032] usb usb3: configuration #1 chosen from 1 choice
[    0.640214] hub 3-0:1.0: USB hub found
[    0.640383] hub 3-0:1.0: 2 ports detected
[    0.640580] ahci 0000:00:1f.2: version 3.0
[    0.640592] ahci 0000:00:1f.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.640746]   alloc irq_desc for 28 on node 0
[    0.640747]   alloc kstat_irqs on node 0
[    0.640757] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.640828] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x35 impl SATA mode
[    0.640982] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pmp pio slum part 
[    0.641131] ahci 0000:00:1f.2: setting latency timer to 64
[    0.641372] scsi0 : ahci
[    0.641646] scsi1 : ahci
[    0.641860] scsi2 : ahci
[    0.642071] scsi3 : ahci
[    0.642282] scsi4 : ahci
[    0.642512] scsi5 : ahci
[    0.642799] ata1: SATA max UDMA/133 abar m2048@0xe8501000 port 0xe8501100 irq 28
[    0.642947] ata2: DUMMY
[    0.643076] ata3: SATA max UDMA/133 abar m2048@0xe8501000 port 0xe8501200 irq 28
[    0.643228] ata4: DUMMY
[    0.643353] ata5: SATA max UDMA/133 abar m2048@0xe8501000 port 0xe8501300 irq 28
[    0.643505] ata6: SATA max UDMA/133 abar m2048@0xe8501000 port 0xe8501380 irq 28
[    0.643806] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.643954] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    0.643961] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    0.644162] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    0.644361] uhci_hcd 0000:00:1a.1: irq 17, io base 0x00001840
[    0.644534] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    0.644671] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.644814] usb usb4: Product: UHCI Host Controller
[    0.644947] usb usb4: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.645082] usb usb4: SerialNumber: 0000:00:1a.1
[    0.645287] usb usb4: configuration #1 chosen from 1 choice
[    0.645468] hub 4-0:1.0: USB hub found
[    0.645599] hub 4-0:1.0: 2 ports detected
[    0.645804] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.645945] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    0.645951] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    0.646137] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    0.646308] uhci_hcd 0000:00:1a.2: irq 18, io base 0x00001860
[    0.646472] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    0.646606] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.646761] usb usb5: Product: UHCI Host Controller
[    0.646894] usb usb5: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.647029] usb usb5: SerialNumber: 0000:00:1a.2
[    0.647228] usb usb5: configuration #1 chosen from 1 choice
[    0.647409] hub 5-0:1.0: USB hub found
[    0.647538] hub 5-0:1.0: 2 ports detected
[    0.647734] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.647878] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    0.647884] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    0.648070] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    0.648243] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001880
[    0.648401] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.648527] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.648674] usb usb6: Product: UHCI Host Controller
[    0.648807] usb usb6: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.648938] usb usb6: SerialNumber: 0000:00:1d.0
[    0.649139] usb usb6: configuration #1 chosen from 1 choice
[    0.649317] hub 6-0:1.0: USB hub found
[    0.649454] hub 6-0:1.0: 2 ports detected
[    0.649641] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.649785] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    0.649792] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    0.649980] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    0.650158] uhci_hcd 0000:00:1d.1: irq 17, io base 0x000018a0
[    0.650326] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.650463] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.650613] usb usb7: Product: UHCI Host Controller
[    0.650750] usb usb7: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.650887] usb usb7: SerialNumber: 0000:00:1d.1
[    0.651105] usb usb7: configuration #1 chosen from 1 choice
[    0.651286] hub 7-0:1.0: USB hub found
[    0.651417] hub 7-0:1.0: 2 ports detected
[    0.651808] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.651949] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    0.651956] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    0.652149] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    0.652384] uhci_hcd 0000:00:1d.2: irq 18, io base 0x000018c0
[    0.652537] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    0.652674] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.652826] usb usb8: Product: UHCI Host Controller
[    0.652959] usb usb8: Manufacturer: Linux 2.6.31-1-amd64 uhci_hcd
[    0.653090] usb usb8: SerialNumber: 0000:00:1d.2
[    0.653291] usb usb8: configuration #1 chosen from 1 choice
[    0.653458] hub 8-0:1.0: USB hub found
[    0.653593] hub 8-0:1.0: 2 ports detected
[    0.693411] e1000e 0000:0d:00.0: Warning: detected DSPD enabled in EEPROM
[    0.710997] Switched to high resolution mode on CPU 1
[    0.712782] Switched to high resolution mode on CPU 0
[    0.753027] 0000:0d:00.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b2:63:ae
[    0.753183] 0000:0d:00.0: eth0: Intel(R) PRO/1000 Network Connection
[    0.753341] 0000:0d:00.0: eth0: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[    0.753639] e1000e 0000:0f:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.753776] e1000e 0000:0f:00.0: pci_enable_pcie_error_reporting failed 0xfffffffb
[    0.753936] e1000e 0000:0f:00.0: setting latency timer to 64
[    0.754288]   alloc irq_desc for 29 on node 0
[    0.754289]   alloc kstat_irqs on node 0
[    0.754322] e1000e 0000:0f:00.0: irq 29 for MSI/MSI-X
[    0.808887] e1000e 0000:0f:00.0: Warning: detected DSPD enabled in EEPROM
[    0.869812] 0000:0f:00.0: eth1: (PCI Express:2.5GB/s:Width x1) 00:e0:81:b2:63:af
[    0.869960] 0000:0f:00.0: eth1: Intel(R) PRO/1000 Network Connection
[    0.870125] 0000:0f:00.0: eth1: MAC: 2, PHY: 2, PBA No: ffffff-0ff
[    1.109044] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.109203] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.109361] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.109501] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.110207] ata1.00: ATA-8: STM3500418AS, CC38, max UDMA/133
[    1.110347] ata1.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.110533] ata6.00: ATA-6: ST31000340NS, SN04, max UDMA/133
[    1.110556] ata3.00: ATA-8: STM3500418AS, CC38, max UDMA/133
[    1.110560] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.110651] ata5.00: ATA-8: ST3500418AS, CC37, max UDMA/133
[    1.110655] ata5.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.111173] ata6.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.111739] ata1.00: configured for UDMA/133
[    1.111915] ata5.00: configured for UDMA/133
[    1.112130] scsi 0:0:0:0: Direct-Access     ATA      STM3500418AS     CC38 PQ: 0 ANSI: 5
[    1.112402] ata3.00: configured for UDMA/133
[    1.112574] scsi 2:0:0:0: Direct-Access     ATA      STM3500418AS     CC38 PQ: 0 ANSI: 5
[    1.112837] scsi 4:0:0:0: Direct-Access     ATA      ST3500418AS      CC37 PQ: 0 ANSI: 5
[    1.113016] ata6.00: configured for UDMA/133
[    1.113317] scsi 5:0:0:0: Direct-Access     ATA      ST31000340NS     SN04 PQ: 0 ANSI: 5
[    1.117925] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.118118] sd 0:0:0:0: [sda] Write Protect is off
[    1.118212] sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.118246] sd 2:0:0:0: [sdb] Write Protect is off
[    1.118248] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    1.118266] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.118367]  sdb:
[    1.118506] sd 4:0:0:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    1.118539] sd 4:0:0:0: [sdc] Write Protect is off
[    1.118541] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    1.118559] sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.118644]  sdc:
[    1.118682] sd 5:0:0:0: [sdd] 1953525168 512-byte logical blocks: (1.00 TB/931 GiB)
[    1.118714] sd 5:0:0:0: [sdd] Write Protect is off
[    1.118715] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    1.118733] sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.118817]  sdd:
[    1.119900] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.120061] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.120316]  sda: sdb1 sdb2 sdb3 sdb4
[    1.124658]  sdc1 sdc2 sdc3 sdc4
[    1.128885]  sda1 sda2 sda3 sda4
[    1.132101] sd 2:0:0:0: [sdb] Attached SCSI disk
[    1.137104] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.138174]  sdd1
[    1.138628] sd 5:0:0:0: [sdd] Attached SCSI disk
[    1.138642] sd 4:0:0:0: [sdc] Attached SCSI disk
[    1.229141] usb 4-1: new low speed USB device using uhci_hcd and address 2
[    1.355926] xor: automatically using best checksumming function: generic_sse
[    1.373000]    generic_sse:  8803.000 MB/sec
[    1.373130] xor: using function: generic_sse (8803.000 MB/sec)
[    1.373649] async_tx: api initialized (async)
[    1.441008] raid6: int64x1   2012 MB/s
[    1.509010] raid6: int64x2   2714 MB/s
[    1.577022] raid6: int64x4   2105 MB/s
[    1.645008] raid6: int64x8   1902 MB/s
[    1.713008] raid6: sse2x1    3586 MB/s
[    1.781009] raid6: sse2x2    4780 MB/s
[    1.849006] raid6: sse2x4    7166 MB/s
[    1.849137] raid6: using algorithm sse2x4 (7166 MB/s)
[    1.854700] md: raid6 personality registered for level 6
[    1.854821] md: raid5 personality registered for level 5
[    1.854959] md: raid4 personality registered for level 4
[    1.917405] md: md1 stopped.
[    1.919576] md: bind<sdb2>
[    1.920694] md: bind<sda2>
[    1.921040] md: bind<sdc2>
[    1.922546] raid5: device sdc2 operational as raid disk 0
[    1.922672] raid5: device sda2 operational as raid disk 2
[    1.922798] raid5: device sdb2 operational as raid disk 1
[    1.923184] raid5: allocated 3228kB for md1
[    1.923342] raid5: raid level 5 set md1 active with 3 out of 3 devices, algorithm 2
[    1.923490] RAID5 conf printout:
[    1.923612]  --- rd:3 wd:3
[    1.923730]  disk 0, o:1, dev:sdc2
[    1.923853]  disk 1, o:1, dev:sdb2
[    1.923979]  disk 2, o:1, dev:sda2
[    1.924137] md1: detected capacity change from 0 to 107389124608
[    1.925244]  md1: unknown partition table
[    2.192846] EXT4-fs (md1): barriers enabled
[    2.205256] kjournald2 starting: pid 453, dev md1:8, commit interval 5 seconds
[    2.205431] EXT4-fs (md1): delayed allocation enabled
[    2.205766] EXT4-fs: file extents enabled
[    2.211754] EXT4-fs: mballoc enabled
[    2.211888] EXT4-fs (md1): mounted filesystem with ordered data mode
[    2.616988] usb 4-1: New USB device found, idVendor=0463, idProduct=ffff
[    2.617107] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=4
[    2.617251] usb 4-1: Product: Ellipse MAX
[    2.617393] usb 4-1: Manufacturer: MGE UPS SYSTEMS
[    2.617526] usb 4-1: SerialNumber: PbAc
[    2.617714] usb 4-1: configuration #1 chosen from 1 choice
[    2.857060] usb 4-2: new low speed USB device using uhci_hcd and address 3
[    3.035075] usb 4-2: New USB device found, idVendor=0b05, idProduct=172e
[    3.035215] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.035366] usb 4-2: Product: ASUS DH Remote
[    3.035490] usb 4-2: Manufacturer: T-wins
[    3.035695] usb 4-2: configuration #1 chosen from 1 choice
[    3.277060] usb 7-1: new full speed USB device using uhci_hcd and address 2
[    3.432944] usb 7-1: New USB device found, idVendor=0c76, idProduct=1607
[    3.432947] usb 7-1: New USB device strings: Mfr=0, Product=1, SerialNumber=0
[    3.432949] usb 7-1: Product: USB Headphone Set
[    3.433031] usb 7-1: configuration #1 chosen from 1 choice
[    3.882407] udev: starting version 149
[    4.769077] usbcore: registered new interface driver hiddev
[    4.838933] ACPI: SSDT 00000000dfed6348 00261 (v01  PmRef  Cpu0Ist 00003000 INTL 20050228)
[    4.840030] ACPI: SSDT 00000000dfed5a8d 00518 (v01  PmRef  Cpu0Cst 00003001 INTL 20050228)
[    4.842990] input: PC Speaker as /devices/platform/pcspkr/input/input1
[    4.877048] Monitor-Mwait will be used to enter C-1 state
[    4.877111] processor LNXCPU:00: registered as cooling_device0
[    4.877248] ACPI: Processor [CPU0] (supports 8 throttling states)
[    4.878127] ACPI: SSDT 00000000dfed65a9 001F2 (v01  PmRef  Cpu1Ist 00003000 INTL 20050228)
[    4.878814] ACPI: SSDT 00000000dfed5fa5 00085 (v01  PmRef  Cpu1Cst 00003000 INTL 20050228)
[    4.879928] processor LNXCPU:01: registered as cooling_device1
[    4.880064] ACPI: Processor [CPU1] (supports 8 throttling states)
[    4.988382] i801_smbus 0000:00:1f.3: enabling device (0001 -> 0003)
[    4.988528] i801_smbus 0000:00:1f.3: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    5.140462] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[    5.140614] ACPI: Power Button [PWRF]
[    5.140826] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0A03:00/PNP0C0C:00/input/input3
[    5.140983] ACPI: Power Button [PWRB]
[    6.004194] usbcore: registered new interface driver snd-usb-audio
[   15.029732] /tmp/buildd/linux-2.6-2.6.31/debian/build/source_i386_none/drivers/hid/usbhid/hid-core.c: usb_submit_urb(ctrl) failed
[   15.029914] generic-usb 0003:0463:FFFF.0001: timeout initializing reports
[   15.030154] generic-usb 0003:0463:FFFF.0001: hiddev96,hidraw0: USB HID v1.10 Device [MGE UPS SYSTEMS Ellipse MAX] on usb-0000:00:1a.1-1/input0
[   15.038933] generic-usb 0003:0B05:172E.0002: hiddev97,hidraw1: USB HID v1.10 Device [T-wins ASUS DH Remote] on usb-0000:00:1a.1-2/input0
[   15.042580] input: USB Headphone Set as /devices/pci0000:00/0000:00:1d.1/usb7/7-1/7-1:1.3/input/input4
[   15.042728] generic-usb 0003:0C76:1607.0003: input,hidraw2: USB HID v1.00 Device [USB Headphone Set] on usb-0000:00:1d.1-1/input3
[   15.042833] usbcore: registered new interface driver usbhid
[   15.042901] usbhid: v2.6:USB HID core driver
[   16.349451] EXT4-fs (md1): internal journal on md1:8
[   16.539171] Uniform Multi-Platform E-IDE driver
[   16.568786] ide-cd driver 5.00
[   16.624522] md: raid1 personality registered for level 1
[   16.688036] ipmi message handler version 39.2
[   16.710460] IPMI System Interface driver.
[   16.710635] ipmi_si: Trying SMBIOS-specified kcs state machine at mem address 0x0, slave address 0x20, irq 0
[   16.710794] Could not set up I/O space
[   16.745054] ipmi_si: Unable to find any System Interface(s)
[   16.778633] coretemp coretemp.0: Using relative temperature scale!
[   16.778811] coretemp coretemp.1: Using relative temperature scale!
[   16.921046] i2c-adapter i2c-0: Found a SCH5027 chip at 0x2e (rev 0x69).
[   16.937109] dme1737 0-002e: Optional features: pwm3=yes, pwm5=no, pwm6=no, fan3=yes, fan4=yes, fan5=no, fan6=no.
[   16.983482] device-mapper: uevent: version 1.0.3
[   17.019092] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   17.327553] md: md0 stopped.
[   17.373921] md: bind<sdb1>
[   17.374217] md: bind<sda1>
[   17.374488] md: bind<sdc1>
[   17.375864] raid1: raid set md0 active with 3 out of 3 mirrors
[   17.376019] md0: detected capacity change from 0 to 542769152
[   17.377340]  md0: unknown partition table
[   17.495121] md: md2 stopped.
[   17.521017] md: bind<sdb4>
[   17.521290] md: bind<sda4>
[   17.521517] md: bind<sdc4>
[   17.526932] raid5: device sdc4 operational as raid disk 0
[   17.527047] raid5: device sda4 operational as raid disk 2
[   17.527174] raid5: device sdb4 operational as raid disk 1
[   17.527580] raid5: allocated 3228kB for md2
[   17.548041] raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
[   17.548193] RAID5 conf printout:
[   17.548324]  --- rd:3 wd:3
[   17.548451]  disk 0, o:1, dev:sdc4
[   17.548581]  disk 1, o:1, dev:sdb4
[   17.548708]  disk 2, o:1, dev:sda4
[   17.548872] md2: detected capacity change from 0 to 883131678720
[   17.550192]  md2: unknown partition table
[   18.433582] kjournald starting.  Commit interval 5 seconds
[   18.459987] EXT3 FS on md0, internal journal
[   18.460228] EXT3-fs: mounted filesystem with ordered data mode.
[   18.472750] EXT4-fs (md2): barriers enabled
[   18.473276] kjournald2 starting: pid 2105, dev md2:8, commit interval 5 seconds
[   18.508402] EXT4-fs (md2): internal journal on md2:8
[   18.508759] EXT4-fs (md2): delayed allocation enabled
[   18.509097] EXT4-fs: file extents enabled
[   18.549014] EXT4-fs: mballoc enabled
[   18.549158] EXT4-fs (md2): mounted filesystem with ordered data mode
[   19.144714] NET: Registered protocol family 15
[   19.185895] alg: No test for cipher_null (cipher_null-generic)
[   19.186098] alg: No test for ecb(cipher_null) (ecb-cipher_null)
[   19.186249] alg: No test for digest_null (digest_null-generic)
[   19.186392] alg: No test for compress_null (compress_null-generic)
[   19.231656] padlock: VIA PadLock Hash Engine not detected.
[   19.290450] padlock: VIA PadLock Hash Engine not detected.
[   19.332886] padlock: VIA PadLock not detected.
[   19.388573] Intel AES-NI instructions are not detected.
[   21.104592] e1000e 0000:0d:00.0: irq 27 for MSI/MSI-X
[   21.160215] e1000e 0000:0d:00.0: irq 27 for MSI/MSI-X
[   21.161362] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   21.492599] JBD: barrier-based sync failed on md1:8 - disabling barriers
[   21.673162] RPC: Registered udp transport module.
[   21.673291] RPC: Registered tcp transport module.
[   21.721900] Slow work thread pool: Starting up
[   21.744076] Slow work thread pool: Ready
[   21.744256] FS-Cache: Loaded
[   21.790627] FS-Cache: Netfs 'nfs' registered for caching
[   21.925374] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   22.186919] ttyS1: LSR safety check engaged!
[   22.187525] ttyS1: LSR safety check engaged!
[   23.538992] SMsC 37B787 watchdog component driver 1.1 initialising...
[   23.540257] smsc37b787_wdt: Timeout set to 60 second(s).
[   23.540385] smsc37b787_wdt: Watchdog initialized and sleeping (nowayout=0)...
[   25.466263] dcdbas dcdbas: Dell Systems Management Base Driver (version 5.6.0-3.2)
[   27.817247] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   27.818583] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.566372] lp: driver loaded but no devices found
[   33.597855] ppdev: user-space parallel port driver
[   36.841378] svc: failed to register lockdv1 RPC service (errno 97).
[   36.842221] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   36.856897] NFSD: starting 90-second grace period
[   38.393408] eth0: no IPv6 routers present
[   40.527714] JBD: barrier-based sync failed on md2:8 - disabling barriers
[   94.384626] e1000e 0000:0f:00.0: irq 29 for MSI/MSI-X
[   94.440188] e1000e 0000:0f:00.0: irq 29 for MSI/MSI-X
[   94.441496] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   94.585688] PPP generic driver version 2.4.2
[   98.806893] e1000e: eth1 NIC Link is Up 100 Mbps Full Duplex, Flow Control: None
[   98.807049] 0000:0f:00.0: eth1: 10/100 speed: disabling TSO
[   98.807867] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[   99.869818] NET: Registered protocol family 24
[  101.968714] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[  101.969167] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[  101.969322] nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
[  101.969469] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[  102.117949] ip_tables: (C) 2000-2006 Netfilter Core Team
[  109.317030] eth1: no IPv6 routers present




