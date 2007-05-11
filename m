Return-Path: <linux-kernel-owner+w=401wt.eu-S1762323AbXEKQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762323AbXEKQWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 12:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759452AbXEKQWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 12:22:09 -0400
Received: from dspnet.fr.eu.org ([213.186.44.138]:1924 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759277AbXEKQWF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 12:22:05 -0400
Date: Fri, 11 May 2007 18:22:01 +0200
From: Olivier Galibert <galibert@pobox.com>
To: "Hack inc." <linux-kernel@vger.kernel.org>
Subject: Does this scsi error storm mean anything to anyone ?
Message-ID: <20070511162201.GA50604@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	"Hack inc." <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I have a 7.5Gb Fibrenetix VP-1252-U4 connected to an IBM x3550 through
an Adaptec ASC-29320ALP U320.  I've been having good luck with these
raids as long as I force the accesses to be in U160 mode.  In U320, DV
fails.

Well, not this time.  When udev starts, all hell breaks loose.

The raid is split in 2T/2T/2T/1.5T.  The "no partition table" is
normal, I haven't written to this raid yet.

Kernel is a fedora 5 one with an unrelated patch to fix an autofs race
condition (hence the 'b').  Anyone recognises anything?

  OG.

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=r

Linux version 2.6.20-1.2307b (root@m77.limsi.fr) (gcc version 4.1.1 20060525 (Red Hat 4.1.1-1)) #1 SMP Mon Apr 2 18:43:02 CEST 2007
Command line: ro root=LABEL=/ rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009a000 (usable)
 BIOS-e820: 000000000009a000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 00000000bffcbac0 (usable)
 BIOS-e820: 00000000bffcbac0 - 00000000bffcee80 (ACPI data)
 BIOS-e820: 00000000bffcee80 - 00000000c0000000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
 BIOS-e820: 0000000100000000 - 0000000240000000 (usable)
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 786379) 1 entries of 3200 used
Entering add_active_range(0, 1048576, 2359296) 2 entries of 3200 used
end_pfn_map = 2359296
DMI 2.4 present.
ACPI: RSDP (v002 IBM                                   ) @ 0x00000000000fdfd0
ACPI: XSDT (v001 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffced80
ACPI: FADT (v002 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffcecc0
ACPI: MADT (v001 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffcec00
ACPI: SRAT (v001 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffceac0
ACPI: HPET (v001 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffcea80
ACPI: MCFG (v001 IBM    SERDEFNT 0x00001000 IBM  0x45444f43) @ 0x00000000bffcea40
ACPI: DSDT (v002 IBM    SERDEFNT 0x00001000 INTL 0x20041203) @ 0x0000000000000000
SRAT: PXM 0 -> APIC 0 -> Node 0
SRAT: PXM 0 -> APIC 1 -> Node 0
SRAT: PXM 0 -> APIC 6 -> Node 0
SRAT: PXM 0 -> APIC 7 -> Node 0
SRAT: Node 0 PXM 0 0-c0000000
Entering add_active_range(0, 0, 154) 0 entries of 3200 used
Entering add_active_range(0, 256, 786379) 1 entries of 3200 used
SRAT: Node 0 PXM 0 0-240000000
Entering add_active_range(0, 0, 154) 2 entries of 3200 used
Entering add_active_range(0, 256, 786379) 2 entries of 3200 used
Entering add_active_range(0, 1048576, 2359296) 2 entries of 3200 used
NUMA: Using 63 for the hash shift.
Bootmem setup node 0 0000000000000000-0000000240000000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  2359296
early_node_map[3] active PFN ranges
    0:        0 ->      154
    0:      256 ->   786379
    0:  1048576 ->  2359296
On node 0 totalpages: 2096997
  DMA zone: 64 pages used for memmap
  DMA zone: 1250 pages reserved
  DMA zone: 2680 pages, LIFO batch:0
  DMA32 zone: 16320 pages used for memmap
  DMA32 zone: 765963 pages, LIFO batch:31
  Normal zone: 20480 pages used for memmap
  Normal zone: 1290240 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x588
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x07] enabled)
Processor #7
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x0e] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 14, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x0d] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 13, address 0xfec80000, GSI 24-47
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009a000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Nosave address range: 00000000bffcb000 - 00000000bffcc000
Nosave address range: 00000000bffcc000 - 00000000bffce000
Nosave address range: 00000000bffce000 - 00000000bffcf000
Nosave address range: 00000000bffcf000 - 00000000c0000000
Nosave address range: 00000000c0000000 - 00000000e0000000
Nosave address range: 00000000e0000000 - 00000000f0000000
Nosave address range: 00000000f0000000 - 00000000fec00000
Nosave address range: 00000000fec00000 - 0000000100000000
Allocating PCI resources starting at c2000000 (gap: c0000000:20000000)
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PERCPU: Allocating 43264 bytes of per cpu data
Built 1 zonelists.  Total pages: 2058883
Kernel command line: ro root=LABEL=/ rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Placing software IO TLB between 0xac99000 - 0xec99000
Memory: 8155544k/9437184k available (2435k kernel code, 232444k reserved, 1145k data, 316k init)
Calibrating delay using timer specific routine.. 3726.70 BogoMIPS (lpj=1863354)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20060707
Using local APIC timer interrupts.
result 16624223
Detected 16.624 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/4 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3723.83 BogoMIPS (lpj=1861917)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 2/4 APIC 0x6
Initializing CPU#2
Calibrating delay using timer specific routine.. 3723.87 BogoMIPS (lpj=1861937)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 2/6 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 0
CPU2: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
SMP alternatives: switching to SMP code
Booting processor 3/4 APIC 0x7
Initializing CPU#3
Calibrating delay using timer specific routine.. 3723.89 BogoMIPS (lpj=1861949)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/7 -> Node 0
CPU: Physical Processor ID: 3
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
Intel(R) Xeon(R) CPU            5120  @ 1.86GHz stepping 06
Brought up 4 CPUs
time.c: Using 14.318180 MHz WALL HPET GTOD HPET/TSC timer.
time.c: Detected 1861.914 MHz processor.
sizeof(vma)=176 bytes
sizeof(page)=64 bytes
sizeof(inode)=720 bytes
sizeof(dentry)=224 bytes
sizeof(ext3inode)=968 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=248 bytes
sizeof(task_struct)=1952 bytes
migration_cost=15,10876
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
0000:00:1f.1: trying to change BAR0 from 01F0 to 01F0
0000:00:1f.1: trying to change BAR1 from 03F4 to 03F4
0000:00:1f.1: trying to change BAR2 from 0170 to 0170
0000:00:1f.1: trying to change BAR3 from 0374 to 0374
Boot video device is 0000:01:01.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4.PCI5.PCI6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI4.PCIA._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIS._PRT]
ACPI: PCI Interrupt Link [LP00] (IRQs *3)
ACPI: PCI Interrupt Link [LP01] (IRQs *10)
ACPI: PCI Interrupt Link [LP02] (IRQs *7)
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP03] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP04] (IRQs) *0, disabled.
ACPI: Blank IRQ resource
ACPI: Resource is not an IRQ entry
ACPI: PCI Interrupt Link [LP05] (IRQs) *0, disabled.
ACPI: PCI Interrupt Link [LP06] (IRQs *11)
ACPI: PCI Interrupt Link [LP07] (IRQs *5)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
PCI-GART: No AMD northbridge found.
pnp: 00:01: ioport range 0x520-0x53f has been reserved
pnp: 00:01: ioport range 0x540-0x547 has been reserved
pnp: 00:09: ioport range 0x400-0x43f has been reserved
PCI: Bridge: 0000:11:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:11:01.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:00.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:10:00.3
  IO window: 5000-5fff
  MEM window: c5000000-c6ffffff
  PREFETCH window: c2000000-c20fffff
