Return-Path: <linux-kernel-owner+w=401wt.eu-S1753065AbYJaQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065AbYJaQZZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbYJaQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:25:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60147 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYJaQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:25:05 -0400
Date: Fri, 31 Oct 2008 12:24:43 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: sched domains oddness.
Message-ID: <20081031162443.GA29885@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The attached dmesg comes from my dual core laptop running 2.6.27
What's up with all the sched domains transitions at the bottom?
This was just a boot up from power off, no suspend/resume or anything funky.

	Dave

-- 
http://www.codemonkey.org.uk


Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27.4-58.fc10.x86_64 (mockbuild@x86-3.fedora.phx.redhat.com) (gcc version 4.3.2 20081007 (Red Hat 4.3.2-6) (GCC) ) #1 SMP Mon Oct 27 17:47:43 EDT 2008
Command line: ro root=UUID=6e7cc77d-93dc-4767-8d51-02e506f75386 reboot=b
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000ba0de000 (usable)
 BIOS-e820: 00000000ba0de000 - 00000000ba0e1000 (ACPI NVS)
 BIOS-e820: 00000000ba0e1000 - 00000000bb90b000 (usable)
 BIOS-e820: 00000000bb90b000 - 00000000bba3c000 (ACPI NVS)
 BIOS-e820: 00000000bba3c000 - 00000000bbb6c000 (usable)
 BIOS-e820: 00000000bbb6c000 - 00000000bbbbf000 (reserved)
 BIOS-e820: 00000000bbbbf000 - 00000000bbc73000 (usable)
 BIOS-e820: 00000000bbc73000 - 00000000bbcbf000 (ACPI NVS)
 BIOS-e820: 00000000bbcbf000 - 00000000bbce9000 (usable)
 BIOS-e820: 00000000bbce9000 - 00000000bbcff000 (ACPI data)
 BIOS-e820: 00000000bbcff000 - 00000000bbd00000 (usable)
 BIOS-e820: 00000000bbd00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f8000000 - 00000000fc000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed10000 - 00000000fed14000 (reserved)
 BIOS-e820: 00000000fed18000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe80000 - 0000000100000000 (reserved)
last_pfn = 0xbbd00 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 00bbc00000 page 2M
 00bbc00000 - 00bbd00000 page 4k
