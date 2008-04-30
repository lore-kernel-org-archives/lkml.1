Return-Path: <linux-kernel-owner+w=401wt.eu-S1763348AbYD3SFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763348AbYD3SFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 14:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757656AbYD3SEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 14:04:48 -0400
Received: from organa.snhdns.com ([208.76.82.131]:34024 "EHLO
	organa.snhdns.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbYD3SEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 14:04:43 -0400
Message-ID: <4818B657.7090403@metricsystems.com>
Date: Wed, 30 Apr 2008 11:11:35 -0700
From: John Clark <jclark@metricsystems.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.13) Gecko/20080313
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: Problem with 8250_pnp Module and using ttyS0 as console
References: <48189FE7.9040208@metricsystems.com> <20080430180133.1e1f940b@core>
In-Reply-To: <20080430180133.1e1f940b@core>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - organa.snhdns.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - metricsystems.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox schrieb:
> On Wed, 30 Apr 2008 09:35:51 -0700
> John Clark <jclark@metricsystems.com> wrote:
>
>   
>> Linux version... at least as far back as 2.6.19 and upto and including 
>> the latest
>> one I've tested, 2.6.25.
>>
>>
>> When the kernel has been configured to use ttyS0 as the console port, via
>> modification of the boot command line, 'console=ttyS0,115200', the kernel
>> ultimately traps with an exception, if the module "8250_pnp.ko" is loaded.
>>
>> Removing this module eliminates the fault.
>>
>> Is this a problem or a documented incompatibility?
>>     
>
> Hard to tell without the trace. Can you capture the trace and let me
> know. It's not supposed to give you an exception but we need to see the
> exception to change that.
>   

Here is the boot sequence for my linux-2.6.25 build. When I did a 
search, I found a few
others who have had a similar problem with other kernel versions.

John Clark.


-------------------------------------------------------------------

root  (hd0,0)
 Filesystem type is ext2fs, partition type 0x83
kernel  /boot/vmlinuz-2.6.25-wanpipe-3.3.8-v1.0 root=/dev/sda1 ro 
console=ttyS0
,115200
   [Linux-bzImage, setup=0x2c00, size=0x282f5c]
savedefault

Linux version 2.6.25-wanpipe-3.3.8-v1.0 (root@astrotac_relay) (gcc 
version 4.2.1 (Debian 4.2.1-5)) #2 SMP Fri Apr 25 1
7:06:39 PDT 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001f7f0000 (usable)
 BIOS-e820: 000000001f7f0000 - 000000001f7f3000 (ACPI NVS)
 BIOS-e820: 000000001f7f3000 - 000000001f800000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
503MB LOWMEM available.
Scan SMP from c0000000 for 1024 bytes.
Scan SMP from c009fc00 for 1024 bytes.
Scan SMP from c00f0000 for 65536 bytes.
found SMP MP-table at [c00f5020] 000f5020
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   129008
  HighMem    129008 ->   129008
Movable zone start PFN for each node
early_node_map[1] active PFN ranges
    0:        0 ->   129008
DMI 2.2 present.
Intel MultiProcessor Specification v1.1
    Virtual Wire compatibility mode.
