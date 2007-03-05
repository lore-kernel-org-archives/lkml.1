Return-Path: <linux-kernel-owner+w=401wt.eu-S932374AbXCEWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374AbXCEWc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 17:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932330AbXCEWc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 17:32:28 -0500
Received: from mga03.intel.com ([143.182.124.21]:3636 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932127AbXCEWcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 17:32:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,251,1170662400"; 
   d="gz'50?scan'50,208,50"; a="190466021:sNHT73305015"
Message-ID: <45EC9A67.8070204@intel.com>
Date: Mon, 05 Mar 2007 14:32:07 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Mail/News 1.5.0.9 (X11/20061228)
MIME-Version: 1.0
To: linux-ide@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: OOPS with 2.6.21rc2-git (ata: conflict with ide0/1)
Content-Type: multipart/mixed;
 boundary="------------060500010700050808020802"
X-OriginalArrivalTime: 05 Mar 2007 22:32:07.0714 (UTC) FILETIME=[1B990020:01C75F76]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060500010700050808020802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit


Attached dmesg. config.gz. here's the OOPS part.

ata_piix 0000:00:1f.2: version 2.10
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ata: 0x1F0 IDE port busy
ata: conflict with ide0
BUG: at drivers/pci/pci.c:846 pcim_pin_device()
  [<c023838c>] pcim_pin_device+0x4c/0x60
  [<c0371af6>] ata_pci_init_one+0x2d6/0x380
  [<c023b968>] pci_get_device+0x18/0x20
  [<c0378651>] piix_check_450nx_errata+0x31/0x110
  [<c0238b90>] pci_intx+0x20/0x90
  [<c0378a97>] piix_init_one+0x117/0x200
  [<c023afca>] pci_call_probe+0xa/0x10
  [<c023b01e>] __pci_device_probe+0x4e/0x60
  [<c023b056>] pci_device_probe+0x26/0x60
  [<c0295a94>] really_probe+0xb4/0x170
  [<c023afa8>] pci_match_device+0xa8/0xc0
  [<c0295c28>] driver_probe_device+0xc8/0xd0
  [<c0465521>] klist_next+0x61/0xc0
  [<c0295d30>] __driver_attach+0x80/0x90
  [<c0294d0a>] bus_for_each_dev+0x3a/0x60
  [<c0295d56>] driver_attach+0x16/0x20
  [<c0295cb0>] __driver_attach+0x0/0x90
  [<c029532f>] bus_add_driver+0x5f/0x110
  [<c023b3d2>] __pci_register_driver+0x82/0xc0
  [<c05c0b91>] piix_init+0x11/0x20
  [<c059ab11>] do_initcalls+0x41/0x130
  [<c0158acc>] register_irq_proc+0x9c/0xc0
  [<c01b4462>] proc_mkdir_mode+0x42/0x60
  [<c059ac30>] init+0x0/0xa0
  [<c059ac7c>] init+0x4c/0xa0
  [<c0104e7f>] kernel_thread_helper+0x7/0x18
  =======================
ata: 0x170 IDE port busy
ata: conflict with ide1
ata_piix: probe of 0000:00:1f.2 failed with error -16
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
ata1: SATA max UDMA/133 cmd 0x0001d000 ctl 0x0001cc02 bmdma 0x0001c480 irq 19
ata2: SATA max UDMA/133 cmd 0x0001c880 ctl 0x0001c802 bmdma 0x0001c488 irq 19
scsi2 : ata_piix
ATA: abnormal status 0x7F on port 0x0001d007
scsi3 : ata_piix
ATA: abnormal status 0x7F on port 0x0001c887


Cheers,

Auke



--------------060500010700050808020802
Content-Type: application/x-tgz;
 name="config.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.gz"

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
gP4f6dFy7yPfAAA=
--------------060500010700050808020802
Content-Type: text/plain;
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg"

Linux version 2.6.21-rc2-g0a0c153f-dirty (ahkok@ahkok-c2d) (gcc version 3.4.6) #24 SMP PREEMPT Mon Mar 5 22:14:44 UTC 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009fc00 end: 000000000009fc00 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009fc00 size: 0000000000000400 end: 00000000000a0000 type: 2
copy_e820_map() start: 00000000000e0000 size: 0000000000020000 end: 0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000003f530000 end: 000000003f630000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000003f630000 size: 0000000000010000 end: 000000003f640000 type: 3
copy_e820_map() start: 000000003f640000 size: 00000000000c0000 end: 000000003f700000 type: 4
copy_e820_map() start: 000000003f700000 size: 0000000000900000 end: 0000000040000000 type: 2
copy_e820_map() start: 00000000ffb00000 size: 0000000000500000 end: 0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003f630000 (usable)
 BIOS-e820: 000000003f630000 - 000000003f640000 (ACPI data)
 BIOS-e820: 000000003f640000 - 000000003f700000 (ACPI NVS)
 BIOS-e820: 000000003f700000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
118MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 259632) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   259632
early_node_map[1] active PFN ranges
    0:        0 ->   259632
