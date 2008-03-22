Return-Path: <linux-kernel-owner+w=401wt.eu-S1756670AbYCVL1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670AbYCVL1A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754160AbYCVL0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:26:51 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:1762 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYCVL0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:26:48 -0400
Date: Sat, 22 Mar 2008 12:27:12 +0100
From: Martin Michlmayr <tbm@cyrius.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080322112712.GC3022@deprecation.cyrius.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <47E3E2CF.5070408@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

* Stefan Richter <stefanr@s5r6.in-berlin.de> [2008-03-21 17:31]:
> According to your 2.6.22 dmesg, this happens a while after the firewire 
> subsystem seemingly successfully initialized the controller.  Could you 
> please post "dmesg | grep firewire" from 2.6.25-rc6 though?

firewire_ohci: Added fw-ohci device 0000:02:06.1, OHCI version 1.10
firewire_core: created device fw0: GUID 001b249929010210, S400

I've also attached the complete dmesg from 2.6.25-rc6.
-- 
Martin Michlmayr
http://www.cyrius.com/

--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=dmesg

Initializing cgroup subsys cpuset
Linux version 2.6.25-rc6-amd64 (Debian 2.6.25~rc6-1~experimental.1~snapshot.10910) (waldi@debian.org) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14+1)) #1 SMP Tue Mar 18 02:45:58 UTC 2008
Command line: root=/dev/mapper/lucky-root ro
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f7b0000 (usable)
 BIOS-e820: 000000007f7b0000 - 000000007f7c5400 (reserved)
 BIOS-e820: 000000007f7c5400 - 000000007f7e7fb8 (ACPI NVS)
 BIOS-e820: 000000007f7e7fb8 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9a000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F77A0, 0024 (r2 HP    )
