Return-Path: <linux-kernel-owner+w=401wt.eu-S932468AbYBTUe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932468AbYBTUe2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933079AbYBTUds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:33:48 -0500
Received: from mail1.ugh.no ([80.239.42.168]:37875 "EHLO mail1.ugh.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934028AbYBTUdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:33:39 -0500
Message-ID: <47BC8E9D.8080309@tomt.net>
Date: Wed, 20 Feb 2008 21:33:33 +0100
From: Andre Tomt <andre@tomt.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: USB OOPS 2.6.25-rc2-git1
References: <47BAF36C.4000509@tomt.net> <200802191049.25869.david-b@pacbell.net> <47BB6083.2050000@tomt.net> <200802191632.35732.david-b@pacbell.net>
In-Reply-To: <200802191632.35732.david-b@pacbell.net>
Content-Type: multipart/mixed;
 boundary="------------040905000300080708080000"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040905000300080708080000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

David Brownell wrote:
> On Tuesday 19 February 2008, Andre Tomt wrote:
>>> Can you try this diagnostic patch, to see if it reports any messages
>>> about IAA and/or IAAD oddities?  There's surely a quick workaround
>>> for this, but I'd rather understand the root cause before patching.
>> Doesn't seem to have triggered anything. dmesg attached in case I missed 
>> anything.
> 
> You don't seem to have enabled CONFIG_USB_DEBUG, as the patch instructions
> say is needed to get such diagnostics ... I can tell because the startup
> messages from USB are pretty minimal.  (See appended, vs what you sent...)
> 
> Please try again with USB debugging enabled.

Argh, silly me. Here you go (attached). It has not crashed yet with the 
patch though.

--------------040905000300080708080000
Content-Type: text/plain;
 name="dmesg.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.txt"

Initializing cgroup subsys cpuset
Linux version 2.6.25-rc2-git1 (atomt@pelle) (gcc version 4.2.3 (Debian 4.2.3-1)) #5 SMP Wed Feb 20 09:40:27 CET 2008
Command line: root=/dev/sda1 ro rootflags=noatime rootfstype=ext2 console=ttyS0,38400 verbose 
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009bc00 (usable)
 BIOS-e820: 000000000009bc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
 BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
 BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
 BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524000) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000F7850, 0014 (r0 IntelR)
ACPI: RSDT 7FEE3040, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FEE30C0, 0074 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FEE3180, 463D (r1 INTELR AWRDACPI     1000 MSFT  3000000)
ACPI: FACS 7FEE0000, 0040
ACPI: HPET 7FEE7900, 0038 (r1 IntelR AWRDACPI 42302E31 AWRD       98)
ACPI: MCFG 7FEE7980, 003C (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FEE7800, 0084 (r1 IntelR AWRDACPI 42302E31 AWRD        0)
ACPI: SSDT 7FEE8020, 02F1 (r1  PmRef    CpuPm     3000 INTL 20040311)
No NUMA configuration found
Faking a node at 0000000000000000-000000007fee0000
Entering add_active_range(0, 0, 155) 0 entries of 3200 used
Entering add_active_range(0, 256, 524000) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007fee0000
  NODE_DATA [000000000000c000 - 0000000000012fff]
  bootmap [0000000000013000 -  0000000000022fdf] pages 10
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-565977] TEXT DATA BSS
early res: 3 [37a43000-37fef4eb] RAMDISK
early res: 4 [9bc00-abbff] EBDA
early res: 5 [8000-bfff] PGTABLE
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
    0:        0 ->      155
    0:      256 ->   524000
