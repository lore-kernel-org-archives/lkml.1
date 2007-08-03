Return-Path: <linux-kernel-owner+w=401wt.eu-S1763741AbXHCUrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763741AbXHCUrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 16:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760960AbXHCUrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 16:47:15 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:47186 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbXHCUrM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 16:47:12 -0400
Date: Fri, 3 Aug 2007 23:47:09 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: spurious NCQ completions from FUJITSU MHW2120BH
Message-ID: <Pine.SOC.4.64.0708032310420.16401@math.ut.ee>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-559023410-851401618-1186173343=:16720"
Content-ID: <Pine.SOC.4.64.0708032345010.16829@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---559023410-851401618-1186173343=:16720
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.SOC.4.64.0708032345011.16829@math.ut.ee>

Todays git gave me some EH errors during fsck (30 times mounted and time 
to check), then recovered and works fine. Seems to be spurious NCQ 
completion. The disk is

Device Model:     FUJITSU MHW2120BH
Firmware Version: 00000012
User Capacity:    120 034 123 776 bytes

Tried Debian 2.6.22-1-686 and yes, I can trigger the spurious NCQ there 
too during fsck. So does this fujitsu disk have buggy NCQ?

Linux version 2.6.23-rc1 (mroos@santarosa) (gcc version 4.1.3 20070718 (prerelease) (Debian 4.1.2-14)) #1 SMP PREEMPT Thu Aug 2 19:31:18 EEST 2007
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000dc000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003fed0000 (usable)
 BIOS-e820: 000000003fed0000 - 000000003fee3000 (ACPI NVS)
 BIOS-e820: 000000003fee3000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000fec00000 - 00000000fec10000 (reserved)
 BIOS-e820: 00000000fed00000 - 00000000fed00400 (reserved)
 BIOS-e820: 00000000fed14000 - 00000000fed1a000 (reserved)
 BIOS-e820: 00000000fed1c000 - 00000000fed90000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff000000 - 0000000100000000 (reserved)
126MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f7c80
Entering add_active_range(0, 0, 261840) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   261840
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   261840
On node 0 totalpages: 261840
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 253 pages used for memmap
  HighMem zone: 32211 pages, LIFO batch:7
  Movable zone: 0 pages used for memmap