PCI: Bridge: 0000:00:02.0
  IO window: 5000-5fff
  MEM window: c5000000-c6ffffff
  PREFETCH window: c2000000-c20fffff
PCI: Bridge: 0000:00:03.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:04.0
  IO window: 6000-ffff
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:05.0
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:03:00.0
  IO window: disabled.
  MEM window: c7000000-caefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:06.0
  IO window: disabled.
  MEM window: c7000000-caefffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:07.0
  IO window: 4000-4fff
  MEM window: cb000000-ccffffff
  PREFETCH window: caf00000-caffffff
PCI: Bridge: 0000:05:00.0
  IO window: disabled.
  MEM window: cd000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: cd000000-cfffffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: 3000-3fff
  MEM window: de000000-dfffffff
  PREFETCH window: d0000000-ddffffff
PCI: Setting latency timer of device 0000:00:02.0 to 64
PCI: Setting latency timer of device 0000:10:00.0 to 64
PCI: Setting latency timer of device 0000:11:00.0 to 64
ACPI: PCI Interrupt 0000:11:01.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:11:01.0 to 64
PCI: Setting latency timer of device 0000:10:00.3 to 64
PCI: Setting latency timer of device 0000:00:03.0 to 64
PCI: Setting latency timer of device 0000:00:04.0 to 64
PCI: Setting latency timer of device 0000:00:05.0 to 64
PCI: Setting latency timer of device 0000:00:06.0 to 64
PCI: Setting latency timer of device 0000:03:00.0 to 64
PCI: Setting latency timer of device 0000:00:07.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
PCI: Setting latency timer of device 0000:05:00.0 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
TCP established hash table entries: 131072 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 1141k freed
audit: initializing netlink socket (disabled)
audit(1178900159.719:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 97D89BC24BCFD501
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:02.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:02.0:pcie00]
Allocate Port Service[0000:00:02.0:pcie01]
PCI: Setting latency timer of device 0000:00:03.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:03.0:pcie00]
Allocate Port Service[0000:00:03.0:pcie01]
PCI: Setting latency timer of device 0000:00:04.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:04.0:pcie00]
Allocate Port Service[0000:00:04.0:pcie01]
PCI: Setting latency timer of device 0000:00:05.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:05.0:pcie00]
Allocate Port Service[0000:00:05.0:pcie01]
PCI: Setting latency timer of device 0000:00:06.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:06.0:pcie00]
Allocate Port Service[0000:00:06.0:pcie01]
PCI: Setting latency timer of device 0000:00:07.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:07.0:pcie00]
Allocate Port Service[0000:00:07.0:pcie01]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:10:00.0 to 64
Allocate Port Service[0000:10:00.0:pcie10]
Allocate Port Service[0000:10:00.0:pcie11]
PCI: Setting latency timer of device 0000:11:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:11:00.0:pcie20]
Allocate Port Service[0000:11:00.0:pcie21]
PCI: Setting latency timer of device 0000:11:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:11:01.0:pcie20]
Allocate Port Service[0000:11:01.0:pcie21]
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:02.0:pcie01 failed with error 2
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:03.0:pcie01 failed with error 1
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:04.0:pcie01 failed with error 2
aer_init: AER service init fails - No ACPI _OSC support
aer: probe of 0000:00:05.0:pcie01 failed with error 1
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:06.0:pcie01 failed with error 2
Evaluate _OSC Set fails. Status = 0x0005
Evaluate _OSC Set fails. Status = 0x0005
aer_init: AER service init fails - Run ACPI _OSC fails
aer: probe of 0000:00:07.0:pcie01 failed with error 2
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: Processor [CPU3] (supports 8 throttling states)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.101 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ESB2: IDE controller at PCI slot 0000:00:1f.1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 23 (level, low) -> IRQ 23
ESB2: chipset revision 9
ESB2: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x0480-0x0487, BIOS settings: hda:DMA, hdb:DMA
Probing IDE interface ide0...
hda: HL-DT-STCD-RW/DVD DRIVE GCC-4244N, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
ide-floppy driver 0.99.newide
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: No PS/2 controller found. Probing ports directly.
i8042.c: Can't read CTR while initializing i8042.
i8042: probe of i8042 failed with error -5
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
 Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
 Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
 Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