OEM ID: OEM00000 Product ID: PROD00000000 APIC at: 0xFEE00000
Processor #0 15:4 APIC version 17
I/O APIC #2 Version 17 at 0xFEC00000.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Processors: 1
Allocating PCI resources starting at 20000000 (gap: 1f800000:c0800000)
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 128001
Kernel command line: root=/dev/sda1 ro console=ttyS0,115200
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 2048 (order: 11, 8192 bytes)
Detected 3000.300 MHz processor.
Console: colour VGA+ 80x25
console [ttyS0] enabled
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Memory: 505796k/516032k available (2997k kernel code, 9776k reserved, 
1676k data, 228k init, 0k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff51000 - 0xfffff000   ( 696 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xe0000000 - 0xff7fe000   ( 503 MB)
    lowmem  : 0xc0000000 - 0xdf7f0000   ( 503 MB)
      .init : 0xc059b000 - 0xc05d4000   ( 228 kB)
      .data : 0xc03ed790 - 0xc0590938   (1676 kB)
      .text : 0xc0100000 - 0xc03ed790   (2997 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
Calibrating delay using timer specific routine.. 6006.03 BogoMIPS 
(lpj=12012061)
Security Framework initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 1024K
CPU: Physical Processor ID: 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 26k freed
CPU0: Intel(R) Pentium(R) 4 CPU 3.00GHz stepping 09
Total of 1 processors activated (6006.03 BogoMIPS).
ExtINT not setup in hardware but reported by MP table
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=0 pin2=0
Brought up 1 CPUs
net_namespace: 548 bytes
NET: Registered protocol family 16
PCI: PCI BIOS revision 3.00 entry at 0xfb3b0, last bus=5
PCI: Using configuration type 1
Setting up standard PCI resources
Linux Plug and Play Support v0.97 (c) Adam Belay
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fbf70
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xbfa0, dseg 0xf0000
PnPBIOS: 15 nodes reported by PnP BIOS; 15 recorded by driver
SCSI subsystem initialized
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Probing PCI hardware
pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
pci 0000:00:1f.0: quirk: region 0480-04bf claimed by ICH6 GPIO
PCI: Transparent bridge - 0000:00:1e.0
PCI: Cannot allocate resource region 0 of device 0000:01:00.0
PCI: Cannot allocate resource region 0 of device 0000:02:00.0
PCI: Cannot allocate resource region 0 of device 0000:03:00.0
PCI: Cannot allocate resource region 0 of device 0000:04:00.0
NET: Registered protocol family 8
NET: Registered protocol family 20
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0xffb00000-0xffb7ffff could not be reserved
system 00:08: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:08: iomem range 0xfec00000-0xfec0ffff could not be reserved
system 00:08: iomem range 0xfee00000-0xfee0ffff could not be reserved
system 00:08: iomem range 0x100000-0xffffff could not be reserved
system 00:09: iomem range 0xe0000-0xeffff has been reserved
system 00:09: iomem range 0xf0000-0xf3fff could not be reserved
system 00:09: iomem range 0xf4000-0xf7fff could not be reserved
system 00:09: iomem range 0xf8000-0xfffff could not be reserved
system 00:09: iomem range 0xcc000-0xcffff has been reserved
PCI: Bridge: 0000:00:1c.0
  IO window: b000-bfff
  MEM window: 0xfd700000-0xfd7fffff
  PREFETCH window: 0x00000000fde00000-0x00000000fdefffff
PCI: Bridge: 0000:00:1c.1
  IO window: a000-afff
  MEM window: 0xfdd00000-0xfddfffff
  PREFETCH window: 0x00000000fdc00000-0x00000000fdcfffff
PCI: Bridge: 0000:00:1c.2
  IO window: e000-efff
  MEM window: 0xfdb00000-0xfdbfffff
  PREFETCH window: 0x00000000fda00000-0x00000000fdafffff
PCI: Bridge: 0000:00:1c.3
  IO window: d000-dfff
  MEM window: 0xfd900000-0xfd9fffff
  PREFETCH window: 0x00000000fd800000-0x00000000fd8fffff
PCI: Bridge: 0000:00:1e.0
  IO window: c000-cfff
  MEM window: 0xfd200000-0xfd6fffff
  PREFETCH window: 0x00000000fd100000-0x00000000fd1fffff
NET: Registered protocol family 2
IP route cache hash table entries: 4096 (order: 2, 16384 bytes)
TCP established hash table entries: 16384 (order: 5, 131072 bytes)
TCP bind hash table entries: 16384 (order: 5, 131072 bytes)
TCP: Hash tables configured (established 16384 bind 16384)
TCP reno registered
audit: initializing netlink socket (disabled)
type=2000 audit(1209556183.638:1): initialized
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NTFS driver 2.1.29 [Flags: R/W].
fuse init (API version 7.9)
io scheduler noop registered
io scheduler anticipatory registered (default)
io scheduler deadline registered
io scheduler cfq registered
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
assign_interrupt_mode Found MSI capability
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
intel_rng: FWH not detected
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
parport_pc 00:0e: reported by Plug and Play BIOS
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
brd: module loaded
loop: module loaded
nbd: registered device at major 43
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
e1000: 0000:05:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:03:2d:09:05:0a
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
e1000: 0000:05:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:03:2d:09:05:0b
e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
sky2 0000:01:00.0: v1.21 addr 0xfd700000 irq 15 Yukon-EC (0xb6) rev 1
sky2 eth2: addr 00:03:2d:09:05:0c
sky2 0000:02:00.0: v1.21 addr 0xfdd00000 irq 11 Yukon-EC (0xb6) rev 1
sky2 eth3: addr 00:03:2d:09:05:0d
sky2 0000:03:00.0: v1.21 addr 0xfdb00000 irq 10 Yukon-EC (0xb6) rev 1
sky2 eth4: addr 00:03:2d:09:05:0e
sky2 0000:04:00.0: v1.21 addr 0xfd900000 irq 15 Yukon-EC (0xb6) rev 1
sky2 eth5: addr 00:03:2d:09:05:0f
tun: Universal TUN/TAP device driver, 1.6
tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
Driver 'sd' needs updating - please use bus_type methods
Driver 'sr' needs updating - please use bus_type methods
scsi0 : ata_piix
scsi1 : ata_piix
ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
ata1.00: ATA-0: SMI MODEL, 20070312, max MWDMA2
ata1.00: 3964464 sectors, multi 0: LBA
ata1.00: configured for MWDMA2
ata1.00: configured for MWDMA2
ata1: EH complete
scsi 0:0:0:0: Direct-Access     ATA      SMI MODEL        2007 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 3964464 512-byte hardware sectors (2030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 3964464 512-byte hardware sectors (2030 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled, doesn't 
support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
sd 0:0:0:0: Attached scsi generic sg0 type 0
usbmon: debugfs is not available
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 11, io base 0x0000fe00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 15, io base 0x0000fd00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 10, io base 0x0000fc00
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
uhci_hcd 0000:00:1d.3: UHCI Host Controller
uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.3: irq 15, io base 0x0000fb00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usbcore: registered new interface driver libusual
usbcore: registered new interface driver usbserial
drivers/usb/serial/usb-serial.c: USB Serial support registered for generic
usbcore: registered new interface driver usbserial_generic
drivers/usb/serial/usb-serial.c: USB Serial Driver core
drivers/usb/serial/usb-serial.c: USB Serial support registered for 
DeLorme Earthmate USB
drivers/usb/serial/usb-serial.c: USB Serial support registered for 
HID->COM RS232 Adapter
drivers/usb/serial/usb-serial.c: USB Serial support registered for Nokia 
CA-42 V2 Adapter
usbcore: registered new interface driver cypress
drivers/usb/serial/cypress_m8.c: Cypress USB to Serial Driver v1.09
PNP: PS/2 Controller [PNP0303] at 0x60,0x64 irq 1
PNP: PS/2 appears to have AUX port disabled, if this is incorrect please 
boot with i8042.nopnp
serio: i8042 KBD port at 0x60,0x64 irq 1
NET: Registered protocol family 26
GACT probability on
Mirror/redirect action on
Simple TC action Loaded
netem: version 1.2
u32 classifier
    Performance counters on
    input device check on
    Actions configured
IPv4 over IPv4 tunneling driver
GRE over IPv4 tunneling driver
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
tunl0: Disabled Privacy Extensions
Mobile IPv6
IPv6 over IPv4 tunneling driver
sit0: Disabled Privacy Extensions
NET: Registered protocol family 17
Bridge firewalling registered
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
Using IPI No-Shortcut mode
drivers/rtc/hctosys.c: unable to open rtc device (rtc0)
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
VFS: Mounted root (ext2 filesystem) readonly.
Freeing unused kernel memory: 228k freed
Mount failed for selinuxfs on /selinux:  No such file or directory
INIT: version 2.86 booting
configuring network interfaces from /etc/safari
/etc/rcS.d/S02ethernetSetup: line 9: /etc/network/interfaces: Read-only 
file system
Starting the hotplug events dispatcher: udevd.
Synthesizing the initial hotplug events...done.
Waiting for /dev to be fully populated...Linux agpgart interface v0.103
agpgart: Detected an Intel 915G Chipset.
agpgart: Detected 7932K stolen memory.
agpgart: AGP aperture is 256M @ 0xd0000000
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 5
ehci_hcd 0000:00:1d.7: irq 11, io mem 0xfdfff000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 8 ports detected
input: PC Speaker as /class/input/input0
Real Time Clock Driver v1.12ac
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:10: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:12: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
BUG: unable to handle kernel NULL pointer dereference at 0000000c
IP: [<c02a0dbd>] uart_write_room+0x9/0x16
*pde = 00000000
Oops: 0000 [#1] SMP
Modules linked in: evdev 8250_pnp rtc pcspkr i2c_i801 i2c_core ehci_hcd 
intel_agp agpgart

Pid: 976, comm: S03udev Not tainted (2.6.25-wanpipe-3.3.8-v1.0 #2)
EIP: 0060:[<c02a0dbd>] EFLAGS: 00010206 CPU: 0
EIP is at uart_write_room+0x9/0x16
EAX: df169800 EBX: 00000006 ECX: df319f3c EDX: 00000000
ESI: df16c400 EDI: df192c00 EBP: 00000006 ESP: df319f1c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process S03udev (pid: 976, ti=df318000 task=de97a620 task.ti=df318000)
Stack: c0294787 df192c00 df0dd280 df16c518 c0290cac 00000000 de97a620 
c01185ba
       df16c51c df16c51c 00000006 df16c400 00000006 00000000 c0292753 
00000006
       00000006 080f6408 df0dd280 c029469b df16c40c df0dd280 080f6408 
c0293c3a
Call Trace:
 [<c0294787>] write_chan+0xec/0x29c
 [<c0290cac>] tty_ldisc_try+0x2c/0x31
 [<c01185ba>] default_wake_function+0x0/0x8
 [<c0292753>] tty_write+0x131/0x1ac
 [<c029469b>] write_chan+0x0/0x29c
 [<c0293c3a>] redirected_tty_write+0x0/0x6b
 [<c015caed>] vfs_write+0x83/0xfc
 [<c015d021>] sys_write+0x3c/0x63
 [<c0103792>] syscall_call+0x7/0xb
 [<c03e0000>] pci_scan_child_bus+0x2f/0x77
 =======================
Code: 09 08 8b 40 10 74 09 81 60 10 ff ff ff fd eb 07 81 48 10 00 00 00 
02 8b 5e 6c 89 f0 ff 53 2c 5b 5e c3 8b 80 44 0
1 00 00 8b 50 10 <8b> 42 0c 48 2b 42 08 25 ff 0f 00 00 c3 8b 80 44 01 00 
00 8b 50
EIP: [<c02a0dbd>] uart_write_room+0x9/0x16 SS:ESP 0068:df319f1c
---[ end trace c18f1edf42461910 ]---
Clocksource tsc unstable (delta = 124312690 ns)


