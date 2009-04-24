Return-Path: <linux-kernel-owner+w=401wt.eu-S1756917AbZDXTTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917AbZDXTTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 15:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZDXTTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 15:19:39 -0400
Received: from mail.gmx.net ([213.165.64.20]:44240 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751924AbZDXTTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 15:19:36 -0400
X-Authenticated: #9354587
X-Provags-ID: V01U2FsdGVkX18y9oNTCXky4m3stApQz7DnLrrV05M/JtloU/3wLd
	OmJUMESdv2jz5C
Message-ID: <49F210C2.8050703@gmx.net>
Date: Fri, 24 Apr 2009 21:19:30 +0200
From: LCID Fire <lcid-fire@gmx.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Link to sata drives fail randomly
Content-Type: multipart/mixed;
 boundary="------------060204010900070505020103"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68,0.49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060204010900070505020103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

First of - I have a Asus P5K WS where I'm running (or actually trying) a 
raid10 based on 4 sata drives. All drives are connected to esata slot 
panels which connect to the mainboard ports.
The problem I'm encountering is the links to random drives fail every 
week or so.
The strange thing is - the link is often failing for 2 drives at a time 
- which is the best when running a raid10 *sarcasm*
The drives are WD, Samsung and Hitachi - so I think some specific driver 
failure can be ruled out.
I attached the dmesg - perhaps someone could tell me which component is 
responsible for my drives losing their link.


P.S. Kernel version is 2.6.28


--------------060204010900070505020103
Content-Type: text/plain;
 name="raiderror.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raiderror.txt"

[    0.000000] BIOS EBDA/lowmem at: 0009a400/0009a400
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.28-11-generic (buildd@crested) (gcc version 4.3.3 (Ubuntu 4.3.3-5ubuntu4) ) #42-Ubuntu SMP Fri Apr 17 01:58:03 UTC 2009 (Ubuntu 2.6.28-11.42-generic)
[    0.000000] Command line: root=/dev/md0 ro quiet splash 
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009a400 (usable)
[    0.000000]  BIOS-e820: 000000000009a400 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e5000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff40000 (usable)
[    0.000000]  BIOS-e820: 00000000cff40000 - 00000000cff4e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff4e000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] DMI 2.4 present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x130000 max_arch_pfn = 0x3ffffffff
[    0.000000] last_pfn = 0xcff40 max_arch_pfn = 0x3ffffffff
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 000000000009a400 (usable)
[    0.000000]  modified: 000000000009a400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e5000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000cff40000 (usable)
[    0.000000]  modified: 00000000cff40000 - 00000000cff4e000 (ACPI data)
[    0.000000]  modified: 00000000cff4e000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  modified: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 0000000130000000 (usable)
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff40000
[    0.000000]  0000000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff40000 page 4k
[    0.000000] kernel direct mapping tables up to cff40000 @ 10000-16000
[    0.000000] last_map_addr: cff40000 end: cff40000
[    0.000000] init_memory_mapping: 0000000100000000-0000000130000000
[    0.000000]  0100000000 - 0130000000 page 2M
[    0.000000] kernel direct mapping tables up to 130000000 @ 14000-1a000
[    0.000000] last_map_addr: 130000000 end: 130000000
[    0.000000] RAMDISK: 3781d000 - 37fef341
[    0.000000] ACPI: RSDP 000FB140, 0014 (r0 ACPIAM)
[    0.000000] ACPI: RSDT CFF40000, 0038 (r1 A_M_I_ OEMRSDT   6000826 MSFT       97)
[    0.000000] ACPI: FACP CFF40200, 0084 (r2 A_M_I_ OEMFACP   6000826 MSFT       97)
[    0.000000] ACPI: DSDT CFF405D0, 8586 (r1  A0754 A0754001        1 INTL 20060113)
[    0.000000] ACPI: FACS CFF4E000, 0040
[    0.000000] ACPI: APIC CFF40390, 0078 (r1 A_M_I_ OEMAPIC   6000826 MSFT       97)
[    0.000000] ACPI: MCFG CFF40410, 003C (r1 A_M_I_ OEMMCFG   6000826 MSFT       97)
[    0.000000] ACPI: OEMB CFF4E040, 0081 (r1 A_M_I_ AMI_OEM   6000826 MSFT       97)
[    0.000000] ACPI: HPET CFF48B60, 0038 (r1 A_M_I_ OEMHPET   6000826 MSFT       97)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] (7 early reservations) ==> bootmem [0000000000 - 0130000000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
[    0.000000]   #2 [0000200000 - 0000b854b0]    TEXT DATA BSS ==> [0000200000 - 0000b854b0]
[    0.000000]   #3 [003781d000 - 0037fef341]          RAMDISK ==> [003781d000 - 0037fef341]
[    0.000000]   #4 [000009a400 - 0000100000]    BIOS reserved ==> [000009a400 - 0000100000]
[    0.000000]   #5 [0000010000 - 0000014000]          PGTABLE ==> [0000010000 - 0000014000]
[    0.000000]   #6 [0000014000 - 0000015000]          PGTABLE ==> [0000014000 - 0000015000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe200043fffff] PMD -> [ffff880028200000-ffff88002c5fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00130000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009a
[    0.000000]     0: 0x00000100 -> 0x000cff40
[    0.000000]     0: 0x00100000 -> 0x00130000
[    0.000000] On node 0 totalpages: 1048266
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 2548 pages reserved
[    0.000000]   DMA zone: 1374 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833400 pages, LIFO batch:31
[    0.000000]   Normal zone: 2688 pages used for memmap
[    0.000000]   Normal zone: 193920 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: IOAPIC (id[0x05] address[0xfec10000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 5, version 0, address 0xfec10000, GSI 24-279
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: HPET id: 0xffffffff base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] SMP: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009a000 - 000000000009b000
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e5000
[    0.000000] PM: Registered nosave memory: 00000000000e5000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff40000 - 00000000cff4e000
[    0.000000] PM: Registered nosave memory: 00000000cff4e000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fee00000
[    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
[    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffe00000
[    0.000000] PM: Registered nosave memory: 00000000ffe00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d4000000 (gap: d0000000:2ee00000)
[    0.000000] PERCPU: Allocating 69632 bytes of per cpu data
[    0.000000] NR_CPUS: 64, nr_cpu_ids: 4, nr_node_ids 1
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1028694
[    0.000000] Kernel command line: root=/dev/md0 ro quiet splash 
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2405.288 MHz processor.
[    0.004000] Console: colour VGA+ 80x25
[    0.004000] console [tty0] enabled
[    0.004000] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.004000] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.004000] allocated 49807360 bytes of page_cgroup
[    0.004000] please try cgroup_disable=memory option if you don't want
[    0.004000] Scanning for low memory corruption every 60 seconds
[    0.004000] Checking aperture...
[    0.004000] No AGP bridge found
[    0.004000] Calgary: detecting Calgary via BIOS EBDA area
[    0.004000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.004000] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.004000] Placing software IO TLB between 0x20000000 - 0x24000000
[    0.004000] Memory: 3983592k/4980736k available (4760k kernel code, 787672k absent, 208636k reserved, 2540k data, 536k init)
[    0.004000] SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.004000] hpet clockevent registered
[    0.004000] HPET: 4 timers in total, 0 timers will be used for per-cpu timer
[    0.004000] Calibrating delay loop (skipped), value calculated using timer frequency.. 4810.57 BogoMIPS (lpj=9621152)
[    0.004000] Security Framework initialized
[    0.004000] SELinux:  Disabled at boot.
[    0.004000] AppArmor: AppArmor initialized
[    0.004000] Mount-cache hash table entries: 256
[    0.004000] Initializing cgroup subsys ns
[    0.004000] Initializing cgroup subsys cpuacct
[    0.004000] Initializing cgroup subsys memory
[    0.004000] Initializing cgroup subsys freezer
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 0
[    0.004000] using mwait in idle threads.
[    0.004000] ACPI: Core revision 20080926
[    0.005352] ACPI: Checking initramfs for custom DSDT
[    0.292043] Setting APIC routing to flat
[    0.296304] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.335987] CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.336001] Booting processor 1 APIC 0x1 ip 0x6000
[    0.004000] Initializing CPU#1
[    0.004000] Calibrating delay using timer specific routine.. 4810.88 BogoMIPS (lpj=9621769)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 1
[    0.420547] CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.420567] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.424109] Booting processor 2 APIC 0x2 ip 0x6000
[    0.004000] Initializing CPU#2
[    0.004000] Calibrating delay using timer specific routine.. 4810.91 BogoMIPS (lpj=9621832)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 2
[    0.512562] CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.512581] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.516076] Booting processor 3 APIC 0x3 ip 0x6000
[    0.004000] Initializing CPU#3
[    0.004000] Calibrating delay using timer specific routine.. 4810.91 BogoMIPS (lpj=9621824)
[    0.004000] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.004000] CPU: L2 cache: 4096K
[    0.004000] CPU: Physical Processor ID: 0
[    0.004000] CPU: Processor Core ID: 3
[    0.604518] CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
[    0.604537] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.608025] Brought up 4 CPUs
[    0.608028] Total of 4 processors activated (19243.28 BogoMIPS).
[    0.608081] CPU0 attaching sched-domain:
[    0.608083]  domain 0: span 0-1 level MC
[    0.608085]   groups: 0 1
[    0.608088]   domain 1: span 0-3 level CPU
[    0.608089]    groups: 0-1 2-3
[    0.608093] CPU1 attaching sched-domain:
[    0.608094]  domain 0: span 0-1 level MC
[    0.608096]   groups: 1 0
[    0.608098]   domain 1: span 0-3 level CPU
[    0.608099]    groups: 0-1 2-3
[    0.608102] CPU2 attaching sched-domain:
[    0.608103]  domain 0: span 2-3 level MC
[    0.608105]   groups: 2 3
[    0.608107]   domain 1: span 0-3 level CPU
[    0.608108]    groups: 2-3 0-1
[    0.608111] CPU3 attaching sched-domain:
[    0.608113]  domain 0: span 2-3 level MC
[    0.608114]   groups: 3 2
[    0.608116]   domain 1: span 0-3 level CPU
[    0.608118]    groups: 2-3 0-1
[    0.608212] net_namespace: 1400 bytes
[    0.608212] Booting paravirtualized kernel on bare hardware
[    0.608239] Time: 13:51:14  Date: 04/24/09
[    0.608239] regulator: core version 0.5
[    0.608239] NET: Registered protocol family 16
[    0.608239] ACPI: bus type pci registered
[    0.608239] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.608239] PCI: Not using MMCONFIG.
[    0.608239] PCI: Using configuration type 1 for base access
[    0.608756] ACPI: EC: Look up EC in DSDT
[    0.621721] ACPI: Interpreter enabled
[    0.621724] ACPI: (supports S0 S1 S3 S4 S5)
[    0.621740] ACPI: Using IOAPIC for interrupt routing
[    0.621791] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.624005] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[    0.632415] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.640304] ACPI: No dock devices found.
[    0.640359] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.640437] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.640439] pci 0000:00:01.0: PME# disabled
[    0.640498] pci 0000:00:1a.0: reg 20 io port: [0x9800-0x981f]
[    0.640550] pci 0000:00:1a.1: reg 20 io port: [0x9880-0x989f]
[    0.640603] pci 0000:00:1a.2: reg 20 io port: [0x9c00-0x9c1f]
[    0.640658] pci 0000:00:1a.7: reg 10 32bit mmio: [0xfe5ffc00-0xfe5fffff]
[    0.640690] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.640694] pci 0000:00:1a.7: PME# disabled
[    0.640728] pci 0000:00:1b.0: reg 10 64bit mmio: [0xfe5f8000-0xfe5fbfff]
[    0.640751] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.640754] pci 0000:00:1b.0: PME# disabled
[    0.640791] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.640794] pci 0000:00:1c.0: PME# disabled
[    0.640833] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.640836] pci 0000:00:1c.2: PME# disabled
[    0.640874] pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
[    0.640877] pci 0000:00:1c.3: PME# disabled
[    0.640915] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.640918] pci 0000:00:1c.4: PME# disabled
[    0.640957] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.640959] pci 0000:00:1c.5: PME# disabled
[    0.641006] pci 0000:00:1d.0: reg 20 io port: [0x9080-0x909f]
[    0.641058] pci 0000:00:1d.1: reg 20 io port: [0x9400-0x941f]
[    0.641110] pci 0000:00:1d.2: reg 20 io port: [0x9480-0x949f]
[    0.641165] pci 0000:00:1d.7: reg 10 32bit mmio: [0xfe5ff800-0xfe5ffbff]
[    0.641197] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.641200] pci 0000:00:1d.7: PME# disabled
[    0.641298] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 ACPI/GPIO/TCO
[    0.641301] pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
[    0.641344] pci 0000:00:1f.2: reg 10 io port: [0x8c00-0x8c07]
[    0.641348] pci 0000:00:1f.2: reg 14 io port: [0x8880-0x8883]
[    0.641353] pci 0000:00:1f.2: reg 18 io port: [0x8800-0x8807]
[    0.641357] pci 0000:00:1f.2: reg 1c io port: [0x8480-0x8483]
[    0.641362] pci 0000:00:1f.2: reg 20 io port: [0x8400-0x841f]
[    0.641366] pci 0000:00:1f.2: reg 24 32bit mmio: [0xfe5fe800-0xfe5fefff]
[    0.641378] pci 0000:00:1f.2: PME# supported from D3hot
[    0.641380] pci 0000:00:1f.2: PME# disabled
[    0.641403] pci 0000:00:1f.3: reg 10 64bit mmio: [0xfe5ff400-0xfe5ff4ff]
[    0.641415] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.641452] pci 0000:01:00.0: reg 10 64bit mmio: [0xd0000000-0xdfffffff]
[    0.641459] pci 0000:01:00.0: reg 18 64bit mmio: [0xfe6e0000-0xfe6effff]
[    0.641464] pci 0000:01:00.0: reg 20 io port: [0xa000-0xa0ff]
[    0.641471] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe6c0000-0xfe6dffff]
[    0.641477] pci 0000:01:00.0: supports D1 D2
[    0.641504] pci 0000:01:00.1: reg 10 64bit mmio: [0xfe6fc000-0xfe6fffff]
[    0.641525] pci 0000:01:00.1: supports D1 D2
[    0.641563] pci 0000:00:01.0: bridge io port: [0xa000-0xafff]
[    0.641565] pci 0000:00:01.0: bridge 32bit mmio: [0xfe600000-0xfe6fffff]
[    0.641568] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.641605] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xfdf00000-0xfdffffff]
[    0.641665] pci 0000:05:00.0: supports D1
[    0.641667] pci 0000:05:00.0: PME# supported from D0 D1 D3hot D3cold
[    0.641671] pci 0000:05:00.0: PME# disabled
[    0.641723] pci 0000:05:00.1: reg 10 64bit mmio: [0xfeaffc00-0xfeaffc7f]
[    0.641745] pci 0000:05:00.1: supports D1
[    0.641746] pci 0000:05:00.1: PME# supported from D0 D1 D3hot D3cold
[    0.641750] pci 0000:05:00.1: PME# disabled
[    0.641808] pci 0000:00:1c.2: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.641813] pci 0000:00:1c.2: bridge 64bit mmio pref: [0xfde00000-0xfdefffff]
[    0.641970] pci 0000:05:00.1: bridge 64bit mmio pref: [0xfde00000-0xfdefffff]
[    0.642038] pci 0000:04:00.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]
[    0.642045] pci 0000:04:00.0: reg 18 io port: [0xd800-0xd8ff]
[    0.642068] pci 0000:04:00.0: reg 30 32bit mmio: [0xfe9c0000-0xfe9dffff]
[    0.642078] pci 0000:04:00.0: supports D1 D2
[    0.642080] pci 0000:04:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.642084] pci 0000:04:00.0: PME# disabled
[    0.642119] pci 0000:00:1c.3: bridge io port: [0xd000-0xdfff]
[    0.642122] pci 0000:00:1c.3: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.642177] pci 0000:03:00.0: reg 10 64bit mmio: [0xfe8fc000-0xfe8fffff]
[    0.642184] pci 0000:03:00.0: reg 18 io port: [0xc800-0xc8ff]
[    0.642208] pci 0000:03:00.0: reg 30 32bit mmio: [0xfe8c0000-0xfe8dffff]
[    0.642218] pci 0000:03:00.0: supports D1 D2
[    0.642219] pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.642223] pci 0000:03:00.0: PME# disabled
[    0.642258] pci 0000:00:1c.4: bridge io port: [0xc000-0xcfff]
[    0.642261] pci 0000:00:1c.4: bridge 32bit mmio: [0xfe800000-0xfe8fffff]
[    0.642304] pci 0000:02:00.0: reg 10 io port: [0xbc00-0xbc07]
[    0.642311] pci 0000:02:00.0: reg 14 io port: [0xb880-0xb883]
[    0.642318] pci 0000:02:00.0: reg 18 io port: [0xb800-0xb807]
[    0.642325] pci 0000:02:00.0: reg 1c io port: [0xb480-0xb483]
[    0.642331] pci 0000:02:00.0: reg 20 io port: [0xb400-0xb40f]
[    0.642338] pci 0000:02:00.0: reg 24 32bit mmio: [0xfe7ffc00-0xfe7fffff]
[    0.642355] pci 0000:02:00.0: supports D1
[    0.642356] pci 0000:02:00.0: PME# supported from D0 D1 D3hot
[    0.642360] pci 0000:02:00.0: PME# disabled
[    0.642399] pci 0000:00:1c.5: bridge io port: [0xb000-0xbfff]
[    0.642402] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe700000-0xfe7fffff]
[    0.642442] pci 0000:09:07.0: reg 10 32bit mmio: [0xfebff800-0xfebfffff]
[    0.642448] pci 0000:09:07.0: reg 14 io port: [0xec00-0xec7f]
[    0.642478] pci 0000:09:07.0: supports D2
[    0.642479] pci 0000:09:07.0: PME# supported from D2 D3hot D3cold
[    0.642483] pci 0000:09:07.0: PME# disabled
[    0.642515] pci 0000:00:1e.0: transparent bridge
[    0.642518] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    0.642520] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.642547] bus 00 -> node 0
[    0.642552] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.642746] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.642836] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.642969] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.643059] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6._PRT]
[    0.643149] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P6.PXHA._PRT]
[    0.643241] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
[    0.643330] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.643419] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.659862] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.659977] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.660103] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.660216] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11 12 14 *15)
[    0.660332] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.660446] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 *7 10 11 12 14 15)
[    0.660559] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.660672] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
[    0.660782] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - 7A, should be 79 [20080926]
[    0.660808] ACPI: WMI: Mapper loaded
[    0.660843] SCSI subsystem initialized
[    0.660843] libata version 3.00 loaded.
[    0.660843] usbcore: registered new interface driver usbfs
[    0.660843] usbcore: registered new interface driver hub
[    0.660843] usbcore: registered new device driver usb
[    0.660843] PCI: Using ACPI for IRQ routing
[    0.676009] Bluetooth: Core ver 2.13
[    0.676021] NET: Registered protocol family 31
[    0.676021] Bluetooth: HCI device and connection manager initialized
[    0.676021] Bluetooth: HCI socket layer initialized
[    0.676021] NET: Registered protocol family 8
[    0.676021] NET: Registered protocol family 20
[    0.676029] NetLabel: Initializing
[    0.676030] NetLabel:  domain hash size = 128
[    0.676031] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.676042] NetLabel:  unlabeled traffic allowed by default
[    0.676071] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.676074] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.684053] AppArmor: AppArmor Filesystem Enabled
[    0.688007] Switched to high resolution mode on CPU 0
[    0.688574] Switched to high resolution mode on CPU 3
[    0.688597] Switched to high resolution mode on CPU 1
[    0.688613] Switched to high resolution mode on CPU 2
[    0.696008] pnp: PnP ACPI init
[    0.696015] ACPI: bus type pnp registered
[    0.698499] pnp: PnP ACPI: found 14 devices
[    0.698501] ACPI: ACPI bus type pnp unregistered
[    0.698509] system 00:01: iomem range 0xfed14000-0xfed19fff has been reserved
[    0.698514] system 00:06: ioport range 0x290-0x297 has been reserved
[    0.698518] system 00:07: ioport range 0x4d0-0x4d1 has been reserved
[    0.698520] system 00:07: ioport range 0x800-0x87f has been reserved
[    0.698522] system 00:07: ioport range 0x480-0x4bf has been reserved
[    0.698524] system 00:07: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.698526] system 00:07: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.698528] system 00:07: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.698530] system 00:07: iomem range 0xffa00000-0xffafffff has been reserved
[    0.698532] system 00:07: iomem range 0xffb00000-0xffbfffff has been reserved
[    0.698534] system 00:07: iomem range 0xffe00000-0xffefffff has been reserved
[    0.698535] system 00:07: iomem range 0xfff00000-0xfffffffe has been reserved
[    0.698540] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[    0.698542] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[    0.698546] system 00:0c: iomem range 0xe0000000-0xefffffff has been reserved
[    0.698553] system 00:0d: iomem range 0x0-0x9ffff could not be reserved
[    0.698555] system 00:0d: iomem range 0xc0000-0xcffff has been reserved
[    0.698557] system 00:0d: iomem range 0xe0000-0xfffff could not be reserved
[    0.698559] system 00:0d: iomem range 0x100000-0xcfffffff could not be reserved
[    0.703203] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.703205] pci 0000:00:01.0:   IO window: 0xa000-0xafff
[    0.703208] pci 0000:00:01.0:   MEM window: 0xfe600000-0xfe6fffff
[    0.703211] pci 0000:00:01.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
[    0.703214] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:08
[    0.703215] pci 0000:00:1c.0:   IO window: disabled
[    0.703219] pci 0000:00:1c.0:   MEM window: disabled
[    0.703222] pci 0000:00:1c.0:   PREFETCH window: 0x000000fdf00000-0x000000fdffffff
[    0.703226] pci 0000:05:00.0: PCI bridge, secondary bus 0000:07
[    0.703227] pci 0000:05:00.0:   IO window: disabled
[    0.703234] pci 0000:05:00.0:   MEM window: disabled
[    0.703238] pci 0000:05:00.0:   PREFETCH window: disabled
[    0.703247] pci 0000:05:00.1: PCI bridge, secondary bus 0000:06
[    0.703248] pci 0000:05:00.1:   IO window: disabled
[    0.703254] pci 0000:05:00.1:   MEM window: disabled
[    0.703259] pci 0000:05:00.1:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
[    0.703268] pci 0000:00:1c.2: PCI bridge, secondary bus 0000:05
[    0.703269] pci 0000:00:1c.2:   IO window: disabled
[    0.703272] pci 0000:00:1c.2:   MEM window: 0xfea00000-0xfeafffff
[    0.703275] pci 0000:00:1c.2:   PREFETCH window: 0x000000fde00000-0x000000fdefffff
[    0.703280] pci 0000:00:1c.3: PCI bridge, secondary bus 0000:04
[    0.703282] pci 0000:00:1c.3:   IO window: 0xd000-0xdfff
[    0.703286] pci 0000:00:1c.3:   MEM window: 0xfe900000-0xfe9fffff
[    0.703289] pci 0000:00:1c.3:   PREFETCH window: disabled
[    0.703293] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    0.703295] pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
[    0.703299] pci 0000:00:1c.4:   MEM window: 0xfe800000-0xfe8fffff
[    0.703302] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.703306] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
[    0.703308] pci 0000:00:1c.5:   IO window: 0xb000-0xbfff
[    0.703312] pci 0000:00:1c.5:   MEM window: 0xfe700000-0xfe7fffff
[    0.703315] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.703319] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:09
[    0.703321] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    0.703325] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.703328] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.703338] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.703341] pci 0000:00:01.0: setting latency timer to 64
[    0.703347] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.703350] pci 0000:00:1c.0: setting latency timer to 64
[    0.703356] pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.703359] pci 0000:00:1c.2: setting latency timer to 64
[    0.703370] pci 0000:05:00.0: setting latency timer to 64
[    0.703379] pci 0000:05:00.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.703383] pci 0000:05:00.1: setting latency timer to 64
[    0.703391] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    0.703394] pci 0000:00:1c.3: setting latency timer to 64
[    0.703399] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.703402] pci 0000:00:1c.4: setting latency timer to 64
[    0.703407] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.703410] pci 0000:00:1c.5: setting latency timer to 64
[    0.703415] pci 0000:00:1e.0: setting latency timer to 64
[    0.703418] bus: 00 index 0 io port: [0x00-0xffff]
[    0.703419] bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
[    0.703421] bus: 01 index 0 io port: [0xa000-0xafff]
[    0.703422] bus: 01 index 1 mmio: [0xfe600000-0xfe6fffff]
[    0.703424] bus: 01 index 2 mmio: [0xd0000000-0xdfffffff]
[    0.703425] bus: 01 index 3 mmio: [0x0-0x0]
[    0.703426] bus: 08 index 0 mmio: [0x0-0x0]
[    0.703427] bus: 08 index 1 mmio: [0x0-0x0]
[    0.703429] bus: 08 index 2 mmio: [0xfdf00000-0xfdffffff]
[    0.703430] bus: 08 index 3 mmio: [0x0-0x0]
[    0.703431] bus: 05 index 0 mmio: [0x0-0x0]
[    0.703432] bus: 05 index 1 mmio: [0xfea00000-0xfeafffff]
[    0.703434] bus: 05 index 2 mmio: [0xfde00000-0xfdefffff]
[    0.703435] bus: 05 index 3 mmio: [0x0-0x0]
[    0.703436] bus: 07 index 0 mmio: [0x0-0x0]
[    0.703437] bus: 07 index 1 mmio: [0x0-0x0]
[    0.703439] bus: 07 index 2 mmio: [0x0-0x0]
[    0.703440] bus: 07 index 3 mmio: [0x0-0x0]
[    0.703441] bus: 06 index 0 mmio: [0x0-0x0]
[    0.703442] bus: 06 index 1 mmio: [0x0-0x0]
[    0.703443] bus: 06 index 2 mmio: [0xfde00000-0xfdefffff]
[    0.703444] bus: 06 index 3 mmio: [0x0-0x0]
[    0.703446] bus: 04 index 0 io port: [0xd000-0xdfff]
[    0.703447] bus: 04 index 1 mmio: [0xfe900000-0xfe9fffff]
[    0.703448] bus: 04 index 2 mmio: [0x0-0x0]
[    0.703449] bus: 04 index 3 mmio: [0x0-0x0]
[    0.703451] bus: 03 index 0 io port: [0xc000-0xcfff]
[    0.703452] bus: 03 index 1 mmio: [0xfe800000-0xfe8fffff]
[    0.703453] bus: 03 index 2 mmio: [0x0-0x0]
[    0.703454] bus: 03 index 3 mmio: [0x0-0x0]
[    0.703456] bus: 02 index 0 io port: [0xb000-0xbfff]
[    0.703457] bus: 02 index 1 mmio: [0xfe700000-0xfe7fffff]
[    0.703458] bus: 02 index 2 mmio: [0x0-0x0]
[    0.703459] bus: 02 index 3 mmio: [0x0-0x0]
[    0.703461] bus: 09 index 0 io port: [0xe000-0xefff]
[    0.703462] bus: 09 index 1 mmio: [0xfeb00000-0xfebfffff]
[    0.703463] bus: 09 index 2 mmio: [0x0-0x0]
[    0.703465] bus: 09 index 3 io port: [0x00-0xffff]
[    0.703466] bus: 09 index 4 mmio: [0x000000-0xffffffffffffffff]
[    0.703473] NET: Registered protocol family 2
[    0.736045] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.736376] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.737762] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.738267] TCP: Hash tables configured (established 262144 bind 65536)
[    0.738269] TCP reno registered
[    0.748107] NET: Registered protocol family 1
[    0.748208] checking if image is initramfs... it is
[    1.319781] Freeing initrd memory: 8008k freed
[    1.322676] audit: initializing netlink socket (disabled)
[    1.322692] type=2000 audit(1240581074.320:1): initialized
[    1.329630] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    1.330619] VFS: Disk quotas dquot_6.5.1
[    1.330659] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    1.331092] fuse init (API version 7.10)
[    1.331148] msgmni has been set to 7797
[    1.331295] alg: No test for stdrng (krng)
[    1.331306] io scheduler noop registered
[    1.331308] io scheduler anticipatory registered
[    1.331309] io scheduler deadline registered
[    1.331339] io scheduler cfq registered (default)
[    2.843904] pci 0000:01:00.0: Boot video device
[    2.846011] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    2.846036] pcieport-driver 0000:00:01.0: found MSI capability
[    2.846053] pcieport-driver 0000:00:01.0: irq 2303 for MSI/MSI-X
[    2.846060] pci_express 0000:00:01.0:pcie00: allocate port service
[    2.846070] pci_express 0000:00:01.0:pcie03: allocate port service
[    2.846106] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    2.846132] pcieport-driver 0000:00:1c.0: found MSI capability
[    2.846151] pcieport-driver 0000:00:1c.0: irq 2302 for MSI/MSI-X
[    2.846159] pci_express 0000:00:1c.0:pcie00: allocate port service
[    2.846168] pci_express 0000:00:1c.0:pcie02: allocate port service
[    2.846177] pci_express 0000:00:1c.0:pcie03: allocate port service
[    2.846220] pcieport-driver 0000:00:1c.2: setting latency timer to 64
[    2.846246] pcieport-driver 0000:00:1c.2: found MSI capability
[    2.846264] pcieport-driver 0000:00:1c.2: irq 2301 for MSI/MSI-X
[    2.846273] pci_express 0000:00:1c.2:pcie00: allocate port service
[    2.846282] pci_express 0000:00:1c.2:pcie02: allocate port service
[    2.846291] pci_express 0000:00:1c.2:pcie03: allocate port service
[    2.846334] pcieport-driver 0000:00:1c.3: setting latency timer to 64
[    2.846360] pcieport-driver 0000:00:1c.3: found MSI capability
[    2.846379] pcieport-driver 0000:00:1c.3: irq 2300 for MSI/MSI-X
[    2.846387] pci_express 0000:00:1c.3:pcie00: allocate port service
[    2.846396] pci_express 0000:00:1c.3:pcie02: allocate port service
[    2.846405] pci_express 0000:00:1c.3:pcie03: allocate port service
[    2.846449] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    2.846475] pcieport-driver 0000:00:1c.4: found MSI capability
[    2.846494] pcieport-driver 0000:00:1c.4: irq 2299 for MSI/MSI-X
[    2.846503] pci_express 0000:00:1c.4:pcie00: allocate port service
[    2.846512] pci_express 0000:00:1c.4:pcie02: allocate port service
[    2.846520] pci_express 0000:00:1c.4:pcie03: allocate port service
[    2.846563] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    2.846589] pcieport-driver 0000:00:1c.5: found MSI capability
[    2.846607] pcieport-driver 0000:00:1c.5: irq 2298 for MSI/MSI-X
[    2.846616] pci_express 0000:00:1c.5:pcie00: allocate port service
[    2.846627] pci_express 0000:00:1c.5:pcie02: allocate port service
[    2.846635] pci_express 0000:00:1c.5:pcie03: allocate port service
[    2.846708] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    2.847307] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    2.847413] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    2.847415] ACPI: Power Button (FF) [PWRF]
[    2.847455] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    2.847457] ACPI: Power Button (CM) [PWRB]
[    2.847932] ACPI: SSDT CFF4E0D0, 01D2 (r1    AMI   CPU1PM        1 INTL 20060113)
[    2.848184] processor ACPI_CPU:00: registered as cooling_device0
[    2.848449] ACPI: SSDT CFF4E2B0, 0143 (r1    AMI   CPU2PM        1 INTL 20060113)
[    2.848689] processor ACPI_CPU:01: registered as cooling_device1
[    2.848950] ACPI: SSDT CFF4E400, 0143 (r1    AMI   CPU3PM        1 INTL 20060113)
[    2.849185] processor ACPI_CPU:02: registered as cooling_device2
[    2.849450] ACPI: SSDT CFF4E550, 0143 (r1    AMI   CPU4PM        1 INTL 20060113)
[    2.849698] processor ACPI_CPU:03: registered as cooling_device3
[    2.877653] Linux agpgart interface v0.103
[    2.877663] Serial: 8250/16550 driver4 ports, IRQ sharing enabled
[    2.877743] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.878032] 00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    2.878574] brd: module loaded
[    2.878807] loop: module loaded
[    2.878857] Fixed MDIO Bus: probed
[    2.878861] PPP generic driver version 2.4.2
[    2.878902] input: Macintosh mouse button emulation as /devices/virtual/input/input2
[    2.878922] Driver 'sd' needs updating - please use bus_type methods
[    2.878929] Driver 'sr' needs updating - please use bus_type methods
[    2.878959] ahci 0000:00:1f.2: version 3.0
[    2.878970] ahci 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
[    2.878994] ahci 0000:00:1f.2: irq 2297 for MSI/MSI-X
[    2.879051] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.879053] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio slum part ems 
[    2.879056] ahci 0000:00:1f.2: setting latency timer to 64
[    2.879309] scsi0 : ahci
[    2.879383] scsi1 : ahci
[    2.879437] scsi2 : ahci
[    2.879483] scsi3 : ahci
[    2.879536] scsi4 : ahci
[    2.879585] scsi5 : ahci
[    2.879676] ata1: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5fe900 irq 2297
[    2.879678] ata2: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5fe980 irq 2297
[    2.879680] ata3: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5fea00 irq 2297
[    2.879682] ata4: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5fea80 irq 2297
[    2.879684] ata5: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5feb00 irq 2297
[    2.879686] ata6: SATA max UDMA/133 abar m2048@0xfe5fe800 port 0xfe5feb80 irq 2297
[    3.360010] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.361082] ata1.00: ATAPI: PIONEER DVD-RW  DVR-212, 1.21, max UDMA/66
[    3.362452] ata1.00: configured for UDMA/66
[    3.860013] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    3.869016] ata2.00: HPA unlocked: 234372887 -> 234375000, native 234375000
[    3.869019] ata2.00: ATA-6: WDC WD1200JD-75FYB0, 02.05D02, max UDMA/100
[    3.869021] ata2.00: 234375000 sectors, multi 0: LBA48 
[    3.869027] ata2.00: applying bridge limits
[    3.874394] ata2.00: configured for UDMA/100
[    4.372010] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.373051] ata3.00: HPA unlocked: 312579695 -> 312581808, native 312581808
[    4.373054] ata3.00: ATA-7: WDC WD1600JS-88MHB0, 02.01C03, max UDMA/133
[    4.373055] ata3.00: 312581808 sectors, multi 0: LBA48 
[    4.373635] ata3.00: configured for UDMA/133
[    4.872012] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.878316] ata4.00: ATA-7: SAMSUNG HD502IJ, 1AA01113, max UDMA7
[    4.878318] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.884690] ata4.00: configured for UDMA/133
[    5.384009] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.384523] ata5.00: ATA-7: WDC WD1600JS-88MHB0, 02.01C03, max UDMA/133
[    5.384525] ata5.00: 312581808 sectors, multi 0: LBA48 
[    5.385130] ata5.00: configured for UDMA/133
[    5.884011] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.897657] ata6.00: ATA-8: Hitachi HDT721016SLA380, ST1OA31B, max UDMA/133
[    5.897659] ata6.00: 312581808 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.898530] ata6.00: configured for UDMA/133
[    5.918383] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-212  1.21 PQ: 0 ANSI: 5
[    5.924347] sr0: scsi3-mmc drive: 62x/62x writer dvd-ram cd/rw xa/form2 cdda tray
[    5.924350] Uniform CD-ROM driver Revision: 3.20
[    5.924452] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    5.924501] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    5.924570] scsi 1:0:0:0: Direct-Access     ATA      WDC WD1200JD-75F 02.0 PQ: 0 ANSI: 5
[    5.924646] sd 1:0:0:0: [sda] 234375000 512-byte hardware sectors: (120 GB/111 GiB)
[    5.924659] sd 1:0:0:0: [sda] Write Protect is off
[    5.924661] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.924681] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.924723] sd 1:0:0:0: [sda] 234375000 512-byte hardware sectors: (120 GB/111 GiB)
[    5.924734] sd 1:0:0:0: [sda] Write Protect is off
[    5.924735] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.924755] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.924757]  sda: sda1
[    5.946203] sd 1:0:0:0: [sda] Attached SCSI disk
[    5.946231] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.946292] scsi 2:0:0:0: Direct-Access     ATA      WDC WD1600JS-88M 02.0 PQ: 0 ANSI: 5
[    5.946356] sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.946367] sd 2:0:0:0: [sdb] Write Protect is off
[    5.946369] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.946388] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.946433] sd 2:0:0:0: [sdb] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.946444] sd 2:0:0:0: [sdb] Write Protect is off
[    5.946446] sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.946465] sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.946467]  sdb: sdb1
[    5.956476] sd 2:0:0:0: [sdb] Attached SCSI disk
[    5.956511] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    5.956577] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[    5.956642] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    5.956654] sd 3:0:0:0: [sdc] Write Protect is off
[    5.956656] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.956675] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.956724] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    5.956735] sd 3:0:0:0: [sdc] Write Protect is off
[    5.956737] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.956755] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.956758]  sdc: sdc1
[    5.968056] sd 3:0:0:0: [sdc] Attached SCSI disk
[    5.968086] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    5.968135] scsi 4:0:0:0: Direct-Access     ATA      WDC WD1600JS-88M 02.0 PQ: 0 ANSI: 5
[    5.968196] sd 4:0:0:0: [sdd] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.968207] sd 4:0:0:0: [sdd] Write Protect is off
[    5.968209] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.968228] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.968270] sd 4:0:0:0: [sdd] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.968281] sd 4:0:0:0: [sdd] Write Protect is off
[    5.968283] sd 4:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.968302] sd 4:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.968304]  sdd: sdd1
[    5.974320] sd 4:0:0:0: [sdd] Attached SCSI disk
[    5.974352] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    5.974404] scsi 5:0:0:0: Direct-Access     ATA      Hitachi HDT72101 ST1O PQ: 0 ANSI: 5
[    5.974467] sd 5:0:0:0: [sde] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.974478] sd 5:0:0:0: [sde] Write Protect is off
[    5.974479] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.974498] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.974540] sd 5:0:0:0: [sde] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[    5.974552] sd 5:0:0:0: [sde] Write Protect is off
[    5.974553] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.974572] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.974575]  sde: sde1
[    5.996893] sd 5:0:0:0: [sde] Attached SCSI disk
[    5.996920] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    5.997267] pata_marvell 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    5.997294] pata_marvell 0000:02:00.0: setting latency timer to 64
[    5.997362] scsi6 : pata_marvell
[    5.997414] scsi7 : pata_marvell
[    5.997440] ata7: PATA max UDMA/100 cmd 0xbc00 ctl 0xb880 bmdma 0xb400 irq 17
[    5.997441] ata8: PATA max UDMA/133 cmd 0xb800 ctl 0xb480 bmdma 0xb408 irq 17
[    6.336056] ata8.01: ATA-8: WDC WD5000AAKS-00A7B2, 01.03B01, max UDMA/133
[    6.336058] ata8.01: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    6.352492] ata8.01: configured for UDMA/133
[    6.352552] scsi 7:0:1:0: Direct-Access     ATA      WDC WD5000AAKS-0 01.0 PQ: 0 ANSI: 5
[    6.352615] sd 7:0:1:0: [sdf] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    6.352626] sd 7:0:1:0: [sdf] Write Protect is off
[    6.352627] sd 7:0:1:0: [sdf] Mode Sense: 00 3a 00 00
[    6.352646] sd 7:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.352685] sd 7:0:1:0: [sdf] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[    6.352695] sd 7:0:1:0: [sdf] Write Protect is off
[    6.352697] sd 7:0:1:0: [sdf] Mode Sense: 00 3a 00 00
[    6.352715] sd 7:0:1:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    6.352718]  sdf: sdf1
[    6.360778] sd 7:0:1:0: [sdf] Attached SCSI disk
[    6.360808] sd 7:0:1:0: Attached scsi generic sg6 type 0
[    6.360993] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.361008] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.361025] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.361028] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.361072] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[    6.364986] ehci_hcd 0000:00:1a.7: debug port 1
[    6.364991] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.365001] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfe5ffc00
[    6.380006] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.380056] usb usb1: configuration #1 chosen from 1 choice
[    6.380075] hub 1-0:1.0: USB hub found
[    6.380080] hub 1-0:1.0: 6 ports detected
[    6.380165] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.380174] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.380177] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    6.380214] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[    6.384123] ehci_hcd 0000:00:1d.7: debug port 1
[    6.384127] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    6.384136] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfe5ff800
[    6.400006] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    6.400044] usb usb2: configuration #1 chosen from 1 choice
[    6.400062] hub 2-0:1.0: USB hub found
[    6.400067] hub 2-0:1.0: 6 ports detected
[    6.400135] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    6.400146] uhci_hcd: USB Universal Host Controller Interface driver
[    6.400175] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    6.400179] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    6.400182] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    6.400214] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[    6.400241] uhci_hcd 0000:00:1a.0: irq 16, io base 0x00009800
[    6.400293] usb usb3: configuration #1 chosen from 1 choice
[    6.400312] hub 3-0:1.0: USB hub found
[    6.400317] hub 3-0:1.0: 2 ports detected
[    6.400377] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    6.400382] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    6.400384] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    6.400412] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[    6.400436] uhci_hcd 0000:00:1a.1: irq 21, io base 0x00009880
[    6.400490] usb usb4: configuration #1 chosen from 1 choice
[    6.400507] hub 4-0:1.0: USB hub found
[    6.400511] hub 4-0:1.0: 2 ports detected
[    6.400576] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.400581] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.400583] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.400611] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
[    6.400630] uhci_hcd 0000:00:1a.2: irq 18, io base 0x00009c00
[    6.400683] usb usb5: configuration #1 chosen from 1 choice
[    6.400700] hub 5-0:1.0: USB hub found
[    6.400704] hub 5-0:1.0: 2 ports detected
[    6.400768] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
[    6.400772] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.400774] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.400806] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
[    6.400825] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00009080
[    6.400875] usb usb6: configuration #1 chosen from 1 choice
[    6.400894] hub 6-0:1.0: USB hub found
[    6.400899] hub 6-0:1.0: 2 ports detected
[    6.400956] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    6.400960] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.400962] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.400993] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
[    6.401017] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00009400
[    6.401068] usb usb7: configuration #1 chosen from 1 choice
[    6.401086] hub 7-0:1.0: USB hub found
[    6.401090] hub 7-0:1.0: 2 ports detected
[    6.401151] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    6.401155] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.401158] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.401192] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
[    6.401210] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00009480
[    6.401263] usb usb8: configuration #1 chosen from 1 choice
[    6.401280] hub 8-0:1.0: USB hub found
[    6.401287] hub 8-0:1.0: 2 ports detected
[    6.401382] usbcore: registered new interface driver libusual
[    6.401406] usbcore: registered new interface driver usbserial
[    6.401415] USB Serial support registered for generic
[    6.401427] usbcore: registered new interface driver usbserial_generic
[    6.401428] usbserial: USB Serial Driver core
[    6.401461] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    6.401463] PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    6.401924] serio: i8042 KBD port at 0x60,0x64 irq 1
[    6.416032] mice: PS/2 mouse device common for all mice
[    6.452051] rtc_cmos 00:03: RTC can wake from S4
[    6.452082] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    6.452103] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    6.452151] device-mapper: uevent: version 1.0.3
[    6.452220] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    6.452323] device-mapper: multipath: version 1.0.5 loaded
[    6.452325] device-mapper: multipath round-robin: version 1.0.0 loaded
[    6.452436] cpuidle: using governor ladder
[    6.452438] cpuidle: using governor menu
[    6.452744] TCP cubic registered
[    6.452797] NET: Registered protocol family 10
[    6.453093] lo: Disabled Privacy Extensions
[    6.453304] NET: Registered protocol family 17
[    6.453317] Bluetooth: L2CAP ver 2.11
[    6.453318] Bluetooth: L2CAP socket layer initialized
[    6.453321] Bluetooth: SCO (Voice Link) ver 0.6
[    6.453322] Bluetooth: SCO socket layer initialized
[    6.453349] Bluetooth: RFCOMM socket layer initialized
[    6.453353] Bluetooth: RFCOMM TTY layer initialized
[    6.453354] Bluetooth: RFCOMM ver 1.10
[    6.454276] registered taskstats version 1
[    6.454406]   Magic number: 5:508:888
[    6.454482] rtc_cmos 00:03: setting system clock to 2009-04-24 13:51:20 UTC (1240581080)
[    6.454485] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    6.454486] EDD information not available.
[    6.454520] Freeing unused kernel memory: 536k freed
[    6.454658] Write protecting the kernel read-only data: 6708k
[    6.549139] md: linear personality registered for level -1
[    6.550694] md: multipath personality registered for level -4
[    6.552084] md: raid0 personality registered for level 0
[    6.554263] md: raid1 personality registered for level 1
[    6.555502] xor: automatically using best checksumming function: generic_sse
[    6.572003]    generic_sse:  8954.000 MB/sec
[    6.572005] xor: using function: generic_sse (8954.000 MB/sec)
[    6.572828] async_tx: api initialized (async)
[    6.640018] raid6: int64x1   1924 MB/s
[    6.708012] raid6: int64x2   2639 MB/s
[    6.776025] raid6: int64x4   2022 MB/s
[    6.844033] raid6: int64x8   1800 MB/s
[    6.912005] raid6: sse2x1    3916 MB/s
[    6.980005] raid6: sse2x2    4410 MB/s
[    7.048007] raid6: sse2x4    7193 MB/s
[    7.048008] raid6: using algorithm sse2x4 (7193 MB/s)
[    7.048010] md: raid6 personality registered for level 6
[    7.048011] md: raid5 personality registered for level 5
[    7.048013] md: raid4 personality registered for level 4
[    7.052819] md: raid10 personality registered for level 10
[    7.099397] sky2 driver version 1.22
[    7.099442] sky2 0000:04:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    7.099455] sky2 0000:04:00.0: setting latency timer to 64
[    7.099495] sky2 0000:04:00.0: Yukon-2 EC chip revision 2
[    7.123099] ohci1394 0000:09:07.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    7.131416] sky2 0000:04:00.0: Marvell Yukon 88E8052 Gigabit Ethernet Controller
[    7.131418]  Part Number: Yukon 88E8052
[    7.131419]  Engineering Level: Rev. 2.1
[    7.131421]  Manufacturer: Marvell
[    7.131469] sky2 0000:04:00.0: irq 2296 for MSI/MSI-X
[    7.131932] sky2 eth0: addr 00:1d:60:44:0d:a8
[    7.131945] sky2 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    7.131952] sky2 0000:03:00.0: setting latency timer to 64
[    7.131968] sky2 0000:03:00.0: Yukon-2 EC Ultra chip revision 2
[    7.161520] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    7.163906] sky2 0000:03:00.0: Marvell Yukon 88E8056 Gigabit Ethernet Controller
[    7.163908]  Part Number: Yukon 88E8056
[    7.163909]  Engineering Level: Rev. 1.2
[    7.163910]  Manufacturer: Marvell
[    7.163959] sky2 0000:03:00.0: irq 2295 for MSI/MSI-X
[    7.165088] sky2 eth1: addr 00:1d:60:44:02:22
[    7.175805] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[20]  MMIO=[febff800-febfffff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[    7.188316] md: bind<sdb1>
[    7.192280] md: bind<sde1>
[    7.234842] md: bind<sdc1>
[    7.239692] md: bind<sdd1>
[    7.241339] raid10: raid set md0 active with 4 out of 4 devices
[    7.242651]  md0: unknown partition table
[    7.295555] usb 1-1: configuration #1 chosen from 1 choice
[    7.298587] Initializing USB Mass Storage driver...
[    7.298686] scsi8 : SCSI emulation for USB Mass Storage devices
[    7.298759] usbcore: registered new interface driver usb-storage
[    7.298761] USB Mass Storage support registered.
[    7.298848] usb-storage: device found at 2
[    7.298849] usb-storage: waiting for device to settle before scanning
[    7.351790] kjournald starting.  Commit interval 5 seconds
[    7.351808] EXT3-fs: mounted filesystem with ordered data mode.
[    7.648010] usb 6-1: new low speed USB device using uhci_hcd and address 2
[    7.831014] usb 6-1: configuration #1 chosen from 1 choice
[    8.072009] usb 6-2: new low speed USB device using uhci_hcd and address 3
[    8.252038] usb 6-2: configuration #1 chosen from 1 choice
[    8.461044] ieee1394: The root node is not cycle master capable; selecting a new root node and resetting...
[    9.417041] ieee1394: Error parsing configrom for node 0-00:1023
[    9.417144] ieee1394: Host added: ID:BUS[0-01:1023]  GUID[0011d800016ef355]
[   12.281857] udev: starting version 141
[   12.297256] usb-storage: device scan complete
[   12.297858] scsi 8:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[   12.298359] scsi 8:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[   12.298854] scsi 8:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[   12.299350] scsi 8:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[   12.300715] sd 8:0:0:0: [sdg] Attached SCSI removable disk
[   12.300776] sd 8:0:0:0: Attached scsi generic sg7 type 0
[   12.301522] sd 8:0:0:1: [sdh] Attached SCSI removable disk
[   12.301559] sd 8:0:0:1: Attached scsi generic sg8 type 0
[   12.304415] sd 8:0:0:2: [sdi] Attached SCSI removable disk
[   12.305240] sd 8:0:0:2: Attached scsi generic sg9 type 0
[   12.306032] sd 8:0:0:3: [sdj] Attached SCSI removable disk
[   12.306081] sd 8:0:0:3: Attached scsi generic sg10 type 0
[   12.615678] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   12.643860] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[   12.725591] iTCO_vendor_support: vendor-support=0
[   12.763730] usbcore: registered new interface driver hiddev
[   12.765107] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
[   12.765268] iTCO_wdt: Found a ICH9R TCO device (Version=2, TCOBASE=0x0860)
[   12.765359] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[   12.778592] input: Microsoft Microsoft 5-Button Mouse with IntelliEye(TM) as /devices/pci0000:00/0000:00:1d.0/usb6/6-1/6-1:1.0/input/input4
[   12.809112] generic-usb 0003:045E:0047.0001: input,hidraw0: USB HID v1.10 Mouse [Microsoft Microsoft 5-Button Mouse with IntelliEye(TM)] on usb-0000:00:1d.0-1/input0
[   12.809317] usbcore: registered new interface driver usbhid
[   12.809334] usbhid: v2.6:USB HID core driver
[   12.837588] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.0/input/input5
[   12.872133] logitech 0003:046D:C30A.0002: input,hidraw1: USB HID v1.10 Keyboard [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-2/input0
[   12.908429] input: Logitech Logitech USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb6/6-2/6-2:1.1/input/input6
[   12.948922] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[   12.948997] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   12.957125] logitech 0003:046D:C30A.0003: input,hidraw2: USB HID v1.10 Mouse [Logitech Logitech USB Keyboard] on usb-0000:00:1d.0-2/input1
[   12.981909] hda_codec: Unknown model for ALC883, trying auto-probe from BIOS...
[   13.015306] HDA Intel 0000:01:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[   13.015340] HDA Intel 0000:01:00.1: setting latency timer to 64
[   13.284873] lp: driver loaded but no devices found
[   13.307670] w83627ehf: Found W83627DHG chip at 0x290
[   13.321837] coretemp coretemp.0: Using relative temperature scale!
[   13.321870] coretemp coretemp.1: Using relative temperature scale!
[   13.321900] coretemp coretemp.2: Using relative temperature scale!
[   13.321932] coretemp coretemp.3: Using relative temperature scale!
[   14.001090] EXT3 FS on md0, internal journal
[   14.821172] kjournald starting.  Commit interval 5 seconds
[   14.821479] EXT3 FS on sda1, internal journal
[   14.821485] EXT3-fs: mounted filesystem with ordered data mode.
[   15.228096] type=1505 audit(1240581089.273:2): operation="profile_load" name="/usr/share/gdm/guest-session/Xsession" name2="default" pid=2574
[   15.258990] type=1505 audit(1240581089.301:3): operation="profile_load" name="/sbin/dhclient-script" name2="default" pid=2578
[   15.259063] type=1505 audit(1240581089.301:4): operation="profile_load" name="/sbin/dhclient3" name2="default" pid=2578
[   15.259091] type=1505 audit(1240581089.301:5): operation="profile_load" name="/usr/lib/NetworkManager/nm-dhcp-client.action" name2="default" pid=2578
[   15.259118] type=1505 audit(1240581089.301:6): operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script" name2="default" pid=2578
[   15.343892] type=1505 audit(1240581089.385:7): operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" name2="default" pid=2583
[   15.344015] type=1505 audit(1240581089.389:8): operation="profile_load" name="/usr/sbin/cupsd" name2="default" pid=2583
[   15.363450] type=1505 audit(1240581089.405:9): operation="profile_load" name="/usr/sbin/tcpdump" name2="default" pid=2587
[   23.964025] usb 1-2: new high speed USB device using ehci_hcd and address 3
[   24.098165] usb 1-2: configuration #1 chosen from 1 choice
[   24.099484] scsi9 : SCSI emulation for USB Mass Storage devices
[   24.100424] usb-storage: device found at 3
[   24.100426] usb-storage: waiting for device to settle before scanning
[   26.628160] vboxdrv: Trying to deactivate the NMI watchdog permanently...
[   26.628164] vboxdrv: Successfully done.
[   26.628166] vboxdrv: Found 4 processor cores.
[   26.628233] VBoxDrv: dbg - g_abExecMemory=ffffffffa02e0aa0
[   26.628297] vboxdrv: fAsync=0 offMin=0x507 offMax=0x1ec3
[   26.628348] vboxdrv: TSC mode is 'synchronous', kernel timer mode is 'normal'.
[   26.628350] vboxdrv: Successfully loaded version 2.1.4_OSE (interface 0x000a0009).
[   26.834527] VBoxNetFlt: dbg - g_abExecMemory=ffffffffa047f940
[   28.143742] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   28.143746] Bluetooth: BNEP filters: protocol multicast
[   28.216860] Bridge firewalling registered
[   29.100186] usb-storage: device scan complete
[   29.100915] scsi 9:0:0:0: Direct-Access     FUJITSU  MHV2060AT        0096 PQ: 0 ANSI: 2 CCS
[   29.101889] sd 9:0:0:0: [sdk] 117210240 512-byte hardware sectors: (60.0 GB/55.8 GiB)
[   29.102640] sd 9:0:0:0: [sdk] Write Protect is off
[   29.102643] sd 9:0:0:0: [sdk] Mode Sense: 00 38 00 00
[   29.102645] sd 9:0:0:0: [sdk] Assuming drive cache: write through
[   29.103398] sd 9:0:0:0: [sdk] 117210240 512-byte hardware sectors: (60.0 GB/55.8 GiB)
[   29.104143] sd 9:0:0:0: [sdk] Write Protect is off
[   29.104145] sd 9:0:0:0: [sdk] Mode Sense: 00 38 00 00
[   29.104147] sd 9:0:0:0: [sdk] Assuming drive cache: write through
[   29.104181]  sdk: sdk1
[   29.128669] sd 9:0:0:0: [sdk] Attached SCSI disk
[   29.128752] sd 9:0:0:0: Attached scsi generic sg11 type 0
[   29.701444] pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   30.013654] [drm] Initialized drm 1.1.0 20060810
[   30.077970] pci 0000:01:00.0: setting latency timer to 64
[   30.078112] [drm] Initialized radeon 1.29.0 20080528 on minor 0
[   30.078749] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   30.124475] ppdev: user-space parallel port driver
[   30.387132] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   30.387180] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   30.387213] mtrr: type mismatch for d0000000,10000000 old: write-back new: write-combining
[   30.443491] [drm] Setting GART location based on new memory map
[   30.459038] [drm] Loading RV770 PFP Microcode
[   30.459068] [drm] Loading RV770 CP Microcode
[   30.474019] [drm] Resetting GPU
[   30.474075] [drm] writeback test succeeded in 1 usecs
[   33.958952] sky2 eth1: enabling interface
[   33.959510] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   33.962008] sky2 eth0: enabling interface
[   33.962539] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   36.305177] sky2 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[   36.305950] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   46.808010] eth0: no IPv6 routers present
[   56.226475] end_request: I/O error, dev sr0, sector 13283944
[   56.317007] end_request: I/O error, dev sr0, sector 13283940
[   56.389432] kjournald starting.  Commit interval 5 seconds
[   56.390259] EXT3 FS on sdk1, internal journal
[   56.390264] EXT3-fs: mounted filesystem with ordered data mode.
[   56.407681] end_request: I/O error, dev sr0, sector 13283948
[   56.570102] UDF-fs: Partition marked readonly; forcing readonly mount
[   56.610854] UDF-fs INFO UDF: Mounting volume 'GALAXY_QUEST_SKU1', timestamp 2001/01/05 11:30 (1000)
[ 1436.994822] npviewer.bin[5954]: segfault at 79616c70 ip 0000000079616c70 sp 00000000ffa99b5c error 14
[ 3854.158005] usb 1-2: USB disconnect, address 3
[ 8618.089131] npviewer.bin[9234]: segfault at f5533030 ip 00000000f78809e0 sp 00000000ffb53624 error 4 in libpthread-2.9.so[f7879000+15000]
[ 8621.640750] npviewer.bin[9268]: segfault at f5567030 ip 00000000f78b49e0 sp 00000000ffa89e04 error 4 in libpthread-2.9.so[f78ad000+15000]
[ 8627.698590] npviewer.bin[9354]: segfault at f552a030 ip 00000000f78779e0 sp 00000000ffc4a714 error 4 in libpthread-2.9.so[f7870000+15000]
[16859.561540] ata4.00: exception Emask 0x10 SAct 0x1 SErr 0x4010000 action 0xe frozen
[16859.561544] ata4.00: irq_stat 0x00400040, connection status changed
[16859.561546] ata4: SError: { PHYRdyChg DevExch }
[16859.561550] ata4.00: cmd 61/78:00:c7:71:4f/00:00:09:00:00/40 tag 0 ncq 61440 out
[16859.561551]          res 40/00:04:c7:71:4f/00:00:09:00:00/40 Emask 0x10 (ATA bus error)
[16859.561553] ata4.00: status: { DRDY }
[16859.561557] ata4: hard resetting link
[16865.917018] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[16865.929735] ata4.00: configured for UDMA/133
[16865.929744] ata4: EH complete
[16865.929778] sd 3:0:0:0: [sdc] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[16865.929792] sd 3:0:0:0: [sdc] Write Protect is off
[16865.929793] sd 3:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[16865.929812] sd 3:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17478.834643] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
[17478.834648] ata4: irq_stat 0x00400040, connection status changed
[17478.834651] ata4: SError: { PHYRdyChg DevExch }
[17478.834657] ata4: hard resetting link
[17481.005022] ata4: SATA link down (SStatus 0 SControl 300)
[17481.441296] ata4: hard resetting link
[17481.797021] ata4: SATA link down (SStatus 0 SControl 300)
[17481.797028] ata4: limiting SATA link speed to 1.5 Gbps
[17481.945025] ata4: hard resetting link
[17482.340027] ata4: SATA link down (SStatus 0 SControl 310)
[17482.340033] ata4.00: disabled
[17482.340044] ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[17482.340047] ata4: irq_stat 0x00000040, connection status changed
[17482.340051] ata4: hard resetting link
[17482.341014] sd 3:0:0:0: rejecting I/O to offline device
[17482.341036] sd 3:0:0:0: rejecting I/O to offline device
[17482.341041] sd 3:0:0:0: rejecting I/O to offline device
[17482.341044] end_request: I/O error, dev sdc, sector 312576575
[17482.341049] md: super_written gets error=-5, uptodate=0
[17482.341053] raid10: Disk failure on sdc1, disabling device.
[17482.341054] raid10: Operation continuing on 3 devices.
[17484.568010] ata4: COMRESET failed (errno=-32)
[17484.568016] ata4: reset failed (errno=-32), retrying in 8 secs
[17492.340022] ata4: limiting SATA link speed to 1.5 Gbps
[17492.340025] ata4: hard resetting link
[17493.232015] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17493.238346] ata4.00: ATA-7: SAMSUNG HD502IJ, 1AA01113, max UDMA7
[17493.238350] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[17493.244749] ata4.00: configured for UDMA/133
[17493.244758] ata4: EH complete
[17493.244764] ata4.00: detaching (SCSI 3:0:0:0)
[17493.261680] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[17493.262763] sd 3:0:0:0: [sdc] Stopping disk
[17494.127627] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[17494.127734] sd 3:0:0:0: [sdk] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[17494.127753] sd 3:0:0:0: [sdk] Write Protect is off
[17494.127755] sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[17494.127784] sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17494.127867] sd 3:0:0:0: [sdk] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[17494.127883] sd 3:0:0:0: [sdk] Write Protect is off
[17494.127886] sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[17494.127914] sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17494.127918]  sdk: sdk1
[17499.837638] sd 3:0:0:0: [sdk] Attached SCSI disk
[17499.837717] sd 3:0:0:0: Attached scsi generic sg11 type 0
[17507.232934] ata4: exception Emask 0x10 SAct 0x0 SErr 0x4010000 action 0xe frozen
[17507.232938] ata4: irq_stat 0x00400040, connection status changed
[17507.232940] ata4: SError: { PHYRdyChg DevExch }
[17507.232944] ata4: hard resetting link
[17508.768025] ata4: SATA link down (SStatus 0 SControl 310)
[17509.215977] ata4: hard resetting link
[17509.612599] ata4: SATA link down (SStatus 0 SControl 310)
[17509.748151] ata4: hard resetting link
[17510.133023] ata4: SATA link down (SStatus 0 SControl 310)
[17510.133029] ata4.00: disabled
[17510.133041] ata4: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[17510.133044] ata4: irq_stat 0x00000040, connection status changed
[17510.133048] ata4: hard resetting link
[17512.433017] ata4: COMRESET failed (errno=-32)
[17512.433022] ata4: reset failed (errno=-32), retrying in 8 secs
[17514.781523] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[17514.781530] ata6.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
[17514.781532]          res 40/00:00:00:4f:c2/00:01:00:00:00/00 Emask 0x4 (timeout)
[17514.781535] ata6.00: status: { DRDY }
[17514.781540] ata6: hard resetting link
[17520.133014] ata4: limiting SATA link speed to 1.5 Gbps
[17520.133018] ata4: hard resetting link
[17523.429013] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17523.435339] ata4.00: ATA-7: SAMSUNG HD502IJ, 1AA01113, max UDMA7
[17523.435343] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[17523.441748] ata4.00: configured for UDMA/133
[17523.441757] ata4: EH complete
[17523.441761] ata4.00: detaching (SCSI 3:0:0:0)
[17523.442035] sd 3:0:0:0: [sdk] Synchronizing SCSI cache
[17523.442970] sd 3:0:0:0: [sdk] Stopping disk
[17524.309488] scsi 3:0:0:0: Direct-Access     ATA      SAMSUNG HD502IJ  1AA0 PQ: 0 ANSI: 5
[17524.309588] sd 3:0:0:0: [sdk] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[17524.309607] sd 3:0:0:0: [sdk] Write Protect is off
[17524.309609] sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[17524.309638] sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17524.309713] sd 3:0:0:0: [sdk] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[17524.309730] sd 3:0:0:0: [sdk] Write Protect is off
[17524.309732] sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[17524.309760] sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17524.309764]  sdk:<3>ata6: softreset failed (device not ready)
[17524.785521] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17526.466449] ata4.00: exception Emask 0x10 SAct 0x1 SErr 0x4010000 action 0xe frozen
[17526.466454] ata4.00: irq_stat 0x00400040, connection status changed
[17526.466457] ata4: SError: { PHYRdyChg DevExch }
[17526.466463] ata4.00: cmd 60/08:00:00:00:00/00:00:00:00:00/40 tag 0 ncq 4096 in
[17526.466464]          res 40/00:04:00:00:00/00:00:00:00:00/40 Emask 0x10 (ATA bus error)
[17526.466467] ata4.00: status: { DRDY }
[17526.466472] ata4: hard resetting link
[17528.788013] ata4: COMRESET failed (errno=-32)
[17528.788019] ata4: reset failed (errno=-32), retrying in 8 secs
[17529.785517] ata6.00: qc timeout (cmd 0xec)
[17529.785524] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[17529.785527] ata6.00: revalidation failed (errno=-5)
[17529.785531] ata6: hard resetting link
[17536.464011] ata4: hard resetting link
[17538.948010] ata4: COMRESET failed (errno=-32)
[17538.948016] ata4: reset failed (errno=-32), retrying in 8 secs
[17539.788014] ata6: softreset failed (device not ready)
[17539.788025] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[17546.468012] ata4: hard resetting link
[17548.868012] ata4: COMRESET failed (errno=-32)
[17548.868017] ata4: reset failed (errno=-32), retrying in 33 secs
[17549.789519] ata6.00: qc timeout (cmd 0xec)
[17549.789528] ata6.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[17549.789531] ata6.00: revalidation failed (errno=-5)
[17549.789537] ata6: limiting SATA link speed to 1.5 Gbps
[17549.789541] ata6: hard resetting link
[17559.792010] ata6: softreset failed (device not ready)
[17559.792019] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17565.818759] ata6.00: configured for UDMA/133
[17565.818777] end_request: I/O error, dev sde, sector 312576575
[17565.818784] md: super_written gets error=-5, uptodate=0
[17565.818788] raid10: Disk failure on sde1, disabling device.
[17565.818789] raid10: Operation continuing on 2 devices.
[17565.818818] ata6: EH complete
[17565.841972] RAID10 conf printout:
[17565.841975]  --- wd:2 rd:4
[17565.841977]  disk 0, wo:1, o:0, dev:sde1
[17565.841980]  disk 1, wo:0, o:1, dev:sdb1
[17565.841982]  disk 2, wo:1, o:0, dev:sdc1
[17565.841984]  disk 3, wo:0, o:1, dev:sdd1
[17565.852516] RAID10 conf printout:
[17565.852519]  --- wd:2 rd:4
[17565.852521]  disk 0, wo:1, o:0, dev:sde1
[17565.852523]  disk 1, wo:0, o:1, dev:sdb1
[17565.852525]  disk 3, wo:0, o:1, dev:sdd1
[17565.852533] RAID10 conf printout:
[17565.852535]  --- wd:2 rd:4
[17565.852536]  disk 0, wo:1, o:0, dev:sde1
[17565.852538]  disk 1, wo:0, o:1, dev:sdb1
[17565.852540]  disk 3, wo:0, o:1, dev:sdd1
[17565.864509] RAID10 conf printout:
[17565.864512]  --- wd:2 rd:4
[17565.864515]  disk 1, wo:0, o:1, dev:sdb1
[17565.864517]  disk 3, wo:0, o:1, dev:sdd1
[17581.464012] ata4: hard resetting link
[17582.352012] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[17582.364735] ata4.00: configured for UDMA/133
[17582.364746] ata4: EH complete
[17582.364763] scsi 3:0:0:0: rejecting I/O to dead device
[17582.364773] scsi 3:0:0:0: rejecting I/O to dead device
[17582.364779] scsi 3:0:0:0: rejecting I/O to dead device
[17582.364788] scsi 3:0:0:0: rejecting I/O to dead device
[17582.374781]  sdk1
[17582.375390] sd 3:0:0:0: [sdk] Attached SCSI disk
[17582.375475] sd 3:0:0:0: Attached scsi generic sg3 type 0
[17582.375526] sd 5:0:0:0: [sde] 312581808 512-byte hardware sectors: (160 GB/149 GiB)
[17582.375545] sd 5:0:0:0: [sde] Write Protect is off
[17582.375548] sd 5:0:0:0: [sde] Mode Sense: 00 3a 00 00
[17582.375576] sd 5:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17582.376545] sd 3:0:0:0: [sdk] 976773168 512-byte hardware sectors: (500 GB/465 GiB)
[17582.376565] sd 3:0:0:0: [sdk] Write Protect is off
[17582.376568] sd 3:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[17582.376597] sd 3:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[17690.150185] scsi 3:0:0:0: rejecting I/O to dead device
[17690.150195] scsi 3:0:0:0: rejecting I/O to dead device
[17690.150201] scsi 3:0:0:0: rejecting I/O to dead device
[17690.150210] scsi 3:0:0:0: rejecting I/O to dead device

--------------060204010900070505020103--