speedstep-centrino with X86_SPEEDSTEP_CENTRINO_ACPI config is deprecated.
 Use X86_ACPI_CPUFREQ (acpi-cpufreq) instead.
ACPI: (supports S0 S4 S5)
Freeing unused kernel memory: 316k freed
Write protecting the kernel read-only data: 735k
SCSI subsystem initialized
ACPI: PCI Interrupt 0000:14:01.0[A] -> GSI 24 (level, low) -> IRQ 24
scsi0 : Adaptec AIC79XX PCI-X SCSI HBA DRIVER, Rev 3.0
        <Adaptec 29320ALP PCIx Ultra320 SCSI adapter>
        aic7901: Ultra320 Wide Channel A, SCSI Id=7, PCI-X 101-133Mhz, 512 SCBs

scsi 0:0:0:0: Direct-Access     VP-1252- FB951223-VOL#00  R001 PQ: 0 ANSI: 5
 target0:0:0: asynchronous
scsi0:A:0:0: Tagged Queuing enabled.  Depth 4
 target0:0:0: Beginning Domain Validation
 target0:0:0: wide asynchronous
 target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 127)
 target0:0:0: Ending Domain Validation
SCSI device sda: 3906247680 512-byte hdwr sectors (1999999 MB)
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sda: 3906247680 512-byte hdwr sectors (1999999 MB)
sda: Write Protect is off
sda: Mode Sense: cb 00 00 08
SCSI device sda: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: unknown partition table
sd 0:0:0:0: Attached scsi disk sda
scsi 0:0:0:1: Direct-Access     VP-1252- FB951223-VOL#01  R001 PQ: 0 ANSI: 5
scsi0:A:0:1: Tagged Queuing enabled.  Depth 4
SCSI device sdb: 3906247680 512-byte hdwr sectors (1999999 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdb: 3906247680 512-byte hdwr sectors (1999999 MB)
sdb: Write Protect is off
sdb: Mode Sense: cb 00 00 08
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: unknown partition table
sd 0:0:0:1: Attached scsi disk sdb
scsi 0:0:0:2: Direct-Access     VP-1252- FB951223-VOL#02  R001 PQ: 0 ANSI: 5
scsi0:A:0:2: Tagged Queuing enabled.  Depth 4
SCSI device sdc: 3906247680 512-byte hdwr sectors (1999999 MB)
sdc: Write Protect is off
sdc: Mode Sense: cb 00 00 08
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdc: 3906247680 512-byte hdwr sectors (1999999 MB)
sdc: Write Protect is off
sdc: Mode Sense: cb 00 00 08
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: unknown partition table
sd 0:0:0:2: Attached scsi disk sdc
scsi 0:0:0:3: Direct-Access     VP-1252- FB951223-VOL#03  R001 PQ: 0 ANSI: 5
scsi0:A:0:3: Tagged Queuing enabled.  Depth 4
SCSI device sdd: 2929674240 512-byte hdwr sectors (1499993 MB)
sdd: Write Protect is off
sdd: Mode Sense: cb 00 00 08
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
SCSI device sdd: 2929674240 512-byte hdwr sectors (1499993 MB)
sdd: Write Protect is off
sdd: Mode Sense: cb 00 00 08
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: unknown partition table
sd 0:0:0:3: Attached scsi disk sdd
Adaptec aacraid driver (1.1-5[2423]-mh3)
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:02:00.0 to 64
AAC0: kernel 5.1-0[9257] 
AAC0: monitor 5.1-0[9257]
AAC0: bios 5.1-0[9257]
AAC0: serial 32418003
AAC0: 64bit support enabled.
AAC0: 64 Bit DAC enabled
scsi1 : ServeRAID
scsi 1:0:0:0: Direct-Access     ServeRA  8k-l Mirror      V1.0 PQ: 0 ANSI: 2
SCSI device sde: 143132672 512-byte hdwr sectors (73284 MB)
sde: assuming Write Enabled
sde: assuming drive cache: write through
SCSI device sde: 143132672 512-byte hdwr sectors (73284 MB)
sde: assuming Write Enabled
sde: assuming drive cache: write through
 sde: sde1 sde2 sde3
sd 1:0:0:0: Attached scsi removable disk sde
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1178900181.522:2): selinux=0 auid=4294967295
input: PC Speaker as /class/input/input1
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 20 (level, low) -> IRQ 20
intel_rng: FWH not detected
hda: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
Broadcom NetXtreme II Gigabit Ethernet Driver bnx2 v1.5.5 (February 1, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 18
eth0: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem c8000000, IRQ 18, node addr 001a641045e2
ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
eth1: Broadcom NetXtreme II BCM5708 1000Base-T (B1) PCI-X 64-bit 133MHz found at mem ce000000, IRQ 16, node addr 001a641045e4
libata version 2.00 loaded.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:0:1: Attached scsi generic sg1 type 0
sd 0:0:0:2: Attached scsi generic sg2 type 0
sd 0:0:0:3: Attached scsi generic sg3 type 0
sd 1:0:0:0: Attached scsi generic sg4 type 0
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf9000000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002200
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00002600
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.2: irq 23, io base 0x00002a00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 3-2: new low speed USB device using uhci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
input: Dell Dell USB Keyboard as /class/input/input2
input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:1d.1-2
sd 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x67] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 4 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 165
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 0x1 0x0 )
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x0, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x1, SCB_NEXT == 0x0, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
sd 0:0:0:0: Device is active, asserting ATN
scsi0: Recovery code sleeping
scsi0: Timer Expired (active 1)
Recovery code awake
scsi0: Command abort returning 0x2003
sd 0:0:0:1: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x31 Mode 0x11
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 4 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 165
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 0x1 0x0 )
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x3, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffff
CDB 12 1 0 82 8 1c
STACK: 0x20b 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:1: Cmd aborted from QINFIFO
sd 0:0:0:1: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x22 Mode 0x33
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 3 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 166
QINFIFO: 0x2
WAITING_TID_QUEUES:
       0 ( 0x1 0x0 )
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0xffff, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffff
CDB 12 1 0 82 8 1c
STACK: 0x20d 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:1: Cmd aborted from QINFIFO
sd 0:0:0:3: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20e Mode 0x11
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 3 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 165
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x1 0x0 )
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 3
Kernel Free SCB list: 2 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x3, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffff
CDB 12 1 0 82 8 1c
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:3: Cmd aborted from QINFIFO
sd 0:0:0:3: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 166
QINFIFO: 0x1
WAITING_TID_QUEUES:
       0 ( 0x0 )
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 3
Kernel Free SCB list: 2 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x0, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x1, SCB_NEXT == 0x0, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:3: Cmd aborted from QINFIFO
sd 0:0:0:2: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 2 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 165
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x0 )
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 1 2 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x0, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x1, SCB_NEXT == 0x0, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:2: Cmd aborted from QINFIFO
sd 0:0:0:2: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x33 Mode 0x11
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x0] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 4 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x3 NEXTSCB 0x0
qinstart = 165 qinfifonext = 166
QINFIFO: 0x0
WAITING_TID_QUEUES:
Pending list:
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 2
Kernel Free SCB list: 1 2 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x81f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e967102, SHCNT = 0xfffffc 
HADDR = 0x23e9670fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x3, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x3, SCB_NEXT == 0xff80, SCB_NEXT2 == 0xffff
CDB 12 1 0 82 8 1c
STACK: 0x20c 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:2: Cmd aborted from QINFIFO
sd 0:0:0:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 2)
scsi0: Device reset returning 0x2003
sd 0:0:0:1: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
sd 0:0:0:2: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
sd 0:0:0:3: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
Recovery SCB completes
Recovery SCB completes
Recovery SCB completes
Recovery SCB completes
Recovery SCB completes
sd 0:0:0:3: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x67] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 4 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 173
QINFIFO:
WAITING_TID_QUEUES:
       0 ( 0x2 0x1 )
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x64] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
(scsi0:A:0:3): Device is disconnected, re-queuing SCB
scsi0: Recovery code sleeping
scsi0: Timer Expired (active 1)
Recovery code awake
scsi0: Command abort returning 0x2003
sd 0:0:0:1: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x21 Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x67] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 3 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 174
QINFIFO: 0x7
WAITING_TID_QUEUES:
       0 ( 0x2 0x1 )
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x20d 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
sd 0:0:0:1: Device is active, asserting ATN
scsi0: Recovery code sleeping
scsi0: Timer Expired (active 1)
Recovery code awake
scsi0: Command abort returning 0x2003
sd 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x34 Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 3 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 174
QINFIFO: 0x7
WAITING_TID_QUEUES:
       0 ( 0x2 0x1 )
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x20c 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:0: Cmd aborted from QINFIFO
sd 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 2 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 175
QINFIFO: 0x7 0x2
WAITING_TID_QUEUES:
       0 ( 0x1 )
