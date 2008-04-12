Return-Path: <linux-kernel-owner+w=401wt.eu-S1758557AbYDLTVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557AbYDLTVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 15:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbYDLTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 15:21:07 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:13254 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754514AbYDLTVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 15:21:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:mime-version:content-type:message-id;
        b=wigYlhqw5QqivsZW2J65Rjem3tS3HexoS3fHVTqYMlDM879Q1t1B0QiamCO2nY9qW9CQWZtoMUoA11NVbrwmm4WMdS1pkY/6FqIoqTJZ1IW14J6hITLVYa1WiX2OsK7IoUeTCWdVtoL3ZQXArFj+CnYIACQ2ad61rwN20AlHk40=
From: Christoph Pfister <christophpfister@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: apic doesn't work with 32bit kernel (fine with 64bit) [asus m2n-mx se+]
Date: Sat, 12 Apr 2008 21:20:53 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_VuQAIseFNQv7Q6I"
Message-Id: <200804122120.53220.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_VuQAIseFNQv7Q6I
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Using a new motherboard, I came across a kernel panic (dmesg using 2.6.25-rc9 
[x86_32] transcribed from screenshot attached; also dmesg when 
using "apic=debug").
The system works nearly fine when using "noapic" (setting rtc doesn't work).

Everything (including apic and rtc) works like a charm when I use the x86_64 
version with (nearly) the same kernel config (dmesg attached as well).

Regards,

Christoph

--Boundary-00=_VuQAIseFNQv7Q6I
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg_bad.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_bad.txt"

[...]
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) X2 Dual Core Processor BE-2350 stepping 02
Booting processor 1/1 ip 4000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4219.25 BogoMIPS (lpj=8438510)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) X2 Dual Core Processor BE-2350 stepping 02
Total of 2 processors activated (8442.63 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug
and send a report.  Then try booting with the 'noapic' option
--Boundary-00=_VuQAIseFNQv7Q6I
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg_bad2.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_bad2.txt"

[...]
Getting ID: 0
Getting LVT0: 700
Getting LVT1: 400
enabled ExtINT on CPU #0
ESR value before enabling vector: 0x00000004  after: 0x00000000
Booting processor 1/1 ip 4000
Initializing CPU#1
masked ExtINT on CPU #1
Calibrating delay using timer specific routine.. 4219.25 BogoMIPS (lpj=8438510)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: AMD Athlon(tm) X2 Dual Core Processor BE-2350 stepping 02
Total of 2 processors activated (8442.63 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...  failed.
...trying to set up timer as Virtual Wire IRQ... failed.
...trying to set up timer as ExtINT IRQ... failed :(.
Kernel panic - not syncing: IO-APIC + timer doesn't work!  Boot with apic=debug
and send a report.  Then try booting with the 'noapic' option
--Boundary-00=_VuQAIseFNQv7Q6I
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg_good.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg_good.txt"

Initializing cgroup subsys cpuset
Linux version 2.6.25-rc9 (root@pdc3) (gcc version 4.2.3 (Debian 4.2.3-3)) #1 SMP Sat Apr 12 16:01:46 UTC 2008
Command line: root=/dev/hda1 vga=791
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
 BIOS-e820: 000000003ffb0000 - 000000003ffbe000 (ACPI data)
 BIOS-e820: 000000003ffbe000 - 000000003ffe0000 (ACPI NVS)
 BIOS-e820: 000000003ffe0000 - 000000003ffee000 (reserved)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fef00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
end_pfn_map = 1048576
DMI present.
ACPI: RSDP 000FB770, 0014 (r0 ACPIAM)
ACPI: RSDT 3FFB0000, 0038 (r1 A_M_I_ OEMRSDT  12000704 MSFT       97)
ACPI: FACP 3FFB0200, 0084 (r2 A_M_I_ OEMFACP  12000704 MSFT       97)
ACPI: DSDT 3FFB05D0, 65BA (r1  A0865 A0865000        0 INTL 20051117)
ACPI: FACS 3FFBE000, 0040
ACPI: APIC 3FFB0390, 0080 (r1 A_M_I_ OEMAPIC  12000704 MSFT       97)
ACPI: MCFG 3FFB0410, 003C (r1 A_M_I_ OEMMCFG  12000704 MSFT       97)
ACPI: OEMB 3FFBE040, 0060 (r1 A_M_I_ AMI_OEM  12000704 MSFT       97)
ACPI: HPET 3FFB6B90, 0038 (r1 A_M_I_ OEMHPET0 12000704 MSFT       97)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003ffb0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003ffb0000
  NODE_DATA [000000000000b000 - 0000000000011fff]
  bootmap [0000000000012000 -  0000000000019ff7] pages 8
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-62ebf7] TEXT DATA BSS
early res: 3 [37b61000-37fef376] RAMDISK
early res: 4 [9fc00-a0bff] EBDA
early res: 5 [8000-afff] PGTABLE
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   262064
On node 0 totalpages: 261967
  DMA zone: 56 pages used for memmap
  DMA zone: 1079 pages reserved
  DMA zone: 2864 pages, LIFO batch:0
  DMA32 zone: 3526 pages used for memmap
  DMA32 zone: 254442 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x508
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 0 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ0 used by override.
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x10de8201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 34712 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257306
Policy zone: DMA32
Kernel command line: root=/dev/hda1 vga=791
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
Marking TSC unstable due to TSCs unsynchronized
time.c: Detected 2109.592 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour dummy device 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ 40000000 size 32 MB
Aperture too small (32 MB)
No AGP bridge found
Memory: 1024256k/1048256k available (2176k kernel code, 23612k reserved, 1011k data, 328k init)
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 4223.40 BogoMIPS (lpj=8446801)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12557112
Detected 12.557 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4219.26 BogoMIPS (lpj=8438522)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
AMD Athlon(tm) X2 Dual Core Processor BE-2350 stepping 02
Brought up 2 CPUs
net_namespace: 1016 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: Error attaching device data
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:04.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR11._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.BR12._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEA] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEB] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNEC] (IRQs 16 17 18 19) *0, disabled.
ACPI: PCI Interrupt Link [LNED] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUB0] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LUB2] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LMAC] (IRQs 20 21 22 23) *5
ACPI: PCI Interrupt Link [LAZA] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LACI] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LMC9] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 20 21 22 23) *10
ACPI: PCI Interrupt Link [LPMU] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LSA0] (IRQs 20 21 22 23) *11
ACPI: PCI Interrupt Link [LSA1] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22 23) *0, disabled.
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  60, should be 53 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0700 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0400 (active)
 00:07: calling quirk 0xffffffff80354d0a: quirk_system_pci_resources+0x0/0x17c()
