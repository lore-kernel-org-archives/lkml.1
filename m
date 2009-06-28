Return-Path: <linux-kernel-owner+w=401wt.eu-S1754257AbZF1NFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754257AbZF1NFK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 09:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751295AbZF1NE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 09:04:59 -0400
Received: from mx.treblig.org ([80.68.94.177]:43174 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750840AbZF1NE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 09:04:56 -0400
Date: Sun, 28 Jun 2009 15:04:52 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: 2.6.{28,30} Keyboard not working on oldish machine
Message-ID: <20090628140452.GA15816@gallifrey>
References: <20090613230842.GA18347@gallifrey> <alpine.LNX.2.00.0906231038500.7457@wotan.suse.de> <20090623185814.GB24108@gallifrey> <200906231106.37460.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200906231106.37460.dmitry.torokhov@gmail.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.29.2-bytemark-kvm-tickless-2009-05-05 (i686)
X-Uptime: 15:02:18 up 33 days,  7:23,  2 users,  load average: 0.01, 0.02, 0.00
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Dmitry Torokhov (dmitry.torokhov@gmail.com) wrote:
> On Tuesday 23 June 2009 11:58:15 Dr. David Alan Gilbert wrote:

<snip>
 
> > Yep; I'm OK with the i8042.noaux from my point of view, but it's a
> > bit worrying that this used to work fine.  There's obviously been
> > a change somewhere since 2.6.18 (and as I remember from the dmesg
> > the keyboard and aux ports are being initialised in different orders).
> > (Actually I say obviously since 2.6.18 - but the 2.6.18 I tried
> > I think I only used the debian version - I should go back and
> > see if I can do a vanilla one), but this box has been running
> > Linux since the time it was originally bought with loads of distros
> > and clean kernels years ago.
> >
> > While this machine is old, the motherboard was a pretty common one
> > at the time.
> >
> 
> Any chance I could get dmesg with i8042.debug with 2.6.18? There was
> quite a large change back then when we got rid of the polling timer
> in i8042.

Apologies for the delay; attached is the dmesg from the Debian 2.6.18
in which keyboard works as previously described.

Dave

Linux version 2.6.18-6-486 (Debian 2.6.18.dfsg.1-24) (dannf@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 Sat Dec 27 08:57:46 UTC 2008
BIOS-provided physical RAM map:
 BIOS-88: 0000000000000000 - 000000000009f000 (usable)
 BIOS-88: 0000000000100000 - 0000000004000000 (usable)
64MB LOWMEM available.
On node 0 totalpages: 16384
  DMA zone: 4096 pages, LIFO batch:0
  Normal zone: 12288 pages, LIFO batch:3
DMI not present or invalid.
ACPI: Unable to locate RSDP
Allocating PCI resources starting at 10000000 (gap: 04000000:fc000000)
Detected 90.208 MHz processor.
Built 1 zonelists.  Total pages: 16384
Kernel command line: root=/dev/hda3 ro i8042.debug
No local APIC present or hardware disabled
mapped APIC to ffffd000 (01081000)
Initializing CPU#0
PID hash table entries: 512 (order: 9, 2048 bytes)
Console: colour VGA+ 80x25
Dentry cache hash table entries: 8192 (order: 3, 32768 bytes)
Inode-cache hash table entries: 4096 (order: 2, 16384 bytes)
Memory: 57648k/65536k available (1501k kernel code, 7432k reserved, 601k data, 256k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 181.01 BogoMIPS (lpj=362028)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 000001bf 00000000 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 000001bf 00000000 00000000 00000000 00000000 00000000 00000000
Intel Pentium with F0 0F bug - workaround enabled.

CPU: After all inits, caps: 000001bf 00000000 00000000 00000000 00000000 00000000 00000000
Compat vDSO mapped to ffffe000.
CPU: Intel Pentium 75 - 200 stepping 04
Checking 'hlt' instruction... OK.
checking if image is initramfs... it is
Freeing initrd memory: 4245k freed
NET: Registered protocol family 16
EISA bus registered
PCI: PCI BIOS revision 2.00 entry at 0xf3940, last bus=0
PCI: Using configuration type 2
Setting up standard PCI resources
ACPI: Interpreter disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI: disabled
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: PnP BIOS support was not detected.
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Ignoring BAR0-1 of IDE controller 0000:00:01.0
PCI: Firmware left 0000:00:0c.0 e100 interrupts enabled, disabling
NET: Registered protocol family 2
IP route cache hash table entries: 512 (order: -1, 2048 bytes)
TCP established hash table entries: 2048 (order: 1, 8192 bytes)
TCP bind hash table entries: 1024 (order: 0, 4096 bytes)
TCP: Hash tables configured (established 2048 bind 1024)
TCP reno registered
audit: initializing netlink socket (disabled)
audit(1246187673.148:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
Initializing Cryptographic API
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
serial8250: ttyS3 at I/O 0x2e8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: No PS/2 controller found. Probing ports directly.
drivers/input/serio/i8042.c: 20 -> i8042 (command) [1]
drivers/input/serio/i8042.c: 65 <- i8042 (return) [1]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [2]
drivers/input/serio/i8042.c: 5a -> i8042 (parameter) [2]
drivers/input/serio/i8042.c: fe <- i8042 (return) [2]
drivers/input/serio/i8042.c: a9 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 00 <- i8042 (return) [3]
drivers/input/serio/i8042.c: a7 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 74 <- i8042 (return) [3]
drivers/input/serio/i8042.c: a8 -> i8042 (command) [3]
drivers/input/serio/i8042.c: 20 -> i8042 (command) [4]
drivers/input/serio/i8042.c: 54 <- i8042 (return) [4]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [4]
drivers/input/serio/i8042.c: 74 -> i8042 (parameter) [4]
drivers/input/serio/i8042.c: d3 -> i8042 (command) [4]
drivers/input/serio/i8042.c: f0 -> i8042 (parameter) [4]
drivers/input/serio/i8042.c: fe <- i8042 (return) [4]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [5]
drivers/input/serio/i8042.c: 54 -> i8042 (parameter) [5]
serio: i8042 AUX port at 0x60,0x64 irq 12
drivers/input/serio/i8042.c: 60 -> i8042 (command) [5]
drivers/input/serio/i8042.c: 44 -> i8042 (parameter) [5]
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
drivers/input/serio/i8042.c: 60 -> i8042 (command) [7]
drivers/input/serio/i8042.c: 46 -> i8042 (parameter) [7]
drivers/input/serio/i8042.c: d4 -> i8042 (command) [7]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [7]
EISA: Probing bus 0 at eisa.0
EISA: Detected 0 cards.
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
NET: Registered protocol family 8
NET: Registered protocol family 20
Using IPI Shortcut mode
Time: tsc clocksource has been installed.
Freeing unused kernel memory: 256k freed
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, AUX, 0, timeout) [19]
drivers/input/serio/i8042.c: d4 -> i8042 (command) [19]
drivers/input/serio/i8042.c: ed -> i8042 (parameter) [19]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, AUX, 0, timeout) [31]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [31]
drivers/input/serio/i8042.c: 44 -> i8042 (parameter) [31]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [31]
drivers/input/serio/i8042.c: 45 -> i8042 (parameter) [31]
drivers/input/serio/i8042.c: f2 -> i8042 (kbd-data) [31]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [31]
drivers/input/serio/i8042.c: ab <- i8042 (interrupt, KBD, 1) [32]
drivers/input/serio/i8042.c: 41 <- i8042 (interrupt, KBD, 1) [32]
drivers/input/serio/i8042.c: ed -> i8042 (kbd-data) [32]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [33]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [33]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [33]
drivers/input/serio/i8042.c: f3 -> i8042 (kbd-data) [33]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [34]
drivers/input/serio/i8042.c: 00 -> i8042 (kbd-data) [34]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [35]
drivers/input/serio/i8042.c: f4 -> i8042 (kbd-data) [35]
drivers/input/serio/i8042.c: fa <- i8042 (interrupt, KBD, 1) [35]
input: AT Translated Set 2 keyboard as /class/input/input0
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
RZ100x: IDE controller at PCI slot 0000:00:01.0
RZ100x: chipset revision 1
RZ100x: not 100% native mode: will probe irqs later
ide0: disabled chipset read-ahead (buggy RZ1000/RZ1001)
ide1: disabled chipset read-ahead (buggy RZ1000/RZ1001)
Probing IDE interface ide0...
8139too Fast Ethernet driver 0.9.27
e100: Intel(R) PRO/100 Network Driver, 3.5.10-k2-NAPI
e100: Copyright(c) 1999-2005 Intel Corporation
hda: IBM-DCAA-33610, ATA DISK drive
hdb: GCD-R542B, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
eth0: RealTek RTL8139 at 0xfc80, 00:20:18:88:7a:c1, IRQ 11
eth0:  Identified 8139 chip type 'RTL-8139 rev K'
e100: eth1: e100_probe: addr 0xffbef000, irq 11, MAC addr 00:D0:B7:BF:81:57
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:00:0e.0: 3Com PCI 3c905C Tornado at c4834f80.
8139cp: 10/100 PCI Ethernet driver v1.2 (Mar 22, 2004)
hda: max request size: 128KiB
hda: 7056000 sectors (3612 MB) w/96KiB Cache, CHS=7000/16/63
hda: cache flushes not supported
 hda: hda1 hda2 < hda5 > hda3
hdb: ATAPI 4X CD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
Attempting manual resume
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
udevd version 125 started
input: PC Speaker as /class/input/input1
drivers/input/serio/i8042.c: 60 -> i8042 (command) [13956]
drivers/input/serio/i8042.c: 47 -> i8042 (parameter) [13956]
drivers/input/serio/i8042.c: d4 -> i8042 (command) [13956]
drivers/input/serio/i8042.c: f2 -> i8042 (parameter) [13956]
drivers/input/serio/i8042.c: fe <- i8042 (interrupt, AUX, 0, timeout) [13969]
drivers/input/serio/i8042.c: 60 -> i8042 (command) [13969]
drivers/input/serio/i8042.c: 45 -> i8042 (parameter) [13969]
Adding 176672k swap on /dev/hda5.  Priority:-1 extents:1 across:176672k
EXT3 FS on hda3, internal journal
loop: loaded (max 8 devices)
device-mapper: ioctl: 4.7.0-ioctl (2006-06-24) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
e100: eth1: e100_watchdog: link up, 100Mbps, full-duplex
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
IPv6 over IPv4 tunneling driver
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth2:  setting full-duplex.
ip_tables: (C) 2000-2006 Netfilter Core Team
eth1: no IPv6 routers present
eth0: no IPv6 routers present
eth2: no IPv6 routers present
Netfilter messages via NETLINK v0.30.
ip_conntrack version 2.4 (512 buckets, 4096 max) - 224 bytes per conntrack
Bridge firewalling registered
ip_conntrack_pptp version 3.1 loaded
ip_nat_pptp version 3.0 loaded
ClusterIP Version 0.8 loaded successfully
ip6_tables: (C) 2000-2006 Netfilter Core Team
parport0: PC-style at 0x378 [PCSPP,EPP]
parport1: PC-style at 0x278 (0x678) [PCSPP,TRISTATE]
parport1: irq 7 detected
lp0: using parport0 (polling).
lp1: using parport1 (polling).
ppdev: user-space parallel port driver
eth0: link down
eth0: media is unconnected, link down, or incompatible connection
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
eth0: link down
eth0: media is unconnected, link down, or incompatible connection
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    | Running GNU/Linux on Alpha,68K| Happy  \ 
\ gro.gilbert @ treblig.org | MIPS,x86,ARM,SPARC,PPC & HPPA | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