Pending list:
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 4
Kernel Free SCB list: 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:0: Cmd aborted from QINFIFO
sd 0:0:0:2: Attempting to queue an ABORT message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 2 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 174
QINFIFO: 0x7
WAITING_TID_QUEUES:
       0 ( 0x1 )
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 3
Kernel Free SCB list: 2 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:2: Cmd aborted from QINFIFO
sd 0:0:0:2: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 175
QINFIFO: 0x7 0x1
WAITING_TID_QUEUES:
Pending list:
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 3
Kernel Free SCB list: 2 0 6 5 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:2: Cmd aborted from QINFIFO
sd 0:0:0:0: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
sd 0:0:0:1: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 2)
scsi0: Device reset returning 0x2003
sd 0:0:0:2: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 1)
scsi0: Device reset returning 0x2003
sd 0:0:0:3: Attempting to queue a TARGET RESET message:CDB: 0x12 0x1 0x0 0x0 0xfe 0x0
scsi0: Device reset code sleeping
scsi0: Device reset timer expired (active 2)
scsi0: Device reset returning 0x2003
scsi0: bus reset still active
sd 0:0:0:3: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 179
QINFIFO: 0x7 0x1 0x2 0x0 0x6 0x5
WAITING_TID_QUEUES:
Pending list:
  5 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  6 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 7
