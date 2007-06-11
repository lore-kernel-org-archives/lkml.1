Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbXFKNHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbXFKNHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636AbXFKNHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:07:19 -0400
Received: from nz-out-0506.google.com ([64.233.162.238]:65011 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbXFKNHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=GkjsNA8w5P15xDtvPY8Rg+oyRnCR2EkllnBOh7vD9b44v/KeaY7g/ese7BYeWYUx2NH6wJr/CqZTjaaqyHqWns3xBURTXaWnBvt8izQFiuRwWutUdWEZP2AFjZLGcqLU1PKkVg2D3nEiMKBnoLGNbKZQPtk84FHhtot08ccEEik=
Message-ID: <19f34abd0706110607u6cf889dci9b8d48494cb40be0@mail.gmail.com>
Date: Mon, 11 Jun 2007 15:07:05 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: IRQ handler type mismatch for IRQ 7
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I receive this on a fresh install of Fedora 7 (x86_64) running
2.6.21-1.3194.fc7, and wonder if it's something to worry about:

IRQ handler type mismatch for IRQ 7
current handler: parport0

Call Trace:
 [<ffffffff802add90>] setup_irq+0x1ba/0x1d5
 [<ffffffff8039a759>] serial8250_interrupt+0x0/0xf4
 [<ffffffff802adf6d>] request_irq+0xd7/0xfd
 [<ffffffff8039a583>] serial8250_startup+0x423/0x56f
 [<ffffffff8024ca8f>] uart_startup+0x76/0x13a
 [<ffffffff8024ccd2>] uart_open+0x17f/0x3ff
 [<ffffffff80380124>] tty_open+0x1a0/0x324
 [<ffffffff80244470>] chrdev_open+0x14d/0x184
 [<ffffffff80244323>] chrdev_open+0x0/0x184
 [<ffffffff8021d207>] __dentry_open+0xd9/0x1aa
 [<ffffffff80225f87>] do_filp_open+0x2a/0x38
 [<ffffffff80233f9e>] __strncpy_from_user+0x28/0x52
 [<ffffffff802182ee>] do_sys_open+0x44/0xc1
 [<ffffffff8025729c>] tracesys+0xdc/0xe1

The machine still runs, though X.org crashes with SIGSEGV. I have a
feeling the two are unrelated. The full dmesg follows.

Kind regards,
Vegard Nossum


Linux version 2.6.21-1.3194.fc7
(kojibuilder@hammer2.fedora.redhat.com) (gcc version 4.1.2 20070502
(Red Hat 4.1.2-12)) #1 SMP Wed May 23 22:47:07 EDT 2007
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007ffd0000 (usable)
 BIOS-e820: 000000007ffd0000 - 000000007ffe5600 (reserved)
 BIOS-e820: 000000007ffe5600 - 000000007fff8000 (ACPI NVS)
 BIOS-e820: 000000007fff8000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fed20000 - 00000000fed9b000 (reserved)
 BIOS-e820: 00000000feda0000 - 00000000fedc0000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffb00000 - 00000000ffc00000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524240) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7850, 0024 (r2 HP    )
ACPI: XSDT 7FFE57C8, 007C (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: FACP 7FFE5684, 00F4 (r4 HP     30AC            3 HP          1)
ACPI: DSDT 7FFE5ACC, 104D3 (r1 HP       nc6400    10000 MSFT  100000E)
ACPI: FACS 7FFF7E80, 0040
ACPI: SLIC 7FFE5844, 0176 (r1 HPQOEM SLIC-MPC        1 HP          1)
ACPI: HPET 7FFE59BC, 0038 (r1 HP     30AC            1 HP          1)
ACPI: APIC 7FFE59F4, 0068 (r1 HP     30AC            1 HP          1)
ACPI: MCFG 7FFE5A5C, 003C (r1 HP     30AC            1 HP          1)
ACPI: TCPA 7FFE5A98, 0032 (r2 HP     30AC            1 HP          1)
ACPI: SSDT 7FFF5F9F, 0059 (r1 HP       HPQNLP        1 MSFT  100000E)
ACPI: SSDT 7FFF5FF8, 032D (r1 HP       HPQSAT        1 MSFT  100000E)
ACPI: SSDT 7FFF6B7A, 025F (r1 HP      Cpu0Tst     3000 INTL 20060317)
ACPI: SSDT 7FFF6DD9, 00A6 (r1 HP      Cpu1Tst     3000 INTL 20060317)
ACPI: SSDT 7FFF6E7F, 04D7 (r1 HP        CpuPm     3000 INTL 20060317)
No NUMA configuration found
Faking a node at 0000000000000000-000000007ffd0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 524240) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007ffd0000
No mptable found.
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
early_node_map[2] active PFN ranges
    0:        0 ->      159
    0:      256 ->   524240