pnp 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0103 (active)
 00:09: calling quirk 0xffffffff80354d0a: quirk_system_pci_resources+0x0/0x17c()
pnp 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0a: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
 00:0b: calling quirk 0xffffffff80354d0a: quirk_system_pci_resources+0x0/0x17c()
pnp 00:0b: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0c: Plug and Play ACPI device, IDs PNP0501 (active)
 00:0d: calling quirk 0xffffffff80354d0a: quirk_system_pci_resources+0x0/0x17c()
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0e: calling quirk 0xffffffff80354d0a: quirk_system_pci_resources+0x0/0x17c()
pnp 00:0e: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 31
hpet0: 3 32-bit timers, 25000000 Hz
ACPI: RTC can wake from S4
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: the driver 'system' has been registered
system 00:07: ioport range 0xa30-0xa37 has been reserved
system 00:07: ioport range 0x4d0-0x4d1 has been reserved
system 00:07: ioport range 0x800-0x80f has been reserved
system 00:07: ioport range 0x500-0x57f has been reserved
system 00:07: ioport range 0x580-0x5ff has been reserved
system 00:07: ioport range 0x800-0x87f could not be reserved
system 00:07: ioport range 0x880-0x8ff has been reserved
system 00:07: ioport range 0xd00-0xd7f has been reserved
system 00:07: ioport range 0xd80-0xdff has been reserved
system 00:07: ioport range 0x900-0x97f has been reserved
system 00:07: ioport range 0x980-0x9ff has been reserved
system 00:07: ioport range 0x2000-0x207f has been reserved
system 00:07: ioport range 0x2080-0x20ff has been reserved
system 00:07: iomem range 0xfefe0000-0xfefe01ff has been reserved
system 00:07: iomem range 0xfefe1000-0xfefe1fff has been reserved
system 00:07: iomem range 0xfee01000-0xfeefffff has been reserved
system 00:07: iomem range 0xffb80000-0xffffffff could not be reserved
system 00:07: iomem range 0xff300000-0xff3fffff has been reserved
system 00:07: driver attached
system 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:09: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:09: iomem range 0x0-0x0 could not be reserved
system 00:09: driver attached
system 00:0b: ioport range 0x230-0x23f has been reserved
system 00:0b: ioport range 0x290-0x29f has been reserved
system 00:0b: ioport range 0xa00-0xa0f has been reserved
system 00:0b: ioport range 0xa10-0xa1f has been reserved
system 00:0b: driver attached
system 00:0d: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0d: driver attached
system 00:0e: iomem range 0x0-0x9ffff could not be reserved
system 00:0e: iomem range 0xc0000-0xcffff has been reserved
system 00:0e: iomem range 0xe0000-0xfffff could not be reserved
system 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
system 00:0e: iomem range 0xff700000-0xffffffff could not be reserved
system 00:0e: driver attached
PCI: Bridge: 0000:00:04.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:09.0
  IO window: e000-efff
  MEM window: 0xdc000000-0xdfffffff
  PREFETCH window: 0x00000000c0000000-0x00000000cfffffff
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:0c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:09.0 to 64
PCI: Setting latency timer of device 0000:00:0b.0 to 64
PCI: Setting latency timer of device 0000:00:0c.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4664k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1208022444.688:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:04.0: Enabling HT MSI Mapping
pci 0000:00:05.0: Enabling HT MSI Mapping
pci 0000:00:07.0: Enabling HT MSI Mapping
pci 0000:00:08.0: Enabling HT MSI Mapping
pci 0000:00:09.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:02:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:09.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:09.0:pcie00]
PCI: Setting latency timer of device 0000:00:0b.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0b.0:pcie00]
PCI: Setting latency timer of device 0000:00:0c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:0c.0:pcie00]
vesafb: framebuffer at 0xdd000000, mapped to 0xffffc20000500000, using 3072k, total 14336k
vesafb: mode is 1024x768x16, linelength=2048, pages=1
vesafb: scrolling: redraw
vesafb: Truecolor: size=0:5:6:5, shift=0:11:5:0
Console: switching to colour frame buffer device 128x48
fb0: VESA VGA frame buffer device
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
pnp: the driver 'serial' has been registered
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial 00:0c: driver attached
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:0a: driver attached
pnp: the driver 'i8042 aux' has been registered
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 328k freed
input: AT Translated Set 2 keyboard as /class/input/input1
ACPI: ACPI0007:00 is registered as cooling_device0
ACPI: ACPI0007:01 is registered as cooling_device1
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUB2] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:02.1 to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.1
ehci_hcd 0000:00:02.1: irq 23, io mem 0xdbffec00
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
No dock devices found.
SCSI subsystem initialized
libata version 3.00 loaded.
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:07.0[A] -> Link [LMAC] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:07.0 to 64
forcedeth 0000:00:07.0: ifname eth0, PHY OUI 0x1374 @ 1, addr 00:1e:8c:d8:df:75
forcedeth 0000:00:07.0: highdma pwrctl mgmt timirq gbit lnktim msi desc-v3
sata_nv 0000:00:08.0: version 3.5
ACPI: PCI Interrupt Link [LSA0] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:08.0[A] -> Link [LSA0] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:08.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 21
ata2: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 21
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
NFORCE-MCP61: 0000:00:06.0 (rev a2) UDMA133 controller
NFORCE-MCP61: IDE controller (0x10de:0x03ec rev 0xa2) at  PCI slot 0000:00:06.0
NFORCE-MCP61: not 100% native mode: will probe irqs later
NFORCE-MCP61: IDE port disabled
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
hda: HDS722512VLAT20, ATA DISK drive
hdb: LITE-ON DVDRW SOHW-1693S, ATAPI CD/DVD-ROM drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: host side 80-wire cable detection failed, limiting max speed to UDMA33
hda: UDMA/33 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt Link [LUB0] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUB0] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 20, io mem 0xdbfff000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 8 ports detected
hdb: ATAPI 48X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
hda: max request size: 512KiB
hda: 241254720 sectors (123522 MB) w/1794KiB Cache, CHS=16383/255/63
hda: cache flushes supported
 hda: hda1 hda2
ReiserFS: hda1: found reiserfs format "3.6" with standard journal
ReiserFS: hda1: using ordered data mode
ReiserFS: hda1: journal params: device hda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda1: checking transaction log (hda1)
usb 2-4: new low speed USB device using ohci_hcd and address 2
ReiserFS: hda1: Using r5 hash to sort names
usb 2-4: configuration #1 chosen from 1 choice
input: PC Speaker as /class/input/input2
pnp: the driver 'parport_pc' has been registered
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
parport_pc 00:06: driver attached
input: Power Button (FF) as /class/input/input3
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x600
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x700
usbcore: registered new interface driver hiddev
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input4
input: Logitech USB Trackball as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input,hidraw0: USB HID v1.10 Mouse [Logitech USB Trackball] on usb-0000:00:02.0-4
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
ACPI: PCI Interrupt Link [LAZA] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:05.0[B] -> Link [LAZA] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:05.0 to 64
hda_codec: Unknown model for ALC662, trying auto-probe from BIOS...
Adding 996020k swap on /dev/hda2.  Priority:-1 extents:1 across:996020k
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
eth0: no IPv6 routers present

--Boundary-00=_VuQAIseFNQv7Q6I--
