Return-Path: <linux-kernel-owner+w=401wt.eu-S1764732AbYHDUjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764732AbYHDUjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 16:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764023AbYHDUiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 16:38:21 -0400
Received: from smtp105.rog.mail.re2.yahoo.com ([206.190.36.83]:29392 "HELO
	smtp105.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1762215AbYHDUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 16:38:12 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Mon, 04 Aug 2008 16:38:11 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
  b=KFD1sW3deS3V4WRIFZgOmb/8iGczaGJweoyCpMJinX1/yvPPLu4Zc0wvVUiNFA8RqPddogqaZ0Ji2TtA2htbJVR/rXTsaPVm9vgNnCfeGBfsjxXtK+Vus8KQqvjkJWKorv1YgcAkTWG2ssMENVG6WZ99uVnLWgy/X+skFjKbSxM=  ;
X-YMail-OSG: 2vwcZJgVM1kMjMqsMWDcsgHMGXG46nnBE5QlbB9OA3TXqgtFnw6Ygf5.202YO6SVgQ--
X-Yahoo-Newman-Property: ymail-3
Message-ID: <4897671F.1050003@rogers.com>
Date: Mon, 04 Aug 2008 16:31:27 -0400
From: David Stuart <dstuart@rogers.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problems with disk + network on 2.6.25.11-60.fc8
References: <48973EB9.90408@rogers.com> <20080804184232.601881a8@lxorguk.ukuu.org.uk>
In-Reply-To: <20080804184232.601881a8@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms030601020307040409040401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms030601020307040409040401
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> To start with can I have a dmesg after boot and a description of what is
> plugged into where (disks and CD wise)
>
> Alan
>   

Hi Alain,

Sure, no problem. First the description, I'll append the dmesg output at 
the end.

I have an ASUS A8V motherboard, with a Maxtor Ultra100 IDE controller 
card on one of the PCI ports. On the mainboard:
- Primary IDE Master : 13GB Quantum Fireball HD (Where Windows resides, 
not that I use it).
- Primary IDE Slave : LG CD-ROM, 52X
- Secondary IDE : Nothing

On the IDE controller card:
- "IDE1 slot" Master : 80GB Maxtor
- "IDE1 slot" Slave : 250GB Western Digital
- "IDE2 slot" : Nothing

The output of dmesg (after booting) follows:
==================================

Initializing cgroup subsys cpuset
Linux version 2.6.25.11-60.fc8 (mockbuild@x86-7) (gcc version 4.1.2 
20070925 (Red Hat 4.1.2-33)) #1 SMP Mon Jul 21 01:40:51 EDT 2008
Command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffb0000 (usable)
 BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
 BIOS-e820: 000000003ffc0000 - 000000003fff0000 (ACPI NVS)
 BIOS-e820: 000000003fff0000 - 0000000040000000 (reserved)
 BIOS-e820: 00000000ff780000 - 0000000100000000 (reserved)
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
end_pfn_map = 1048576
DMI 2.3 present.
ACPI: RSDP 000FA810, 0021 (r2 ACPIAM)
ACPI: XSDT 3FFB0100, 003C (r1 A M I  OEMXSDT   5000729 MSFT       97)
ACPI: FACP 3FFB0290, 00F4 (r3 A M I  OEMFACP   5000729 MSFT       97)
ACPI: DSDT 3FFB03F0, 391B (r1  A0277 A0277001        1 MSFT  100000D)
ACPI: FACS 3FFC0000, 0040
ACPI: APIC 3FFB0390, 0052 (r1 A M I  OEMAPIC   5000729 MSFT       97)
ACPI: OEMB 3FFC0040, 003F (r1 A M I  OEMBIOS   5000729 MSFT       97)
Scanning NUMA topology in Northbridge 24
No NUMA configuration found
Faking a node at 0000000000000000-000000003ffb0000
Entering add_active_range(0, 0, 159) 0 entries of 3200 used
Entering add_active_range(0, 256, 262064) 1 entries of 3200 used
Bootmem setup node 0 0000000000000000-000000003ffb0000
  NODE_DATA [000000000000b000 - 0000000000012fff]
  bootmap [0000000000013000 -  000000000001aff7] pages 8
early res: 0 [0-fff] BIOS data page
early res: 1 [6000-7fff] SMP_TRAMPOLINE
early res: 2 [200000-756aeb] TEXT DATA BSS
early res: 3 [37c20000-37fef4f7] RAMDISK
early res: 4 [9f000-9ffff] EBDA
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
  DMA zone: 1375 pages reserved
  DMA zone: 2568 pages, LIFO batch:0
  DMA32 zone: 3526 pages used for memmap
  DMA32 zone: 254442 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x808
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 (Bootup-CPU)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x81] disabled)
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
Using ACPI (MADT) for SMP configuration information
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Allocating PCI resources starting at 50000000 (gap: 40000000:bf780000)
SMP: Allowing 2 CPUs, 1 hotplug CPUs
PERCPU: Allocating 43072 bytes of per cpu data
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 257010
Policy zone: DMA32
Kernel command line: ro root=/dev/VolGroup00/LogVol00 rhgb quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Extended CMOS year: 2000
TSC calibrated against PM_TIMER
time.c: Detected 2202.814 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
Node 0: aperture @ dc000000 size 64 MB
Memory: 1023824k/1048256k available (2630k kernel code, 24044k reserved, 
1408k data, 348k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-1, MinObjects=4, CPUs=2, Nodes=1
Calibrating delay using timer specific routine.. 4409.62 BogoMIPS 
(lpj=2204812)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes)
Inode-cache hash table entries: 65536 (order: 7, 524288 bytes)
Mount-cache hash table entries: 256
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/0 -> Node 0
ACPI: Core revision 20070126
Using local APIC timer interrupts.
APIC timer calibration result 12515985
Detected 12.515 MHz APIC timer.
Brought up 1 CPUs
sizeof(vma)=176 bytes
sizeof(page)=56 bytes
sizeof(inode)=560 bytes
sizeof(dentry)=208 bytes
sizeof(ext3inode)=760 bytes
sizeof(buffer_head)=104 bytes
sizeof(skbuff)=224 bytes
sizeof(task_struct)=6224 bytes
CPU0 attaching sched-domain:
 domain 0: span 00000000,00000001
  groups: 00000000,00000001
