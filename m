Return-Path: <linux-kernel-owner+w=401wt.eu-S964849AbYAaXiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964849AbYAaXiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 18:38:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYAaXin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 18:38:43 -0500
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:64069
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754581AbYAaXik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 18:38:40 -0500
X-Greylist: delayed 606 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 18:38:37 EST
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CAMbooUd8qNBs/2dsb2JhbACrCQ
X-IronPort-AV: E=Sophos;i="4.25,287,1199631600"; 
   d="scan'208?fc7'208";a="220407072"
Message-ID: <47A25998.1000501@eyal.emu.id.au>
Date: Fri, 01 Feb 2008 10:28:24 +1100
From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Organization: Eyal at Home
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: list linux-kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.23.14 snd_hda_intel problem
Content-Type: multipart/mixed;
 boundary="------------090202070209020708090409"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090202070209020708090409
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Running fc7 all was well up until 2.6.23.12-52.fc7.

A recent update to 2.6.23.14-64.fc7 lost sound. The boot log now has
	hda-intel: Error creating card!
	HDA Intel: probe of 0000:00:1b.0 failed with error -12

Mobo is Intel BLKDG965OTMKR.
The device is
	00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio Controller (rev 02)

dmesg attached.

TIA

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)

--------------090202070209020708090409
Content-Type: text/plain;
 name="dmesg.2.6.23.12-52.fc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.2.6.23.12-52.fc7"

Linux version 2.6.23.12-52.fc7 (mockbuild@xenbuilder4.fedora.phx.redhat.com) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 SMP Tue Dec 18 20:27:10 EST 2007
Command line: ro root=LABEL=/ rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007edb6000 (usable)
 BIOS-e820: 000000007edb6000 - 000000007edc3000 (reserved)
 BIOS-e820: 000000007edc3000 - 000000007ee47000 (usable)
 BIOS-e820: 000000007ee47000 - 000000007eeac000 (ACPI NVS)
 BIOS-e820: 000000007eeac000 - 000000007eeaf000 (ACPI data)
 BIOS-e820: 000000007eeaf000 - 000000007eef2000 (ACPI NVS)
 BIOS-e820: 000000007eef2000 - 000000007eeff000 (ACPI data)
 BIOS-e820: 000000007eeff000 - 000000007ef00000 (usable)
 BIOS-e820: 000000007ef00000 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 519606) 1 entries of 3200 used
