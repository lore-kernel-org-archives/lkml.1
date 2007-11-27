Return-Path: <linux-kernel-owner+w=401wt.eu-S1758129AbXK0Svh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758129AbXK0Svh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 13:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758546AbXK0SvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 13:51:11 -0500
Received: from brick.kernel.dk ([87.55.233.238]:17602 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758102AbXK0SvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 13:51:06 -0500
Date: Tue, 27 Nov 2007 19:50:58 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: len.brown@intel.com
Subject: WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Message-ID: <20071127185058.GD5541@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With current -git I get three of these on boot. I'm attaching full boot
messages.

Linux version 2.6.24-rc3 (axboe@carl) (gcc version 4.2.1 (SUSE Linux)) #20 SMP Tue Nov 27 19:43:25 CET 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f000 (usable)
 BIOS-e820: 000000000009f000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f6d0000 (usable)
 BIOS-e820: 000000007f6d0000 - 000000007f6df000 (ACPI data)
 BIOS-e820: 000000007f6df000 - 000000007f700000 (ACPI NVS)
 BIOS-e820: 000000007f700000 - 0000000080000000 (reserved)
 BIOS-e820: 00000000f0000000 - 00000000f4000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff800000 - 0000000100000000 (reserved)
2038MB LOWMEM available.
found SMP MP-table at 000f67f0
Entering add_active_range(0, 0, 521936) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   521936
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   521936
On node 0 totalpages: 521936
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 4045 pages used for memmap
  Normal zone: 513795 pages, LIFO batch:31
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F67C0, 0024 (r2 LENOVO)
ACPI: XSDT 7F6D191C, 0084 (r1 LENOVO TP-7B        2140  LTP        0)
ACPI: FACP 7F6D1A00, 00F4 (r3 LENOVO TP-7B        2140 LNVO        1)
ACPI Warning (tbfadt-0442): Optional field "Gpe1Block" has zero address or length: 000000000000102C/0 [20070126]
ACPI: DSDT 7F6D1D90, CFB9 (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: FACS 7F6F4000, 0040
ACPI: SSDT 7F6D1BB4, 01DC (r1 LENOVO TP-7B        2140 MSFT  100000E)
ACPI: ECDT 7F6DED49, 0052 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: TCPA 7F6DED9B, 0032 (r2 LENOVO TP-7B        2140 LNVO        1)
ACPI: APIC 7F6DEDCD, 0068 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: MCFG 7F6DEE35, 003C (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: HPET 7F6DEE71, 0038 (r1 LENOVO TP-7B        2140 LNVO        1)
ACPI: BOOT 7F6DEFD8, 0028 (r1 LENOVO TP-7B        2140  LTP        1)
ACPI: SSDT 7F6F2645, 025F (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F28A4, 00A6 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F294A, 04F7 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: SSDT 7F6F2E41, 01D8 (r1 LENOVO TP-7B        2140 INTL 20050513)
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:14 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:14 APIC version 20
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:70000000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 517859
Kernel command line: root=/dev/sda2 vga=ext resume=/dev/sda5 acpi_sleep=s3_bios
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=783b4000 soft=783b2000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1828.954 MHz processor.
Console: colour VGA+ 80x50
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 131072 (order: 7, 524288 bytes)
Memory: 2060116k/2087744k available (1839k kernel code, 26932k reserved, 683k data, 208k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfffb4000 - 0xfffff000   ( 300 kB)
    vmalloc : 0xf8000000 - 0xfffb2000   ( 127 MB)
    lowmem  : 0x78000000 - 0xf76d0000   (2038 MB)
      .init : 0x7837b000 - 0x783af000   ( 208 kB)
      .data : 0x782cbf25 - 0x78376b54   ( 683 kB)
      .text : 0x78100000 - 0x782cbf25   (1839 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=11, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet clockevent registered
Calibrating delay using timer specific routine.. 3660.70 BogoMIPS (lpj=1830350)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=783b5000 soft=783b3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3657.53 BogoMIPS (lpj=1828769)
CPU: After generic identify, caps: bfe9fbff 00100000 00000000 00000000 0000c1a9 00000000 00000000 00000000
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfe9fbff 00100000 00000000 00002940 0000c1a9 00000000 00000000 00000000
CPU1: Intel Genuine Intel(R) CPU           T2400  @ 1.83GHz stepping 08
Total of 2 processors activated (7318.23 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]:
Measured 579678 cycles TSC warp between CPUs, turning off TSC clock.
Marking TSC unstable due to: check_tsc_sync_source failed.
Brought up 2 CPUs
net_namespace: 64 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
ACPI: EC: EC description table is found, configuring boot EC
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62
ACPI: EC: driver started in poll mode
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 1000-107f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 1180-11bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.EXP3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 *11)
ACPI: EC: non-query interrupt received, switching to interrupt mode
ACPI: Power Resource [PUBS] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 11 devices
ACPI: ACPI bus type pnp unregistered
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Time: hpet clocksource has been installed.
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0xc0000-0xc3fff could not be reserved
system 00:00: iomem range 0xc4000-0xc7fff could not be reserved
system 00:00: iomem range 0xc8000-0xcbfff has been reserved
system 00:02: iomem range 0xf0000000-0xf3ffffff could not be reserved
system 00:02: iomem range 0xfed1c000-0xfed1ffff could not be reserved
system 00:02: iomem range 0xfed14000-0xfed17fff could not be reserved
system 00:02: iomem range 0xfed18000-0xfed18fff could not be reserved
PCI: Bridge: 0000:00:1c.0
  IO window: 2000-2fff
  MEM window: ee000000-ee0fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 3000-4fff
  MEM window: ec000000-edffffff
  PREFETCH window: e4000000-e40fffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-6fff
  MEM window: e8000000-e9ffffff
  PREFETCH window: e4100000-e41fffff
PCI: Bridge: 0000:00:1c.3
  IO window: 7000-8fff
  MEM window: ea000000-ebffffff
  PREFETCH window: e4200000-e42fffff
PCI: Bus 22, cardbus bridge: 0000:15:00.0
  IO window: 00009000-000090ff
  IO window: 00009400-000094ff
  PREFETCH window: e0000000-e3ffffff
  MEM window: 88000000-8bffffff
PCI: Bridge: 0000:00:1e.0
  IO window: 9000-cfff
  MEM window: e4300000-e7ffffff
  PREFETCH window: e0000000-e3ffffff
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 20 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 22 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 23 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
PCI: Enabling device 0000:00:1e.0 (0005 -> 0007)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
ACPI: PCI Interrupt 0000:15:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:15:00.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 6, 262144 bytes)
TCP established hash table entries: 262144 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
Unpacking initramfs... done
Freeing initrd memory: 5833k freed
Simple Boot Flag at 0x35 set to 0x1
io scheduler noop registered
io scheduler cfq registered (default)
Boot video device is 0000:00:02.0
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.1 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.1:pcie00]
Allocate Port Service[0000:00:1c.1:pcie02]
Allocate Port Service[0000:00:1c.1:pcie03]
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
Allocate Port Service[0000:00:1c.2:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.102
agpgart: Detected an Intel 945GM Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input0
input: PC Speaker as /class/input/input1
IBM TrackPoint firmware: 0x0e, buttons: 3/3
input: TPPS/2 IBM TrackPoint as /class/input/input2
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
NET: Registered protocol family 1
Using IPI No-Shortcut mode
Freeing unused kernel memory: 208k freed
Write protecting the kernel read-only data: 527k
ACPI: SSDT 7F6F1D26, 0240 (r1  PmRef  Cpu0Ist      100 INTL 20050513)
ACPI: SSDT 7F6F1FEB, 065A (r1  PmRef  Cpu0Cst      100 INTL 20050513)
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7F6F1C5E, 00C8 (r1  PmRef  Cpu1Ist      100 INTL 20050513)
ACPI: SSDT 7F6F1F66, 0085 (r1  PmRef  Cpu1Cst      100 INTL 20050513)
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 385, comm: modprobe Not tainted 2.6.24-rc3 #20
 [<7811734e>] native_smp_call_function_mask+0x16e/0x180
 [<781f0ca6>] acpi_ds_delete_walk_state+0xb0/0xca
 [<781188e1>] smp_call_function_single+0x31/0x70
 [<781ddbad>] _rdmsr_on_cpu+0x6d/0x80
 [<781ddbf8>] rdmsr_on_cpu+0x18/0x20
 [<f803646a>] acpi_processor_get_throttling_ptc+0x122/0x1a0 [processor]
 [<f8035b14>] acpi_processor_get_throttling+0x8/0x9 [processor]
 [<f8036157>] acpi_processor_get_throttling_info+0x41c/0x461 [processor]
 [<f80355ad>] acpi_processor_start+0x4fa/0x59d [processor]
 [<782046b3>] acpi_start_single_object+0x1d/0x39
 [<78205849>] acpi_device_probe+0x6e/0x7c
 [<7822e258>] driver_probe_device+0x88/0x190
 [<7822e4ce>] __driver_attach+0x9e/0xa0
 [<7822d64a>] bus_for_each_dev+0x3a/0x60
 [<7822e0d6>] driver_attach+0x16/0x20
 [<7822e430>] __driver_attach+0x0/0xa0
 [<7822da0a>] bus_add_driver+0x8a/0x1e0
 [<f803f084>] acpi_processor_init+0x84/0xf3 [processor]
 [<78140ec7>] blocking_notifier_call_chain+0x17/0x20
 [<7814bd56>] sys_init_module+0x126/0x19b0
 [<78205b15>] acpi_bus_register_driver+0x0/0x38
 [<781052f6>] sysenter_past_esp+0x6b/0xa1
 [<782c0000>] ip_rt_ioctl+0x380/0x390
 =======================
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 385, comm: modprobe Not tainted 2.6.24-rc3 #20
 [<7811734e>] native_smp_call_function_mask+0x16e/0x180
 [<7812e001>] irq_exit+0x51/0x80
 [<78119aa5>] smp_apic_timer_interrupt+0x55/0x80
 [<781188e1>] smp_call_function_single+0x31/0x70
 [<781ddaf5>] _wrmsr_on_cpu+0x65/0x70
 [<781ddb38>] wrmsr_on_cpu+0x18/0x20
 [<f803630a>] acpi_processor_set_throttling_ptc+0x122/0x160 [processor]
 [<f8035b1d>] acpi_processor_set_throttling+0x8/0x9 [processor]
 [<f803616d>] acpi_processor_get_throttling_info+0x432/0x461 [processor]
 [<f80355ad>] acpi_processor_start+0x4fa/0x59d [processor]
 [<782046b3>] acpi_start_single_object+0x1d/0x39
 [<78205849>] acpi_device_probe+0x6e/0x7c
 [<7822e258>] driver_probe_device+0x88/0x190
 [<7822e4ce>] __driver_attach+0x9e/0xa0
 [<7822d64a>] bus_for_each_dev+0x3a/0x60
 [<7822e0d6>] driver_attach+0x16/0x20
 [<7822e430>] __driver_attach+0x0/0xa0
 [<7822da0a>] bus_add_driver+0x8a/0x1e0
 [<f803f084>] acpi_processor_init+0x84/0xf3 [processor]
 [<78140ec7>] blocking_notifier_call_chain+0x17/0x20
 [<7814bd56>] sys_init_module+0x126/0x19b0
 [<78205b15>] acpi_bus_register_driver+0x0/0x38
 [<781052f6>] sysenter_past_esp+0x6b/0xa1
 [<782c0000>] ip_rt_ioctl+0x380/0x390
 =======================
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: Thermal Zone [THM0] (75 C)
ACPI: Thermal Zone [THM1] (74 C)
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 16 (level, low) -> IRQ 20
ahci 0000:00:1f.2: nr_ports (4) and implemented port map (0x1) don't match, using nr_ports
ahci 0000:00:1f.2: forcing PORTS_IMPL to 0xf
Clocksource tsc unstable (delta = -376758155 ns)
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 4 ports 1.5 Gbps 0xf impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
ata1: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444500 irq 219
ata2: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444580 irq 219
ata3: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444600 irq 219
ata4: SATA max UDMA/133 abar m1024@0xee444400 port 0xee444680 irq 219
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7: HTS721010G9SA00, MCZOC10H, max UDMA/100
ata1.00: 195371568 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 0)
ata3: SATA link down (SStatus 0 SControl 0)
ata4: SATA link down (SStatus 0 SControl 0)
scsi 0:0:0:0: Direct-Access     ATA      HTS721010G9SA00  MCZO PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2 sda3 < sda5 sda6 sda7 sda8 >
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.12
ACPI: PCI Interrupt 0000:00:1f.1[C] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi4 : ata_piix
scsi5 : ata_piix
ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0x1810 irq 14
ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0x1818 irq 15
ata6: port disabled. ignoring.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 20, io base 0x00001820
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 21, io base 0x00001840
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 22, io base 0x00001860
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.3 to 64
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 23, io base 0x00001880
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xee444000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ata1: D2H reg with I during NCQ, this message won't be printed again
sd 0:0:0:0: Attached scsi generic sg0 type 0
input: Power Button (FF) as /class/input/input3
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input4
ACPI: Lid Switch [LID]
input: Sleep Button (CM) as /class/input/input5
ACPI: Sleep Button (CM) [SLPB]
ACPI: AC Adapter [AC] (on-line)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 16 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:02:00.0 to 64
e1000: 0000:02:00.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:d3:31:39:4d
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Yenta: CardBus bridge found at 0000:15:00.0 [17aa:201c]
ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 21
hda_intel: probe_mask set to 0x1 for device 17aa:2010
PCI: Setting latency timer of device 0000:00:1b.0 to 64
Yenta: ISA IRQ mask 0x04b8, PCI irq 20
Socket status: 30000006
pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
pcmcia: parent PCI bridge Memory window: 0xe4300000 - 0xe7ffffff
pcmcia: parent PCI bridge Memory window: 0xe0000000 - 0xe3ffffff
Adding 2096472k swap on /dev/sda5.  Priority:-1 extents:1 across:2096472k
loop: module loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
fuse init (API version 7.9)
input: /usr/sbin/acpi-keys as /class/input/input6
WARNING: at arch/x86/kernel/smp_32.c:561 native_smp_call_function_mask()
Pid: 3216, comm: powersaved Not tainted 2.6.24-rc3 #20
 [<7811734e>] native_smp_call_function_mask+0x16e/0x180
 [<781188e1>] smp_call_function_single+0x31/0x70
 [<781ddbad>] _rdmsr_on_cpu+0x6d/0x80
 [<781ddbf8>] rdmsr_on_cpu+0x18/0x20
 [<f803646a>] acpi_processor_get_throttling_ptc+0x122/0x1a0 [processor]
 [<f8035b14>] acpi_processor_get_throttling+0x8/0x9 [processor]
 [<f8035b5d>] acpi_processor_throttling_seq_show+0x29/0x137 [processor]
 [<7816732d>] vma_link+0x5d/0xf0
 [<7819089d>] seq_read+0x9d/0x290
 [<78190800>] seq_read+0x0/0x290
 [<781a781f>] proc_reg_read+0x5f/0x90
 [<781a77c0>] proc_reg_read+0x0/0x90
 [<78177bed>] vfs_read+0x9d/0x140
 [<781780f1>] sys_read+0x41/0x70
 [<781052f6>] sysenter_past_esp+0x6b/0xa1
 =======================

-- 
Jens Axboe

