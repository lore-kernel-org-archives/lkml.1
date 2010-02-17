Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0BQUul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:50:41 -0500
Received: from mail.gmx.net ([213.165.64.20]:37194 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755315Ab0BQUuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:50:39 -0500
X-Authenticated: #2387525
X-Provags-ID: V01U2FsdGVkX186FpMaDL46HrbNwk0SO3YX/1hNXLYR/64GlJa4PR
	oPJo2QF1jz5oIX
Message-ID: <4B7C5696.7030609@gmx.de>
Date: Wed, 17 Feb 2010 21:50:30 +0100
From: Axel Uhl <axel.uhl@gmx.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Kernel Bug in ATA or SMART area
References: <4B72941A.7060704@gmx.de> <4B74BDCF.1010805@kernel.org> <4B74F263.1060709@gmx.de> <4B7505CA.60409@kernel.org> <4B75154B.8030507@gmx.de> <4B7B548B.4040606@kernel.org>
In-Reply-To: <4B7B548B.4040606@kernel.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050903010108000806040400"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46999999999999997
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050903010108000806040400
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here's what /var/log/dmesg contains:

g Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Root Bridge [PCI1] (0000:80)
pci 0000:80:01.0: reg 10 64bit mmio: [0xfe9fc000-0xfe9fffff]
pci 0000:80:01.0: PME# supported from D0 D3hot D3cold
pci 0000:80:01.0: PME# disabled
pci_bus 0000:80: on NUMA node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 *10 11 12 14 15)
vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
vgaarb: loaded
SCSI subsystem initialized
libata version 3.00 loaded.
PCI: Using ACPI for IRQ routing
Switching to clocksource tsc
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 17 devices
ACPI: ACPI bus type pnp unregistered
system 00:09: ioport range 0x295-0x296 has been reserved
system 00:09: ioport range 0x3e0-0x3e7 has been reserved
system 00:09: ioport range 0x4d0-0x4d1 has been reserved
system 00:09: ioport range 0x800-0x87f has been reserved
system 00:09: ioport range 0x400-0x41f has been reserved
system 00:09: iomem range 0xfe9fc000-0xfe9fffff has been reserved
system 00:09: iomem range 0xffb80000-0xffbfffff has been reserved
system 00:0a: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:0a: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
system 00:0f: iomem range 0x0-0x9ffff could not be reserved
system 00:0f: iomem range 0xc0000-0xcffff could not be reserved
system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
system 00:0f: iomem range 0x100000-0x3fffffff could not be reserved
system 00:0f: iomem range 0xfff80000-0xffffffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xfc700000-0xfe7fffff
pci 0000:00:01.0:   PREFETCH window: 0xcff00000-0xdfefffff
pci 0000:00:02.0: PCI bridge, secondary bus 0000:02
pci 0000:00:02.0:   IO window: 0x1000-0x1fff
pci 0000:00:02.0:   MEM window: 0xfe800000-0xfe8fffff
pci 0000:00:02.0:   PREFETCH window: 0x40000000-0x401fffff
pci 0000:00:01.0: setting latency timer to 64
pci 0000:00:02.0: enabling device (0106 -> 0107)
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
pci 0000:00:02.0: PCI INT A -> Link[LNKH] -> GSI 10 (level, low) -> IRQ 10
pci 0000:00:02.0: setting latency timer to 64
pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
pci_bus 0000:01: resource 1 mem: [0xfc700000-0xfe7fffff]
pci_bus 0000:01: resource 2 pref mem [0xcff00000-0xdfefffff]
pci_bus 0000:02: resource 0 io:  [0x1000-0x1fff]
pci_bus 0000:02: resource 1 mem: [0xfe800000-0xfe8fffff]
pci_bus 0000:02: resource 2 pref mem [0x40000000-0x401fffff]
pci_bus 0000:80: resource 0 io:  [0x00-0xffff]
pci_bus 0000:80: resource 1 mem: [0x000000-0xffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
RPC: Registered tcp NFSv4.1 backchannel transport module.
pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:01:00.0: Boot video device
apm: BIOS version 1.2 Flags 0x02 (Driver version 1.16ac)
apm: overridden by ACPI.
highmem bounce pool size: 64 pages
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
msgmni has been set to 1749
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
input: Power Button as /class/input/input0
ACPI: Power Button [PWRB]
input: Power Button as /class/input/input1
ACPI: Power Button [PWRF]
processor LNXCPU:00: registered as cooling_device0
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12b
Linux agpgart interface v0.103
agpgart: Detected VIA PT880 Ultra chipset
agpgart-via 0000:00:00.0: AGP aperture is 64M @ 0xf8000000
FDC 0 is a post-1991 82077
brd: module loaded
loop: module loaded
Uniform Multi-Platform E-IDE driver
via82cxxx 0000:00:0f.1: VIA vt8237a (rev 00) IDE UDMA133
via82cxxx 0000:00:0f.1: IDE controller (0x1106:0x0571 rev 0x07)
via82cxxx 0000:00:0f.1: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xfc00-0xfc07
     ide1: BM-DMA at 0xfc08-0xfc0f
Probing IDE interface ide0...
hda: Maxtor 6L300R0, ATA DISK drive
hdb: Maxtor 6L300R0, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/133 mode selected
hdb: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/133 mode selected
Probing IDE interface ide1...
hdc: SAMSUNG SP1614N, ATA DISK drive
hdd: Maxtor 6L300R0, ATA DISK drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: UDMA/100 mode selected
hdd: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdd: UDMA/133 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ide_generic: please use "probe_mask=0x3f" module parameter for probing 
all legac
y ISA IDE ports
ide-gd driver 1.18
hda: max request size: 512KiB
hda: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hda: cache flushes supported
  hda: hda1
hdb: max request size: 512KiB
hdb: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hdb: cache flushes supported
  hdb: hdb1 hdb2
hdc: max request size: 512KiB
hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
hdc: cache flushes supported
  hdc: hdc1
hdd: max request size: 512KiB
hdd: 586114704 sectors (300090 MB) w/16384KiB Cache, CHS=36483/255/63
hdd: cache flushes supported
  hdd: hdd1
SCSI Media Changer driver v0.25
sata_promise 0000:00:0a.0: version 2.12
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
sata_promise 0000:00:0a.0: PCI INT A -> Link[LNKC] -> GSI 10 (level, 
low) -> IRQ
  10
scsi0 : sata_promise
scsi1 : sata_promise
scsi2 : sata_promise
scsi3 : sata_promise
ata1: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe380 irq 10
ata2: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe280 irq 10
ata3: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe200 irq 10
ata4: SATA max UDMA/133 mmio m4096@0xfebfe000 ata 0xfebfe300 irq 10
sata_via 0000:00:0f.0: version 2.4
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
sata_via 0000:00:0f.0: PCI INT B -> Link[LNKB] -> GSI 10 (level, low) -> 
IRQ 10
sata_via 0000:00:0f.0: routed to hard irq line 10
scsi4 : sata_via
scsi5 : sata_via
ata5: SATA max UDMA/133 cmd 0xe000 ctl 0xdc00 bmdma 0xd480 irq 10
ata6: SATA max UDMA/133 cmd 0xd880 ctl 0xd800 bmdma 0xd488 irq 10
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
cpuidle: using governor ladder
Netfilter messages via NETLINK v0.30.
ip_tables: (C) 2000-2006 Netfilter Core Team
arp_tables: (C) 2002 David S. Miller
TCP cubic registered
NET: Registered protocol family 17
p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation available
input: AT Translated Set 2 keyboard as /class/input/input2
ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata5.00: ATA-7: ST3500630AS, 3.AAK, max UDMA/133
ata5.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: configured for UDMA/133
ata1.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
ata1.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO
  or FUA
  sda:
sd 0:0:0:0: Attached scsi generic sg0 type 0
  sda1
sd 0:0:0:0: [sda] Attached SCSI disk
input: ImPS/2 Logitech Wheel Mouse as /class/input/input3
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
scsi 4:0:0:0: Direct-Access     ATA      ST3500630AS      3.AA PQ: 0 ANSI: 5
sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
sd 4:0:0:0: [sdb] Write Protect is off
sd 4:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO
  or FUA
  sdb:
sd 4:0:0:0: Attached scsi generic sg1 type 0
  sdb1
sd 4:0:0:0: [sdb] Attached SCSI disk
ata6: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with writeback data mode.
VFS: Mounted root (ext3 filesystem) readonly on device 8:1.
Freeing unused kernel memory: 320k freed
Intel(R) PRO/1000 Network Driver - version 7.3.21-k5-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e1000 0000:00:09.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) -> IRQ 10
e1000 0000:00:09.0: PCI: Disallowing DAC for device
e1000: 0000:00:09.0: e1000_probe: (PCI:33MHz:32-bit) 00:1b:21:01:89:8c
via-rhine.c:v1.10-LK1.4.3 2007-03-06 Written by Donald Becker
Linux video capture interface: v2.00
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
saa7130/34: v4l2 driver version 0.2.15 loaded
Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0d: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
via-rhine 0000:00:12.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) 
-> IRQ 11

