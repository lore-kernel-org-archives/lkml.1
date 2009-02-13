Return-Path: <linux-kernel-owner+w=401wt.eu-S1758596AbZBMT4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596AbZBMT4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 14:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbZBMT4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 14:56:03 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:43027 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZBMTz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 14:55:58 -0500
X-Greylist: delayed 4284 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Feb 2009 14:55:56 EST
From: Philippe Grenard <philippe.grenard@laposte.net>
To: linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: cannot get stable system since 2.6.28 kernel
Date: Fri, 13 Feb 2009 20:56:19 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.27.10-phiphi; KDE/4.2.0; x86_64; ; )
Cc: Len Brown <lenb@kernel.org>
References: <200902131944.56634.philippe.grenard@laposte.net> <alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0902131356010.5440@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902132056.20097.philippe.grenard@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 February 2009 19:56:54 Len Brown wrote:
> dmesg -- assuming you can boot far enough to capture it,
> may be helpful.
>
> also, disabling PREEMPT may be interesting to try.
>
> cheers,
> --
> Len Brown, Intel Open Source Technology Center

I tried to disable all "PREEMPT" options in make config, re-compiled 2.6.29-rc4 
and managed to get these info before kernel stalls :
(Was that what you understood by "disabling PREEMPT" ?)

I'll also try to make some diff on the different files to see what changes 
between working 2.6.27.10 and non-working 2.6.29-rc4

Philippe