Entering add_active_range(0, 519619, 519751) 2 entries of 3200 used
Entering add_active_range(0, 519935, 519936) 3 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 7EEFD038, 004C (r1 INTEL  DG965OT       330       1000013)
ACPI: FACP 7EEFC000, 0074 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: DSDT 7EEF8000, 3EDA (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: FACS 7EEAF000, 0040
ACPI: APIC 7EEF7000, 0078 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: WDDT 7EEF6000, 0040 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: MCFG 7EEF5000, 003C (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: ASF! 7EEF4000, 00A6 (r32 INTEL  DG965OT       330 MSFT  1000013)
ACPI: SSDT 7EEF3000, 01BC (r1 INTEL     CpuPm      330 MSFT  1000013)
ACPI: SSDT 7EEF2000, 0175 (r1 INTEL   Cpu0Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAE000, 0175 (r1 INTEL   Cpu1Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAD000, 0175 (r1 INTEL   Cpu2Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAC000, 0175 (r1 INTEL   Cpu3Ist      330 MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-000000007ef00000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 519606) 1 entries of 3200 used
Entering add_active_range(0, 519619, 519751) 2 entries of 3200 used
Entering add_active_range(0, 519935, 519936) 3 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007ef00000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      159
    0:      256 ->   519606
    0:   519619 ->   519751
    0:   519935 ->   519936
On node 0 totalpages: 519642
  DMA zone: 56 pages used for memmap
  DMA zone: 1307 pages reserved
  DMA zone: 2636 pages, LIFO batch:0
  DMA32 zone: 7052 pages used for memmap
  DMA32 zone: 508591 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007edb6000 - 000000007edc3000
swsusp: Registered nosave memory region: 000000007ee47000 - 000000007eeac000
swsusp: Registered nosave memory region: 000000007eeac000 - 000000007eeaf000
swsusp: Registered nosave memory region: 000000007eeaf000 - 000000007eef2000
swsusp: Registered nosave memory region: 000000007eef2000 - 000000007eeff000
Allocating PCI resources starting at 80000000 (gap: 7f000000:80f00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 41176 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 511227
Policy zone: DMA32
Kernel command line: ro root=LABEL=/ rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2131.220 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2041240k/2079744k available (2417k kernel code, 37328k reserved, 1369k data, 324k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4264.20 BogoMIPS (lpj=2132103)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16650146
Detected 16.650 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4261.83 BogoMIPS (lpj=2130919)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=2080 bytes
Time: 22:09:37  Date: 01/31/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
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
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
pnp: 00:06: ioport range 0x500-0x53f has been reserved
pnp: 00:06: ioport range 0x400-0x47f has been reserved
pnp: 00:06: ioport range 0x680-0x6ff has been reserved
PCI: Failed to allocate mem resource #6:20000@a0000000 for 0000:01:00.0
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: a0000000-a1ffffff
  PREFETCH window: 80000000-9fffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: a2300000-a23fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 1000-1fff
  MEM window: a2100000-a21fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: a2400000-a24fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: a2500000-a25fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: a2600000-a26fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: a2000000-a20fffff
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
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3068k freed
audit: initializing netlink socket (disabled)
audit(1201817376.445:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 7C3D39AAD2D29BC5
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
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
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
  Magic number: 8:250:200
Freeing unused kernel memory: 324k freed
Write protecting the kernel read-only data: 1012k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020a0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
usb 3-2: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xa2225400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech Logitech USB Headset as /class/input/input3
input: USB HID v1.00 Device [Logitech Logitech USB Headset] on usb-0000:00:1d.0-2
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xa2225000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x0000000000012138 ctl 0x000000000001214e bmdma 0x0000000000012110 irq 19
ata2: SATA max UDMA/133 cmd 0x0000000000012130 ctl 0x000000000001214a bmdma 0x0000000000012118 irq 19
ata1.00: ATA-7: SAMSUNG HD400LJ, ZZ100-15, max UDMA7
ata1.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD400LJ  ZZ10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0000000000012128 ctl 0x0000000000012146 bmdma 0x00000000000120f0 irq 19
ata4: SATA max UDMA/133 cmd 0x0000000000012120 ctl 0x0000000000012142 bmdma 0x00000000000120f8 irq 19
usb 7-3: new high speed USB device using ehci_hcd and address 3
usb 7-3: configuration #1 chosen from 1 choice
hub 7-3:1.0: USB hub found
hub 7-3:1.0: 2 ports detected
usb 3-2: USB disconnect, address 2
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech Logitech USB Headset as /class/input/input4
input: USB HID v1.00 Device [Logitech Logitech USB Headset] on usb-0000:00:1d.0-2
usb 7-3.1: new high speed USB device using ehci_hcd and address 5
usb 7-3.1: configuration #1 chosen from 1 choice
hub 7-3.1:1.0: USB hub found
hub 7-3.1:1.0: 4 ports detected
usb 7-3.2: new high speed USB device using ehci_hcd and address 6
usb 7-3.2: configuration #1 chosen from 1 choice
usb 4-2: new low speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
input: Ver 1.0 USB To RS232 Interface (V1.0) BaudRate 2400bps as /class/input/input5
input: USB HID v1.00 Gamepad [Ver 1.0 USB To RS232 Interface (V1.0) BaudRate 2400bps] on usb-0000:00:1d.1-2
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi4 : pata_marvell
scsi5 : pata_marvell
ata5: PATA max UDMA/100 cmd 0x0000000000011018 ctl 0x0000000000011026 bmdma 0x0000000000011000 irq 17
ata6: DUMMY
BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
ata5.00: ATAPI: HL-DT-STDVD-RAM GSA-H22N, 1.00, max UDMA/66
ata5.00: configured for UDMA/66
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H22N 1.00 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1201817384.527:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1835 types, 87 bools, 1 sens, 1024 cats
security:  61 classes, 69985 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1201817384.811:3): policy loaded auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 21 (level, low) -> IRQ 21
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
input: PC Speaker as /class/input/input6
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8DH TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
nvidia: module license 'NVIDIA' taints kernel.
input: Power Button (FF) as /class/input/input7
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input8
ACPI: Sleep Button (CM) [SLPB]
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.07  Thu Dec 13 18:34:01 PST 2007
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:b6:bc:b6
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
usbcore: registered new interface driver snd-usb-audio
firewire_core: created new fw device fw0 (0 config rom retries, S400)
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     SMSC     223 U HS-CF      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:1: Direct-Access     SMSC     223 U HS-MS      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:2: Direct-Access     SMSC     223 U HS-SM      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:3: Direct-Access     SMSC     223 U HS-SD/MMC  3.60 PQ: 0 ANSI: 0
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:1: [sdc] Attached SCSI removable disk
sd 6:0:0:1: Attached scsi generic sg3 type 0
sd 6:0:0:2: [sdd] Attached SCSI removable disk
sd 6:0:0:2: Attached scsi generic sg4 type 0
sd 6:0:0:3: [sde] Attached SCSI removable disk
sd 6:0:0:3: Attached scsi generic sg5 type 0
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 4192956k swap on /dev/sda2.  Priority:-1 extents:1 across:4192956k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--------------090202070209020708090409
Content-Type: text/plain;
 name="dmesg.2.6.23.14-64.fc7"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.2.6.23.14-64.fc7"

Linux version 2.6.23.14-64.fc7 (mockbuild@xenbuilder2.fedora.redhat.com) (gcc version 4.1.2 20070925 (Red Hat 4.1.2-27)) #1 SMP Sun Jan 20 22:20:19 EST 2008
Command line: ro root=LABEL=/ rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007edb6000 (usable)
 BIOS-e820: 000000007edb6000 - 000000007edc3000 (reserved)
 BIOS-e820: 000000007edc3000 - 000000007ee47000 (usable)
 BIOS-e820: 000000007ee47000 - 000000007eeac000 (ACPI NVS)
 BIOS-e820: 000000007eeac000 - 000000007eeaf000 (ACPI data)
 BIOS-e820: 000000007eeaf000 - 000000007eef2000 (ACPI NVS)
 BIOS-e820: 000000007eef2000 - 000000007eeff000 (ACPI data)
 BIOS-e820: 000000007eeff000 - 000000007ef00000 (usable)
 BIOS-e820: 000000007ef00000 - 000000007f000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 519606) 1 entries of 3200 used
Entering add_active_range(0, 519619, 519751) 2 entries of 3200 used
Entering add_active_range(0, 519935, 519936) 3 entries of 3200 used
end_pfn_map = 1048576
DMI 2.4 present.
ACPI: RSDP 000FE020, 0014 (r0 INTEL )
ACPI: RSDT 7EEFD038, 004C (r1 INTEL  DG965OT       330       1000013)
ACPI: FACP 7EEFC000, 0074 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: DSDT 7EEF8000, 3EDA (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: FACS 7EEAF000, 0040
ACPI: APIC 7EEF7000, 0078 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: WDDT 7EEF6000, 0040 (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: MCFG 7EEF5000, 003C (r1 INTEL  DG965OT       330 MSFT  1000013)
ACPI: ASF! 7EEF4000, 00A6 (r32 INTEL  DG965OT       330 MSFT  1000013)
ACPI: SSDT 7EEF3000, 01BC (r1 INTEL     CpuPm      330 MSFT  1000013)
ACPI: SSDT 7EEF2000, 0175 (r1 INTEL   Cpu0Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAE000, 0175 (r1 INTEL   Cpu1Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAD000, 0175 (r1 INTEL   Cpu2Ist      330 MSFT  1000013)
ACPI: SSDT 7EEAC000, 0175 (r1 INTEL   Cpu3Ist      330 MSFT  1000013)
No NUMA configuration found
Faking a node at 0000000000000000-000000007ef00000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 519606) 1 entries of 3200 used
Entering add_active_range(0, 519619, 519751) 2 entries of 3200 used
Entering add_active_range(0, 519935, 519936) 3 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000007ef00000
Zone PFN ranges:
  DMA             0 ->     4096
  DMA32        4096 ->  1048576
  Normal    1048576 ->  1048576
Movable zone start PFN for each node
early_node_map[4] active PFN ranges
    0:        0 ->      159
    0:      256 ->   519606
    0:   519619 ->   519751
    0:   519935 ->   519936
On node 0 totalpages: 519642
  DMA zone: 56 pages used for memmap
  DMA zone: 1307 pages reserved
  DMA zone: 2636 pages, LIFO batch:0
  DMA32 zone: 7052 pages used for memmap
  DMA32 zone: 508591 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Processor #1
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
swsusp: Registered nosave memory region: 000000000009f000 - 00000000000a0000
swsusp: Registered nosave memory region: 00000000000a0000 - 00000000000e0000
swsusp: Registered nosave memory region: 00000000000e0000 - 0000000000100000
swsusp: Registered nosave memory region: 000000007edb6000 - 000000007edc3000
swsusp: Registered nosave memory region: 000000007ee47000 - 000000007eeac000
swsusp: Registered nosave memory region: 000000007eeac000 - 000000007eeaf000
swsusp: Registered nosave memory region: 000000007eeaf000 - 000000007eef2000
swsusp: Registered nosave memory region: 000000007eef2000 - 000000007eeff000
Allocating PCI resources starting at 80000000 (gap: 7f000000:80f00000)
SMP: Allowing 4 CPUs, 2 hotplug CPUs
PERCPU: Allocating 41176 bytes of per cpu data
Built 1 zonelists in Node order.  Total pages: 511227
Policy zone: DMA32
Kernel command line: ro root=LABEL=/ rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
time.c: Detected 2131.261 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2041244k/2079744k available (2418k kernel code, 37324k reserved, 1368k data, 324k init)
SLUB: Genslabs=23, HWalign=64, Order=0-1, MinObjects=4, CPUs=4, Nodes=1
Calibrating delay using timer specific routine.. 4264.19 BogoMIPS (lpj=2132097)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 0/0 -> Node 0
using mwait in idle threads.
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
Using local APIC timer interrupts.
result 16650471
Detected 16.650 MHz APIC timer.
SMP alternatives: switching to SMP code
Booting processor 1/2 APIC 0x1
Initializing CPU#1
Calibrating delay using timer specific routine.. 4432.26 BogoMIPS (lpj=2216132)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 2048K
CPU 1/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU1: Thermal monitoring enabled (TM2)
Intel(R) Core(TM)2 CPU          6400  @ 2.13GHz stepping 06
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Brought up 2 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=232 bytes
sizeof(task_struct)=2080 bytes
Time:  9:43:15  Date: 01/31/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 12 devices
ACPI: ACPI bus type pnp unregistered
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
Time: tsc clocksource has been installed.
pnp: 00:01: iomem range 0xf0000000-0xf7ffffff has been reserved
pnp: 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
pnp: 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
pnp: 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
pnp: 00:06: ioport range 0x500-0x53f has been reserved
pnp: 00:06: ioport range 0x400-0x47f has been reserved
pnp: 00:06: ioport range 0x680-0x6ff has been reserved
PCI: Failed to allocate mem resource #6:20000@a0000000 for 0000:01:00.0
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: a0000000-a1ffffff
  PREFETCH window: 80000000-9fffffff
PCI: Bridge: 0000:00:1c.0
  IO window: disabled.
  MEM window: a2300000-a23fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.1
  IO window: 1000-1fff
  MEM window: a2100000-a21fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.2
  IO window: disabled.
  MEM window: a2400000-a24fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: disabled.
  MEM window: a2500000-a25fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: disabled.
  MEM window: a2600000-a26fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1e.0
  IO window: disabled.
  MEM window: a2000000-a20fffff
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
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 6291456 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3066k freed
audit: initializing netlink socket (disabled)
audit(1201772595.441:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 4E0C9E3E2FB53A6F
- User ID: Red Hat, Inc. (Kernel Module GPG key)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
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
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
ACPI Exception (processor_core-0818): AE_NOT_FOUND, Processor Device is not present [20070126]
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.102
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 16384K size 4096 blocksize
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
  Magic number: 8:934:728
Freeing unused kernel memory: 324k freed
Write protecting the kernel read-only data: 1012k
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x000020a0
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 21, io base 0x00002080
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.0: irq 23, io base 0x00002060
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
input: ImPS/2 Generic Wheel Mouse as /class/input/input2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.1: irq 19, io base 0x00002040
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.2: irq 18, io base 0x00002020
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
usb 3-2: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 6
ehci_hcd 0000:00:1a.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xa2225400
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 4 ports detected
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech Logitech USB Headset as /class/input/input3
input: USB HID v1.00 Device [Logitech Logitech USB Headset] on usb-0000:00:1d.0-2
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 7
ehci_hcd 0000:00:1d.7: debug port 1
PCI: cache line size of 32 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xa2225000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
SCSI subsystem initialized
libata version 2.21 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.2 to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x0000000000012138 ctl 0x000000000001214e bmdma 0x0000000000012110 irq 19
ata2: SATA max UDMA/133 cmd 0x0000000000012130 ctl 0x000000000001214a bmdma 0x0000000000012118 irq 19
ata1.00: ATA-7: SAMSUNG HD400LJ, ZZ100-15, max UDMA7
ata1.00: 781422768 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD400LJ  ZZ10 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 781422768 512-byte hardware sectors (400088 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[A] -> GSI 19 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1f.5 to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0x0000000000012128 ctl 0x0000000000012146 bmdma 0x00000000000120f0 irq 19
ata4: SATA max UDMA/133 cmd 0x0000000000012120 ctl 0x0000000000012142 bmdma 0x00000000000120f8 irq 19
usb 7-3: new high speed USB device using ehci_hcd and address 3
usb 7-3: configuration #1 chosen from 1 choice
hub 7-3:1.0: USB hub found
hub 7-3:1.0: 2 ports detected
usb 3-2: USB disconnect, address 2
usb 3-2: new full speed USB device using uhci_hcd and address 3
usb 3-2: configuration #1 chosen from 1 choice
input: Logitech Logitech USB Headset as /class/input/input4
input: USB HID v1.00 Device [Logitech Logitech USB Headset] on usb-0000:00:1d.0-2
usb 7-3.1: new high speed USB device using ehci_hcd and address 5
usb 7-3.1: configuration #1 chosen from 1 choice
hub 7-3.1:1.0: USB hub found
hub 7-3.1:1.0: 4 ports detected
usb 7-3.2: new high speed USB device using ehci_hcd and address 6
usb 7-3.2: configuration #1 chosen from 1 choice
usb 4-2: new low speed USB device using uhci_hcd and address 2
usb 4-2: configuration #1 chosen from 1 choice
input: Ver 1.0 USB To RS232 Interface (V1.0) BaudRate 2400bps as /class/input/input5
input: USB HID v1.00 Gamepad [Ver 1.0 USB To RS232 Interface (V1.0) BaudRate 2400bps] on usb-0000:00:1d.1-2
ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:03:00.0 to 64
scsi4 : pata_marvell
scsi5 : pata_marvell
ata5: PATA max UDMA/100 cmd 0x0000000000011018 ctl 0x0000000000011026 bmdma 0x0000000000011000 irq 17
ata6: DUMMY
BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
ata5.00: ATAPI: HL-DT-STDVD-RAM GSA-H22N, 1.00, max UDMA/66
ata5.00: configured for UDMA/66
scsi 4:0:0:0: CD-ROM            HL-DT-ST DVD-RAM GSA-H22N 1.00 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
audit(1201772603.509:2): enforcing=1 old_enforcing=0 auid=4294967295
security:  3 users, 6 roles, 1835 types, 87 bools, 1 sens, 1024 cats
security:  61 classes, 69985 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev sda1, type ext3), uses xattr
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev futexfs, type futexfs), uses genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev cpuset, type cpuset), uses genfs_contexts
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
audit(1201772603.801:3): policy loaded auid=4294967295
sd 0:0:0:0: Attached scsi generic sg0 type 0
scsi 4:0:0:0: Attached scsi generic sg1 type 5
sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt 0000:00:1f.3[B] -> GSI 21 (level, low) -> IRQ 21
iTCO_vendor_support: vendor-support=0
iTCO_wdt: Intel TCO WatchDog Timer Driver v1.02 (26-Jul-2007)
iTCO_wdt: Found a ICH8DH TCO device (Version=2, TCOBASE=0x0460)
iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 6
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
input: Power Button (FF) as /class/input/input6
ACPI: Power Button (FF) [PWRF]
input: Sleep Button (CM) as /class/input/input7
ACPI: Sleep Button (CM) [SLPB]
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 00:16:76:b6:bc:b6
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
input: PC Speaker as /class/input/input8
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378 (0x778), irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 19 (level, low) -> IRQ 19
firewire_ohci: Added fw-ohci device 0000:07:03.0, OHCI version 1.10
firewire_core: created new fw device fw0 (0 config rom retries, S400)
usbcore: registered new interface driver snd-usb-audio
cannot find the slot for index 0 (range 0-0), error: -16
hda-intel: Error creating card!
HDA Intel: probe of 0000:00:1b.0 failed with error -12
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:01:00.0 to 64
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  169.07  Thu Dec 13 18:34:01 PST 2007
SELinux: initialized (dev ramfs, type ramfs), uses genfs_contexts
usb-storage: device scan complete
scsi 6:0:0:0: Direct-Access     SMSC     223 U HS-CF      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:1: Direct-Access     SMSC     223 U HS-MS      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:2: Direct-Access     SMSC     223 U HS-SM      3.60 PQ: 0 ANSI: 0
scsi 6:0:0:3: Direct-Access     SMSC     223 U HS-SD/MMC  3.60 PQ: 0 ANSI: 0
sd 6:0:0:0: [sdb] Attached SCSI removable disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
sd 6:0:0:1: [sdc] Attached SCSI removable disk
sd 6:0:0:1: Attached scsi generic sg3 type 0
sd 6:0:0:2: [sdd] Attached SCSI removable disk
sd 6:0:0:2: Attached scsi generic sg4 type 0
sd 6:0:0:3: [sde] Attached SCSI removable disk
sd 6:0:0:3: Attached scsi generic sg5 type 0
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
Adding 4192956k swap on /dev/sda2.  Priority:-1 extents:1 across:4192956k
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts

--------------090202070209020708090409--