eth1: VIA Rhine II at 0x1e800, 00:19:66:21:66:47, IRQ 11.
eth1: MII PHY found at address 1, status 0x7849 advertising 05e1 Link 0000.
ehci_hcd 0000:00:10.4: PCI INT C -> Link[LNKC] -> GSI 10 (level, low) -> 
IRQ 10
ehci_hcd 0000:00:10.4: EHCI Host Controller
ehci_hcd 0000:00:10.4: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:10.4: irq 10, io mem 0xfebff800
ehci_hcd 0000:00:10.4: USB 2.0 started, EHCI 1.00
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 8 ports detected
saa7134 0000:00:0c.0: PCI INT A -> Link[LNKA] -> GSI 11 (level, low) -> 
IRQ 11
saa7133[0]: found at 0000:00:0c.0, rev: 209, irq: 11, latency: 32, mmio: 
0xfebff
000
saa7133[0]: subsystem: 1461:2c05, board: AverTV DVB-T 777 
[card=85,insmod option
]
saa7133[0]: board init: gpio is 2ba00
input: saa7134 IR (AverTV DVB-T 777) as /class/input/input4
IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
udev: renamed network interface eth1 to eth5
udev: renamed network interface eth0 to eth6
saa7133[0]: i2c eeprom 00: 61 14 05 2c 00 00 00 00 00 00 00 00 00 00 00 00
saa7133[0]: i2c eeprom 10: 00 ff 82 0e ff 20 ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 20: 01 40 01 02 02 03 03 01 08 ff 00 a8 ff ff ff ff
saa7133[0]: i2c eeprom 30: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 40: ff 32 00 c0 86 1e ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 50: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 60: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 70: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 80: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom 90: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom a0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom b0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom c0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom d0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom e0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
saa7133[0]: i2c eeprom f0: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
i2c i2c-0: Invalid 7-bit address 0x7a
saa7133[0]: registered device video0 [v4l2]
saa7133[0]: registered device vbi0
dvb_init() allocating 1 frontend
HDA Intel 0000:80:01.0: PCI INT A -> Link[LNKB] -> GSI 10 (level, low) 
-> IRQ 10