********* DMESG *************

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.29-rc4 (root@debian) (gcc version 4.3.3 
(Debian 4.3.3-3) ) #1 SMP Fri Feb 13 20:31:27 CET 2009
[    0.000000] Command line: root=/dev/sda5 ro vga=0x0369
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel
[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
[    0.000000]  BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff70000 (usable)
[    0.000000]  BIOS-e820: 000000007ff70000 - 000000007ff7e000 (ACPI data)
[    0.000000]  BIOS-e820: 000000007ff7e000 - 000000007ffd0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 000000007ffd0000 - 0000000080000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working it around.
[    0.000000] last_pfn = 0x7ff70 max_arch_pfn = 0x100000000
[    0.000000] init_memory_mapping: 0000000000000000-000000007ff70000
[    0.000000]  0000000000 - 007fe00000 page 2M
[    0.000000]  007fe00000 - 007ff70000 page 4k
[    0.000000] kernel direct mapping tables up to 7ff70000 @ 10000-14000
[    0.000000] last_map_addr: 7ff70000 end: 7ff70000
[    0.000000] RAMDISK: 37cc7000 - 37fef294
[    0.000000] ACPI: RSDP 000FB460, 0024 (r2 ACPIAM)
[    0.000000] ACPI: XSDT 7FF70100, 005C (r1 A_M_I_ OEMXSDT   7000811 MSFT       
97)
[    0.000000] ACPI: FACP 7FF70290, 00F4 (r3 A_M_I_ OEMFACP   7000811 MSFT       
97)
[    0.000000] FADT: X_PM1a_EVT_BLK.bit_width (16) does not match PM1_EVT_LEN 
(4)
[    0.000000] ACPI: DSDT 7FF70440, 963F (r1  A0991 A0991001        1 INTL 
20060113)
[    0.000000] ACPI: FACS 7FF7E000, 0040
[    0.000000] ACPI: APIC 7FF70390, 006C (r1 A_M_I_ OEMAPIC   7000811 MSFT       
97)
[    0.000000] ACPI: MCFG 7FF70400, 003C (r1 A_M_I_ OEMMCFG   7000811 MSFT       
97)
[    0.000000] ACPI: OEMB 7FF7E040, 0081 (r1 A_M_I_ AMI_OEM   7000811 MSFT       
97)
[    0.000000] ACPI: HPET 7FF79A80, 0038 (r1 A_M_I_ OEMHPET   7000811 MSFT       
97)
[    0.000000] ACPI: OSFR 7FF79AC0, 00B0 (r1 A_M_I_ OEMOSFR   7000811 MSFT       
97)
[    0.000000] ACPI: SSDT 7FF7EB20, 0A7C (r1 DpgPmm    CpuPm       12 INTL 
20060113)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-000000007ff70000
[    0.000000] Bootmem setup node 0 0000000000000000-000000007ff70000
[    0.000000]   NODE_DATA [0000000000012000 - 0000000000015fff]
[    0.000000]   bootmap [0000000000016000 -  0000000000025fef] pages 10
[    0.000000] (6 early reservations) ==> bootmem [0000000000 - 007ff70000]
[    0.000000]   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 
- 0000001000]
[    0.000000]   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 
- 0000008000]
[    0.000000]   #2 [0000200000 - 00006e32fc]    TEXT DATA BSS ==> [0000200000 
- 00006e32fc]
[    0.000000]   #3 [0037cc7000 - 0037fef294]          RAMDISK ==> [0037cc7000 
- 0037fef294]
[    0.000000]   #4 [000009bc00 - 0000100000]    BIOS reserved ==> [000009bc00 
- 0000100000]
[    0.000000]   #5 [0000010000 - 0000012000]          PGTABLE ==> [0000010000 
- 0000012000]
[    0.000000] found SMP MP-table at [ffff8800000ff780] 000ff780
[    0.000000]  [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-
ffff880002dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00100000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009b
[    0.000000]     0: 0x00000100 -> 0x0007ff70
[    0.000000] On node 0 totalpages: 524027
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1358 pages reserved
[    0.000000]   DMA zone: 2565 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 7111 pages used for memmap
[    0.000000]   DMA32 zone: 512937 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
[    0.000000] PM: Registered nosave memory: 000000000009b000 - 
000000000009c000
[    0.000000] PM: Registered nosave memory: 000000000009c000 - 
00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 
00000000000e4000
[    0.000000] PM: Registered nosave memory: 00000000000e4000 - 
0000000000100000
[    0.000000] Allocating PCI resources starting at 88000000 (gap: 
80000000:7ee00000)
[    0.000000] NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Allocating 49152 bytes of per cpu data
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  Total 
pages: 515502
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line: root=/dev/sda5 ro vga=0x0369
[    0.000000] Initializing CPU#0
[    0.000000] xsave/xrstor: enabled xstate_bv 0x3, cntxt size 0x240
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2999.773 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Checking aperture...
[    0.000999] No AGP bridge found
[    0.000999] Calgary: detecting Calgary via BIOS EBDA area
[    0.000999] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000999] Memory: 2058840k/2096576k available (2550k kernel code, 468k 
absent, 37268k reserved, 1235k data, 500k init)
[    0.000999] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, 
Nodes=1
[    0.000999] hpet clockevent registered
[    0.000999] HPET: 4 timers in total, 0 timers will be used for per-cpu 
timer
[    0.000999] Calibrating delay loop (skipped), value calculated using timer 
frequency.. 5999.54 BogoMIPS (lpj=2999773)
[    0.000999] Security Framework initialized
[    0.000999] SELinux:  Disabled at boot.
[    0.000999] Dentry cache hash table entries: 262144 (order: 9, 2097152 
bytes)
[    0.000999] Inode-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.001344] Mount-cache hash table entries: 256
[    0.001445] Initializing cgroup subsys ns
[    0.001449] Initializing cgroup subsys cpuacct
[    0.001452] Initializing cgroup subsys devices
[    0.001465] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.001467] CPU: L2 cache: 6144K
[    0.001470] [ds] using Core 2/Atom configuration
[    0.001472] CPU 0/0x0 -> Node 0
[    0.001474] CPU: Physical Processor ID: 0
[    0.001476] CPU: Processor Core ID: 0
[    0.001482] CPU0: Thermal monitoring enabled (TM2)
[    0.001485] using mwait in idle threads.
[    0.002978] ACPI: Core revision 20081204
[    0.012030] Setting APIC routing to flat
[    0.012347] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.022853] CPU0: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz stepping 
0a
[    0.022996] APIC calibration not consistent with PM Timer: 118ms instead of 
100ms
[    0.022996] APIC delta adjusted to PM-Timer: 2083092 (2478850)
[    0.022996] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 5999.07 
BogoMIPS (lpj=2999537)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 6144K
[    0.000999] [ds] using Core 2/Atom configuration
[    0.000999] CPU 1/0x1 -> Node 0
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.093694] CPU1: Intel(R) Core(TM)2 Duo CPU     E8400  @ 3.00GHz stepping 
0a
[    0.093719] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.094008] Brought up 2 CPUs
[    0.094011] Total of 2 processors activated (11998.62 BogoMIPS).
[    0.094054] CPU0 attaching sched-domain:
[    0.094055]  domain 0: span 0-1 level MC
[    0.094056]   groups: 0 1
[    0.094059] CPU1 attaching sched-domain:
[    0.094060]  domain 0: span 0-1 level MC
[    0.094061]   groups: 1 0
[    0.094987] net_namespace: 1888 bytes
[    0.094987] Booting paravirtualized kernel on bare hardware
[    0.094987] NET: Registered protocol family 16
[    0.095020] ACPI: bus type pci registered
[    0.095020] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.095020] PCI: Not using MMCONFIG.
[    0.095020] PCI: Using configuration type 1 for base access
[    0.096200] bio: create slab <bio-0> at 0
[    0.096731] ACPI: EC: Look up EC in DSDT
[    0.107984] ACPI: Interpreter enabled
[    0.107984] ACPI: (supports S0 S1 S3 S4 S5)
[    0.107984] ACPI: Using IOAPIC for interrupt routing
[    0.107984] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.109983] PCI: MCFG area at e0000000 reserved in ACPI motherboard 
resources
[    0.115982] PCI: Using MMCONFIG at e0000000 - efffffff
[    0.123258] ACPI: No dock devices found.
[    0.123309] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.123386] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.123389] pci 0000:00:01.0: PME# disabled
[    0.123440] pci 0000:00:1a.0: reg 20 io port: [0xa800-0xa81f]
[    0.123492] pci 0000:00:1a.1: reg 20 io port: [0xa880-0xa89f]
[    0.123543] pci 0000:00:1a.2: reg 20 io port: [0xac00-0xac1f]
[    0.123598] pci 0000:00:1a.7: reg 10 32bit mmio: [0xf9fffc00-0xf9ffffff]
[    0.123640] pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
[    0.123644] pci 0000:00:1a.7: PME# disabled
[    0.123674] pci 0000:00:1b.0: reg 10 64bit mmio: [0xf9ff8000-0xf9ffbfff]
[    0.123699] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.123699] pci 0000:00:1b.0: PME# disabled
[    0.123699] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.123699] pci 0000:00:1c.0: PME# disabled
[    0.123699] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.123699] pci 0000:00:1c.4: PME# disabled
[    0.123699] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.123699] pci 0000:00:1c.5: PME# disabled
[    0.123699] pci 0000:00:1d.0: reg 20 io port: [0xa080-0xa09f]
[    0.123699] pci 0000:00:1d.1: reg 20 io port: [0xa400-0xa41f]
[    0.123699] pci 0000:00:1d.2: reg 20 io port: [0xa480-0xa49f]
[    0.123699] pci 0000:00:1d.7: reg 10 32bit mmio: [0xf9fff800-0xf9fffbff]
[    0.123699] pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
[    0.123699] pci 0000:00:1d.7: PME# disabled
[    0.123699] pci 0000:00:1f.0: quirk: region 0800-087f claimed by ICH6 
ACPI/GPIO/TCO
[    0.123699] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.123699] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 
(mask 0003)
[    0.123699] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 3 PIO at 4700 
(mask 001f)
[    0.123699] pci 0000:00:1f.2: reg 10 io port: [0x9c00-0x9c07]
[    0.123699] pci 0000:00:1f.2: reg 14 io port: [0x9880-0x9883]
[    0.123699] pci 0000:00:1f.2: reg 18 io port: [0x9800-0x9807]
[    0.123699] pci 0000:00:1f.2: reg 1c io port: [0x9480-0x9483]
[    0.123699] pci 0000:00:1f.2: reg 20 io port: [0x9400-0x941f]
[    0.123699] pci 0000:00:1f.2: reg 24 32bit mmio: [0xf9ffe800-0xf9ffefff]
[    0.123699] pci 0000:00:1f.2: PME# supported from D3hot
[    0.123699] pci 0000:00:1f.2: PME# disabled
[    0.123699] pci 0000:00:1f.3: reg 10 64bit mmio: [0xf9fff400-0xf9fff4ff]
[    0.123699] pci 0000:00:1f.3: reg 20 io port: [0x400-0x41f]
[    0.123699] pci 0000:01:00.0: reg 10 32bit mmio: [0xfd000000-0xfdffffff]
[    0.123699] pci 0000:01:00.0: reg 14 64bit mmio: [0xd0000000-0xdfffffff]
[    0.123699] pci 0000:01:00.0: reg 1c 64bit mmio: [0xfa000000-0xfbffffff]
[    0.123699] pci 0000:01:00.0: reg 24 io port: [0xbc00-0xbc7f]
[    0.123699] pci 0000:01:00.0: reg 30 32bit mmio: [0xfe880000-0xfe8fffff]
[    0.123713] pci 0000:00:01.0: bridge io port: [0xb000-0xbfff]
[    0.123715] pci 0000:00:01.0: bridge 32bit mmio: [0xfa000000-0xfe8fffff]
[    0.123717] pci 0000:00:01.0: bridge 64bit mmio pref: [0xd0000000-0xdfffffff]
[    0.123748] pci 0000:00:1c.0: bridge 64bit mmio pref: [0xf8f00000-0xf8ffffff]
[    0.123784] pci 0000:03:00.0: reg 10 io port: [0xdc00-0xdc07]
[    0.123790] pci 0000:03:00.0: reg 14 io port: [0xd880-0xd883]
[    0.123796] pci 0000:03:00.0: reg 18 io port: [0xd800-0xd807]
[    0.123802] pci 0000:03:00.0: reg 1c io port: [0xd480-0xd483]
[    0.123808] pci 0000:03:00.0: reg 20 io port: [0xd400-0xd40f]
[    0.123815] pci 0000:03:00.0: reg 24 32bit mmio: [0xfeaffc00-0xfeafffff]
[    0.123848] pci 0000:03:00.0: supports D1
[    0.123849] pci 0000:03:00.0: PME# supported from D0 D1 D3hot
[    0.123854] pci 0000:03:00.0: PME# disabled
[    0.123888] pci 0000:00:1c.4: bridge io port: [0xd000-0xdfff]
[    0.123891] pci 0000:00:1c.4: bridge 32bit mmio: [0xfea00000-0xfeafffff]
[    0.123941] pci 0000:02:00.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]
[    0.123947] pci 0000:02:00.0: reg 18 io port: [0xc800-0xc8ff]
[    0.123969] pci 0000:02:00.0: reg 30 32bit mmio: [0xfe9c0000-0xfe9dffff]
[    0.124005] pci 0000:02:00.0: supports D1 D2
[    0.124006] pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124011] pci 0000:02:00.0: PME# disabled
[    0.124042] pci 0000:00:1c.5: bridge io port: [0xc000-0xcfff]
[    0.124044] pci 0000:00:1c.5: bridge 32bit mmio: [0xfe900000-0xfe9fffff]
[    0.124080] pci 0000:05:02.0: reg 10 32bit mmio: [0xfebfc000-0xfebfffff]
[    0.124085] pci 0000:05:02.0: reg 14 io port: [0xe800-0xe8ff]
[    0.124105] pci 0000:05:02.0: reg 30 32bit mmio: [0xfebc0000-0xfebdffff]
[    0.124124] pci 0000:05:02.0: supports D1 D2
[    0.124125] pci 0000:05:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.124129] pci 0000:05:02.0: PME# disabled
[    0.124156] pci 0000:05:03.0: reg 10 32bit mmio: [0xfebfb000-0xfebfbfff]
[    0.124192] pci 0000:05:03.0: supports D1 D2
[    0.124193] pci 0000:05:03.0: PME# supported from D0 D1 D2 D3hot
[    0.124197] pci 0000:05:03.0: PME# disabled
[    0.124229] pci 0000:00:1e.0: transparent bridge
[    0.124233] pci 0000:00:1e.0: bridge io port: [0xe000-0xefff]
[    0.124235] pci 0000:00:1e.0: bridge 32bit mmio: [0xfeb00000-0xfebfffff]
[    0.124256] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.124377] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
[    0.124424] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[    0.124499] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P8._PRT]
[    0.124543] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P9._PRT]
[    0.124599] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4._PRT]
[    0.139058] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 
15)
[    0.139157] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 
15)
[    0.139255] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 
*15)
[    0.139352] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 
15)
[    0.139450] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) 
*0, disabled.
[    0.139549] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 *14 
15)
[    0.139647] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 
15)
[    0.139745] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 *7 10 11 12 14 
15)
[    0.139793] ACPI Warning (tbutils-0242): Incorrect checksum in table [OEMB] 
- 1E, should be 15 [20081204]
[    0.140000] usbcore: registered new interface driver usbfs
[    0.140000] usbcore: registered new interface driver hub
[    0.140000] usbcore: registered new device driver usb
[    0.140000] PCI: Using ACPI for IRQ routing
[    0.143023] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    0.143030] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    0.150717] pnp: PnP ACPI init
[    0.150726] ACPI: bus type pnp registered
[    0.153670] pnp: PnP ACPI: found 17 devices
[    0.153672] ACPI: ACPI bus type pnp unregistered
[    0.153679] system 00:01: iomem range 0xfed14000-0xfed19fff has been 
reserved
[    0.153684] system 00:07: ioport range 0x290-0x29f has been reserved
[    0.153689] system 00:08: ioport range 0x4d0-0x4d1 has been reserved
[    0.153692] system 00:08: ioport range 0x800-0x87f has been reserved
[    0.153695] system 00:08: ioport range 0x500-0x57f could not be reserved
[    0.153698] system 00:08: iomem range 0xfed08000-0xfed08fff has been 
reserved
[    0.153701] system 00:08: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.153703] system 00:08: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.153706] system 00:08: iomem range 0xfed50000-0xfed8ffff has been reserved
[    0.153711] system 00:0b: iomem range 0xffc00000-0xffdfffff has been reserved
[    0.153716] system 00:0d: iomem range 0xfec00000-0xfec00fff has been 
reserved
[    0.153719] system 00:0d: iomem range 0xfee00000-0xfee00fff has been 
reserved
[    0.153723] system 00:0f: iomem range 0xe0000000-0xefffffff has been reserved
[    0.153728] system 00:10: iomem range 0x0-0x9ffff could not be reserved
[    0.153731] system 00:10: iomem range 0xc0000-0xcffff has been reserved
[    0.153733] system 00:10: iomem range 0xe0000-0xfffff could not be reserved
[    0.153736] system 00:10: iomem range 0x100000-0x7fffffff could not be 
reserved
[    0.158496] pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
[    0.158500] pci 0000:00:01.0:   IO window: 0xb000-0xbfff
[    0.158503] pci 0000:00:01.0:   MEM window: 0xfa000000-0xfe8fffff
[    0.158506] pci 0000:00:01.0:   PREFETCH window: 
0x000000d0000000-0x000000dfffffff
[    0.158511] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:04
[    0.158513] pci 0000:00:1c.0:   IO window: disabled
[    0.158517] pci 0000:00:1c.0:   MEM window: disabled
[    0.158520] pci 0000:00:1c.0:   PREFETCH window: 
0x000000f8f00000-0x000000f8ffffff
[    0.158526] pci 0000:00:1c.4: PCI bridge, secondary bus 0000:03
[    0.158529] pci 0000:00:1c.4:   IO window: 0xd000-0xdfff
[    0.158533] pci 0000:00:1c.4:   MEM window: 0xfea00000-0xfeafffff
[    0.158537] pci 0000:00:1c.4:   PREFETCH window: disabled
[    0.158542] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:02
[    0.158545] pci 0000:00:1c.5:   IO window: 0xc000-0xcfff
[    0.158549] pci 0000:00:1c.5:   MEM window: 0xfe900000-0xfe9fffff
[    0.158553] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.158558] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:05
[    0.158561] pci 0000:00:1e.0:   IO window: 0xe000-0xefff
[    0.158565] pci 0000:00:1e.0:   MEM window: 0xfeb00000-0xfebfffff
[    0.158569] pci 0000:00:1e.0:   PREFETCH window: 
0x00000088000000-0x000000880fffff
[    0.158579] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.158582] pci 0000:00:01.0: setting latency timer to 64
[    0.158587] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.158591] pci 0000:00:1c.0: setting latency timer to 64
[    0.158595] pci 0000:00:1c.4: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.158599] pci 0000:00:1c.4: setting latency timer to 64
[    0.158603] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.158607] pci 0000:00:1c.5: setting latency timer to 64
[    0.158611] pci 0000:00:1e.0: setting latency timer to 64
[    0.158613] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.158615] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffffffffffff]
[    0.158616] pci_bus 0000:01: resource 0 io:  [0xb000-0xbfff]
[    0.158618] pci_bus 0000:01: resource 1 mem: [0xfa000000-0xfe8fffff]
[    0.158620] pci_bus 0000:01: resource 2 mem: [0xd0000000-0xdfffffff]
[    0.158621] pci_bus 0000:01: resource 3 mem: [0x0-0x0]
[    0.158623] pci_bus 0000:04: resource 0 mem: [0x0-0x0]
[    0.158624] pci_bus 0000:04: resource 1 mem: [0x0-0x0]
[    0.158625] pci_bus 0000:04: resource 2 mem: [0xf8f00000-0xf8ffffff]
[    0.158627] pci_bus 0000:04: resource 3 mem: [0x0-0x0]
[    0.158628] pci_bus 0000:03: resource 0 io:  [0xd000-0xdfff]
[    0.158630] pci_bus 0000:03: resource 1 mem: [0xfea00000-0xfeafffff]
[    0.158632] pci_bus 0000:03: resource 2 mem: [0x0-0x0]
[    0.158633] pci_bus 0000:03: resource 3 mem: [0x0-0x0]
[    0.158634] pci_bus 0000:02: resource 0 io:  [0xc000-0xcfff]
[    0.158636] pci_bus 0000:02: resource 1 mem: [0xfe900000-0xfe9fffff]
[    0.158637] pci_bus 0000:02: resource 2 mem: [0x0-0x0]
[    0.158639] pci_bus 0000:02: resource 3 mem: [0x0-0x0]
[    0.158640] pci_bus 0000:05: resource 0 io:  [0xe000-0xefff]
[    0.158642] pci_bus 0000:05: resource 1 mem: [0xfeb00000-0xfebfffff]
[    0.158643] pci_bus 0000:05: resource 2 mem: [0x88000000-0x880fffff]
[    0.158645] pci_bus 0000:05: resource 3 io:  [0x00-0xffff]
[    0.158647] pci_bus 0000:05: resource 4 mem: [0x000000-0xffffffffffffffff]
[    0.158661] NET: Registered protocol family 2
[    0.169747] IP route cache hash table entries: 65536 (order: 7, 524288 
bytes)
[    0.170190] TCP established hash table entries: 262144 (order: 10, 4194304 
bytes)
[    0.171031] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.171297] TCP: Hash tables configured (established 262144 bind 65536)
[    0.171300] TCP reno registered
[    0.173715] NET: Registered protocol family 1
[    0.173812] checking if image is initramfs... it is
[    0.329655] Freeing initrd memory: 3232k freed
[    0.330581] audit: initializing netlink socket (disabled)
[    0.330590] type=2000 audit(1234554185.329:1): initialized
[    0.330761] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.332257] VFS: Disk quotas dquot_6.5.2
[    0.332306] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.332585] msgmni has been set to 4027
[    0.332693] alg: No test for stdrng (krng)
[    0.332756] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 
253)
[    0.332760] io scheduler noop registered
[    0.332762] io scheduler anticipatory registered
[    0.332764] io scheduler deadline registered
[    0.332833] io scheduler cfq registered (default)
[    0.332954] pci 0000:01:00.0: Boot video device
[    0.333026] pcieport-driver 0000:00:01.0: setting latency timer to 64
[    0.333056] pcieport-driver 0000:00:01.0: irq 24 for MSI/MSI-X
[    0.333128] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.333166] pcieport-driver 0000:00:1c.0: irq 25 for MSI/MSI-X
[    0.333270] pcieport-driver 0000:00:1c.4: setting latency timer to 64
[    0.333307] pcieport-driver 0000:00:1c.4: irq 26 for MSI/MSI-X
[    0.333414] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.333451] pcieport-driver 0000:00:1c.5: irq 27 for MSI/MSI-X
[    0.334039] vesafb: framebuffer at 0xfb000000, mapped to 0xffffc20010980000, 
using 13781k, total 14336k
[    0.334044] vesafb: mode is 1680x1050x32, linelength=6720, pages=1
[    0.334046] vesafb: scrolling: redraw
[    0.334048] vesafb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    0.376873] Console: switching to colour frame buffer device 210x65
[    0.419590] fb0: VESA VGA frame buffer device
[    0.421408] Linux agpgart interface v0.103
[    0.421557] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.421879] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.422402] 00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    0.423557] brd: module loaded
[    0.423768] PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.424006] PNP: PS/2 appears to have AUX port disabled, if this is 
incorrect please boot with i8042.nopnp
[    0.424849] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.425121] mice: PS/2 mouse device common for all mice
[    0.425330] cpuidle: using governor ladder
[    0.425478] cpuidle: using governor menu
[    0.425624] No iBFT detected.
[    0.425903] TCP cubic registered
[    0.426020] NET: Registered protocol family 17
[    0.426260] registered taskstats version 1
[    0.426500] drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
[    0.426752] Freeing unused kernel memory: 500k freed
[    0.448039] input: AT Translated Set 2 keyboard as /class/input/input0
[    0.456095] SCSI subsystem initialized
[    0.463607] libata version 3.00 loaded.
[    0.464231] pata_marvell 0000:03:00.0: PCI INT A -> GSI 16 (level, low) -> 
IRQ 16
[    0.464518] pata_marvell 0000:03:00.0: setting latency timer to 64
[    0.464551] scsi0 : pata_marvell
[    0.464717] scsi1 : pata_marvell
[    0.464863] ata1: PATA max UDMA/100 cmd 0xdc00 ctl 0xd880 bmdma 0xd400 irq 
16
[    0.465120] ata2: PATA max UDMA/133 cmd 0xd800 ctl 0xd480 bmdma 0xd408 irq 
16
[    0.500443] Switched to high resolution mode on CPU 1
[    0.500681] Switched to high resolution mode on CPU 0
[    0.621359] ata1.00: ATAPI: PIONEER DVD-RW  DVR-107D, 1.10, max UDMA/33
[    0.629373] ata1.00: configured for UDMA/33
[    0.635341] isa bounce pool size: 16 pages
[    0.641819] scsi 0:0:0:0: CD-ROM            PIONEER  DVD-RW  DVR-107D 1.10 
PQ: 0 ANSI: 5
[    0.810038] ahci 0000:00:1f.2: version 3.0
[    0.810046] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
[    0.810316] ahci 0000:00:1f.2: irq 28 for MSI/MSI-X
[    0.810346] ahci: SSS flag set, parallel bus scan disabled
[    0.810566] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps 0x3f 
impl SATA mode
[    0.810860] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pmp pio 
slum part ems 
[    0.811165] ahci 0000:00:1f.2: setting latency timer to 64
[    0.811392] scsi2 : ahci
[    0.811527] scsi3 : ahci
[    0.811659] scsi4 : ahci
[    0.811790] scsi5 : ahci
[    0.811921] scsi6 : ahci
[    0.812061] scsi7 : ahci
[    0.818529] ata3: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffe900 irq 
28
[    0.825274] ata4: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffe980 irq 
28
[    0.832037] ata5: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffea00 irq 
28
[    0.838825] ata6: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffea80 irq 
28
[    0.845631] ata7: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb00 irq 
28
[    0.852462] ata8: SATA max UDMA/133 abar m2048@0xf9ffe800 port 0xf9ffeb80 irq 
28
[    1.317022] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.371506] ata3.00: ATA-7: ST3250620AS, 3.AAC, max UDMA/133
[    1.378672] ata3.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.429794] ata3.00: configured for UDMA/133
[    1.448062] scsi 2:0:0:0: Direct-Access     ATA      ST3250620AS      3.AA 
PQ: 0 ANSI: 5
[    1.913017] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    1.921790] ata4.00: ATA-7: ST3250823AS, 3.03, max UDMA/133
[    1.929840] ata4.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.938964] ata4.00: configured for UDMA/133
[    1.958057] scsi 3:0:0:0: Direct-Access     ATA      ST3250823AS      3.03 
PQ: 0 ANSI: 5
[    2.271010] ata5: SATA link down (SStatus 0 SControl 300)
[    2.595010] ata6: SATA link down (SStatus 0 SControl 300)
[    2.919009] ata7: SATA link down (SStatus 0 SControl 300)
[    3.243009] ata8: SATA link down (SStatus 0 SControl 300)
[    3.285149] ACPI: SSDT 7FF7E0D0, 0277 (r1 DpgPmm  P001Ist       11 INTL 
20060113)
[    3.294830] ACPI: SSDT 7FF7E5D0, 04B2 (r1  PmRef  P001Cst     3001 INTL 
20060113)
[    3.304938] Monitor-Mwait will be used to enter C-1 state
[    3.304943] Monitor-Mwait will be used to enter C-2 state
[    3.304946] Monitor-Mwait will be used to enter C-3 state
[    3.305044] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
[    3.314737] processor ACPI_CPU:00: registered as cooling_device0
[    3.316001] Marking TSC unstable due to TSC halts in idle
[    3.334402] ACPI: SSDT 7FF7E350, 0277 (r1 DpgPmm  P002Ist       12 INTL 
20060113)
[    3.344474] ACPI: SSDT 7FF7EA90, 0085 (r1  PmRef  P002Cst     3000 INTL 
20060113)
[    3.354720] ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
[    3.364420] processor ACPI_CPU:01: registered as cooling_device1
[    3.424136] Driver 'sd' needs updating - please use bus_type methods
[    3.434045] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 
GB/232 GiB)
[    3.443942] sd 2:0:0:0: [sda] Write Protect is off
[    3.453578] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.453594] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.463465] sd 2:0:0:0: [sda] 488397168 512-byte hardware sectors: (250 
GB/232 GiB)
[    3.473253] sd 2:0:0:0: [sda] Write Protect is off
[    3.483060] sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    3.483074] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.493123]  sda: sda1 sda2 < sda5 sda6 sda7 > sda3
[    3.560564] sd 2:0:0:0: [sda] Attached SCSI disk
[    3.570786] sd 3:0:0:0: [sdb] 488397168 512-byte hardware sectors: (250 
GB/232 GiB)
[    3.581104] sd 3:0:0:0: [sdb] Write Protect is off
[    3.591278] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.591293] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.601657] sd 3:0:0:0: [sdb] 488397168 512-byte hardware sectors: (250 
GB/232 GiB)
[    3.612416] sd 3:0:0:0: [sdb] Write Protect is off
[    3.622528] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    3.622593] sd 3:0:0:0: [sdb] Write cache: enabled, read cache: enabled, 
doesn't support DPO or FUA
[    3.632724]  sdb: sdb1
[    3.661991] sd 3:0:0:0: [sdb] Attached SCSI disk
[    4.001927] PM: Starting manual resume from disk
[    4.089290] kjournald starting.  Commit interval 5 seconds
[    4.099547] EXT3-fs: mounted filesystem with ordered data mode.
[    5.342475] udevd version 125 started
[    5.636723] Driver 'sr' needs updating - please use bus_type methods
[    5.674877] sr0: scsi3-mmc drive: 40x/40x writer cd/rw xa/form2 cdda tray
[    5.686366] Uniform CD-ROM driver Revision: 3.20
[    5.697865] sr 0:0:0:0: Attached scsi CD-ROM sr0
[    5.726104] input: Power Button (FF) as /class/input/input1
[    5.745067] ACPI: Power Button (FF) [PWRF]
[    5.756828] input: Power Button (CM) as /class/input/input2
[    5.768752] uhci_hcd: USB Universal Host Controller Interface driver
[    5.780832] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 
16
[    5.792951] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    5.792954] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    5.804853] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus 
number 1
[    5.816773] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000a800
[    5.828566] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    5.840360] usb usb1: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    5.852162] usb usb1: Product: UHCI Host Controller
[    5.863898] usb usb1: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    5.875611] usb usb1: SerialNumber: 0000:00:1a.0
[    5.887285] usb usb1: configuration #1 chosen from 1 choice
[    5.898854] hub 1-0:1.0: USB hub found
[    5.910498] hub 1-0:1.0: 2 ports detected
[    5.922310] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 
21
[    5.934277] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    5.934279] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    5.946190] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus 
number 2
[    5.957971] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000a880
[    5.969509] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
[    5.981033] usb usb2: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    5.992578] usb usb2: Product: UHCI Host Controller
[    6.004039] usb usb2: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    6.015475] usb usb2: SerialNumber: 0000:00:1a.1
[    6.026959] usb usb2: configuration #1 chosen from 1 choice
[    6.038389] hub 2-0:1.0: USB hub found
[    6.049735] hub 2-0:1.0: 2 ports detected
[    6.061087] uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.072382] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    6.072384] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    6.072456] ACPI: Power Button (CM) [PWRB]
[    6.094757] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus 
number 3
[    6.106009] uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000ac00
[    6.117169] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
[    6.128384] usb usb3: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.139492] usb usb3: Product: UHCI Host Controller
[    6.150569] usb usb3: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    6.161639] usb usb3: SerialNumber: 0000:00:1a.2
[    6.172646] usb usb3: configuration #1 chosen from 1 choice
[    6.183613] hub 3-0:1.0: USB hub found
[    6.194422] hub 3-0:1.0: 2 ports detected
[    6.205205] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    6.205211] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.205215] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    6.205216] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    6.205245] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus 
number 4
[    6.205268] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000a080
[    6.205291] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
[    6.205292] usb usb4: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.205293] usb usb4: Product: UHCI Host Controller
[    6.205294] usb usb4: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    6.205295] usb usb4: SerialNumber: 0000:00:1d.0
[    6.205323] usb usb4: configuration #1 chosen from 1 choice
[    6.205340] hub 4-0:1.0: USB hub found
[    6.205344] hub 4-0:1.0: 2 ports detected
[    6.342093] Warning! ehci_hcd should always be loaded before uhci_hcd and 
ohci_hcd, not after
[    6.342244] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 
19
[    6.342248] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    6.342250] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    6.342285] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus 
number 5
[    6.342308] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000a400
[    6.342331] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
[    6.342332] usb usb5: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.342333] usb usb5: Product: UHCI Host Controller
[    6.342334] usb usb5: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    6.342335] usb usb5: SerialNumber: 0000:00:1d.1
[    6.342363] usb usb5: configuration #1 chosen from 1 choice
[    6.342378] hub 5-0:1.0: USB hub found
[    6.342381] hub 5-0:1.0: 2 ports detected
[    6.342439] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.342442] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    6.342444] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    6.342469] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus 
number 6
[    6.342487] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000a480
[    6.342506] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    6.342507] usb usb6: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.342508] usb usb6: Product: UHCI Host Controller
[    6.342509] usb usb6: Manufacturer: Linux 2.6.29-rc4 uhci_hcd
[    6.342510] usb usb6: SerialNumber: 0000:00:1d.2
[    6.342535] usb usb6: configuration #1 chosen from 1 choice
[    6.342550] hub 6-0:1.0: USB hub found
[    6.342554] hub 6-0:1.0: 2 ports detected
[    6.590211] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 
18
[    6.599965] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    6.599967] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    6.609570] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus 
number 7
[    6.623143] ehci_hcd 0000:00:1a.7: debug port 1
[    6.632710] ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
[    6.632713] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf9fffc00
[    6.670775] input: PC Speaker as /class/input/input3
[    6.747555] sky2 driver version 1.22
[    6.757063] usb 3-1: new full speed USB device using uhci_hcd and address 2
[    6.771735] sr 0:0:0:0: Attached scsi generic sg0 type 5
[    6.781433] sd 2:0:0:0: Attached scsi generic sg1 type 0
[    6.790993] sd 3:0:0:0: Attached scsi generic sg2 type 0
[    6.800392] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    6.809815] usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
[    6.819390] usb usb7: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    6.828929] usb usb7: Product: EHCI Host Controller
[    6.838431] usb usb7: Manufacturer: Linux 2.6.29-rc4 ehci_hcd
[    6.847950] usb usb7: SerialNumber: 0000:00:1a.7
[    6.857381] usb usb7: configuration #1 chosen from 1 choice
[    6.866847] hub 7-0:1.0: USB hub found
[    6.876153] hub 7-0:1.0: 6 ports detected
[    6.885451] skge 0000:05:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    6.894844] skge 1.13 addr 0xfebfc000 irq 18 chip Yukon-Lite rev 9
[    6.904357] skge eth0: addr 00:22:15:7c:68:6e
[    6.913766] sky2 0000:02:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    6.923324] sky2 0000:02:00.0: setting latency timer to 64
[    6.923342] sky2 0000:02:00.0: Yukon-2 EC Ultra chip revision 3
[    6.965006] sky2 0000:02:00.0: Marvell Yukon 88E8056 Gigabit Ethernet 
Controller
[    6.974531]  Part Number: Yukon 88E8056
[    6.974532]  Engineering Level: Rev. 1.2
[    6.974533]  Manufacturer: Marvell
[    6.974585] sky2 0000:02:00.0: irq 29 for MSI/MSI-X
[    6.974804] sky2 eth1: addr 00:22:15:7c:7c:b1
[    6.984354] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 
23
[    6.993968] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    6.993970] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    7.003537] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus 
number 8
[    7.017022] ehci_hcd 0000:00:1d.7: debug port 1
[    7.026492] ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
[    7.026497] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9fff800
[    7.026533] hub 3-0:1.0: unable to enumerate USB device on port 1
[    7.070118] udev: renamed network interface eth0 to eth1
[    7.096587] udev: renamed network interface eth1_rename to eth0
[    7.130136] usb 6-1: new full speed USB device using uhci_hcd and address 2
[    7.137419] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    7.137432] usb usb8: New USB device found, idVendor=1d6b, idProduct=0002
[    7.137433] usb usb8: New USB device strings: Mfr=3, Product=2, 
SerialNumber=1
[    7.137434] usb usb8: Product: EHCI Host Controller
[    7.137435] usb usb8: Manufacturer: Linux 2.6.29-rc4 ehci_hcd
[    7.137436] usb usb8: SerialNumber: 0000:00:1d.7
[    7.137472] usb usb8: configuration #1 chosen from 1 choice
[    7.137492] hub 8-0:1.0: USB hub found
[    7.137495] hub 8-0:1.0: 6 ports detected
[    7.137571] ohci1394 0000:05:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 
19
[    7.287062] ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[19]  
MMIO=[febfb000-febfb7ff]  Max Packet=[2048]  IR/IT contexts=[8/8]
[    7.298889] hub 6-0:1.0: unable to enumerate USB device on port 1
[    7.310863] i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> 
IRQ 18
[    7.320851] ACPI: I/O resource 0000:00:1f.3 [0x400-0x41f] conflicts with 
ACPI region SMRG [0x400-0x40f]
[    7.331031] ACPI: Device needs an ACPI driver
[    7.366371] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 
22
[    7.376750] HDA Intel 0000:00:1b.0: setting latency timer to 64
[    7.530089] usb 7-5: new high speed USB device using ehci_hcd and address 2
[    7.673440] usb 7-5: New USB device found, idVendor=0b05, idProduct=1742
[    7.683889] usb 7-5: New USB device strings: Mfr=1, Product=2, 
SerialNumber=3
[    7.694313] usb 7-5: Product: 802.11 n WLAN
[    7.704684] usb 7-5: Manufacturer: Ralink
[    7.714947] usb 7-5: SerialNumber: 1.0
[    7.725179] usb 7-5: configuration #1 chosen from 1 choice
[    8.111531] Adding 1052216k swap on /dev/sda1.  Priority:-1 extents:1 
across:1052216k 
[    8.160030] usb 6-1: new full speed USB device using uhci_hcd and address 3
[    8.336532] usb 6-1: New USB device found, idVendor=046d, idProduct=c525
[    8.347739] usb 6-1: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.358911] usb 6-1: Product: USB Receiver
[    8.369974] usb 6-1: Manufacturer: Logitech
[    8.380976] usb 6-1: configuration #1 chosen from 1 choice
[    8.527713] input: Logitech USB Receiver as /class/input/input4
[    8.548037] generic-usb 0003:046D:C525.0001: input,hidraw0: USB HID v1.11 
Mouse [Logitech USB Receiver] on usb-0000:00:1d.2-1/input0
[    8.565602] input: Logitech USB Receiver as /class/input/input5
[    8.577750] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[001e8c00016c61b0]
[    8.585052] generic-usb 0003:046D:C525.0002: input,hidraw1: USB HID v1.11 
Device [Logitech USB Receiver] on usb-0000:00:1d.2-1/input1
[    8.597180] usbcore: registered new interface driver usbhid
[    8.609203] usbhid: v2.6:USB HID core driver
[    8.621232] usb 6-2: new full speed USB device using uhci_hcd and address 4
[    8.828532] usb 6-2: New USB device found, idVendor=046d, idProduct=c318
[    8.841388] usb 6-2: New USB device strings: Mfr=1, Product=2, 
SerialNumber=0
[    8.854121] usb 6-2: Product: Logitech Illuminated Keyboard
[    8.866845] usb 6-2: Manufacturer: Logitech
[    8.879543] usb 6-2: configuration #1 chosen from 1 choice
[    8.899677] input: Logitech Logitech Illuminated Keyboard as 
/class/input/input6
[    8.922221] generic-usb 0003:046D:C318.0003: input,hidraw2: USB HID v1.11 
Keyboard [Logitech Logitech Illuminated Keyboard] on usb-0000:00:1d.2-2/input0
[    8.940557] input: Logitech Logitech Illuminated Keyboard as 
/class/input/input7
[    8.967368] generic-usb 0003:046D:C318.0004: input,hidraw3: USB HID v1.11 
Device [Logitech Logitech Illuminated Keyboard] on usb-0000:00:1d.2-2/input1
[   22.324049] EXT3 FS on sda5, internal journal
[   22.507981] loop: module loaded
[   22.544852] coretemp coretemp.0: Using relative temperature scale!
[   22.559015] coretemp coretemp.1: Using relative temperature scale!
[   23.500080] Clocksource tsc unstable (delta = -102978989 ns)
[   24.036185] kjournald starting.  Commit interval 5 seconds
[   24.050271] EXT3 FS on sda7, internal journal
[   24.064177] EXT3-fs: mounted filesystem with ordered data mode.
[   24.105275] kjournald starting.  Commit interval 5 seconds
[   24.119329] EXT3 FS on sda6, internal journal
[   24.133139] EXT3-fs: mounted filesystem with ordered data mode.
[   24.192387] kjournald starting.  Commit interval 5 seconds
[   24.206431] EXT3 FS on sda3, internal journal
[   24.220305] EXT3-fs: mounted filesystem with ordered data mode.
[   24.273792] kjournald starting.  Commit interval 5 seconds
[   24.288031] EXT3 FS on sdb1, internal journal
[   24.302030] EXT3-fs: mounted filesystem with ordered data mode.
[   25.489076] sky2 eth0: enabling interface
[   27.103077] NET: Registered protocol family 10
[   27.115862] lo: Disabled Privacy Extensions
[   27.128581] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   27.610929] sky2 eth0: Link is up at 100 Mbps, full duplex, flow control rx
[   27.623511] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   33.645308] input: btnx keyboard as /class/input/input8
[   33.663143] input: btnx mouse as /class/input/input9
[   36.351195] nvidia: module license 'NVIDIA' taints kernel.
[   36.603727] nvidia 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   36.603733] nvidia 0000:01:00.0: setting latency timer to 64
[   36.603892] NVRM: loading NVIDIA UNIX x86_64 Kernel Module  180.22  Tue Jan  
6 09:15:58 PST 2009
[   36.606686] IRQ 16/nvidia: IRQF_DISABLED is not guaranteed on shared IRQs
[   37.781004] eth0: no IPv6 routers present
******** VER_LINUX **********

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.
 
Linux debian 2.6.29-rc4 #1 SMP Fri Feb 13 20:31:27 CET 2009 x86_64 GNU/Linux
 
Gnu C                  4.3.3
Gnu make               3.81
binutils               2.18.0.20080103
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      found
Linux C Library        2.7
Dynamic linker (ldd)   2.7
Procps                 3.2.7
Console-tools          0.2.3
Sh-utils               6.10
udev                   125
Modules Loaded         nvidia binfmt_misc uinput ipv6 coretemp sbp2 loop 
joydev hid_pl hid_cypress hid_gyration hid_sony hid_ntrig hid_samsung 
hid_microsoft hid_monterey hid_ezkey hid_apple hid_a4tech hid_logitech 
hid_cherry hid_sunplus hid_petalynx hid_belkin usbhid hid_chicony hid 
snd_hda_codec_analog snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss 
snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi_event snd_seq snd_timer 
snd_seq_device i2c_i801 snd sg ohci1394 sky2 i2c_core skge ieee1394 pcspkr 
soundcore snd_page_alloc ehci_hcd uhci_hcd button intel_agp sr_mod cdrom evdev 
sd_mod thermal processor fan thermal_sys ahci pata_marvell libata scsi_mod
**********************************************