DMI present.
ACPI: RSDP 000F7C00, 0024 (r2 Compal)
ACPI: XSDT 3FED88D3, 008C (r1 Compal CRESTLNE  6040000  LTP        0)
ACPI: FACP 3FEDFBD2, 00F4 (r3 INTEL  CRESTLNE  6040000 ALAN        1)
ACPI: DSDT 3FED9C80, 5EDE (r2 Compal CRESTLNE  6040000 INTL 20061109)
ACPI: FACS 3FEE2FC0, 0040
ACPI: APIC 3FEDFCC6, 0068 (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: HPET 3FEDFD2E, 0038 (r1 Compal CRESTLNE  6040000 LOHR       5A)
ACPI: MCFG 3FEDFD66, 003C (r1 INTEL  CRESTLNE  6040000 LOHR       5A)
ACPI: TCPA 3FEDFDA2, 0032 (r1 Intel  CRESTLNE  6040000 LOHR       5A)
ACPI: TMOR 3FEDFDD4, 0026 (r1 PTLTD            6040000 PTL         3)
ACPI: SLIC 3FEDFDFA, 0176 (r1 Compal CRESTLNE  6040000 TBD         1)
ACPI: APIC 3FEDFF70, 0068 (r1 PTLTD  	 APIC    6040000  LTP        0)
ACPI: BOOT 3FEDFFD8, 0028 (r1 PTLTD  $SBFTBL$  6040000  LTP        1)
ACPI: SSDT 3FED99BB, 02C5 (r1 SataRe SataAhci     1000 INTL 20050624)
ACPI: SSDT 3FED8EEB, 025F (r1  PmRef  Cpu0Tst     3000 INTL 20050624)
ACPI: SSDT 3FED8E45, 00A6 (r1  PmRef  Cpu1Tst     3000 INTL 20050624)
ACPI: SSDT 3FED895F, 04E6 (r1  PmRef    CpuPm     3000 INTL 20050624)
ACPI: BIOS bug: multiple APIC/MADT found, using 0
ACPI: If "acpi_apic_instance=2" works better, notify linux-acpi@vger.kernel.org
ACPI: PM-Timer IO Port: 0x1008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 6:15 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 6:15 APIC version 20
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
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000dc000
swsusp: Registered nosave memory region: 00000000000dc000 - 0000000000100000
Built 1 zonelists in Zone order.  Total pages: 259795
Kernel command line: root=/dev/sda1 ro resume=/dev/sda2
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c03df000 soft=c03d7000
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 1995.062 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1027676k/1047360k available (1978k kernel code, 18912k reserved, 664k data, 236k init, 129856k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4d000 - 0xfffff000   ( 712 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0399000 - 0xc03d4000   ( 236 kB)
      .data : 0xc02ee8ee - 0xc0394984   ( 664 kB)
      .text : 0xc0100000 - 0xc02ee8ee   (1978 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
SLUB: Genslabs=22, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
hpet0: 3 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 3994.26 BogoMIPS (lpj=7988532)
Security Framework v1.0.0 initialized
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000e3bd 00000000 00000001 00000001
monitor/mwait feature present.
using mwait in idle threads.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU: After all inits, caps: bfebfbff 20000000 00000000 00003940 0000e3bd 00000000 00000001 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
SMP alternatives: switching to SMP code
Booting processor 1/1 eip 3000
CPU 1 irqstacks, hard=c03e0000 soft=c03d8000
Initializing CPU#1
Calibrating delay using timer specific routine.. 3990.22 BogoMIPS (lpj=7980441)
CPU: After generic identify, caps: bfebfbff 20000000 00000000 00000000 0000e3bd 00000000 00000001 00000001
monitor/mwait feature present.
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU: After all inits, caps: bfebfbff 20000000 00000000 00003940 0000e3bd 00000000 00000001 00000001
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel(R) Core(TM)2 Duo CPU     T7300  @ 2.00GHz stepping 0a
Total of 2 processors activated (7984.48 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: BIOS Bug: MCFG area at e0000000 is not E820-reserved
PCI: Not using MMCONFIG.
PCI: PCI BIOS revision 2.10 entry at 0xfddef, last bus=14
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: System BIOS is requesting _OSI(Linux)
ACPI: If "acpi_osi=Linux" works better,
Please send dmidecode to linux-acpi@vger.kernel.org
ACPI: Interpreter enabled
ACPI: (supports S0 S3)
ACPI: Using IOAPIC for interrupt routing
ACPI: EC: GPE = 0x1c, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEGP._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP03._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP04._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP05._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 *7 10 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *11
ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xfed1c000-0xfed1ffff could not be reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff could not be reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff could not be reserved
pnp: 00:01: iomem range 0xfed19000-0xfed19fff could not be reserved
pnp: 00:04: iomem range 0xfed00000-0xfed003ff could not be reserved
PCI: Failed to allocate mem resource #6:20000@e0000000 for 0000:01:00.0
PCI: Bridge: 0000:00:01.0
  IO window: 2000-2fff
  MEM window: b4000000-b6ffffff
  PREFETCH window: d0000000-dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: 3000-3fff
  MEM window: ac000000-afffffff
  PREFETCH window: c8000000-cbffffff
PCI: Bridge: 0000:00:1c.1
  IO window: 4000-4fff
  MEM window: f4000000-f7ffffff
  PREFETCH window: f0000000-f3ffffff
PCI: Bridge: 0000:00:1c.2
  IO window: 5000-5fff
  MEM window: a4000000-a7ffffff
  PREFETCH window: c0000000-c3ffffff
PCI: Bridge: 0000:00:1c.3
  IO window: 6000-6fff
  MEM window: 9c000000-9fffffff
  PREFETCH window: b8000000-bbffffff
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.5
  IO window: disabled.
  MEM window: f8000000-f80fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: f8100000-f81fffff
  PREFETCH window: disabled.
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
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
ACPI: PCI Interrupt 0000:00:1c.5[B] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.5 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 7, 786432 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs...<6>Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
 it is
Freeing initrd memory: 6380k freed
Simple Boot Flag at 0x38 set to 0x1
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie02]
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
PCI: Setting latency timer of device 0000:00:1c.5 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.5:pcie00]
Allocate Port Service[0000:00:1c.5:pcie02]
hpet_resources: 0xfed00000 is busy
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 236k freed
Write protecting the kernel read-only data: 486k
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: SSDT 3FED9679, 027A (r1  PmRef  Cpu0Ist     3000 INTL 20050624)
ACPI: SSDT 3FED914A, 04AA (r1  PmRef  Cpu0Cst     3001 INTL 20050624)
Monitor-Mwait will be used to enter C-1 state
Monitor-Mwait will be used to enter C-2 state
Monitor-Mwait will be used to enter C-3 state
ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 3FED98F3, 00C8 (r1  PmRef  Cpu1Ist     3000 INTL 20050624)
ACPI: SSDT 3FED95F4, 0085 (r1  PmRef  Cpu1Cst     3000 INTL 20050624)
ACPI: CPU1 (power states: C1[C1] C2[C2] C3[C3])
ACPI: Processor [CPU1] (supports 8 throttling states)
Marking TSC unstable due to: possible TSC halt in C2.
Time: hpet clocksource has been installed.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
libata version 2.21 loaded.
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf8404800
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.0: irq 16, io base 0x00001800
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.1: irq 20, io base 0x00001820
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 21, io base 0x00001840
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-2: new high speed USB device using ehci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00001860
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
Clocksource tsc unstable (delta = -374106127 ns)
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001880
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
tg3.c:v3.79 (July 18, 2007)
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:04:00.0 to 64
usb 1-2: configuration #1 chosen from 1 choice
usb 3-2: new full speed USB device using uhci_hcd and address 2
usb 3-2: configuration #1 chosen from 1 choice
eth0: Tigon3 [partno(none) rev b002 PHY(5787)] (PCI Express) 10/100/1000Base-T Ethernet 00:16:d4:d7:b5:0e
eth0: RXcsums[1] LinkChgREG[0] MIirq[0] ASF[0] WireSpeed[1] TSOcap[1]
eth0: dma_rwctrl[76180000] dma_mask[64-bit]
ahci 0000:00:1f.2: version 2.3
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
net eth1: device_rename: sysfs_create_symlink failed (-17)
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 3 ports 3 Gbps 0x7 impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
ata1: SATA max UDMA/133 cmd 0xf8852100 ctl 0x00000000 bmdma 0x00000000 irq 216
ata2: SATA max UDMA/133 cmd 0xf8852180 ctl 0x00000000 bmdma 0x00000000 irq 216
ata3: SATA max UDMA/133 cmd 0xf8852200 ctl 0x00000000 bmdma 0x00000000 irq 216
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-8: FUJITSU MHW2120BH, 00000012, max UDMA/100
ata1.00: 234441648 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      FUJITSU MHW2120B 0000 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:0e:06.0[A] -> GSI 22 (level, low) -> IRQ 22
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda:<6>ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 21, io mem 0xf8404c00
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[22]  MMIO=[f8100000-f81007ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
 sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.1: version 2.11
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.1 to 64
scsi3 : ata_piix
scsi4 : ata_piix
ata4: PATA max UDMA/100 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x000118a0 irq 14
ata5: PATA max UDMA/100 cmd 0x00010170 ctl 0x00010376 bmdma 0x000118a8 irq 15
ata4.00: ATAPI: TSSTcorpCD/DVDW SN-S082D, SS03, max UDMA/33
ata4.00: configured for UDMA/33
scsi 3:0:0:0: CD-ROM            TSSTcorp CD/DVDW SN-S082D SS03 PQ: 0 ANSI: 5
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 3:0:0:0: Attached scsi CD-ROM sr0
sd 0:0:0:0: Attached scsi generic sg0 type 0
sr 3:0:0:0: Attached scsi generic sg1 type 5
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023f74bf40005f]
Attempting manual resume
swsusp: Marking nosave pages: 000000000009f000 - 0000000000100000
swsusp: Basic memory bitmaps created
swsusp: Basic memory bitmaps freed
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Real Time Clock Driver v1.12ac
Linux agpgart interface v0.102
input: Power Button (FF) as /class/input/input1
ACPI: Power Button (FF) [PWRF]
input: Lid Switch as /class/input/input2
ACPI: Lid Switch [LID0]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
ACPI: Battery Slot [BAT1] (battery present)
iwl4965: Intel(R) Wireless WiFi Link 4965AGN driver for Linux, 0.1.5k
iwl4965: Copyright(c) 2003-2007 Intel Corporation
ACPI: PCI Interrupt 0000:0c:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:0c:00.0 to 64
iwl4965: Detected Intel Wireless WiFi Link 4965AGN
set_level status: 0
ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
set_level status: 0
ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
ACPI: AC Adapter [ACAD] (on-line)
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 19 (level, low) -> IRQ 19
sdhci: Secure Digital Host Controller Interface driver
sdhci: Copyright(c) Pierre Ossman
sdhci: SDHCI controller found at 0000:0e:06.1 [1180:0822] (rev 22)
ACPI: PCI Interrupt 0000:0e:06.1[B] -> GSI 23 (level, low) -> IRQ 21
mmc0: SDHCI at 0xf8100800 irq 21 DMA
Linux video capture interface: v2.00
iwl4965: Radio disabled by HW RF Kill switch
uvcvideo: Found UVC 1.00 device USB 2.0 Camera (04f2:b018)
usbcore: registered new interface driver uvcvideo
USB Video Class driver (v0.1.0-c)
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 20 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC268, trying auto-probe from BIOS...
input: ImPS/2 Logitech Wheel Mouse as /class/input/input4
Adding 3903784k swap on /dev/sda2.  Priority:-1 extents:1 across:3903784k
EXT3 FS on sda1, internal journal
loop: module loaded
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
ata1.00: exception Emask 0x2 SAct 0x33 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x33 FIS=004040a1:00000008
ata1.00: cmd 60/01:00:b6:4e:03/00:00:04:00:00/40 tag 0 cdb 0x0 data 512 in
         res 40/00:08:b7:4e:03/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/80:08:b7:4e:03/00:00:04:00:00/40 tag 1 cdb 0x0 data 65536 in
         res 40/00:08:b7:4e:03/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:20:37:4e:03/00:00:04:00:00/40 tag 4 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:03/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:28:37:4f:03/00:00:04:00:00/40 tag 5 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:03/00:00:04:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x2 SAct 0x33 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x33 FIS=004040a1:00000008
ata1.00: cmd 60/01:00:b6:4e:5f/00:00:06:00:00/40 tag 0 cdb 0x0 data 512 in
         res 40/00:08:b7:4e:5f/00:00:06:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/80:08:b7:4e:5f/00:00:06:00:00/40 tag 1 cdb 0x0 data 65536 in
         res 40/00:08:b7:4e:5f/00:00:06:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:20:37:4e:5f/00:00:06:00:00/40 tag 4 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:5f/00:00:06:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:28:37:4f:5f/00:00:06:00:00/40 tag 5 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:5f/00:00:06:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
ata1.00: exception Emask 0x2 SAct 0x33 SErr 0x0 action 0x2 frozen
ata1.00: spurious completions during NCQ issue=0x0 SAct=0x33 FIS=004040a1:00000008
ata1.00: cmd 60/01:00:b6:4e:7f/00:00:07:00:00/40 tag 0 cdb 0x0 data 512 in
         res 40/00:08:b7:4e:7f/00:00:07:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/80:08:b7:4e:7f/00:00:07:00:00/40 tag 1 cdb 0x0 data 65536 in
         res 40/00:08:b7:4e:7f/00:00:07:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:20:37:4e:7f/00:00:07:00:00/40 tag 4 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:7f/00:00:07:00:00/40 Emask 0x2 (HSM violation)
ata1.00: cmd 60/7f:28:37:4f:7f/00:00:07:00:00/40 tag 5 cdb 0x0 data 65024 in
         res 40/00:08:b7:4e:7f/00:00:07:00:00/40 Emask 0x2 (HSM violation)
ata1: soft resetting port
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: configured for UDMA/100
ata1: EH complete
sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
kjournald starting.  Commit interval 30 seconds
EXT3 FS on sda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ADDRCONF(NETDEV_UP): eth1: link is not ready
tg3: eth1: Link is up at 100 Mbps, full duplex.
tg3: eth1: Flow control is off for TX and off for RX.
ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
IA-32 Microcode Update Driver: v1.14a <tigran@aivazian.fsnet.co.uk>
lp: driver loaded but no devices found
ppdev: user-space parallel port driver
Bluetooth: Core ver 2.11
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.8
Bluetooth: L2CAP socket layer initialized
eth1: no IPv6 routers present
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM ver 1.8
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
eth1: no IPv6 routers present

-- 
Meelis Roos (mroos@linux.ee)
---559023410-851401618-1186173343=:16720--