On node 0 totalpages: 524143
  DMA zone: 56 pages used for memmap
  DMA zone: 1277 pages reserved
  DMA zone: 2666 pages, LIFO batch:0
  DMA32 zone: 7111 pages used for memmap
  DMA32 zone: 513033 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
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
Setting APIC routing to physical flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Nosave address range: 000000000009f000 - 00000000000a0000
Nosave address range: 00000000000a0000 - 00000000000e0000
Nosave address range: 00000000000e0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
SMP: Allowing 2 CPUs, 0 hotplug CPUs
PERCPU: Allocating 43648 bytes of per cpu data
Built 1 zonelists.  Total pages: 515699
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
time.c: Detected 1994.999 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2055704k/2096960k available (2319k kernel code, 40868k
reserved, 1375k data, 316k init)
Calibrating delay using timer specific routine.. 3993.39 BogoMIPS (lpj=1996697)
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
CPU0: Thermal monitoring handled by SMI
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 10390604
Detected 10.390 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.01 BogoMIPS (lpj=1995009)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU         T7200  @ 2.00GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=248 bytes
sizeof(task_struct)=1888 bytes
migration_cost=23
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [C003] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1100-113f claimed by ICH6 GPIO
Boot video device is 0000:01:00.0
PCI: Transparent bridge - 0000:00:1e.0
PCI: Bus #03 (-#06) is hidden behind transparent bridge #02 (-#03)
(try 'pci=assign-busses')
Please report the result to linux-kernel to fix this permanently
ACPI: PCI Interrupt Routing Table [\_SB_.C003._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C084._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C099._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C102._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C112._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.C003.C118._PRT]
ACPI: PCI Interrupt Link [C10E] (IRQs *10 11)
ACPI: PCI Interrupt Link [C10F] (IRQs *10 11)
ACPI: PCI Interrupt Link [C110] (IRQs 10 *11)
ACPI: PCI Interrupt Link [C111] (IRQs 10 11) *5
ACPI: PCI Interrupt Link [C124] (IRQs *10 11)
ACPI: PCI Interrupt Link [C125] (IRQs *10 11)
ACPI: PCI Interrupt Link [C126] (IRQs 10 *11)
ACPI Exception (pci_link-0179): AE_NOT_FOUND, Evaluating _PRS [20070126]
ACPI: Power Resource [C1F5] (on)
ACPI: Power Resource [C1FC] (on)
ACPI: Power Resource [C219] (on)
ACPI: Power Resource [C221] (on)
ACPI: Power Resource [C32A] (off)
ACPI: Power Resource [C32B] (off)
ACPI: Power Resource [C32C] (off)
ACPI: Power Resource [C32D] (off)
ACPI: Power Resource [C32E] (off)
ACPI: Power Resource [C32F] (off)
ACPI: Power Resource [C330] (off)
ACPI: Power Resource [C331] (off)
ACPI: Power Resource [C332] (off)
ACPI: Power Resource [C333] (off)
ACPI: Power Resource [C334] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 16 devices
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x7fffffff could not be reserved
pnp: 00:0c: iomem range 0xffb00000-0xffbfffff could not be reserved
pnp: 00:0c: iomem range 0xfff00000-0xffffffff could not be reserved
pnp: 00:0e: ioport range 0x4d0-0x4d1 has been reserved
pnp: 00:0e: ioport range 0x1000-0x107f has been reserved
pnp: 00:0e: ioport range 0x1100-0x113f has been reserved
pnp: 00:0e: ioport range 0x1200-0x121f has been reserved
pnp: 00:0e: iomem range 0xf8000000-0xfbffffff has been reserved
pnp: 00:0e: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:0e: iomem range 0xfed20000-0xfed3ffff could not be reserved
pnp: 00:0e: iomem range 0xfed45000-0xfed8ffff could not be reserved
pnp: 00:0f: iomem range 0xcfc00-0xcffff has been reserved
pnp: 00:0f: iomem range 0xd2800-0xd3fff has been reserved
pnp: 00:0f: iomem range 0xfeda0000-0xfedbffff could not be reserved
pnp: 00:0f: iomem range 0xfee00000-0xfee00fff could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: 4000-4fff
  MEM window: e0600000-e06fffff
  PREFETCH window: d8000000-dbffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: e0100000-e01fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: e0000000-e00fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: 2000-3fff
  MEM window: dc000000-dfffffff
  PREFETCH window: disabled.