On node 0 totalpages: 523899
  DMA zone: 56 pages used for memmap
  DMA zone: 894 pages reserved
  DMA zone: 3045 pages, LIFO batch:0
  DMA32 zone: 7108 pages used for memmap
  DMA32 zone: 512796 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: IOAPIC (id[0x04] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 4, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 34472 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515841
Policy zone: DMA32
Kernel command line: root=/dev/sda1 ro rootflags=noatime rootfstype=ext2 console=ttyS0,38400 verbose 
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC calibrated against PM_TIMER
time.c: Detected 1861.998 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2057256k/2096000k available (1802k kernel code, 38340k reserved, 791k data, 328k init)
CPA: page pool initialized 32 of 32 pages preallocated
hpet clockevent registered
Calibrating delay using timer specific routine.. 3726.32 BogoMIPS (lpj=18631646)
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
checking if image is initramfs... it is
Freeing initrd memory: 5809k freed
ACPI: Core revision 20070126
ACPI: Checking initramfs for custom DSDT
Using local APIC timer interrupts.
APIC timer calibration result 16624978
Detected 16.624 MHz APIC timer.
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 3724.04 BogoMIPS (lpj=18620204)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
net_namespace: 1024 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 *7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 7 9 10 11 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 10 *11 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 7 9 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 *9 10 11 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnpacpi: exceeded the max number of mem resources: 12
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 11
hpet0: 3 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
Time: tsc clocksource has been installed.
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x290-0x29f has been reserved
system 00:01: ioport range 0x800-0x87f has been reserved
system 00:01: ioport range 0x880-0x88f has been reserved
system 00:09: ioport range 0x400-0x4bf could not be reserved
system 00:0b: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:0c: iomem range 0xf0000-0xfffff could not be reserved
system 00:0c: iomem range 0x7ff00000-0x7fffffff has been reserved
system 00:0c: iomem range 0xfed00000-0xfed000ff has been reserved
system 00:0c: iomem range 0x7fee0000-0x7fefffff could not be reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0x100000-0x7fedffff could not be reserved
system 00:0c: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0c: iomem range 0xfed14000-0xfed1dfff has been reserved
system 00:0c: iomem range 0xfed20000-0xfed9ffff has been reserved
system 00:0c: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0c: iomem range 0xffb00000-0xffb7ffff has been reserved
system 00:0c: iomem range 0xfff00000-0xffffffff has been reserved
PCI: Bridge: 0000:00:01.0
  IO window: b000-bfff
  MEM window: 0xfa000000-0xfcffffff
  PREFETCH window: 0x00000000d0000000-0x00000000dfffffff
PCI: Bridge: 0000:00:1c.0
  IO window: a000-afff
  MEM window: 0xfda00000-0xfdafffff
  PREFETCH window: 0x00000000fd700000-0x00000000fd7fffff
PCI: Bridge: 0000:00:1c.1
  IO window: 9000-9fff
  MEM window: 0xfd600000-0xfd6fffff
  PREFETCH window: 0x00000000fd500000-0x00000000fd5fffff
PCI: Bridge: 0000:00:1c.2
  IO window: d000-dfff
  MEM window: 0xfde00000-0xfdefffff
  PREFETCH window: 0x00000000fdd00000-0x00000000fddfffff
PCI: Bridge: 0000:00:1c.4
  IO window: c000-cfff
  MEM window: 0xfdc00000-0xfdcfffff
  PREFETCH window: 0x00000000fdb00000-0x00000000fdbfffff
PCI: Bridge: 0000:00:1e.0
  IO window: 8000-8fff
  MEM window: 0xfd900000-0xfd9fffff
  PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:01.0 to 64
ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1c.1 to 64
ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1c.2 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Enabling device 0000:00:1e.0 (0100 -> 0103)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered (default)
io scheduler cfq registered
pci 0000:00:1a.0: uhci_check_and_reset_hc: legsup = 0x0f10
pci 0000:00:1a.0: Performing full reset
pci 0000:00:1a.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1a.1: Performing full reset
pci 0000:00:1d.0: uhci_check_and_reset_hc: legsup = 0x043a
pci 0000:00:1d.0: Performing full reset
pci 0000:00:1d.1: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.1: Performing full reset
pci 0000:00:1d.2: uhci_check_and_reset_hc: legsup = 0x0010
pci 0000:00:1d.2: Performing full reset
pci 0000:01:00.0: Boot video device
PCI: Setting latency timer of device 0000:00:01.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:01.0:pcie00]
Allocate Port Service[0000:00:01.0:pcie03]
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
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
Freeing unused kernel memory: 328k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd: block sizes: ed 80 td 96
ehci_hcd: block sizes: qh 160 qtd 96 itd 192 sitd 96
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: reset hcs_params 0x102204 dbg=1 cc=2 pcc=2 ordered !ppc ports=4
ehci_hcd 0000:00:1a.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: supports USB remote wakeup
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xfdffe000
ehci_hcd 0000:00:1a.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1a.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: default language 0x0409
usb usb1: uevent
usb usb1: usb_probe_device
usb usb1: configuration #1 chosen from 1 choice
usb usb1: adding 1-0:1.0 (config #1, interface 0)
usb 1-0:1.0: uevent
hub 1-0:1.0: usb_probe_interface
hub 1-0:1.0: usb_probe_interface - got id
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
hub 1-0:1.0: standalone hub
hub 1-0:1.0: no power switching (usb 1.0)
hub 1-0:1.0: individual port over-current protection
hub 1-0:1.0: Single TT
hub 1-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 1-0:1.0: power on to power good time: 20ms
hub 1-0:1.0: local power source is good
hub 1-0:1.0: trying to enable port power on non-switchable hub
hub 1-0:1.0: state 7 ports 4 chg 0000 evt 0000
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25-rc2-git1 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: reset hcs_params 0x103206 dbg=1 cc=3 pcc=2 ordered !ppc ports=6
ehci_hcd 0000:00:1d.7: reset hcc_params 6871 thresh 7 uframes 1024 64 bit addr
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: supports USB remote wakeup
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xfdffd000
ehci_hcd 0000:00:1d.7: reset command 080002 (park)=0 ithresh=8 period=1024 Reset HALT
ehci_hcd 0000:00:1d.7: init command 010001 (park)=0 ithresh=1 period=1024 RUN
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: default language 0x0409
usb usb2: uevent
usb usb2: usb_probe_device
usb usb2: configuration #1 chosen from 1 choice
usb usb2: adding 2-0:1.0 (config #1, interface 0)
usb 2-0:1.0: uevent
hub 2-0:1.0: usb_probe_interface
hub 2-0:1.0: usb_probe_interface - got id
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
hub 2-0:1.0: standalone hub
hub 2-0:1.0: no power switching (usb 1.0)
hub 2-0:1.0: individual port over-current protection
hub 2-0:1.0: Single TT
hub 2-0:1.0: TT requires at most 8 FS bit times (666 ns)
hub 2-0:1.0: power on to power good time: 20ms
hub 2-0:1.0: local power source is good
hub 2-0:1.0: trying to enable port power on non-switchable hub
hub 2-0:1.0: state 7 ports 6 chg 0000 evt 0000
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001803 POWER sig=j CSC CONNECT
hub 2-0:1.0: port 2, status 0501, change 0001, 480 Mb/s
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25-rc2-git1 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
hub 2-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x501
ehci_hcd 0000:00:1d.7: port 2 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
usb 2-2: new high speed USB device using ehci_hcd and address 2
ehci_hcd 0000:00:1d.7: port 2 high speed
ehci_hcd 0000:00:1d.7: GetStatus port 2 status 001005 POWER sig=se0 PE CONNECT
usb 2-2: default language 0x0409
usb 2-2: uevent
usb 2-2: usb_probe_device
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: adding 2-2:1.0 (config #1, interface 0)
usb 2-2:1.0: uevent
usb 2-2: New USB device found, idVendor=090c, idProduct=1000
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-2: Product: Flash Voyager
usb 2-2: Manufacturer: Corsair
usb 2-2: SerialNumber: A302000000000155
libusual 2-2:1.0: usb_probe_interface
libusual 2-2:1.0: usb_probe_interface - got id
usbcore: registered new interface driver libusual
SCSI subsystem initialized
Initializing USB Mass Storage driver...
usb-storage 2-2:1.0: usb_probe_interface
usb-storage 2-2:1.0: usb_probe_interface - got id
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
Driver 'sd' needs updating - please use bus_type methods
ACPI: PNP0C0B:00 is registered as cooling_device0
ACPI: Fan [FAN] (on)
ACPI: ACPI0007:00 is registered as cooling_device1
ACPI: SSDT 7FEE7EC0, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
ACPI: ACPI0007:01 is registered as cooling_device2
ACPI: LNXTHERM:01 is registered as thermal_zone0
ACPI: Thermal Zone [THRM] (36 C)
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-2: uevent
usb 2-2:1.0: uevent
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: detected 2 ports
uhci_hcd 0000:00:1a.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.0: Performing full reset
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000fe00
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
libata version 3.00 loaded.
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25-rc2-git1 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: detected 2 ports
uhci_hcd 0000:00:1a.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1a.1: Performing full reset
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000fd00
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
hub 4-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25-rc2-git1 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.0: detected 2 ports
uhci_hcd 0000:00:1d.0: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.0: Performing full reset
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000fc00
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
hub 5-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
uhci_hcd 0000:00:1d.0: port 2 portsc 008a,00
hub 5-0:1.0: port 2, status 0100, change 0003, 12 Mb/s
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25-rc2-git1 uhci_hcd
hub 1-0:1.0: hub_suspend
usb usb1: bus auto-suspend
ehci_hcd 0000:00:1a.7: suspend root hub
usb usb5: SerialNumber: 0000:00:1d.0
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.1: detected 2 ports
uhci_hcd 0000:00:1d.1: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.1: Performing full reset
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000fb00
usb usb6: default language 0x0409
usb usb6: uevent
usb usb6: usb_probe_device
usb usb6: configuration #1 chosen from 1 choice
usb usb6: adding 6-0:1.0 (config #1, interface 0)
usb 6-0:1.0: uevent
hub 6-0:1.0: usb_probe_interface
hub 6-0:1.0: usb_probe_interface - got id
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
hub 6-0:1.0: standalone hub
hub 6-0:1.0: no power switching (usb 1.0)
hub 6-0:1.0: individual port over-current protection
hub 6-0:1.0: power on to power good time: 2ms
hub 6-0:1.0: local power source is good
hub 6-0:1.0: trying to enable port power on non-switchable hub
hub 5-0:1.0: debounce: port 2: total 100ms stable 100ms status 0x100
hub 6-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.25-rc2-git1 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.1
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.2: detected 2 ports
uhci_hcd 0000:00:1d.2: uhci_check_and_reset_hc: cmd = 0x0000
uhci_hcd 0000:00:1d.2: Performing full reset
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000fa00
usb usb7: default language 0x0409
usb usb7: uevent
usb usb7: usb_probe_device
usb usb7: configuration #1 chosen from 1 choice
usb usb7: adding 7-0:1.0 (config #1, interface 0)
usb 7-0:1.0: uevent
hub 7-0:1.0: usb_probe_interface
hub 7-0:1.0: usb_probe_interface - got id
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
hub 7-0:1.0: standalone hub
hub 7-0:1.0: no power switching (usb 1.0)
hub 7-0:1.0: individual port over-current protection
hub 7-0:1.0: power on to power good time: 2ms
hub 7-0:1.0: local power source is good
hub 7-0:1.0: trying to enable port power on non-switchable hub
hub 7-0:1.0: state 7 ports 2 chg 0000 evt 0000
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.25-rc2-git1 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.2
sata_sil24 0000:03:00.0: version 1.1
PCI: Enabling device 0000:05:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi1 : sata_sil24
scsi2 : sata_sil24
ata1: SATA max UDMA/100 host m128@0xfd6ff000 port 0xfd6f8000 irq 17
ata2: SATA max UDMA/100 host m128@0xfd6ff000 port 0xfd6fa000 irq 17
usb usb3: suspend_rh (auto-stop)
ACPI: PCI Interrupt 0000:05:00.1[B] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:05:00.1 to 64
scsi3 : pata_jmicron
scsi4 : pata_jmicron
ata3: PATA max UDMA/100 cmd 0xcf00 ctl 0xce00 bmdma 0xcb00 irq 17
ata4: PATA max UDMA/100 cmd 0xcd00 ctl 0xcc00 bmdma 0xcb08 irq 17
usb usb4: suspend_rh (auto-stop)
ahci 0000:00:1f.2: version 3.0
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 19
usb usb5: suspend_rh (auto-stop)
usb usb6: suspend_rh (auto-stop)
usb usb7: suspend_rh (auto-stop)
hub 3-0:1.0: hub_suspend
usb usb3: bus auto-suspend
usb usb3: suspend_rh
hub 4-0:1.0: hub_suspend
usb usb4: bus auto-suspend
usb usb4: suspend_rh
ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
scsi8 : ahci
scsi9 : ahci
scsi10 : ahci
ata5: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc100 irq 506
ata6: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc180 irq 506
ata7: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc200 irq 506
ata8: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc280 irq 506
ata9: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc300 irq 506
ata10: SATA max UDMA/133 abar m2048@0xfdffc000 port 0xfdffc380 irq 506
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
hub 5-0:1.0: hub_suspend
usb usb5: bus auto-suspend
usb usb5: suspend_rh
hub 6-0:1.0: hub_suspend
usb usb6: bus auto-suspend
usb usb6: suspend_rh
hub 7-0:1.0: hub_suspend
usb usb7: bus auto-suspend
usb usb7: suspend_rh
ata5.00: ATA-6: ST3200822A, 3.01, max UDMA/100
ata5.00: 390721968 sectors, multi 0: LBA48 
ata5.00: applying bridge limits
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata5.00: configured for UDMA/100
ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/100
ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata6.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata6.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata6.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     Corsair  Flash Voyager    1100 PQ: 0 ANSI: 0 CCS
sd 0:0:0:0: [sda] 16251904 512-byte hardware sectors (8321 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
sd 0:0:0:0: [sda] 16251904 512-byte hardware sectors (8321 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
sd 0:0:0:0: [sda] Assuming drive cache: write through
 sda: sda1
sd 0:0:0:0: [sda] Attached SCSI removable disk
usb-storage: device scan complete
ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata7.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata7.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata7.00: configured for UDMA/133
ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata8.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
ata8.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata8.00: configured for UDMA/133
ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata9.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata9.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata2.00: ATA-7: Hitachi HDT725032VLA360, V54OA73A, max UDMA/133
ata2.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata9.00: configured for UDMA/133
ata2.00: configured for UDMA/100
scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 1:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 < sdb5 >
sd 1:0:0:0: [sdb] Attached SCSI disk
scsi 2:0:0:0: Direct-Access     ATA      Hitachi HDT72503 V54O PQ: 0 ANSI: 5
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sdc] 625142448 512-byte hardware sectors (320073 MB)
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:04:00.0 to 64
scsi11 : sata_sil24
scsi12 : sata_sil24
ata11: SATA max UDMA/100 host m128@0xfdeff000 port 0xfdef8000 irq 18
ata12: SATA max UDMA/100 host m128@0xfdeff000 port 0xfdefa000 irq 18
ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata10.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata10.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata10.00: configured for UDMA/133
scsi 5:0:0:0: Direct-Access     ATA      ST3200822A       3.01 PQ: 0 ANSI: 5
sd 5:0:0:0: [sdd] 390721968 512-byte hardware sectors (200050 MB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 5:0:0:0: [sdd] 390721968 512-byte hardware sectors (200050 MB)
sd 5:0:0:0: [sdd] Write Protect is off
sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 5:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1 sdd2 < sdd5 >
sd 5:0:0:0: [sdd] Attached SCSI disk
scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 6:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sde] Write Protect is off
sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1 < sde5 >
sd 6:0:0:0: [sde] Attached SCSI disk
scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdf] Write Protect is off
sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdf] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdf] Write Protect is off
sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdf: sdf1 < sdf5 >
sd 7:0:0:0: [sdf] Attached SCSI disk
scsi 8:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 8:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdg] Write Protect is off
sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 8:0:0:0: [sdg] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdg] Write Protect is off
sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdg: sdg1 < sdg5 >
sd 8:0:0:0: [sdg] Attached SCSI disk
scsi 9:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 9:0:0:0: [sdh] 625142448 512-byte hardware sectors (320073 MB)
sd 9:0:0:0: [sdh] Write Protect is off
sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 9:0:0:0: [sdh] 625142448 512-byte hardware sectors (320073 MB)
sd 9:0:0:0: [sdh] Write Protect is off
sd 9:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdh: sdh1 sdh2
sd 9:0:0:0: [sdh] Attached SCSI disk
scsi 10:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 10:0:0:0: [sdi] 625142448 512-byte hardware sectors (320073 MB)
sd 10:0:0:0: [sdi] Write Protect is off
sd 10:0:0:0: [sdi] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 10:0:0:0: [sdi] 625142448 512-byte hardware sectors (320073 MB)
sd 10:0:0:0: [sdi] Write Protect is off
sd 10:0:0:0: [sdi] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdi: sdi1 sdi2
sd 10:0:0:0: [sdi] Attached SCSI disk
ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata11.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata11.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata11.00: configured for UDMA/100
ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
ata12.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata12.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata12.00: configured for UDMA/100
scsi 11:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 11:0:0:0: [sdj] 625142448 512-byte hardware sectors (320073 MB)
sd 11:0:0:0: [sdj] Write Protect is off
sd 11:0:0:0: [sdj] Mode Sense: 00 3a 00 00
sd 11:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 11:0:0:0: [sdj] 625142448 512-byte hardware sectors (320073 MB)
sd 11:0:0:0: [sdj] Write Protect is off
sd 11:0:0:0: [sdj] Mode Sense: 00 3a 00 00
sd 11:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdj: sdj1 sdj2
sd 11:0:0:0: [sdj] Attached SCSI disk
scsi 12:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 12:0:0:0: [sdk] 625142448 512-byte hardware sectors (320073 MB)
sd 12:0:0:0: [sdk] Write Protect is off
sd 12:0:0:0: [sdk] Mode Sense: 00 3a 00 00
sd 12:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 12:0:0:0: [sdk] 625142448 512-byte hardware sectors (320073 MB)
sd 12:0:0:0: [sdk] Write Protect is off
sd 12:0:0:0: [sdk] Mode Sense: 00 3a 00 00
sd 12:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdk: sdk1 sdk2
sd 12:0:0:0: [sdk] Attached SCSI disk
ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
ahci 0000:05:00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:05:00.0: flags: 64bit ncq pm led clo pmp pio slum part 
PCI: Setting latency timer of device 0000:05:00.0 to 64
scsi13 : ahci
scsi14 : ahci
ata13: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe100 irq 16
ata14: SATA max UDMA/133 abar m8192@0xfdcfe000 port 0xfdcfe180 irq 16
ata13: SATA link down (SStatus 0 SControl 300)
ata14: SATA link down (SStatus 0 SControl 300)
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: dm-devel@redhat.com
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
usb usb3: uevent
usb 3-0:1.0: uevent
usb usb4: uevent
usb 4-0:1.0: uevent
usb usb1: uevent
usb 1-0:1.0: uevent
usb usb5: uevent
usb 5-0:1.0: uevent
usb usb6: uevent
usb 6-0:1.0: uevent
usb usb7: uevent
usb 7-0:1.0: uevent
usb usb2: uevent
usb 2-0:1.0: uevent
usb 2-2: uevent
usb 2-2:1.0: uevent
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
e1000e: Copyright (c) 1999-2007 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
input: Power Button (FF) as /devices/virtual/input/input1
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/virtual/input/input2
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8DH TCO device (Version=2, TCOBASE=0x0460)
0000:00:19.0: eth0: (PCI Express:2.5GB/s:Width x1) 00:19:21:af:91:17
0000:00:19.0: eth0: Intel(R) PRO/1000 Network Connection
0000:00:19.0: eth0: MAC: 4, PHY: 6, PBA No: ffffff-0ff
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
ACPI: Power Button (CM) [PWRB]
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 19 (level, low) -> IRQ 19
Real Time Clock Driver v1.12ac
input: PC Speaker as /devices/platform/pcspkr/input/input3
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
loop: module loaded
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
SGI XFS with ACLs, large block/inode numbers, no debug enabled
SGI XFS Quota Management subsystem
md: raid1 personality registered for level 1
xor: automatically using best checksumming function: generic_sse
   generic_sse:  6825.200 MB/sec
xor: using function: generic_sse (6825.200 MB/sec)
async_tx: api initialized (sync-only)
raid6: int64x1   1567 MB/s
raid6: int64x2   2105 MB/s
raid6: int64x4   2098 MB/s
raid6: int64x8   1704 MB/s
raid6: sse2x1    3395 MB/s
raid6: sse2x2    5130 MB/s
raid6: sse2x4    5683 MB/s
raid6: using algorithm sse2x4 (5683 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
md: md0 stopped.
md: bind<sdk1>
md: bind<sdh1>
raid1: raid set md0 active with 2 out of 2 mirrors
md: md1 stopped.
md: bind<sdf5>
md: bind<sdb5>
md: bind<sdg5>
md: bind<sde5>
raid5: device sde5 operational as raid disk 0
raid5: device sdg5 operational as raid disk 3
raid5: device sdb5 operational as raid disk 2
raid5: device sdf5 operational as raid disk 1
raid5: allocated 4274kB for md1
raid5: raid level 5 set md1 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sde5
 disk 1, o:1, dev:sdf5
 disk 2, o:1, dev:sdb5
 disk 3, o:1, dev:sdg5
md: md2 stopped.
md: bind<sdh2>
md: bind<sdj2>
md: bind<sdi2>
md: bind<sdk2>
raid5: device sdk2 operational as raid disk 0
raid5: device sdi2 operational as raid disk 3
raid5: device sdj2 operational as raid disk 2
raid5: device sdh2 operational as raid disk 1
raid5: allocated 4274kB for md2
raid5: raid level 5 set md2 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4
 disk 0, o:1, dev:sdk2
 disk 1, o:1, dev:sdh2
 disk 2, o:1, dev:sdj2
 disk 3, o:1, dev:sdi2
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-6, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdc1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-0, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Filesystem "dm-4": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-4
Ending clean XFS mount for filesystem: dm-4
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdd1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1048568k swap on /dev/mapper/vg00-swap.  Priority:-1 extents:1 across:1048568k
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
0000:00:19.0: eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8028 cmd 10021
ehci_hcd 0000:00:1d.7: IAA watchdog, lost IAA: status 8029 cmd 10021

--------------040905000300080708080000--