net_namespace: 1016 bytes
Time: 20:15:35  Date: 08/04/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: Using configuration type 1
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:11.0: Enabled onboard AC97/MC97 devices
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 10 *11 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 *10 11 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs *3 4 5 7 10 11 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 14 15) *0, disabled.
ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] -  ED, 
should be E0 [20070126]
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Cannot allocate resource region 0 of device 0000:00:00.0
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
agpgart: Detected AGP bridge 0
agpgart: AGP aperture is 64M @ 0xdc000000
system 00:08: ioport range 0x680-0x6ff has been reserved
system 00:08: ioport range 0x290-0x297 has been reserved
system 00:09: ioport range 0x3e1-0x3e7 has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x800-0x87f has been reserved
system 00:09: ioport range 0x400-0x41f has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0a: iomem range 0xfff80000-0xffffffff could not be reserved
system 00:0c: iomem range 0x0-0x9ffff could not be reserved
system 00:0c: iomem range 0xc0000-0xdffff has been reserved
system 00:0c: iomem range 0xe0000-0xfffff could not be reserved
system 00:0c: iomem range 0x100000-0x3ffeffff could not be reserved
system 00:0c: iomem range 0x0-0x0 could not be reserved
PCI: Bridge: 0000:00:01.0
  IO window: disabled.
  MEM window: 0xfaf00000-0xfbffffff
  PREFETCH window: 0x00000000e0000000-0x00000000f9ffffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 6, 262144 bytes)