PCI: Bus 3, cardbus bridge: 0000:02:06.0
  IO window: 00006000-000060ff
  IO window: 00006400-000064ff
  PREFETCH window: 88000000-8bffffff
  MEM window: 8c000000-8fffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 6000-6fff
  MEM window: e0200000-e05fffff
  PREFETCH window: 88000000-8bffffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
Time: tsc clocksource has been installed.
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:02:06.0[A] -> GSI 18 (level, low) -> IRQ 18
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 3145728 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3739k freed
audit: initializing netlink socket (disabled)
audit(1181563436.699:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key F2580AE679027173
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Transitioning device [C335] to D3
ACPI: Transitioning device [C335] to D3
ACPI: Fan [C335] (off)
ACPI: Transitioning device [C336] to D3
ACPI: Transitioning device [C336] to D3
ACPI: Fan [C336] (off)
ACPI: Transitioning device [C337] to D3
ACPI: Transitioning device [C337] to D3
ACPI: Fan [C337] (off)
ACPI: Transitioning device [C338] to D3
ACPI: Transitioning device [C338] to D3
ACPI: Fan [C338] (off)
ACPI: Transitioning device [C339] to D3
ACPI: Transitioning device [C339] to D3
ACPI: Fan [C339] (off)
ACPI: Transitioning device [C33A] to D3
ACPI: Transitioning device [C33A] to D3
ACPI: Fan [C33A] (off)
ACPI: Transitioning device [C33B] to D3
ACPI: Transitioning device [C33B] to D3
ACPI: Fan [C33B] (off)
ACPI: Transitioning device [C33C] to D3
ACPI: Transitioning device [C33C] to D3
ACPI: Fan [C33C] (off)
ACPI: Transitioning device [C33D] to D3
ACPI: Transitioning device [C33D] to D3
ACPI: Fan [C33D] (off)
ACPI: Transitioning device [C33E] to D3
ACPI: Transitioning device [C33E] to D3
ACPI: Fan [C33E] (off)
ACPI: Transitioning device [C33F] to D3
ACPI: Transitioning device [C33F] to D3
ACPI: Fan [C33F] (off)
ACPI: SSDT 7FFF63ED, 023D (r1 HP      Cpu0Ist     3000 INTL 20060317)
ACPI: SSDT 7FFF66AF, 04CB (r1 HP      Cpu0Cst     3001 INTL 20060317)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
ACPI: CPU0 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7FFF6325, 00C8 (r1 HP      Cpu1Ist     3000 INTL 20060317)
ACPI: SSDT 7FFF662A, 0085 (r1 HP      Cpu1Cst     3000 INTL 20060317)
ACPI: CPU1 (power states: C1[C1] C2[C2])
ACPI: Processor [CPU1] (supports 8 throttling states)
Time: hpet clocksource has been installed.
ACPI: Thermal Zone [TZ0] (38 C)
ACPI: Thermal Zone [TZ1] (42 C)
ACPI: Thermal Zone [TZ2] (41 C)
ACPI: Thermal Zone [TZ3] (32 C)
ACPI: Thermal Zone [TZ4] (32 C)
ACPI: Thermal Zone [TZ5] (75 C)
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Non-volatile memory driver v1.2
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 945GM Chipset.
agpgart: AGP aperture is 256M @ 0x0
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS2 at I/O 0x3e8 (irq = 7) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
Yenta: CardBus bridge found at 0000:02:06.0 [103c:30ac]
Yenta: Enabling burst memory read transactions
Yenta: Using INTVAL to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:02:06.0, mfunc 0x01aa1b22, devctl 0x64
Yenta: ISA IRQ mask 0x0cf8, PCI irq 18
Socket status: 30000006
Yenta: Raising subordinate bus# of parent bus (#02) from #03 to #06
pcmcia: parent PCI bridge I/O window: 0x6000 - 0x6fff
pcmcia: parent PCI bridge Memory window: 0xe0200000 - 0xe05fffff
pcmcia: parent PCI bridge Memory window: 0x88000000 - 0x8bffffff
usbcore: registered new interface driver libusual
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:C216,PNP0f13:C217] at 0x60,0x64 irq 1,12
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
Freeing unused kernel memory: 316k freed
Write protecting the kernel read-only data: 1032k
synaptics reset failed
synaptics reset failed
synaptics reset failed
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00005000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
Synaptics Touchpad, model: 1, fw: 6.2, id: 0x2580b1, caps: 0xa04793/0x300000
serio: Synaptics pass-through port at isa0060/serio4/input0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 22, io base 0x00005020
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
input: SynPS/2 Synaptics TouchPad as /class/input/input1
input: AT Translated Set 2 keyboard as /class/input/input2
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00005040
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 19, io base 0x00005060
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 20, io mem 0xe0704000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
SCSI subsystem initialized
libata version 2.20 loaded.
ahci 0000:00:1f.2: version 2.1
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 21 (level, low) -> IRQ 21
usb 1-1: device not accepting address 2, error -71
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0x1 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq ilck stag pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xffffc20000052100 ctl 0x0000000000000000
bmdma 0x0000000000000000 irq 21
ata2: SATA max UDMA/133 cmd 0xffffc20000052180 ctl 0x0000000000000000
bmdma 0x0000000000000000 irq 21
ata3: SATA max UDMA/133 cmd 0xffffc20000052200 ctl 0x0000000000000000
bmdma 0x0000000000000000 irq 21
ata4: SATA max UDMA/133 cmd 0xffffc20000052280 ctl 0x0000000000000000
bmdma 0x0000000000000000 irq 21
scsi0 : ahci
usb 1-1: new full speed USB device using uhci_hcd and address 4
usb 1-1: configuration #1 chosen from 1 choice
usb 2-1: new full speed USB device using uhci_hcd and address 2
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: FUJITSU MHW2080BH PL, 891F, max UDMA/100
ata1.00: 156301488 sectors, multi 16: LBA48
ata1.00: configured for UDMA/100
scsi1 : ahci
usb 2-1: configuration #1 chosen from 1 choice
ata2: SATA link down (SStatus 0 SControl 0)
scsi2 : ahci
ata3: SATA link down (SStatus 0 SControl 0)
scsi3 : ahci
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2080B 891F PQ: 0 ANSI: 5
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4 < sda5 >
sd 0:0:0:0: Attached scsi disk sda
input: PS/2 Generic Mouse as /class/input/input3
ata_piix 0000:00:1f.1: version 2.10ac1
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1f.1 to 64
ata5: PATA max UDMA/133 cmd 0x00000000000101f0 ctl 0x00000000000103f6
bmdma 0x0000000000015080 irq 14
ata6: PATA max UDMA/133 cmd 0x0000000000010170 ctl 0x0000000000010376
bmdma 0x0000000000015088 irq 15
scsi4 : ata_piix
ata5.00: ATAPI, max MWDMA2
ata5.00: configured for MWDMA2
scsi5 : ata_piix
ata6: port disabled. ignoring.
scsi 4:0:0:0: CD-ROM            MATSHITA DVD-RAM UJ-842S  1.01 PQ: 0 ANSI: 5
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
audit(1181563447.491:2): selinux=0 auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Attached scsi generic sg1 type 5
NET: Registered protocol family 23
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input4
intel_rng: FWH not detected
Floppy drive(s): fd0 is 1.44M
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt 0000:02:06.2[A] -> GSI 18 (level, low) -> IRQ 18
tg3.c:v3.75.1 (May 7, 2007)
ACPI: PCI Interrupt 0000:08:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:08:00.0 to 64
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
iTCO_vendor_support: vendor-support=0
eth0: Tigon3 [partno(BCM95751M) rev 4201 PHY(5750)] (PCI Express)
10/100/1000Base-T Ethernet 00:16:d4:e8:1e:4d
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
sdhci: SDHCI controller found at 0000:02:06.3 [104c:803c] (rev 0)
ACPI: PCI Interrupt 0000:02:06.3[C] -> GSI 22 (level, low) -> IRQ 22
mmc0: SDHCI at 0xe0202000 irq 22 PIO
Bluetooth: HCI USB driver ver 2.9
iwl3945: Intel(R) PRO/Wireless 3945ABG/BG Network Connection driver
for Linux, 0.0.21kd
iwl3945: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:10:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:10:00.0 to 64
iwl3945: Detected Intel PRO/Wireless 3945ABG Network Connection
tpm_inf_pnp 00:04: Found C1FE with ID IFX0102
tpm_inf_pnp 00:04: TPM found: config base 0x560, io base 0x570, chip
version 0x000b, vendor id 0x15d1 (Infineon), product id 0x000b (SLB
9635 TT 1.2)
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.01 (21-Jan-2007)
iTCO_wdt: Found a ICH7-M TCO device (Version=2, TCOBASE=0x1060)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
usbcore: registered new interface driver hci_usb
iwl3945: Channel 14 [2.4GHz] is Tx only -- skipping.
iwl3945: Channel 183 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 184 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 185 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 187 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 188 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 189 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 192 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 196 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 7 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 8 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 11 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 12 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 16 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 145 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 149 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 153 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 157 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 161 [5.2GHz] is Tx only -- skipping.
iwl3945: Channel 165 [5.2GHz] is Tx only -- skipping.
iwl3945: Tunable channels: 13 802.11bg, 23 802.11a channels
wmaster0: Selected rate control algorithm 'simple'
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1b.0 to 64
floppy0: no floppy controllers found
loop: loaded (max 8 devices)
Floppy drive(s): fd0 is 1.44M
floppy0: no floppy controllers found
lp0: using parport0 (interrupt-driven).
lp0: console ready
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
Mobile IPv6
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ACPI: AC Adapter [C1B8] (on-line)
ACPI: Battery Slot [C1BA] (battery present)
ACPI: Battery Slot [C1B9] (battery absent)
No dock devices found.
input: Power Button (FF) as /class/input/input5
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [C242]
input: Lid Switch as /class/input/input7
ACPI: Lid Switch [C23A]
ibm_acpi: ec object not found
ACPI: Video Device [C12F] (multi-head: yes  rom: no  post: no)
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 2031608k swap on /dev/VolGroup00/LogVol01.  Priority:-1
extents:1 across:2031608k
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
ip6_tables: (C) 2000-2006 Netfilter Core Team
ip_tables: (C) 2000-2006 Netfilter Core Team
Netfilter messages via NETLINK v0.30.
nf_conntrack version 0.5.0 (8192 buckets, 65536 max)
ADDRCONF(NETDEV_UP): eth0: link is not ready
ADDRCONF(NETDEV_UP): wlan0: link is not ready
usb 5-6: new high speed USB device using ehci_hcd and address 4
usb 5-6: configuration #1 chosen from 1 choice
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 4
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     SanDisk  U3 Cruzer Micro  2.18 PQ: 0 ANSI: 2
SCSI device sdb: 2006673 512-byte hdwr sectors (1027 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
SCSI device sdb: 2006673 512-byte hdwr sectors (1027 MB)
sdb: Write Protect is off
sdb: Mode Sense: 03 00 00 00
sdb: assuming drive cache: write through
 sdb: sdb1
sd 6:0:0:0: Attached scsi removable disk sdb
sd 6:0:0:0: Attached scsi generic sg2 type 0
audit(1181563534.200:3): audit_pid=2562 old=0 by auid=4294967295
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
IRQ handler type mismatch for IRQ 7
current handler: parport0

Call Trace:
 [<ffffffff802add90>] setup_irq+0x1ba/0x1d5
 [<ffffffff8039a759>] serial8250_interrupt+0x0/0xf4
 [<ffffffff802adf6d>] request_irq+0xd7/0xfd
 [<ffffffff8039a583>] serial8250_startup+0x423/0x56f
 [<ffffffff8024ca8f>] uart_startup+0x76/0x13a
 [<ffffffff8024ccd2>] uart_open+0x17f/0x3ff
 [<ffffffff80380124>] tty_open+0x1a0/0x324
 [<ffffffff80244470>] chrdev_open+0x14d/0x184
 [<ffffffff80244323>] chrdev_open+0x0/0x184
 [<ffffffff8021d207>] __dentry_open+0xd9/0x1aa
 [<ffffffff80225f87>] do_filp_open+0x2a/0x38
 [<ffffffff80233f9e>] __strncpy_from_user+0x28/0x52
 [<ffffffff802182ee>] do_sys_open+0x44/0xc1
 [<ffffffff8025729c>] tracesys+0xdc/0xe1