Kernel Free SCB list: 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:3: Cmd aborted from QINFIFO
sd 0:0:0:1: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 179
QINFIFO: 0x7 0x1 0x2 0x0 0x6 0x5
WAITING_TID_QUEUES:
Pending list:
  5 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  6 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 7
Kernel Free SCB list: 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:1: Cmd aborted from QINFIFO
sd 0:0:0:0: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 179
QINFIFO: 0x7 0x1 0x2 0x0 0x6 0x5
WAITING_TID_QUEUES:
Pending list:
  5 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  6 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 7
Kernel Free SCB list: 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:0: Cmd aborted from QINFIFO
sd 0:0:0:2: Attempting to queue an ABORT message:CDB: 0x0 0x0 0x0 0x0 0x0 0x0
scsi0: At time of recovery, card was not paused
>>>>>>>>>>>>>>>>>> Dump Card State Begins <<<<<<<<<<<<<<<<<
scsi0: Dumping Card State at program address 0x20c Mode 0x22
Card was paused
INTSTAT[0x0] SELOID[0x0] SELID[0x0] HS_MAILBOX[0x0] 
INTCTL[0x80] SEQINTSTAT[0x0] SAVED_MODE[0x11] DFFSTAT[0x19] 
SCSISIGI[0x77] SCSIPHASE[0x0] SCSIBUS[0x0] LASTPHASE[0x60] 
SCSISEQ0[0x40] SCSISEQ1[0x12] SEQCTL0[0x0] SEQINTCTL[0x0] 
SEQ_FLAGS[0x20] SEQ_FLAGS2[0x4] QFREEZE_COUNT[0x0] 
KERNEL_QFREEZE_COUNT[0x0] MK_MESSAGE_SCB[0xff00] 
MK_MESSAGE_SCSIID[0xff] SSTAT0[0x0] SSTAT1[0x0] 
SSTAT2[0x0] SSTAT3[0x0] PERRDIAG[0xc0] SIMODE1[0xac] 
LQISTAT0[0x0] LQISTAT1[0x0] LQISTAT2[0x0] LQOSTAT0[0x0] 
LQOSTAT1[0x0] LQOSTAT2[0x0] 