kernel direct mapping tables up to bbd00000 @ 8000-d000
last_map_addr: bbd00000 end: bbd00000
RAMDISK: 37c4a000 - 37fef28c
DMI 2.4 present.
ACPI: RSDP 000FE020, 0024 (r2   Sony)
ACPI: XSDT BBCFE120, 006C (r1   Sony     VAIO 20080715       1000013)
ACPI: FACP BBCFD000, 00F4 (r4   Sony     VAIO 20080715 MSFT  1000013)
ACPI: DSDT BBCEC000, B00C (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: FACS BBC92000, 0040
ACPI: HPET BBCFC000, 0038 (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: APIC BBCFB000, 006C (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: MCFG BBCFA000, 003C (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: SLIC BBCF9000, 0176 (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: ASF! BBCF8000, 00A5 (r32   Sony     VAIO 20080715 MSFT  1000013)
ACPI: BOOT BBCEB000, 0028 (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: DBGP BBCEA000, 0034 (r1   Sony     VAIO 20080715 MSFT  1000013)
ACPI: SSDT BBCE9000, 0655 (r1   Sony     VAIO 20080715 INTL 20051117)
ACPI: DMI detected: Sony
No NUMA configuration found
Faking a node at 0000000000000000-00000000bbd00000
Bootmem setup node 0 0000000000000000-00000000bbd00000
  NODE_DATA [000000000000b000 - 0000000000022fff]
  bootmap [0000000000023000 -  000000000003a79f] pages 18
(6 early reservations) ==> bootmem [0000000000 - 00bbd00000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000c18214]    TEXT DATA BSS ==> [0000200000 - 0000c18214]
  #3 [0037c4a000 - 0037fef28c]          RAMDISK ==> [0037c4a000 - 0037fef28c]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
 [ffffe20000000000-ffffe200029fffff] PMD -> [ffff880001200000-ffff880003bfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[7] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000ba0de
    0: 0x000ba0e1 -> 0x000bb90b
    0: 0x000bba3c -> 0x000bbb6c
    0: 0x000bbbbf -> 0x000bbc73
    0: 0x000bbcbf -> 0x000bbce9
    0: 0x000bbcff -> 0x000bbd00
On node 0 totalpages: 768694
  DMA zone: 1257 pages, LIFO batch:0
  DMA32 zone: 754233 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
PM: Registered nosave memory: 00000000ba0de000 - 00000000ba0e1000
PM: Registered nosave memory: 00000000bb90b000 - 00000000bba3c000
PM: Registered nosave memory: 00000000bbb6c000 - 00000000bbbbf000
PM: Registered nosave memory: 00000000bbc73000 - 00000000bbcbf000
PM: Registered nosave memory: 00000000bbce9000 - 00000000bbcff000
Allocating PCI resources starting at c4000000 (gap: c0000000:38000000)
PERCPU: Allocating 74016 bytes of per cpu data
NR_CPUS: 512, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 755490
Policy zone: DMA32
Kernel command line: ro root=UUID=6e7cc77d-93dc-4767-8d51-02e506f75386 reboot=b
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2393.987 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3017024k/3077120k available (3450k kernel code, 57752k reserved, 1880k data, 1276k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. 4787.97 BogoMIPS (lpj=2393987)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
Using local APIC timer interrupts.
APIC timer calibration result 16624942
Detected 16.624 MHz APIC timer.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4787.75 BogoMIPS (lpj=2393877)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 3072K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Duo CPU     P8600  @ 2.40GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9575.72 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=5952 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
net_namespace: 1552 bytes
Booting paravirtualized kernel on bare hardware
Time: 14:52:21  Date: 10/31/08
NET: Registered protocol family 16
ACPI: ACPI Dock Station Driver
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f8000000 segment 0 buses 0 - 63
PCI: MCFG area at f8000000 reserved in E820
PCI: Using MMCONFIG at f8000000 - fbffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
PCI: 0000:00:02.0 reg 10 64bit mmio: [e8400000, e87fffff]
PCI: 0000:00:02.0 reg 18 32bit mmio: [d0000000, dfffffff]
PCI: 0000:00:02.0 reg 20 io port: [8130, 8137]
PCI: 0000:00:19.0 reg 10 32bit mmio: [ee900000, ee91ffff]
PCI: 0000:00:19.0 reg 14 32bit mmio: [ee924000, ee924fff]
PCI: 0000:00:19.0 reg 18 io port: [8100, 811f]
pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
pci 0000:00:19.0: PME# disabled
PCI: 0000:00:1a.0 reg 20 io port: [80e0, 80ff]
PCI: 0000:00:1a.1 reg 20 io port: [80c0, 80df]
PCI: 0000:00:1a.2 reg 20 io port: [80a0, 80bf]
PCI: 0000:00:1a.7 reg 10 32bit mmio: [ee925c00, ee925fff]
pci 0000:00:1a.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1a.7: PME# disabled
PCI: 0000:00:1b.0 reg 10 64bit mmio: [ee920000, ee923fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.3: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.3: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [8080, 809f]
PCI: 0000:00:1d.1 reg 20 io port: [8060, 807f]
PCI: 0000:00:1d.2 reg 20 io port: [8040, 805f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [ee925800, ee925bff]
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
PCI: 0000:00:1f.2 reg 10 io port: [8128, 812f]
PCI: 0000:00:1f.2 reg 14 io port: [813c, 813f]
PCI: 0000:00:1f.2 reg 18 io port: [8120, 8127]
PCI: 0000:00:1f.2 reg 1c io port: [8138, 813b]
PCI: 0000:00:1f.2 reg 20 io port: [8020, 803f]
PCI: 0000:00:1f.2 reg 24 32bit mmio: [ee925000, ee9257ff]
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
PCI: 0000:00:1f.3 reg 10 64bit mmio: [ee926000, ee9260ff]
PCI: 0000:00:1f.3 reg 20 io port: [8000, 801f]
PCI: 0000:01:00.0 reg 10 32bit mmio: [e4000000, e4ffffff]
PCI: 0000:01:00.0 reg 14 32bit mmio: [c0000000, cfffffff]
PCI: 0000:01:00.0 reg 1c 64bit mmio: [e2000000, e3ffffff]
PCI: 0000:01:00.0 reg 24 io port: [7000, 707f]
PCI: 0000:01:00.0 reg 30 32bit mmio: [fffe0000, ffffffff]
PCI: bridge 0000:00:01.0 io port: [7000, 7fff]
PCI: bridge 0000:00:01.0 32bit mmio: [e2000000, e4ffffff]
PCI: bridge 0000:00:01.0 64bit mmio pref: [c0000000, cfffffff]
PCI: bridge 0000:00:1c.0 io port: [6000, 6fff]
PCI: bridge 0000:00:1c.0 32bit mmio: [ed900000, ee8fffff]
PCI: bridge 0000:00:1c.0 64bit mmio pref: [e8800000, e97fffff]
PCI: 0000:06:00.0 reg 10 64bit mmio: [ec800000, ec801fff]
pci 0000:06:00.0: PME# supported from D0 D3hot D3cold
pci 0000:06:00.0: PME# disabled
PCI: bridge 0000:00:1c.1 io port: [5000, 5fff]
PCI: bridge 0000:00:1c.1 32bit mmio: [ec800000, ed8fffff]
PCI: bridge 0000:00:1c.1 64bit mmio pref: [e9800000, ea7fffff]
PCI: bridge 0000:00:1c.3 io port: [4000, 4fff]
PCI: bridge 0000:00:1c.3 32bit mmio: [eb800000, ec7fffff]
PCI: bridge 0000:00:1c.3 64bit mmio pref: [ea800000, eb7fffff]
PCI: 0000:0b:04.0 reg 10 32bit mmio: [e8000000, e8000fff]
pci 0000:0b:04.0: supports D1
pci 0000:0b:04.0: supports D2
pci 0000:0b:04.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0b:04.0: PME# disabled
PCI: 0000:0b:04.1 reg 10 32bit mmio: [e8001000, e80017ff]
pci 0000:0b:04.1: PME# supported from D0 D3hot D3cold
pci 0000:0b:04.1: PME# disabled
PCI: 0000:0b:04.2 reg 10 32bit mmio: [e8001900, e80019ff]
pci 0000:0b:04.2: supports D1
pci 0000:0b:04.2: supports D2
pci 0000:0b:04.2: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0b:04.2: PME# disabled
PCI: 0000:0b:04.4 reg 10 32bit mmio: [e8001800, e80018ff]
pci 0000:0b:04.4: supports D1
pci 0000:0b:04.4: supports D2
pci 0000:0b:04.4: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:0b:04.4: PME# disabled
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 io port: [3000, 3fff]
PCI: bridge 0000:00:1e.0 32bit mmio: [e6000000, e80fffff]
PCI: bridge 0000:00:1e.0 64bit mmio pref: [e0000000, e1ffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: Power Resource [DGPR] (on)
ACPI: Power Resource [MGPR] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
ACPI: RTC can wake from S4
system 00:01: ioport range 0x164e-0x164f has been reserved
system 00:01: ioport range 0x600-0x60f has been reserved
system 00:01: ioport range 0x610-0x610 has been reserved
system 00:01: ioport range 0x800-0x80f has been reserved
system 00:01: ioport range 0x810-0x817 has been reserved
system 00:01: ioport range 0x820-0x823 has been reserved
system 00:01: ioport range 0x400-0x47f has been reserved
system 00:01: ioport range 0x500-0x53f has been reserved
system 00:01: ioport range 0x2000-0x2000 has been reserved
system 00:01: ioport range 0x2004-0x2004 has been reserved
system 00:01: iomem range 0xf8000000-0xfbffffff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed10000-0xfed13fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
system 00:01: iomem range 0xfee00000-0xfee00fff could not be reserved
pci 0000:01:00.0: BAR 6: can't allocate mem resource [0xd0000000-0xcfffffff]
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x7000-0x7fff
pci 0000:00:01.0:   MEM window: 0xe2000000-0xe4ffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x6000-0x6fff
pci 0000:00:1c.0:   MEM window: 0xed900000-0xee8fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000e8800000-0x000000e97fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:06
pci 0000:00:1c.1:   IO window: 0x5000-0x5fff
pci 0000:00:1c.1:   MEM window: 0xec800000-0xed8fffff
pci 0000:00:1c.1:   PREFETCH window: 0x000000e9800000-0x000000ea7fffff
pci 0000:00:1c.3: PCI bridge, secondary bus 0000:08
pci 0000:00:1c.3:   IO window: 0x4000-0x4fff
pci 0000:00:1c.3:   MEM window: 0xeb800000-0xec7fffff
pci 0000:00:1c.3:   PREFETCH window: 0x000000ea800000-0x000000eb7fffff
pci 0000:0b:04.0: CardBus bridge, secondary bus 0000:0c
pci 0000:0b:04.0:   IO window: 0x003000-0x0030ff
pci 0000:0b:04.0:   IO window: 0x003400-0x0034ff
pci 0000:0b:04.0:   PREFETCH window: 0xf0000000-0xf3ffffff
pci 0000:0b:04.0:   MEM window: 0xf4000000-0xf7ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0b
pci 0000:00:1e.0:   IO window: 0x3000-0x3fff
pci 0000:00:1e.0:   MEM window: 0xe6000000-0xe80fffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000e0000000-0x000000e1ffffff
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:1c.0: enabling device (0000 -> 0003)
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.1: setting latency timer to 64
pci 0000:00:1c.3: enabling device (0000 -> 0003)
pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
pci 0000:00:1c.3: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
pci 0000:0b:04.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
pci 0000:0b:04.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 io port: [7000, 7fff]
bus: 01 index 1 mmio: [e2000000, e4ffffff]
bus: 01 index 2 mmio: [c0000000, cfffffff]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [6000, 6fff]
bus: 02 index 1 mmio: [ed900000, ee8fffff]
bus: 02 index 2 mmio: [e8800000, e97fffff]
bus: 02 index 3 mmio: [0, 0]
bus: 06 index 0 io port: [5000, 5fff]
bus: 06 index 1 mmio: [ec800000, ed8fffff]
bus: 06 index 2 mmio: [e9800000, ea7fffff]
bus: 06 index 3 mmio: [0, 0]
bus: 08 index 0 io port: [4000, 4fff]
bus: 08 index 1 mmio: [eb800000, ec7fffff]
bus: 08 index 2 mmio: [ea800000, eb7fffff]
bus: 08 index 3 mmio: [0, 0]
bus: 0b index 0 io port: [3000, 3fff]
bus: 0b index 1 mmio: [e6000000, e80fffff]
bus: 0b index 2 mmio: [e0000000, e1ffffff]
bus: 0b index 3 io port: [0, ffff]
bus: 0b index 4 mmio: [0, ffffffffffffffff]
bus: 0c index 0 io port: [3000, 30ff]
bus: 0c index 1 io port: [3400, 34ff]
bus: 0c index 2 mmio: [f0000000, f3ffffff]
bus: 0c index 3 mmio: [f4000000, f7ffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 3732k freed
Simple Boot Flag value 0x5 read from CMOS RAM was invalid
Simple Boot Flag at 0x44 set to 0x1
audit: initializing netlink socket (disabled)
type=2000 audit(1225464741.448:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 5899
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
pcieport-driver 0000:00:01.0: setting latency timer to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie02: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.1: setting latency timer to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
pcieport-driver 0000:00:1c.3: setting latency timer to 64
pcieport-driver 0000:00:1c.3: found MSI capability
pci_express 0000:00:1c.3:pcie00: allocate port service
pci_express 0000:00:1c.3:pcie02: allocate port service
pci_express 0000:00:1c.3:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input0
ACPI: Power Button (CM) [PWRB]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID0]
ACPI: SSDT BBB6FC18, 0265 (r1   Sony     VAIO 20080715 INTL 20051117)
ACPI: SSDT BBB6D618, 05B8 (r1   Sony     VAIO 20080715 INTL 20051117)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BBB6EE18, 01CF (r1   Sony     VAIO 20080715 INTL 20051117)
ACPI: SSDT BBB6FF18, 008D (r1   Sony     VAIO 20080715 INTL 20051117)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [ATF0] (48 C)
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
agpgart-intel 0000:00:00.0: Intel Mobile Intel? GM45 Express Chipset
agpgart-intel 0000:00:00.0: detected 65532K stolen memory
agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0xd0000000
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input2
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
ahci 0000:00:1f.2: version 3.0
ahci 0000:00:1f.2: PCI INT B -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 4 ports 3 Gbps 0x33 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
ahci 0000:00:1f.2: setting latency timer to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925100 irq 22
ata2: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925180 irq 22
ata3: DUMMY
ata4: DUMMY
ata5: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925300 irq 22
ata6: SATA max UDMA/133 abar m2048@0xee925000 port 0xee925380 irq 22
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: ATA-8: Hitachi HTS722020K9SA00, DC4OC58P, max UDMA/133
ata1.00: 390721968 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
ata1.00: configured for UDMA/133
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ACPI cmd 00/00:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata2.00: ATAPI: MATSHITADVD-RAM UJ862AS, 1.21, max UDMA/33
ata2.00: ACPI cmd 00/00:00:00:00:00:a0 rejected by device (Stat=0x51 Err=0x04)
ata2.00: configured for UDMA/33
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      Hitachi HTS72202 DC4O PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 1:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ862AS  1.21 PQ: 0 ANSI: 5
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sr 1:0:0:0: Attached scsi generic sg1 type 5
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 23, io mem 0xee925c00
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 20 (level, low) -> IRQ 20
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xee925800
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
usb 1-2: new high speed USB device using ehci_hcd and address 3
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 23, io base 0x000080e0
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb 1-2: configuration #1 chosen from 1 choice
usb 1-2: New USB device found, idVendor=05ca, idProduct=18b0
usb 1-2: New USB device strings: Mfr=1, Product=0, SerialNumber=0
usb 1-2: Manufacturer: Ricoh co. Ltd.
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 23, io base 0x000080c0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 3-1: new full speed USB device using uhci_hcd and address 2
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 23, io base 0x000080a0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00008080
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb 3-1: configuration #1 chosen from 1 choice
usb 3-1: New USB device found, idVendor=147e, idProduct=1000
usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-1: Product: Fingerprint Sensor   
usb 3-1: Manufacturer: TouchStrip        
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 20, io base 0x00008060
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 20, io base 0x00008040
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.27.4-58.fc10.x86_64 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
PNP: PS/2 Controller [PNP0303:KBC,PNP0f13:MOUE] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k, hpet irqs
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 12:179:891
Freeing unused kernel memory: 1276k freed
Write protecting the kernel read-only data: 4948k
Clocksource tsc unstable (delta = -158183072 ns)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1225464745.438:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
input: PS/2 Mouse as /devices/platform/i8042/serio2/input/input4
input: AlpsPS/2 ALPS GlidePoint as /devices/platform/i8042/serio2/input/input5
SELinux: 8192 avtab hash slots, 106879 rules.
SELinux: 8192 avtab hash slots, 106879 rules.
SELinux:  8 users, 11 roles, 2475 types, 119 bools, 1 sens, 1024 cats
SELinux:  73 classes, 106879 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=1403 audit(1225464745.631:3): policy loaded auid=4294967295 ses=4294967295
ACPI: WMI: Mapper loaded
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [AC] (on-line)
e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k6
e1000e: Copyright (c) 1999-2008 Intel Corporation.
e1000e 0000:00:19.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
e1000e 0000:00:19.0: setting latency timer to 64
0000:00:19.0: 0000:00:19.0: Failed to initialize MSI interrupts.  Falling back to legacy interrupts.
sony-laptop: Sony Programmable IO Control Driver v0.6.
sony-laptop: detected Type2 model
input: Sony Vaio Keys as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:0f/SNY6001:00/input/input6
input: Sony Vaio Jogdial as /devices/virtual/input/input7
sony-laptop: device allocated minor is 59
sony-laptop: Sony Notebook Control Driver v0.6.
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:1a:80:d6:73:22
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 6, PHY: 8, PBA No: ffffff-0ff
acpi device:02: registered as cooling_device2
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:01/input/input8
ACPI: Video Device [OVGA] (multi-head: yes  rom: no  post: no)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:07/device:08/input/input9
ACPI: Video Device [DGPU] (multi-head: yes  rom: yes  post: no)
tpm_inf_pnp 00:0a: Found TPM with ID IFX0102
Yenta: CardBus bridge found at 0000:0b:04.0 [104d:9025]
Linux video capture interface: v2.00
Yenta: ISA IRQ mask 0x00b8, PCI irq 20
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#0b) from #0c to #0f
pcmcia: parent PCI bridge I/O window: 0x3000 - 0x3fff
pcmcia: parent PCI bridge Memory window: 0xe6000000 - 0xe80fffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe1ffffff
input: PC Speaker as /devices/platform/pcspkr/input/input10
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
uvcvideo: Found UVC 1.00 device <unnamed> (05ca:18b0)
input: UVC Camera (05ca:18b0) as /devices/pci0000:00/0000:00:1a.7/usb1/1-2/1-2:1.0/input/input11
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0)
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 22 (level, low) -> IRQ 22
ACPI: I/O resource 0000:00:1f.3 [0x8000-0x801f] conflicts with ACPI region SMBI [0x8000-0x800f]
ACPI: Device needs an ACPI driver
firewire_ohci 0000:0b:04.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
firewire_ohci 0000:0b:04.1: setting latency timer to 64
firewire_ohci: Added fw-ohci device 0000:0b:04.1, OHCI version 1.0
sdhci-pci 0000:0b:04.2: SDHCI controller found [1180:0822] (rev 21)
sdhci-pci 0000:0b:04.2: PCI INT C -> GSI 22 (level, low) -> IRQ 22
sdhci-pci 0000:0b:04.2: Will use DMA mode even though HW doesn't fully claim to support it.
sdhci-pci 0000:0b:04.2: setting latency timer to 64
Registered led device: mmc0
mmc0: SDHCI controller on PCI [0000:0b:04.2] using DMA
iwlagn: Intel(R) Wireless WiFi Link AGN driver for Linux, 1.3.27kds
iwlagn: Copyright(c) 2003-2008 Intel Corporation
iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:06:00.0: setting latency timer to 64
iwlagn: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
iwlagn: Tunable channels: 13 802.11bg, 24 802.11a channels
iwlagn 0000:06:00.0: PCI INT A disabled
phy0: Selected rate control algorithm 'iwl-agn-rs'
firewire_core: created device fw0: GUID 0800460302af3026, S400
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 21 (level, low) -> IRQ 21
HDA Intel 0000:00:1b.0: setting latency timer to 64
hda_codec: Unknown model for ALC262, trying auto-probe from BIOS...
ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=1 (0x14/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0x15/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0x12, fmic=0x18, line=0x0, fline=0x0, cd=0x0, aux=0x0
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 5079032k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 extents:1 across:5079032k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-17-06
firmware: requesting intel-ucode/06-17-06
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
iwlagn 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
iwlagn 0000:06:00.0: restoring config space at offset 0x1 (was 0x100002, writing 0x100006)
firmware: requesting iwlwifi-5000-1.ucode
iwlagn: Radio disabled by HW RF Kill switch
0000:00:19.0: eth0: Link is Up 100 Mbps Full Duplex, Flow Control: None
0000:00:19.0: eth0: 10/100 speed: disabling TSO
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
SELinux: initialized (dev 0:14, type nfs), uses genfs_contexts
fuse init (API version 7.9)
SELinux: initialized (dev fuse, type fuse), uses genfs_contexts
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 0 1
  domain 1: span 0-1 level NODE
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level MC
  groups: 1 0
  domain 1: span 0-1 level NODE
   groups: 0-1