ACPI: XSDT 7F7C81C4, 0074 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 7F7C8084, 00F4 (r4 HP     30C9            3 HP          1)
ACPI: DSDT 7F7C84C0, 13484 (r1 HP       nc2500    10000 MSFT  3000001)
ACPI: FACS 7F7E7D80, 0040
ACPI: SLIC 7F7C8238, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 7F7C83B0, 0038 (r1 HP     30C9            1 HP          1)
ACPI: APIC 7F7C83E8, 0068 (r1 HP     30C9            1 HP          1)
ACPI: MCFG 7F7C8450, 003C (r1 HP     30C9            1 HP          1)
ACPI: TCPA 7F7C848C, 0032 (r2 HP     30C9            1 HP          1)
ACPI: SSDT 7F7DB944, 02BE (r1 HP       HPQPAT        1 MSFT  3000001)
ACPI: SSDT 7F7DC586, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 7F7DC7E5, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 7F7DC88B, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
ACPI: DMI detected: Hewlett-Packard
No NUMA configuration found
Faking a node at 0000000000000000-000000007f7b0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 522160) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007f7b0000
  NODE_DATA [000000000000c000 - 0000000000012fff]
  bootmap [0000000000013000 -  0000000000022ef7] pages 10
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-6b10a7] TEXT DATA BSS
early res: 3 [37907000-37fef10a] RAMDISK
early res: 4 [9fc00-a0bff] EBDA
early res: 5 [8000-bfff] PGTABLE
No mptable found.
 [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
 [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
 [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
 [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
 [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
 [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
 [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
 [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
 [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
 [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
 [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
 [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
 [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
 [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   522160
On node 0 totalpages: 522063
  DMA zone: 56 pages used for memmap
  DMA zone: 1209 pages reserved
  DMA zone: 2734 pages, LIFO batch:0
  DMA32 zone: 7082 pages used for memmap
  DMA32 zone: 510982 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e0000
PM: Registered nosave memory: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 36208 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 513716
Policy zone: DMA32
Kernel command line: root=/dev/mapper/lucky-root ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 1196.997 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2047392k/2088640k available (2303k kernel code, 40860k reserved, 1335k data, 376k init)
CPA: page pool initialized 1 of 1 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 2397.35 BogoMIPS (lpj=4794716)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring handled by SMI
using mwait in idle threads.
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 8312479
Detected 8.312 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 2393.99 BogoMIPS (lpj=4787998)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 Duo CPU     U7600  @ 1.20GHz stepping 0d
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
  domain 1: span 00000003
   groups: 00000003
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
  domain 1: span 00000003
   groups: 00000003
net_namespace: 1016 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at f8000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in interrupt mode
ACPI: PCI Root Bridge [C003] (0000:00)
pci 0000:00:1f.0: quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 1100-113f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C0B2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C11F._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C133._PRT]
ACPI: PCI Interrupt Link [C12F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C130] (IRQs *10 11)
ACPI: PCI Interrupt Link [C131] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C132] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C142] (IRQs *10 11)
ACPI: PCI Interrupt Link [C143] (IRQs 10 11) *0, disabled.
ACPI: PCI Interrupt Link [C144] (IRQs 10 *11)
ACPI Exception (pci_link-0184): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C29F] (on)
ACPI: Power Resource [C1C7] (off)
ACPI: Power Resource [C3AD] (off)
ACPI: Power Resource [C3B0] (off)
ACPI: Power Resource [C3C3] (off)
ACPI: Power Resource [C3C4] (off)
ACPI: Power Resource [C3C5] (off)
ACPI: Power Resource [C3C6] (off)
ACPI: Power Resource [C3C7] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
 00:00: calling quirk 0xffffffff8036b6af: quirk_system_pci_resources+0x0/0x16e()
pnp 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
pnp 00:01: Plug and Play ACPI device, IDs PNP0a08 PNP0a03 (active)
pnp 00:02: Plug and Play ACPI device, IDs IFX0102 PNP0c31 (active)
pnp 00:03: Plug and Play ACPI device, IDs PNP0c04 (active)
pnp 00:04: Plug and Play ACPI device, IDs PNP0200 (active)
pnp 00:05: Plug and Play ACPI device, IDs PNP0800 (active)
pnp 00:06: Plug and Play ACPI device, IDs PNP0b00 (active)
pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (active)
pnp 00:08: Plug and Play ACPI device, IDs PNP0303 (active)
pnp 00:09: Plug and Play ACPI device, IDs SYN0130 SYN0100 SYN0002 PNP0f13 (active)
 00:0a: calling quirk 0xffffffff8036b6af: quirk_system_pci_resources+0x0/0x16e()
pnp 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp 00:0b: Plug and Play ACPI device, IDs HPQ0004 (active)
 00:0c: calling quirk 0xffffffff8036b6af: quirk_system_pci_resources+0x0/0x16e()
pnp 00:0c: Plug and Play ACPI device, IDs PNP0c02 (active)
 00:0d: calling quirk 0xffffffff8036b6af: quirk_system_pci_resources+0x0/0x16e()
pnp 00:0d: Plug and Play ACPI device, IDs PNP0c02 (active)
pnp: PnP ACPI: found 14 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
pnp: the driver 'system' has been registered
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xe0000-0xfffff could not be reserved
system 00:00: iomem range 0x100000-0x7f7fffff could not be reserved
system 00:00: driver attached
system 00:0a: ioport range 0x500-0x55f has been reserved
system 00:0a: ioport range 0x800-0x80f has been reserved
system 00:0a: iomem range 0xffb00000-0xffbfffff could not be reserved
system 00:0a: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0a: driver attached
system 00:0c: ioport range 0x4d0-0x4d1 has been reserved
system 00:0c: ioport range 0x2f8-0x2ff has been reserved
system 00:0c: ioport range 0x3f8-0x3ff has been reserved
system 00:0c: ioport range 0x1000-0x107f has been reserved
system 00:0c: ioport range 0x1100-0x113f has been reserved
system 00:0c: ioport range 0x1200-0x121f has been reserved
system 00:0c: iomem range 0xf8000000-0xfbffffff has been reserved
system 00:0c: iomem range 0xfec00000-0xfec000ff could not be reserved
system 00:0c: iomem range 0xfed20000-0xfed3ffff could not be reserved
system 00:0c: iomem range 0xfed45000-0xfed8ffff could not be reserved
system 00:0c: iomem range 0xfed90000-0xfed99fff could not be reserved
system 00:0c: driver attached
system 00:0d: iomem range 0xcee00-0xcffff has been reserved
system 00:0d: iomem range 0xd2000-0xd3fff has been reserved
system 00:0d: iomem range 0xfeda0000-0xfedbffff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0d: driver attached
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: 0xe0000000-0xe00fffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 0x00001400-0x000014ff
  IO window: 0x00001800-0x000018ff
  PREFETCH window: 0x88000000-0x8bffffff
  MEM window: 0x8c000000-0x8fffffff
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: 0xe0100000-0xe03fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 7072k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1206184530.572:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:02.0: Boot video device
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
pnp: the driver 'serial' has been registered
isa bounce pool size: 16 pages
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
pnp: the driver 'i8042 kbd' has been registered
i8042 kbd 00:08: driver attached
pnp: the driver 'i8042 aux' has been registered
i8042 aux 00:09: driver attached
PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 376k freed
input: AT Translated Set 2 keyboard as /class/input/input1
ACPI: Transitioning device [C3B1] to D3
ACPI: PNP0C0B:00 is registered as cooling_device0
ACPI: Fan [C3B1] (off)
ACPI: Transitioning device [C3B2] to D3
ACPI: PNP0C0B:01 is registered as cooling_device1
ACPI: Fan [C3B2] (off)
ACPI: Transitioning device [C3C8] to D3
ACPI: PNP0C0B:02 is registered as cooling_device2
ACPI: Fan [C3C8] (off)
ACPI: Transitioning device [C3C9] to D3
ACPI: PNP0C0B:03 is registered as cooling_device3
ACPI: Fan [C3C9] (off)
ACPI: Transitioning device [C3CA] to D3
ACPI: PNP0C0B:04 is registered as cooling_device4
ACPI: Fan [C3CA] (off)
ACPI: Transitioning device [C3CB] to D3
ACPI: PNP0C0B:05 is registered as cooling_device5
ACPI: Fan [C3CB] (off)
ACPI: Transitioning device [C3CC] to D3
ACPI: PNP0C0B:06 is registered as cooling_device6
ACPI: Fan [C3CC] (off)
ACPI: SSDT 7F7DBCCA, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 7F7DBF8C, 05FA (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:00 is registered as cooling_device7
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F7DBC02, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 7F7DBF07, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
Marking TSC unstable due to TSC halts in idle
Time: hpet clocksource has been installed.
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: ACPI0007:01 is registered as cooling_device8
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [TZ6] (25 C)
ACPI: LNXTHERM:02 is registered as thermal_zone1
ACPI: Thermal Zone [TZ0] (44 C)
ACPI: LNXTHERM:03 is registered as thermal_zone2
ACPI: Thermal Zone [TZ1] (46 C)
ACPI: LNXTHERM:04 is registered as thermal_zone3
ACPI: Thermal Zone [TZ3] (35 C)
ACPI: LNXTHERM:05 is registered as thermal_zone4
ACPI: Thermal Zone [TZ4] (26 C)
ACPI: LNXTHERM:06 is registered as thermal_zone5
ACPI: Thermal Zone [TZ5] (0 C)
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00002040
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: UHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc6-amd64 uhci_hcd
usb usb1: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 17, io base 0x00002060
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
Uniform Multi-Platform E-IDE driver
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc6-amd64 uhci_hcd
usb usb2: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00002080
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-rc6-amd64 uhci_hcd
usb usb3: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 22, io base 0x000020a0
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-rc6-amd64 uhci_hcd
usb usb4: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x000020c0
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25-rc6-amd64 uhci_hcd
usb usb5: SerialNumber: 0000:00:1d.2
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0621000
usb 3-2: new full speed USB device using uhci_hcd and address 2
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
Clocksource tsc unstable (delta = -268136546 ns)
usb usb6: New USB device found, idVendor=1d6b, idProduct=0002
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: EHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25-rc6-amd64 ehci_hcd
usb usb6: SerialNumber: 0000:00:1a.7
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0628000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0002
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: EHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.25-rc6-amd64 ehci_hcd
usb usb7: SerialNumber: 0000:00:1d.7
ICH8M: IDE controller (0x8086:0x2850 rev 0x03) at  PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
ICH8M: not 100% native mode: will probe irqs later
ICH8M: IDE port disabled
    ide0: BM-DMA at 0x20e0-0x20e7, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
usb 3-2: device not accepting address 2, error -71
hdb: MATSHITADVD-RAM UJ-842S, ATAPI CD/DVD-ROM drive
hda: TOSHIBA MK8009GAH, ATA DISK drive
hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ACPI: PCI Interrupt 0000:02:06.1[B] -> GSI 19 (level, low) -> IRQ 19
SCSI subsystem initialized
libata version 3.00 loaded.
usb 3-2: new full speed USB device using uhci_hcd and address 4
firewire_ohci: Added fw-ohci device 0000:02:06.1, OHCI version 1.10
hda: max request size: 128KiB
hda: 156301488 sectors (80026 MB), CHS=65535/16/63
hda: cache flushes supported
 hda: hda1 hda2 hda3
hdb: ATAPI 24X DVD-ROM DVD-R-RAM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: New USB device found, idVendor=08ff, idProduct=2580
usb 3-2: New USB device strings: Mfr=0, Product=1, SerialNumber=0
usb 3-2: Product: Fingerprint Sensor
firewire_core: created device fw0: GUID 001b249929010210, S400
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
PM: Starting manual resume from disk
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
agpgart: Detected an Intel 965GM Chipset.
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
ACPI: AC Adapter [C23B] (off-line)
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input3
ACPI: Sleep Button (CM) [C2BF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [C155]
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:19.0 to 64
eth0: (PCI Express:2.5GB/s:Width x1) 00:1e:68:06:12:ee
eth0: Intel(R) PRO/1000 Network Connection
ACPI: Battery Slot [C23D] (battery present)
eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
ACPI: WMI: Mapper loaded
Yenta: CardBus bridge found at 0000:02:06.0 [103c:30c9]
ricoh-mmc: Ricoh MMC Controller disabling driver
ricoh-mmc: Copyright(c) Philip Langdale
Yenta: ISA IRQ mask 0x04b8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge Memory window: 0xe0100000 - 0xe03fffff
input: PC Speaker as /class/input/input5
ricoh-mmc: Ricoh MMC controller found at 0000:02:06.3 [1180:0843] (rev 11)
ricoh-mmc: Controller is now disabled.
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8M-E TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
pnp: the driver 'tpm_inf_pnp' has been registered
tpm_inf_pnp 00:02: Found C284 with ID IFX0102
tpm_inf_pnp 00:02: TPM found: config base 0x560, data base 0x570, chip version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB 9635 TT 1.2)
tpm_inf_pnp 00:02: driver attached
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:02:06.2 [1180:0822] (rev 21)
ACPI: PCI Interrupt 0000:02:06.2[C] -> GSI 20 (level, low) -> IRQ 20
sdhc0:slot0: Will use DMA mode even though HW doesn't fully claim to support it.
mmc0: SDHCI at 0xe0102000 irq 20 DMA
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 1.2.23ks
iwl4965: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:10:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
iwl4965: Tunable channels: 13 802.11bg, 19 802.11a channels
phy0: Selected rate control algorithm 'iwl-4965-rs'
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1b.0 to 64
ACPI: PCI interrupt for device 0000:10:00.0 disabled
input: PS/2 Generic Mouse as /class/input/input6
Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
input: SynPS/2 Synaptics TouchPad as /class/input/input7
EXT3 FS on dm-1, internal journal
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1048568k swap on /dev/mapper/lucky-swap.  Priority:-1 extents:1 across:1048568k
eth0: Link is Up 100 Mbps Full Duplex, Flow Control: RX/TX
eth0: 10/100 speed: disabling TSO
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
pnp: the driver 'parport_pc' has been registered
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
warning: `avahi-daemon' uses 32-bit capabilities (legacy support in use)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.9
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
eth0: no IPv6 routers present
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
hdb: task_no_data_intr: status=0x51 { DriveReady SeekComplete Error }
hdb: task_no_data_intr: error=0x04 { AbortedCommand }
ide: failed opcode was: 0xef
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
[drm] Initialized i915 1.6.0 20060119 on minor 0
eth0: no IPv6 routers present
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000001 00000002
  domain 1: span 00000003
   groups: 00000003
   domain 2: span 00000003
    groups: 00000003
CPU1 attaching sched-domain:
 domain 0: span 00000003
  groups: 00000002 00000001
  domain 1: span 00000003
   groups: 00000003
   domain 2: span 00000003
    groups: 00000003
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PM: Writing back config space on device 0000:10:00.0 at offset 1 (was 100002, writing 100006)
iwl4965: iwlwifi-4965-1.ucode firmware file req failed: Reason -2
iwl4965: Could not read microcode: -2
ACPI: PCI interrupt for device 0000:10:00.0 disabled

--ikeVEW9yuYc//A+q--