SCB Count = 8 CMDS_PENDING = 1 LASTSCB 0xffff CURRSCB 0x2 NEXTSCB 0x0
qinstart = 173 qinfifonext = 179
QINFIFO: 0x7 0x1 0x2 0x0 0x6 0x5
WAITING_TID_QUEUES:
Pending list:
  5 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  6 FIFO_USE[0x0] SCB_CONTROL[0x0] SCB_SCSIID[0x0] 
  0 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  2 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  1 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
  7 FIFO_USE[0x0] SCB_CONTROL[0x74] SCB_SCSIID[0x7] 
  3 FIFO_USE[0x0] SCB_CONTROL[0x60] SCB_SCSIID[0x7] 
Total 7
Kernel Free SCB list: 4 
Sequencer Complete DMA-inprog list: 
Sequencer Complete list: 
Sequencer DMA-Up and Complete list: 
Sequencer On QFreeze and Complete list: 


scsi0: FIFO0 Free, LONGJMP == 0x80ff, SCB 0x0
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x0] DFSTATUS[0x89] 
SG_CACHE_SHADOW[0x2] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x5] SHADDR = 0x00, SHCNT = 0x0 
HADDR = 0x00, HCNT = 0x0 CCSGCTL[0x10] 

scsi0: FIFO1 Active, LONGJMP == 0x80f2, SCB 0x3
SEQIMODE[0x3f] SEQINTSRC[0x0] DFCNTRL[0x28] DFSTATUS[0x88] 
SG_CACHE_SHADOW[0xa] SG_STATE[0x0] DFFSXFRCTL[0x0] 
SOFFCNT[0x0] MDFFSTAT[0x44] SHADDR = 0x23e1a1102, SHCNT = 0xfffffc 
HADDR = 0x23e1a10fe, HCNT = 0x0 CCSGCTL[0x10] 
LQIN: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 
scsi0: LQISTATE = 0x0, LQOSTATE = 0x0, OPTIONMODE = 0x52
scsi0: OS_SPACE_CNT = 0x20 MAXCMDCNT = 0x0
scsi0: SAVED_SCSIID = 0x0 SAVED_LUN = 0x0
SIMODE0[0xc] 
CCSCBCTL[0x4] 
scsi0: REG0 == 0x1, SINDEX = 0x102, DINDEX = 0x102
scsi0: SCBPTR == 0x2, SCB_NEXT == 0x1, SCB_NEXT2 == 0xffff
CDB 12 1 0 0 fe 0
STACK: 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0
<<<<<<<<<<<<<<<<< Dump Card State Ends >>>>>>>>>>>>>>>>>>
scsi0:0:0:2: Cmd aborted from QINFIFO
sd 0:0:0:3: scsi: Device offlined - not ready after error recovery
sd 0:0:0:1: scsi: Device offlined - not ready after error recovery
sd 0:0:0:0: scsi: Device offlined - not ready after error recovery
sd 0:0:0:2: scsi: Device offlined - not ready after error recovery
floppy0: no floppy controllers found
lp: driver loaded but no devices found
input: Power Button (FF) as /class/input/input3
ACPI: Power Button (FF) [PWRF]
No dock devices found.
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sde1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sde3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
bnx2: eth0: using MSI
bnx2: eth0 NIC Link is Up, 1000 Mbps full duplex, receive & transmit flow control ON
audit(1178900370.021:3): audit_pid=3952 old=0 by auid=4294967295
Loading iSCSI transport class v2.0-724.
iscsi: registered transport (tcp)
iscsi: registered transport (iser)
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
eth0: no IPv6 routers present