TCP established hash table entries: 131072 (order: 9, 2097152 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 3901k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1217880935.367:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
ksign: Installing public key data
Loading keyring
- Added public key 23D29F0AA2F12253
- User ID: Red Hat, Inc. (Kernel Module GPG key)
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: VIA PCI bridge detected. Disabling DAC.
Switched to high resolution mode on CPU 0
pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:01:00.0: Boot video device
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: ACPI0007:00 is registered as cooling_device0
Real Time Clock Driver v1.12ac
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0b: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please 
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
registered taskstats version 1
  Magic number: 4:154:295
  hash matches device tty28
Freeing unused kernel memory: 348k freed
Write protecting the kernel read-only data: 1128k
ACPI: PCI Interrupt 0000:00:10.4[C] -> GSI 21 (level, low) -> IRQ 21
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 21, io mem 0xfae00000
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.25.11-60.fc8 ehci_hcd
usb usb1: SerialNumber: 0000:00:10.4
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
ACPI: PCI Interrupt 0000:00:10.0[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.0: UHCI Host Controller
uhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:10.0: irq 21, io base 0x0000d400
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: UHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.25.11-60.fc8 uhci_hcd
usb usb2: SerialNumber: 0000:00:10.0
ACPI: PCI Interrupt 0000:00:10.1[A] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.1: UHCI Host Controller
uhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:10.1: irq 21, io base 0x0000d800
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
hub 1-0:1.0: unable to enumerate USB device on port 2
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.25.11-60.fc8 uhci_hcd
usb usb3: SerialNumber: 0000:00:10.1
ACPI: PCI Interrupt 0000:00:10.2[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.2: UHCI Host Controller
uhci_hcd 0000:00:10.2: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:10.2: irq 21, io base 0x0000e000
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.25.11-60.fc8 uhci_hcd
usb usb4: SerialNumber: 0000:00:10.2
ACPI: PCI Interrupt 0000:00:10.3[B] -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:10.3: UHCI Host Controller
uhci_hcd 0000:00:10.3: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:10.3: irq 21, io base 0x0000e400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.25.11-60.fc8 uhci_hcd
usb usb5: SerialNumber: 0000:00:10.3
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
libata version 3.00 loaded.
ACPI: PCI Interrupt 0000:00:0d.0[A] -> GSI 18 (level, low) -> IRQ 18
scsi0 : pata_pdc202xx_old
scsi1 : pata_pdc202xx_old
ata1: PATA max UDMA/100 cmd 0xa800 ctl 0xa400 bmdma 0x9400 irq 18
ata2: PATA max UDMA/100 cmd 0xa000 ctl 0x9800 bmdma 0x9408 irq 18
usb 2-2: new low speed USB device using uhci_hcd and address 2
ata1.00: ATA-7: Maxtor 6Y080L0, YAR41BW0, max UDMA/133
ata1.00: 160086528 sectors, multi 16: LBA
ata1.01: ATA-6: WDC WD2500JB-98GVA0, 08.02D08, max UDMA/100
ata1.01: 488397168 sectors, multi 16: LBA48
ata1.00: configured for UDMA/100
ata1.01: configured for UDMA/100
usb 2-2: configuration #1 chosen from 1 choice
input: Logitech USB Receiver as /class/input/input2
input,hidraw0: USB HID v1.10 Mouse [Logitech USB Receiver] on 
usb-0000:00:10.0-2
usb 2-2: New USB device found, idVendor=046d, idProduct=c50d
usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-2: Product: USB Receiver
usb 2-2: Manufacturer: Logitech
scsi 0:0:0:0: Direct-Access     ATA      Maxtor 6Y080L0   YAR4 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors (81964 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 160086528 512-byte hardware sectors (81964 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: Direct-Access     ATA      WDC WD2500JB-98G 08.0 PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:1:0: [sdb] 488397168 512-byte hardware sectors (250059 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdb: sdb1
sd 0:0:1:0: [sdb] Attached SCSI disk
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.13.0-ioctl (2007-10-18) initialised: 
dm-devel@redhat.com
sata_via 0000:00:0f.0: version 2.3
ACPI: PCI Interrupt 0000:00:0f.0[B] -> GSI 20 (level, low) -> IRQ 20
sata_via 0000:00:0f.0: routed to hard irq line 10
scsi2 : sata_via
scsi3 : sata_via
ata3: SATA max UDMA/133 cmd 0xd000 ctl 0xc800 bmdma 0xb800 irq 20
ata4: SATA max UDMA/133 cmd 0xc400 ctl 0xc000 bmdma 0xb808 irq 20
ata3: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
ata4: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1217880948.630:2): selinux=0 auid=4294967295 ses=4294967295
input: PC Speaker as /class/input/input3
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
ACPI: PCI interrupt for device 0000:00:0f.1 disabled
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:00:0e.0: This (id 10ec:8139 rev 10) is not an 8139C+ 
compatible chip
8139cp 0000:00:0e.0: Try the "8139too" driver instead.
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
8139too Fast Ethernet driver 0.9.28
ACPI: PCI Interrupt 0000:00:0e.0[A] -> GSI 19 (level, low) -> IRQ 19
eth0: RealTek RTL8139 at 0xffffc200004ec000, 00:50:fc:f4:c8:59, IRQ 19
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP]
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input6
ACPI: Sleep Button (CM) [SLPB]
pata_via 0000:00:0f.1: version 0.3.3
ACPI: PCI Interrupt 0000:00:0f.1[A] -> GSI 20 (level, low) -> IRQ 20
scsi4 : pata_via
scsi5 : pata_via
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xfc00 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xfc08 irq 15
ata5.00: ATA-4: QUANTUM FIREBALL CR13.0A, A5U.1200, max UDMA/66
ata5.00: 25429824 sectors, multi 16: LBA
ata5.01: ATAPI: GCR-8523B, LNUX, max MWDMA2
ata5.00: limited to UDMA/33 due to 40-wire cable
ata5.00: configured for UDMA/33
udev: renamed network interface eth0 to eth2
ata5.01: configured for MWDMA2
scsi 4:0:0:0: Direct-Access     ATA      QUANTUM FIREBALL A5U. PQ: 0 ANSI: 5
sd 4:0:0:0: [sdc] 25429824 512-byte hardware sectors (13020 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 4:0:0:0: [sdc] 25429824 512-byte hardware sectors (13020 MB)
sd 4:0:0:0: [sdc] Write Protect is off
sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
 sdc: sdc1
sd 4:0:0:0: [sdc] Attached SCSI disk
sd 4:0:0:0: Attached scsi generic sg2 type 0
scsi 4:0:1:0: CD-ROM            HL-DT-ST CD-ROM GCR-8523B LNUX PQ: 0 ANSI: 5
scsi 4:0:1:0: Attached scsi generic sg3 type 5
ACPI: PCI Interrupt 0000:00:11.5[C] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:11.5 to 64
nvidia: module license 'NVIDIA' taints kernel.
ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
NVRM: loading NVIDIA UNIX x86_64 Kernel Module  173.14.12  Thu Jul 17 
18:10:24 PDT 2008
PCI: Enabling device 0000:00:11.6 (0000 -> 0001)
ACPI: PCI Interrupt 0000:00:11.6[C] -> GSI 22 (level, low) -> IRQ 22
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 52x/52x cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:1:0: Attached scsi CD-ROM sr0
PCI: Setting latency timer of device 0000:00:11.6 to 64
ACPI: PCI interrupt for device 0000:00:11.6 disabled
VIA 82xx Modem: probe of 0000:00:11.6 failed with error -13
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode
device-mapper: multipath: version 1.0.5 loaded
loop: module loaded
EXT3 FS on dm-0, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1933304k swap on /dev/mapper/VolGroup00-LogVol01.  Priority:-1 
extents:1 across:1933304k
warning: process `kudzu' used the deprecated sysctl system call with 1.23.
powernow-k8: Found 1 AMD Athlon(tm) 64 Processor 3500+ processors (1 cpu 
cores) (version 2.20.00)
powernow-k8:    0 : fid 0xe (2200 MHz), vid 0x2
powernow-k8:    1 : fid 0xc (2000 MHz), vid 0x6
powernow-k8:    2 : fid 0xa (1800 MHz), vid 0xa
powernow-k8:    3 : fid 0x2 (1000 MHz), vid 0x12
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (8192 buckets, 32768 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
Marking TSC unstable due to cpufreq changes
Clocksource tsc unstable (delta = -64000180 ns)
eth2: link up, 100Mbps, full-duplex, lpa 0x45E1
fuse init (API version 7.9)
warning: `dbus-daemon' uses 32-bit capabilities (legacy support in use)
eth2: no IPv6 routers present
agpgart: Found an AGP 3.0 compliant device at 0000:00:00.0.
agpgart: Putting AGP V3 device at 0000:00:00.0 into 8x mode
agpgart: Putting AGP V3 device at 0000:01:00.0 into 8x mode



-- 
The only way to keep your health is to eat what you don't want, drink
what you don't like, and do what you'd rather not.
                -- Mark Twain


--------------ms030601020307040409040401
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJBzCC
At4wggJHoAMCAQICEHcAGlDwU0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoX
DTA5MDcxMjE2MDQ0NFowRDEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8G
CSqGSIb3DQEJARYSZHN0dWFydEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAqUMveSpJ7k7kMyf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj0
3/eARmjszsn/24Zn1/Iufz3xuc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQC
vWuKL3SLtX3jI4ah5L/te5w+x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/
4AZUBvl3PzD0fNZP3FS8k7aBuAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4K
ukbhuxITTWrQHDqJJAIopvP8FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQAB
oy8wLTAdBgNVHREEFjAUgRJkc3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkq
hkiG9w0BAQUFAAOBgQBHbO5t4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi4
1AAJ8wAnEeuHqJi4TMVF6lMWAOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n
/DK2cZovx/xBgVjWl7hpvk5qw6Clr4R21DbrA/GOMGcE8TCCAt4wggJHoAMCAQICEHcAGlDw
U0NqjFetNQ2D/hEwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRo
YXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBG
cmVlbWFpbCBJc3N1aW5nIENBMB4XDTA4MDcxMjE2MDQ0NFoXDTA5MDcxMjE2MDQ0NFowRDEf
MB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEhMB8GCSqGSIb3DQEJARYSZHN0dWFy
dEByb2dlcnMuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqUMveSpJ7k7k
Myf5zbslvkiz9VGDfcnCQNOFLaw9y6j0jPvvkgIXtslpofj03/eARmjszsn/24Zn1/Iufz3x
uc/XYYn7lQgf1PCTeV8bYTq81Kvh6srKbrYmPz06uXVhtGQCvWuKL3SLtX3jI4ah5L/te5w+
x/MDaflM8N0xb0UlRGeR80FwFSzk1qh+vyx+hWoUz0Gdmuc/4AZUBvl3PzD0fNZP3FS8k7aB
uAAQT1H5iUag8BFWmqAiR1QYWsjpcK4VwSfeSTDsEK7rcU4KukbhuxITTWrQHDqJJAIopvP8
FocH/uAumuNFsZLp6jvJNOft02TiGuU2CWAL1ZCW9wIDAQABoy8wLTAdBgNVHREEFjAUgRJk
c3R1YXJ0QHJvZ2Vycy5jb20wDAYDVR0TAQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQBHbO5t
4ZukqhZfwdR6RqNujNssesMxKwU2w/lXNxoPH5RssWsN3xi41AAJ8wAnEeuHqJi4TMVF6lMW
AOSuJO/OQR2gDBysHT29jrJn0bUqgOeT7KC6A7wtjabbLK0n/DK2cZovx/xBgVjWl7hpvk5q
w6Clr4R21DbrA/GOMGcE8TCCAz8wggKooAMCAQICAQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJ
BgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENhcGUxEjAQBgNVBAcTCUNhcGUgVG93bjEa
MBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAmBgNVBAsTH0NlcnRpZmljYXRpb24gU2Vy
dmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTEr
MCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1haWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcw
MDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUg
Q29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1h
aWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEFAAOBjQAwgYkCgYEAxKY8VXNV+065ypla
HmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FW
y688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79AgAJk16emu59l0cUqVIUPSAR/p7bRPGEE
QB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8ECDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2
oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3Js
MAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEaMBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0x
MzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7MDaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYf
qi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUaC4J0niVQlGLH2ydxVyWN3amcOY6MIE9l
X5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk13iSx0x1G/11fZU8xggNxMIIDbQIBATB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQdwAaUPBT
Q2qMV601DYP+ETAJBgUrDgMCGgUAoIIB0DAYBgkqhkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwG
CSqGSIb3DQEJBTEPFw0wODA4MDQyMDMxMjdaMCMGCSqGSIb3DQEJBDEWBBS1uu0T1XNleQht
s0zUf2nSvcj5SDBfBgkqhkiG9w0BCQ8xUjBQMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzAO
BggqhkiG9w0DAgICAIAwDQYIKoZIhvcNAwICAUAwBwYFKw4DAgcwDQYIKoZIhvcNAwICASgw
gYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUNg/4RMIGHBgsqhkiG9w0BCRACCzF4oHYwYjELMAkG
A1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhB3ABpQ8FNDaoxXrTUN
g/4RMA0GCSqGSIb3DQEBAQUABIIBADdF398aEF10vKUQG1qUr9zgKx4zfChrkFmGavfLnEeh
mitYQuypf6JaNnOOtjHeExGod6KMZ3N4b9jlOWud0OxzrBySyhzBw+gRoZ7KfqQzDqxpkYTa
7UHm+ZWLvDqNXDsln4aQzUUvEoKAFTLMM01DwIisj+cKYfQgybwzKychPhu/oGbVIYddmGvo
5bG0j7kmRYw7YuX6c4GckZXDsm4vYJDv5oinO4JHLNmu4dzuj/ffh05NkNrDBLp+OuJP8xwW
dSBGyyDgr2duKXSyaMSok8Y5gHbl3bTpWklvyb4wwhME6tUNyNRiagSWsK3+myvatEiwPBdH
GZc2k5scnrYAAAAAAAA=
--------------ms030601020307040409040401--