On node 0 totalpages: 259632
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 236 pages used for memmap
  HighMem zone: 30020 pages, LIFO batch:7
DMI 2.3 present.
ACPI: RSDP 000F96A0, 0014 (r0 ACPIAM)
ACPI: RSDT 3F630000, 0038 (r1 A M I  OEMRSDT   7000614 MSFT       97)
ACPI: FACP 3F630200, 0084 (r2 A M I  OEMFACP   7000614 MSFT       97)
ACPI: DSDT 3F630900, 77B3 (r1 VVCBI8 VVCBI850       50 INTL  2002026)
ACPI: FACS 3F640000, 0040
ACPI: APIC 3F630300, 006C (r1 A M I  OEMAPIC   7000614 MSFT       97)
ACPI: MCFG 3F630400, 003C (r1 A M I  OEMMCFG   7000614 MSFT       97)
ACPI: OEMB 3F640040, 00B3 (r1 A M I  OEMBIOS   7000614 MSFT       97)
ACPI: ASF! 3F6380C0, 0099 (r32 INTEL  LAKEPORT        1 INTL  2002026)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bfb00000)
Detected 2394.043 MHz processor.
Built 1 zonelists.  Total pages: 257604
Kernel command line: root=/dev/hdb5 ro
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1023576k/1038528k available (3490k kernel code, 14336k reserved, 1193k data, 312k init, 121024k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc059a000 - 0xc05e8000   ( 312 kB)
      .data : 0xc0468842 - 0xc0592dac   (1193 kB)
      .text : 0xc0100000 - 0xc0468842   (3490 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4789.89 BogoMIPS (lpj=2394948)
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 CPU         E6600  @ 2.40GHz stepping 05
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4787.33 BogoMIPS (lpj=2393665)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000 0000e3bd 00000000 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003940 0000e3bd 00000000 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 CPU         E6600  @ 2.40GHz stepping 05
Total of 2 processors activated (9577.22 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
migration_cost=42
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 3.00 entry at 0xf0031, last bus=10
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI Error (psargs-0355): [\_SB_.PCI0.SBRG.GP6R] Namespace lookup failure, AE_NOT_FOUND
ACPI Error (psparse-0537): Method parse/execution failed [\_SB_.PCI0.IDE1.CHN1._INI] (Node c1905734), AE_NOT_FOUND
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Firmware left 0000:0a:00.0 e100 interrupts enabled, disabling
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEG1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: Power Resource [URP1] (off)
ACPI: Power Resource [FDDP] (off)
ACPI: Power Resource [LPTP] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
SCSI subsystem initialized
libata version 2.20 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:0b: ioport range 0x400-0x47f has been reserved
pnp: 00:0b: ioport range 0x680-0x6ff has been reserved
pnp: 00:0b: ioport range 0x500-0x53f has been reserved
pnp: 00:0b: iomem range 0xfec00000-0xfec00fff has been reserved
pnp: 00:0b: iomem range 0xfee00000-0xfee00fff has been reserved
pnp: 00:0b: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0b: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0c: iomem range 0xfeafc000-0xfeafcfff has been reserved
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:02:00.0
  IO window: 9000-9fff
  MEM window: fdd00000-fdefffff
  PREFETCH window: bf500000-bf5fffff
PCI: Bridge: 0000:02:01.0
  IO window: a000-afff
  MEM window: fdf00000-fe0fffff
  PREFETCH window: bf600000-bf6fffff
PCI: Bridge: 0000:01:00.0
  IO window: 9000-afff
  MEM window: fdd00000-fe1fffff
  PREFETCH window: bf500000-bf7fffff
PCI: Bridge: 0000:00:01.0
  IO window: 9000-afff
  MEM window: fdd00000-fe2fffff
  PREFETCH window: bf500000-bf8fffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: fe700000-fe7fffff
  PREFETCH window: bfd00000-bfdfffff
PCI: Bridge: 0000:00:1c.1
  IO window: disabled.
  MEM window: fe600000-fe6fffff
  PREFETCH window: bfc00000-bfcfffff
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: fe500000-fe5fffff
  PREFETCH window: bfb00000-bfbfffff
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: fe400000-fe4fffff
  PREFETCH window: bfa00000-bfafffff
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: fe300000-fe3fffff
  PREFETCH window: bf900000-bf9fffff
PCI: Bridge: 0000:00:1e.0
  IO window: b000-bfff
  MEM window: fe800000-fe8fffff
  PREFETCH window: bfe00000-bfefffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
PCI: Setting latency timer of device 0000:01:00.0 to 64
PCI: Setting latency timer of device 0000:02:00.0 to 64
PCI: Setting latency timer of device 0000:02:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
Machine check exception polling timer started.
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1173133393.445:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
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
PCI: Setting latency timer of device 0000:00:1c.2 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.2:pcie00]
Allocate Port Service[0000:00:1c.2:pcie02]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
PCI: Setting latency timer of device 0000:01:00.0 to 64
Allocate Port Service[0000:01:00.0:pcie10]
PCI: Setting latency timer of device 0000:02:00.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:00.0:pcie20]
PCI: Setting latency timer of device 0000:02:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:02:01.0:pcie20]
input: Power Button (FF) as /class/input/input0
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input1
ACPI: Sleep Button (CM) [SPBT]
ACPI: Video Device [GRFX] (multi-head: no  rom: yes  post: yes)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device is not present [20070126]
ibm_acpi: ec object not found
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12ac
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ACPI: PCI Interrupt 0000:00:03.3[B] -> GSI 17 (level, low) -> IRQ 17
0000:00:03.3: ttyS1 at I/O 0xe000 (irq = 17) is a 16550A
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
RAMDISK driver initialized: 16 RAM disks of 4096K size 1024 blocksize
Compaq SMART2 Driver (v 2.6.0)
HP CISS Driver (v 3.6.14)
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
Probing IDE interface ide0...
hda: PLEXTOR DVDR PX-755A, ATAPI CD/DVD-ROM drive
hdb: HDT722516DLA380, ATA DISK drive
Probing IDE interface ide1...
hdc: HDT722516DLA380, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hdb: max request size: 512KiB
hdb: 321672960 sectors (164696 MB) w/7674KiB Cache, CHS=20023/255/63
hdb: cache flushes supported
 hdb: hdb1 hdb2 hdb3 < hdb5 hdb6 hdb7 hdb8 hdb9 >