HDA Intel 0000:80:01.0: setting latency timer to 64
HDA Intel 0000:80:01.0: PCI: Disallowing DAC for device
tuner-simple 0-0061: unable to probe Philips TD1316 Hybrid Tuner, 
proceeding any
way.
tuner-simple 0-0061: creating new instance
tuner-simple 0-0061: type set to 67 (Philips TD1316 Hybrid Tuner)
DVB: registering new adapter (saa7133[0])
DVB: registering adapter 0 frontend 0 (Zarlink MT352 DVB-T)...
hda_codec: ALC888: BIOS auto-probing.
saa7134 ALSA driver for DMA sound loaded
IRQ 11/saa7133[0]: IRQF_DISABLED is not guaranteed on shared IRQs
saa7133[0]/alsa: saa7133[0] at 0xfebff000 irq 11 registered as card -1
hda: UDMA/133 mode selected
hda: UDMA/100 mode selected
hda: UDMA/100 mode selected
hdb: UDMA/133 mode selected
hdb: UDMA/100 mode selected
hdb: UDMA/100 mode selected
hdc: UDMA/100 mode selected
hdc: UDMA/100 mode selected
hdc: UDMA/100 mode selected
hdd: UDMA/133 mode selected
hdd: UDMA/100 mode selected
hdd: UDMA/100 mode selected
Adding 4964076k swap on /dev/hdb2.  Priority:-1 extents:1 across:4964076k
EXT3 FS on sda1, internal journal
i2c /dev entries driver
w83627hf: Found W83697HF chip at 0x290
PPP generic driver version 2.4.2
PPP Deflate Compression module registered
Initializing USB Mass Storage driver...
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
PPP BSD Compression module registered
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdc1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hdd1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sdb1, internal journal
EXT3-fs: mounted filesystem with writeback data mode.
e1000: eth6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
e1000: eth6 changing MTU from 1500 to 7200
NET: Registered protocol family 10
ADDRCONF(NETDEV_UP): eth6: link is not ready
e1000: eth6 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
ADDRCONF(NETDEV_CHANGE): eth6: link becomes ready
eth5: link down
ADDRCONF(NETDEV_UP): eth5: link is not ready

Cheers,
-- Axel

Tejun Heo wrote:
> Hello,
> 
> On 02/12/2010 05:46 PM, Axel Uhl wrote:
>> I don't have a /var/log/boot.msg, only a /var/log/boot. Its contents:
> 
> Then please attach output of dmesg after boot.
> 
> Thanks.
> 

-- 
Find Security Certificate at http://www.axel-uhl.de/cgi-bin/cacert.cgi

--------------ms050903010108000806040400
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
4oGXnwwUeCAgmLWuAAAAAAAA
--------------ms050903010108000806040400--
