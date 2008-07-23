Return-Path: <linux-kernel-owner+w=401wt.eu-S1754777AbYGWBBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777AbYGWBBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 21:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYGWBBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 21:01:05 -0400
Received: from bromo.msbb.uc.edu ([129.137.3.146]:39703 "HELO
	bromo.msbb.uc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751207AbYGWBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 21:01:00 -0400
Date: Tue, 22 Jul 2008 21:00:58 -0400
From: Jack Howarth <howarth@bromo.msbb.uc.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86,pci: dmi check for mackpro 2.2 mmconf
Message-ID: <20080723010058.GA12662@bromo.msbb.uc.edu>
References: <20080722233722.GA12247@bromo.msbb.uc.edu> <200807221723.04654.jbarnes@virtuousgeek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807221723.04654.jbarnes@virtuousgeek.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse,
    I found that patch right after I sent the email. Applying the ASPM
patch solves the boot hangs on under 2.6.26-git9 built with 
CONFIG_PCIEASPM=y. I am attaching the dmesg log for such a boot
below. I am a little confused if the patch totally disables aspm on
my machine or just inhibits the hang. Is there a proc entry I can check
to monitor that aspm is in use?
                   Jack

Initializing cgroup subsys cpuset
Initializing cgroup subsys cpu
Linux version 2.6.27-0.159.rc0.git9.fc9.x86_64 (howarth@localhost.localdomain) (gcc version 4.3.0 20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Tue Jul 22 19:47:49 EDT 2008
Command line: ro root=UUID=81966632-17b2-4377-929d-dc1e867e4d6d rhgb debug 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bf0e9000 (usable)
 BIOS-e820: 00000000bf0e9000 - 00000000bf2ea000 (ACPI NVS)
 BIOS-e820: 00000000bf2ea000 - 00000000bfebe000 (ACPI data)
 BIOS-e820: 00000000bfebe000 - 00000000bfeef000 (ACPI NVS)
 BIOS-e820: 00000000bfeef000 - 00000000bff00000 (ACPI data)
 BIOS-e820: 00000000bff00000 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed20000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffe00000 - 0000000100000000 (reserved)
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
last_pfn = 0xbf0e9 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
 0000000000 - 00bf000000 page 2M
 00bf000000 - 00bf0e9000 page 4k
kernel direct mapping tables up to bf0e9000 @ 8000-d000
last_map_addr: bf0e9000 end: bf0e9000
RAMDISK: 37d35000 - 37fef6a9
DMI 2.4 present.
ACPI: RSDP 000FE020, 0024 (r2 APPLE )
ACPI: XSDT BFEFD1C0, 0074 (r1 APPLE   Apple00       A5       1000013)
ACPI: FACP BFEFB000, 00F4 (r3 APPLE   Apple00       A5 Loki       5F)
ACPI: DSDT BFEF0000, 48BD (r1 APPLE  MacBookP    20001 INTL 20050309)
ACPI: FACS BFEC0000, 0040
ACPI: HPET BFEFA000, 0038 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: APIC BFEF9000, 0068 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: MCFG BFEF8000, 003C (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ASF! BFEF7000, 00A0 (r32 APPLE   Apple00        1 Loki       5F)
ACPI: SBST BFEF6000, 0030 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: ECDT BFEF5000, 0053 (r1 APPLE   Apple00        1 Loki       5F)
ACPI: SSDT BFEEF000, 04DC (r1 APPLE     CpuPm     3000 INTL 20050309)
ACPI: SSDT BFEBD000, 064F (r1 SataRe  SataPri     1000 INTL 20050309)
ACPI: SSDT BFEBC000, 069C (r1 SataRe  SataSec     1000 INTL 20050309)
ACPI: DMI detected: Apple
No NUMA configuration found
Faking a node at 0000000000000000-00000000bf0e9000
Entering add_active_range(0, 0x0, 0x9f) 0 entries of 25600 used
Entering add_active_range(0, 0x100, 0xbf0e9) 1 entries of 25600 used
Bootmem setup node 0 0000000000000000-00000000bf0e9000
  NODE_DATA [000000000000b000 - 000000000001ffff]
  bootmap [0000000000020000 -  0000000000037e1f] pages 18
(6 early reservations) ==> bootmem [0000000000 - 00bf0e9000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 0000e64168]    TEXT DATA BSS ==> [0000200000 - 0000e64168]
  #3 [0037d35000 - 0037fef6a9]          RAMDISK ==> [0037d35000 - 0037fef6a9]
  #4 [000009fc00 - 0000100000]    BIOS reserved ==> [000009fc00 - 0000100000]
  #5 [0000008000 - 000000b000]          PGTABLE ==> [0000008000 - 000000b000]
Scan SMP from ffff880000000000 for 1024 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
Scan SMP from ffff8800000f0000 for 65536 bytes.
Scan SMP from ffff88000009fc00 for 1024 bytes.
 [ffffe20000000000-ffffe200047fffff] PMD -> [ffff880001200000-ffff8800059fffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x000bf0e9
On node 0 totalpages: 782472
  DMA zone: 96 pages used for memmap
  DMA zone: 3274 pages reserved
  DMA zone: 629 pages, LIFO batch:0
  DMA32 zone: 18246 pages used for memmap
  DMA32 zone: 760227 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at c4000000 (gap: c0000000:30000000)
PERCPU: Allocating 442304 bytes of per cpu data
NR_CPUS: 64, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 760856
Policy zone: DMA32
Kernel command line: ro root=UUID=81966632-17b2-4377-929d-dc1e867e4d6d rhgb debug 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
Detected 2327.506 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:    8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        2048
... CLASSHASH_SIZE:           1024
... MAX_LOCKDEP_ENTRIES:     8192
... MAX_LOCKDEP_CHAINS:      16384
... CHAINHASH_SIZE:          8192
 memory used by lock dependency info: 1840 kB
 per task-struct memory footprint: 3456 bytes
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 3039248k/3130276k available (3110k kernel code, 90640k reserved, 1750k data, 1548k init)
CPA: page pool initialized 48 of 48 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer frequency.. <6>4655.01 BogoMIPS (lpj=2327506)
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
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
Using local APIC timer interrupts.
APIC timer calibration result 10390648
Detected 10.390 MHz APIC timer.
lockdep: fixing up alternatives.
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. <6>4654.79 BogoMIPS (lpj=2327397)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 CPU         T7600  @ 2.33GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
Total of 2 processors activated (9309.80 BogoMIPS).
sizeof(vma)=176 bytes
sizeof(page)=96 bytes
sizeof(inode)=1088 bytes
sizeof(dentry)=256 bytes
sizeof(ext3inode)=1488 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=9528 bytes
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
khelper used greatest stack depth: 5664 bytes left
net_namespace: 1576 bytes
Booting paravirtualized kernel on bare hardware
Time:  0:51:49  Date: 07/23/08
NET: Registered protocol family 16
No dock devices found.
khelper used greatest stack depth: 4872 bytes left
ACPI: bus type pci registered
PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 255
PCI: MCFG area at f0000000 reserved in E820
PCI: updated MCFG configuration 0: base f0000000 segment 0 buses 0 - 63
PCI: Using MMCONFIG at f0000000 - f3ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: BIOS _OSI(Linux) query ignored via DMI
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
pci 0000:00:01.0: PME# disabled
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.1: PME# disabled
pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.2: PME# disabled
pci 0000:00:1d.7: PME# supported from D0 D3hot D3cold
pci 0000:00:1d.7: PME# disabled
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
pci 0000:00:1f.2: PME# supported from D3hot
pci 0000:00:1f.2: PME# disabled
pci 0000:01:00.0: supports D1
pci 0000:01:00.0: supports D2
pci 0000:02:00.0: supports D1
pci 0000:02:00.0: supports D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: PME# supported from D0 D1 D3hot
pci 0000:03:00.0: PME# disabled
pci 0000:0c:03.0: supports D1
pci 0000:0c:03.0: supports D2
pci 0000:0c:03.0: PME# supported from D0 D1 D2 D3hot
pci 0000:0c:03.0: PME# disabled
pci 0000:00:1e.0: transparent bridge
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 *10 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
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
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
tracer: 1286 pages allocated for 65536 entries of 80 bytes
   actual entries 65586
ACPI: RTC can wake from S4
system 00:01: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
system 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
system 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:01: iomem range 0xfed20000-0xfed8ffff has been reserved
system 00:05: iomem range 0xfed00000-0xfed003ff has been reserved
system 00:07: ioport range 0x680-0x6ef has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x810-0x817 has been reserved
system 00:07: ioport range 0x400-0x47f has been reserved
system 00:07: ioport range 0x500-0x53f has been reserved
system 00:07: ioport range 0x1640-0x164f has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0x3000-0x3fff
pci 0000:00:01.0:   MEM window: 0xd8300000-0xd83fffff
pci 0000:00:01.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.0:   IO window: 0x2000-0x2fff
pci 0000:00:1c.0:   MEM window: 0xd8200000-0xd82fffff
pci 0000:00:1c.0:   PREFETCH window: 0x000000d8500000-0x000000d85fffff
pci 0000:00:1c.1: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.1:   IO window: disabled
pci 0000:00:1c.1:   MEM window: 0xd8100000-0xd81fffff
pci 0000:00:1c.1:   PREFETCH window: disabled
pci 0000:00:1c.2: PCI bridge, secondary bus 0000:04
pci 0000:00:1c.2:   IO window: 0x1000-0x1fff
pci 0000:00:1c.2:   MEM window: 0xd4100000-0xd80fffff
pci 0000:00:1c.2:   PREFETCH window: 0x000000d0000000-0x000000d3ffffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:0c
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xd4000000-0xd40fffff
pci 0000:00:1e.0:   PREFETCH window: disabled
pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pci 0000:00:1c.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pci 0000:00:1e.0: power state changed by ACPI to D0
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
TCP bind hash table entries: 65536 (order: 10, 4194304 bytes)
TCP: Hash tables configured (established 524288 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs...<7>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 it is
debug: unmapping init memory ffff880037d35000..ffff880037ff0000
audit: initializing netlink socket (disabled)
type=2000 audit(1216774309.732:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 5936
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x1010
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
pci 0000:00:1d.3: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.3: Performing full reset
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
pcieport-driver 0000:00:01.0: found MSI capability
pci_express 0000:00:01.0:pcie00: allocate port service
pci_express 0000:00:01.0:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.0 to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.1 to 64
pcieport-driver 0000:00:1c.1: found MSI capability
pci_express 0000:00:1c.1:pcie00: allocate port service
pci_express 0000:00:1c.1:pcie02: allocate port service
pci_express 0000:00:1c.1:pcie03: allocate port service
PCI: Setting latency timer of device 0000:00:1c.2 to 64
pcieport-driver 0000:00:1c.2: found MSI capability
pci_express 0000:00:1c.2:pcie00: allocate port service
pci_express 0000:00:1c.2:pcie02: allocate port service
pci_express 0000:00:1c.2:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /devices/LNXSYSTM:00/device:00/PNP0C0D:00/input/input1
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input2
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input3
ACPI: Sleep Button (CM) [SLPB]
ACPI: SSDT BFEB8A90, 02F0 (r1 APPLE   Cpu0Ist     3000 INTL 20050309)
ACPI: SSDT BFEB6C10, 02A0 (r1 APPLE   Cpu0Cst     3001 INTL 20050309)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT BFEB7F10, 0087 (r1 APPLE   Cpu1Ist     3000 INTL 20050309)
ACPI: SSDT BFEB6F10, 0085 (r1 APPLE   Cpu1Cst     3000 INTL 20050309)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input4
Driver 'sd' needs updating - please use bus_type methods
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: No controller found.
mice: PS/2 mouse device common for all mice
rtc_cmos 00:08: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, y3k
cpuidle: using governor ladder
cpuidle: using governor menu
Marking TSC unstable due to TSC halts in idle
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 0:71:861
debug: unmapping init memory ffffffff814ef000..ffffffff81672000
Write protecting the kernel read-only data: 1376k
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
drivers/usb/core/inode.c: creating file 'devices'
drivers/usb/core/inode.c: creating file '001'
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: reset hcs_params 0x104208 dbg=1 cc=4 pcc=2 ordered !ppc ports=8
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xd8405400
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 2: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 4: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 6: status 0501 change 0001
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 001803 POWER sig=j CSC CONNECT
hub 1-0:1.0: port 7: status 0501 change 0001
hub 1-0:1.0: state 7 ports 8 chg 00d4 evt 0000
drivers/usb/core/inode.c: creating file '001'
hub 1-0:1.0: port 2, status 0501, change 0000, 480 Mb/s
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27-0.159.rc0.git9.fc9.x86_64 ehci_hcd
usb usb1: SerialNumber: 0000:00:1d.7
modprobe used greatest stack depth: 3472 bytes left
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
drivers/usb/core/inode.c: creating file '002'
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: supports USB remote wakeup
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00004080
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: power on to power good time: 2ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
Clocksource tsc unstable (delta = -452396461 ns)
ehci_hcd 0000:00:1d.7: port 2 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 2 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 4, status 0501, change 0000, 480 Mb/s
uhci_hcd 0000:00:1d.0: port 2 portsc 009b,00
hub 2-0:1.0: port 2: status 0101 change 0003
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: new high speed USB device using ehci_hcd and address 3
drivers/usb/core/inode.c: creating file '001'
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27-0.159.rc0.git9.fc9.x86_64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
drivers/usb/core/inode.c: creating file '003'
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: supports USB remote wakeup
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00004060
usb usb3: default language 0x0409
usb usb3: uevent
usb usb3: usb_probe_device
usb usb3: configuration #1 chosen from 1 choice
usb usb3: adding 3-0:1.0 (config #1, interface 0)
usb 3-0:1.0: uevent
hub 3-0:1.0: usb_probe_interface
hub 3-0:1.0: usb_probe_interface - got id
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 3-0:1.0: standalone hub
hub 3-0:1.0: no power switching (usb 1.0)
hub 3-0:1.0: individual port over-current protection
hub 3-0:1.0: power on to power good time: 2ms
hub 3-0:1.0: local power source is good
hub 3-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 4 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 4 status 001005 POWER sig=se0 PE CONNECT
usb 1-4: uevent
usb 1-4: usb_probe_device
usb 1-4: configuration #1 chosen from 1 choice
usb 1-4: adding 1-4:1.0 (config #1, interface 0)
usb 1-4:1.0: uevent
drivers/usb/core/inode.c: creating file '003'
usb 1-4: New USB device found, idVendor=05ac, idProduct=8300
usb 1-4: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 1-0:1.0: port 6, status 0501, change 0000, 480 Mb/s
uhci_hcd 0000:00:1d.1: port 2 portsc 008a,00
ehci_hcd 0000:00:1d.7: port 6 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 6 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 6 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: port 7, status 0501, change 0000, 480 Mb/s
drivers/usb/core/inode.c: creating file '001'
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27-0.159.rc0.git9.fc9.x86_64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
drivers/usb/core/inode.c: creating file '004'
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: supports USB remote wakeup
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00004040
usb usb4: default language 0x0409
usb usb4: uevent
usb usb4: usb_probe_device
usb usb4: configuration #1 chosen from 1 choice
usb usb4: adding 4-0:1.0 (config #1, interface 0)
usb 4-0:1.0: uevent
hub 4-0:1.0: usb_probe_interface
hub 4-0:1.0: usb_probe_interface - got id
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
hub 4-0:1.0: standalone hub
hub 4-0:1.0: no power switching (usb 1.0)
hub 4-0:1.0: individual port over-current protection
hub 4-0:1.0: power on to power good time: 2ms
hub 4-0:1.0: local power source is good
hub 4-0:1.0: trying to enable port power on non-switchable hub
ehci_hcd 0000:00:1d.7: port 7 full speed --> companion
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003801 POWER OWNER sig=j CONNECT
hub 1-0:1.0: port 7 not reset yet, waiting 50ms
ehci_hcd 0000:00:1d.7: GetStatus port 7 status 003002 POWER OWNER sig=se0 CSC
hub 1-0:1.0: state 7 ports 8 chg 0000 evt fe80
hub 2-0:1.0: state 7 ports 2 chg 0004 evt 0000
hub 2-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
uhci_hcd 0000:00:1d.2: port 2 portsc 009b,00
hub 4-0:1.0: port 2: status 0101 change 0003
usb 2-2: new full speed USB device using uhci_hcd and address 2
drivers/usb/core/inode.c: creating file '001'
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27-0.159.rc0.git9.fc9.x86_64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.2
uhci_hcd 0000:00:1d.3: PCI INT D -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
drivers/usb/core/inode.c: creating file '005'
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.3: detected 2 ports
uhci_hcd 0000:00:1d.3: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.3: Performing full reset
uhci_hcd 0000:00:1d.3: supports USB remote wakeup
uhci_hcd 0000:00:1d.3: irq 16, io base 0x00004020
usb usb5: default language 0x0409
usb usb5: uevent
usb usb5: usb_probe_device
usb usb5: configuration #1 chosen from 1 choice
usb usb5: adding 5-0:1.0 (config #1, interface 0)
usb 5-0:1.0: uevent
hub 5-0:1.0: usb_probe_interface
hub 5-0:1.0: usb_probe_interface - got id
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
hub 5-0:1.0: standalone hub
hub 5-0:1.0: no power switching (usb 1.0)
hub 5-0:1.0: individual port over-current protection
hub 5-0:1.0: power on to power good time: 2ms
hub 5-0:1.0: local power source is good
hub 5-0:1.0: trying to enable port power on non-switchable hub
uhci_hcd 0000:00:1d.3: port 1 portsc 009b,00
hub 5-0:1.0: port 1: status 0101 change 0003
usb 2-2: ep0 maxpacket = 8
usb 2-2: USB quirks for this device: 2
usb 2-2: skipped 1 descriptor after interface
usb 2-2: skipped 1 descriptor after interface
usb 2-2: skipped 1 descriptor after interface
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usbhid 2-2:1.0: usb_probe_interface
usbhid 2-2:1.0: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
uhci_hcd 0000:00:1d.0: reserve dev 2 ep83-INT, period 8, phase 4, 17 us
input,hidraw0: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
usb 2-2: adding 2-2:1.1 (config #1, interface 1)
usb 2-2:1.1: uevent
usbhid 2-2:1.1: usb_probe_interface
usbhid 2-2:1.1: usb_probe_interface - got id
usb 2-2: adding 2-2:1.2 (config #1, interface 2)
usb 2-2:1.2: uevent
usbhid 2-2:1.2: usb_probe_interface
usbhid 2-2:1.2: usb_probe_interface - got id
input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input6
uhci_hcd 0000:00:1d.0: reserve dev 2 ep84-INT, period 8, phase 4, 12 us
input,hidraw1: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
drivers/usb/core/inode.c: creating file '002'
usb 2-2: New USB device found, idVendor=05ac, idProduct=021a
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: Apple Internal Keyboard / Trackpad
usb 2-2: Manufacturer: Apple Computer
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
hub 4-0:1.0: state 7 ports 2 chg 0004 evt 0000
hub 4-0:1.0: port 2, status 0101, change 0000, 12 Mb/s
drivers/usb/core/inode.c: creating file '001'
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27-0.159.rc0.git9.fc9.x86_64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.3
ata_piix 0000:00:1f.1: version 2.12
ata_piix 0000:00:1f.1: power state changed by ACPI to D0
ata_piix 0000:00:1f.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x40b0 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x40b8 irq 15
usb 4-2: new full speed USB device using uhci_hcd and address 2
ata1.00: ATAPI: MATSHITADVD-R   UJ-85J, FAV1, max UDMA/66
ata1.00: configured for UDMA/66
usb 4-2: ep0 maxpacket = 8
usb 4-2: skipped 1 descriptor after interface
usb 4-2: default language 0x0409
usb 4-2: uevent
usb 4-2: usb_probe_device
usb 4-2: configuration #1 chosen from 1 choice
usb 4-2: adding 4-2:1.0 (config #1, interface 0)
usb 4-2:1.0: uevent
usbhid 4-2:1.0: usb_probe_interface
usbhid 4-2:1.0: usb_probe_interface - got id
drivers/usb/core/file.c: looking for a minor, starting at 96
hiddev96hidraw2: USB HID v1.11 Device [Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-2
drivers/usb/core/inode.c: creating file '002'
usb 4-2: New USB device found, idVendor=05ac, idProduct=8240
usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 4-2: Product: IR Receiver
usb 4-2: Manufacturer: Apple Computer, Inc.
hub 5-0:1.0: state 7 ports 2 chg 0002 evt 0000
hub 5-0:1.0: port 1, status 0101, change 0000, 12 Mb/s
isa bounce pool size: 16 pages
scsi 0:0:0:0: CD-ROM            MATSHITA DVD-R   UJ-85J   FAV1 PQ: 0 ANSI: 5
scsi 0:0:0:0: Attached scsi generic sg0 type 5
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 -- -- ]
usb 5-1: new full speed USB device using uhci_hcd and address 2
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x40c8 ctl 0x40e4 bmdma 0x40a0 irq 19
ata4: SATA max UDMA/133 cmd 0x40c0 ctl 0x40e0 bmdma 0x40a8 irq 19
usb 5-1: skipped 1 descriptor after interface
usb 5-1: skipped 1 descriptor after interface
usb 5-1: uevent
usb 5-1: usb_probe_device
usb 5-1: configuration #1 chosen from 1 choice
usb 5-1: adding 5-1:1.0 (config #1, interface 0)
usb 5-1:1.0: uevent
usbhid 5-1:1.0: usb_probe_interface
usbhid 5-1:1.0: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
uhci_hcd 0000:00:1d.3: reserve dev 2 ep81-INT, period 1, phase 0, 23 us
input,hidraw3: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
usb 5-1: adding 5-1:1.1 (config #1, interface 1)
usb 5-1:1.1: uevent
usbhid 5-1:1.1: usb_probe_interface
usbhid 5-1:1.1: usb_probe_interface - got id
input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input8
input,hidraw4: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
drivers/usb/core/inode.c: creating file '002'
usb 5-1: New USB device found, idVendor=05ac, idProduct=1000
usb 5-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0002
usb usb3: suspend_rh (auto-stop)
ata3.01: ATA-7: TOSHIBA MK2035GSS, DK021B, max UDMA/100
ata3.01: 390721968 sectors, multi 16: LBA48 NCQ (depth 0/4)
ata3.01: configured for UDMA/100
scsi 2:0:1:0: Direct-Access     ATA      TOSHIBA MK2035GS DK02 PQ: 0 ANSI: 5
sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:1:0: [sda] 390721968 512-byte hardware sectors (200050 MB)
sd 2:0:1:0: [sda] Write Protect is off
sd 2:0:1:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:1:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 sda4 sda5
sd 2:0:1:0: [sda] Attached SCSI disk
sd 2:0:1:0: Attached scsi generic sg1 type 0
modprobe used greatest stack depth: 2304 bytes left
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
type=1404 audit(1216774317.677:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
SELinux: 8192 avtab hash slots, 171021 rules.
SELinux: 8192 avtab hash slots, 171021 rules.
SELinux:  8 users, 12 roles, 2347 types, 115 bools, 1 sens, 1024 cats
SELinux:  72 classes, 171021 rules
SELinux:  permission open in class dir not defined in policy
SELinux:  permission open in class file not defined in policy
SELinux:  permission open in class chr_file not defined in policy
SELinux:  permission open in class blk_file not defined in policy
SELinux:  permission open in class fifo_file not defined in policy
SELinux: the above unknown classes and permissions will be allowed
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda5, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
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
type=1403 audit(1216774318.525:3): policy loaded auid=4294967295 ses=4294967295
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-2: uevent
usb 2-2:1.0: uevent
usb 2-2:1.1: uevent
usb 2-2:1.2: uevent
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb 4-2: uevent
usb 4-2:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb 5-1: uevent
usb 5-1:1.0: uevent
usb 5-1:1.1: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb 1-4: uevent
usb 1-4:1.0: uevent
appletouch 2-2:1.1: usb_probe_interface
appletouch 2-2:1.1: usb_probe_interface - got id
appletouch: Geyser mode initialized.
input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input9
usbcore: registered new interface driver appletouch
isight_firmware 1-4:1.0: usb_probe_interface
isight_firmware 1-4:1.0: usb_probe_interface - got id
firmware: requesting isight.fw
ath_hal: module license 'Proprietary' taints kernel.
AR5210, AR5211, AR5212, AR5416, RF5111, RF5112, RF2413, RF5413, RF2133)
sky2 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:02:00.0 to 64
sky2 0000:02:00.0: v1.22 addr 0xd8200000 irq 16 Yukon-2 EC rev 2
sky2 eth0: addr 00:17:f2:d1:e0:6f
intel_rng: FWH not detected
ACPI: Battery Slot [BAT0] (battery present)
ACPI: AC Adapter [ADP1] (on-line)
input: Video Bus as /devices/LNXSYSTM:00/device:00/PNP0A08:00/device:02/input/input10
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 24x/24x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 0:0:0:0: Attached scsi CD-ROM sr0
input: PC Speaker as /devices/platform/pcspkr/input/input11
iTCO_vendor_support: vendor-support=0
i801_smbus 0000:00:1f.3: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ACPI: I/O resource 0000:00:1f.3 [0xefa0-0xefbf] conflicts with ACPI region SMBI [0xefa0-0xefaf]
ACPI: Device needs an ACPI driver
firewire_ohci 0000:0c:03.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:0c:03.0, OHCI version 1.10
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Unable to load isight firmware
usbcore: registered new interface driver isight_firmware
firewire_core: created device fw0: GUID 0019e3fffe6e4c54, S800
ath_pci 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
MadWifi: ath_attach: Switching rfkill capability off.
wifi0: Atheros AR5418 chip found (MAC 12.10, PHY SChip 8.1, Radio 12.0)
ath_pci: wifi0: Atheros 5418: mem=0xd8100000, irq=17
Error: Driver 'pcspkr' is already registered, aborting...
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ALSA sound/pci/hda/hda_intel.c:2069: chipset global capabilities = 0x4401
ALSA sound/pci/hda/hda_intel.c:754: codec_mask = 0x1
ALSA sound/pci/hda/hda_codec.c:2350: hda_codec: model 'intel-mac-v3' is selected for config 8384:7680 (Mac Mini)
hda_codec: STAC922x, Apple subsys_id=106b1a00
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0a pin config 0321e21f
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0b pin config 03a1e02e
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0c pin config 9017e110
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0d pin config 9017e11f
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0e pin config 400000fe
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 0f pin config 0381e020
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 10 pin config 1345e230
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 11 pin config 13c5e240
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 15 pin config 400000fc
ALSA sound/pci/hda/patch_sigmatel.c:1840: hda_codec: pin nid 1b pin config 400000fb
ALSA sound/pci/hda/hda_codec.c:3021: autoconfig: line_outs=2 (0xc/0xd/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3025:    speaker_outs=0 (0x0/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3029:    hp_outs=1 (0xa/0x0/0x0/0x0/0x0)
ALSA sound/pci/hda/hda_codec.c:3030:    mono: mono_out=0x0
ALSA sound/pci/hda/hda_codec.c:3038:    inputs: mic=0xb, fmic=0x0, line=0xf, fline=0x0, cd=0x0, aux=0x0
ALSA sound/pci/hda/patch_sigmatel.c:2249: stac92xx_add_dyn_out_pins: total dac count=4
ALSA sound/pci/hda/patch_sigmatel.c:2371: dac_nids=4 (0x3/0x2/0x5/0x4/0x0)
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave External Speaker Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker2 Playback Volume, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Headphone Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave External Speaker Playback Switch, skipped
ALSA sound/pci/hda/hda_codec.c:1127: Cannot find slave Speaker2 Playback Switch, skipped
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
[drm] Initialized drm 1.1.0 20060810
pci 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
[drm] Initialized radeon 1.29.0 20080528 on minor 0
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda5, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda3, type ext3), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 2047992k swap on /dev/sda4.  Priority:-1 extents:1 across:2047992k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
firmware: requesting intel-ucode/06-0f-06
firmware: requesting intel-ucode/06-0f-06
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
ip_tables: (C) 2000-2006 Netfilter Core Team
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that may be insecure.
fuse init (API version 7.9)
SELinux: initialized (dev fusectl, type fusectl), uses genfs_contexts
usb usb3: usb auto-resume
usb usb3: wakeup_rh
hub 3-0:1.0: hub_resume
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: suspend_rh (auto-stop)
uhci_hcd 0000:00:1d.2: reserve dev 2 ep83-INT, period 8, phase 4, 61 us
uhci_hcd 0000:00:1d.2: release dev 2 ep83-INT, period 8, phase 4, 61 us
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
Bluetooth: Core ver 2.12
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.10
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.10
Bluetooth: BNEP (Ethernet Emulation) ver 1.2
Bluetooth: BNEP filters: protocol multicast
Bridge firewalling registered
pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
[drm] Num pipes: 1
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
[drm] Setting GART location based on new memory map
[drm] Loading R500 Microcode
[drm] Num pipes: 1
[drm] writeback test succeeded in 1 usecs
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: release dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.3: reserve dev 2 ep82-INT, period 1, phase 0, 23 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
ath0: no IPv6 routers present
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x1, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x1, channel=0, format=0x4011
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
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ACPI: EC: GPE storm detected, disabling EC GPE
appletouch: 17" model detected.
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x1, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x6, stream=0x1, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x6
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
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
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_intel.c:1390: azx_pcm_prepare: bufsize=0x4400, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x8, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x3, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x5, stream=0x5, channel=0, format=0x4011
ALSA sound/pci/hda/hda_codec.c:716: hda_codec_setup_stream: NID=0x4, stream=0x5, channel=0, format=0x4011
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x8
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x3
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x2
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x5
ALSA sound/pci/hda/hda_codec.c:728: hda_codec_cleanup_stream: NID=0x4
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: release dev 2 ep81-INT, period 1, phase 0, 61 us
uhci_hcd 0000:00:1d.0: reserve dev 2 ep81-INT, period 1, phase 0, 61 us