hdc: max request size: 512KiB
hdc: 321672960 sectors (164696 MB) w/7674KiB Cache, CHS=20023/255/63
hdc: cache flushes supported
 hdc: hdc1
hda: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
Adaptec aacraid driver (1.1-5[2423]-mh3)
NCR53c406a: no available ports found
3ware Storage Controller device driver for Linux v1.26.02.002.
3ware 9000 Storage Controller device driver for Linux v2.26.02.008.
ata_piix 0000:00:1f.2: version 2.10
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
ata: 0x1F0 IDE port busy
ata: conflict with ide0
BUG: at drivers/pci/pci.c:846 pcim_pin_device()
 [<c023838c>] pcim_pin_device+0x4c/0x60
 [<c0371af6>] ata_pci_init_one+0x2d6/0x380
 [<c023b968>] pci_get_device+0x18/0x20
 [<c0378651>] piix_check_450nx_errata+0x31/0x110
 [<c0238b90>] pci_intx+0x20/0x90
 [<c0378a97>] piix_init_one+0x117/0x200
 [<c023afca>] pci_call_probe+0xa/0x10
 [<c023b01e>] __pci_device_probe+0x4e/0x60
 [<c023b056>] pci_device_probe+0x26/0x60
 [<c0295a94>] really_probe+0xb4/0x170
 [<c023afa8>] pci_match_device+0xa8/0xc0
 [<c0295c28>] driver_probe_device+0xc8/0xd0
 [<c0465521>] klist_next+0x61/0xc0
 [<c0295d30>] __driver_attach+0x80/0x90
 [<c0294d0a>] bus_for_each_dev+0x3a/0x60
 [<c0295d56>] driver_attach+0x16/0x20
 [<c0295cb0>] __driver_attach+0x0/0x90
 [<c029532f>] bus_add_driver+0x5f/0x110
 [<c023b3d2>] __pci_register_driver+0x82/0xc0
 [<c05c0b91>] piix_init+0x11/0x20
 [<c059ab11>] do_initcalls+0x41/0x130
 [<c0158acc>] register_irq_proc+0x9c/0xc0
 [<c01b4462>] proc_mkdir_mode+0x42/0x60
 [<c059ac30>] init+0x0/0xa0
 [<c059ac7c>] init+0x4c/0xa0
 [<c0104e7f>] kernel_thread_helper+0x7/0x18
 =======================
ata: 0x170 IDE port busy
ata: conflict with ide1
ata_piix: probe of 0000:00:1f.2 failed with error -16
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
ata1: SATA max UDMA/133 cmd 0x0001d000 ctl 0x0001cc02 bmdma 0x0001c480 irq 19
ata2: SATA max UDMA/133 cmd 0x0001c880 ctl 0x0001c802 bmdma 0x0001c488 irq 19
scsi2 : ata_piix
ATA: abnormal status 0x7F on port 0x0001d007
scsi3 : ata_piix
ATA: abnormal status 0x7F on port 0x0001c887
usbmon: debugfs is not available
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f12:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input2
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
TCP cubic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Time: tsc clocksource has been installed.
logips2pp: Detected unknown logitech mouse model 1
input: ImPS/2 Logitech Wheel Mouse as /class/input/input3
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 312k freed
EXT3 FS on hdb5, internal journal
Unable to find swap-space signature
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
ACPI: PCI Interrupt 0000:0a:00.0[A] -> GSI 21 (level, low) -> IRQ 20
e100: eth0: e100_probe: addr 0xfe8ff000, irq 20, MAC addr 00:02:B3:A7:55:E5
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfeafe400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xfeafe000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for AD1988, trying auto-probe from BIOS...
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected an Intel 965G Chipset.
agpgart: Unknown page table size, assuming 512KB
agpgart: Detected 7676K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>

--------------060500010700050808020802--