--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=s

00:00.0 Host bridge: Intel Corporation Workstation Memory Controller Hub (rev 31)
00:02.0 PCI bridge: Intel Corporation Server PCI Express x8 Port 2-3 (rev 31)
00:03.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 3 (rev 31)
00:04.0 PCI bridge: Intel Corporation Server PCI Express x8 Port 4-5 (rev 31)
00:05.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 5 (rev 31)
00:06.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 6 (rev 31)
00:07.0 PCI bridge: Intel Corporation Server PCI Express x4 Port 7 (rev 31)
00:08.0 System peripheral: Intel Corporation Server DMA Controller (rev 31)
00:10.0 Host bridge: Intel Corporation Server Error Reporting Registers (rev 31)
00:10.1 Host bridge: Intel Corporation Server Error Reporting Registers (rev 31)
00:10.2 Host bridge: Intel Corporation Server Error Reporting Registers (rev 31)
00:11.0 Host bridge: Intel Corporation Reserved Registers (rev 31)
00:13.0 Host bridge: Intel Corporation Reserved Registers (rev 31)
00:15.0 Host bridge: Intel Corporation Server FBD Registers (rev 31)
00:16.0 Host bridge: Intel Corporation Server FBD Registers (rev 31)
00:1c.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI Express Root Port 1 (rev 09)
00:1d.0 USB Controller: Intel Corporation Enterprise Southbridge UHCI USB #1 (rev 09)
00:1d.1 USB Controller: Intel Corporation Enterprise Southbridge UHCI USB #2 (rev 09)
00:1d.2 USB Controller: Intel Corporation Enterprise Southbridge UHCI USB #3 (rev 09)
00:1d.7 USB Controller: Intel Corporation Enterprise Southbridge EHCI USB (rev 09)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev d9)
00:1f.0 ISA bridge: Intel Corporation Enterprise Southbridge LPC (rev 09)
00:1f.1 IDE interface: Intel Corporation Enterprise Southbridge PATA (rev 09)
00:1f.3 SMBus: Intel Corporation Enterprise Southbridge SMBus (rev 09)
01:01.0 VGA compatible controller: ATI Technologies Inc ES1000 (rev 02)
02:00.0 RAID bus controller: Adaptec AAC-RAID (Rocket) (rev 02)
03:00.0 PCI bridge: Broadcom Unknown device 0103 (rev c2)
04:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 11)
05:00.0 PCI bridge: Broadcom Unknown device 0103 (rev c2)
06:00.0 Ethernet controller: Broadcom Corporation NetXtreme II BCM5708 Gigabit Ethernet (rev 11)
10:00.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI Express Upstream Port (rev 01)
10:00.3 PCI bridge: Intel Corporation Enterprise Southbridge PCI Express to PCI-X Bridge (rev 01)
11:00.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI Express Downstream Port E1 (rev 01)
11:01.0 PCI bridge: Intel Corporation Enterprise Southbridge PCI Express Downstream Port E2 (rev 01)
14:01.0 SCSI storage controller: Adaptec ASC-29320ALP U320 (rev 10)

--IS0zKkzwUGydFO0o--
