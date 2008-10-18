Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbYJRKJ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbYJRKJ0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 06:09:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYJRKJR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 06:09:17 -0400
Received: from host86-158-139-183.range86-158.btcentralplus.com ([86.158.139.183]:49972
	"EHLO oak.selfip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbYJRKJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 06:09:11 -0400
X-Greylist: delayed 703 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 Oct 2008 06:09:11 EDT
Message-ID: <48F9B2FE.1030306@oak.selfip.net>
Date: Sat, 18 Oct 2008 10:57:18 +0100
From: Dave Haywood <tla@oak.selfip.net>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: PROBLEM: Oops 2.6.27-05178-g2e532d6
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000800030808000900040707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000800030808000900040707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

PROBLEM:
 Oops: BUG: unable to handle kernel NULL pointer dereference at 00000020

/proc/version:

    Linux version 2.6.27-05178-g2e532d6 (tla@s1) (gcc version 4.3.2 (Gentoo 4.3.2 p1.0) ) #257 Fri Oct 17 09:58:13 BST 2008

scripts/ver_linux
Linux s1 2.6.27-05178-g2e532d6 #257 Fri Oct 17 09:58:13 BST 2008 i686 Pentium III (Coppermine) GenuineIntel GNU/Linux

Gnu C                  4.3.2
Gnu make               3.81
binutils               2.18
util-linux             2.13.1.1
mount                  2.13.1.1
module-init-tools      3.4
e2fsprogs              1.40.9
PPP                    2.4.4
Linux C Library        2.6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.13
oprofile               0.9.3
Sh-utils               6.10
udev                   124

/proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 6
cpu MHz         : 930.291
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
bogomips        : 1860.58
clflush size    : 32
power management:

/proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.1
  0170-0177 : piix
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : piix
0376-0376 : 0000:00:1f.1
  0376-0376 : piix
03c0-03df : vga+
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : piix
0400-041f : pnp 00:0d
0420-043f : pnp 00:0d
0440-045f : pnp 00:0d
0460-047f : pnp 00:0d
  0460-0461 : ACPI PM1b_CNT_BLK
04d0-04d1 : pnp 00:0c
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus 0000:02
  1000-10ff : 0000:02:09.0
    1000-10ff : 8139too
  1400-14ff : 0000:02:0a.0
    1400-14ff : 8139too
2000-20ff : 0000:00:1f.5
2400-243f : 0000:00:1f.5
2440-245f : 0000:00:1f.2
  2440-245f : uhci_hcd
2460-246f : 0000:00:1f.1
  2460-246f : piix
f800-f87f : 0000:00:1f.0
  f800-f803 : ACPI PM1a_EVT_BLK
  f804-f805 : ACPI PM1a_CNT_BLK
  f808-f80b : ACPI PM_TMR
  f810-f815 : ACPI CPU throttle
  f828-f82b : ACPI GPE0_BLK
fa00-fa3f : 0000:00:1f.0
  fa00-fa3f : pnp 00:0d
fc00-fc7f : pnp 00:0d
fc80-fcff : pnp 00:0d
fe00-fe7f : pnp 00:0d
fe80-feff : pnp 00:0d

/proc/iomem
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000e0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-0fecffff : System RAM
  00100000-00423f68 : Kernel code
  00423f69-00544d3b : Kernel data
  00593000-008b9437 : Kernel bss
0fed0000-0feeffff : ACPI Non-volatile Storage
0fef0000-0fefffff : System RAM
40000000-407fffff : PCI Bus 0000:02
  40000000-4000ffff : 0000:02:08.0
  40100000-40100fff : 0000:02:08.1
  40200000-402000ff : 0000:02:09.0
    40200000-402000ff : 8139too
  40300000-403000ff : 0000:02:0a.0
    40300000-403000ff : 8139too
  40400000-4040007f : 0000:02:08.1
  40500000-4050003f : 0000:02:08.0
40800000-4087ffff : 0000:00:02.0
44000000-47ffffff : 0000:00:02.0
fee00000-fee00fff : Local APIC
feea0000-ffffffff : reserved

lshw
s1
    description: Desktop Computer
    product: Deskpro
    vendor: Compaq
    serial: 8121FR4Z0GGP
    width: 32 bits
    capabilities: smbios-2.3 dmi-2.3 smp-1.4 smp
    configuration: boot=normal chassis=desktop cpus=1 uuid=D0A1A720-D04F-D511-8F86-3ADD3FD0481D
  *-core
       description: Motherboard
       product: 06C4h
       vendor: Compaq
       physical id: 0
       serial: 8121FR4Z0GGP
     *-firmware
          description: BIOS
          vendor: Compaq
          physical id: 1
          version: 686P0 v2.04 (06/12/2001)
          size: 128KiB
          capacity: 448KiB
          capabilities: pci pnp apm upgrade shadowing escd cdboot bootselect edd int13floppynec int13floppytoshiba int13floppy360 int13floppy1200 int13floppy720 int5printscreen int9keyboard int14serial int17printer acpi usb agp ls120boot zipboot biosbootspecification netboot
     *-cpu
          description: CPU
          product: Pentium III (Coppermine)
          vendor: Intel Corp.
          physical id: 5
          bus info: cpu@0
          version: 6.8.6
          slot: XU1
          size: 933MHz
          capacity: 2300MHz
          width: 32 bits
          clock: 133MHz
          capabilities: boot fpu fpu_exception wp vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 mmx fxsr sse
        *-cache:0
             description: L1 cache
             physical id: 6
             slot: Internal L1 Cache
             size: 32KiB
             capacity: 32KiB
             capabilities: burst internal write-back
        *-cache:1
             description: L2 cache
             physical id: 7
             slot: Cache L2
             size: 256KiB
             capacity: 4MiB
             capabilities: burst internal write-back
     *-memory:0
          description: System Memory
          physical id: 21
          slot: System board or motherboard
          capacity: 512MiB
        *-bank:0
             description: DIMM SDRAM Synchronous 133 MHz (7.5 ns)
             product: HYS72V16301GR-7.5
             vendor: JEDEC ID:C1 49 4E 46 49 4E 45 4F
             physical id: 0
             serial: 29832401
             slot: XMM1
             size: 128MiB
             width: 64 bits
             clock: 133MHz (7.5ns)
        *-bank:1
             description: DIMM SDRAM Synchronous 133 MHz (7.5 ns)
             product: 127007-031
             vendor: JEDEC ID:7F 94 FF FF FF FF FF FF
             physical id: 1
             serial: 2DF05EEE
             slot: XMM2
             size: 128MiB
             width: 64 bits
             clock: 133MHz (7.5ns)
     *-memory:1 UNCLAIMED
          description: Flash Memory
          physical id: 22
          slot: System board or motherboard
          capacity: 512KiB
        *-bank UNCLAIMED
             description: Chip FLASH Non-volatile
             physical id: 0
             slot: XU15
             size: 512KiB
             width: 4 bits
     *-memory:2 UNCLAIMED
          physical id: 0
     *-memory:3 UNCLAIMED
          physical id: 2
     *-pci
          description: Host bridge
          product: 82815 815 Chipset Host Bridge and Memory Controller Hub
          vendor: Intel Corporation
          physical id: 100
          bus info: pci@0000:00:00.0
          version: 02
          width: 32 bits
          clock: 33MHz
        *-display UNCLAIMED
             description: VGA compatible controller
             product: 82815 Chipset Graphics Controller (CGC)
             vendor: Intel Corporation
             physical id: 2
             bus info: pci@0000:00:02.0
             version: 02
             width: 32 bits
             clock: 66MHz
             capabilities: pm vga_controller bus_master cap_list
             configuration: latency=0
        *-pci
             description: PCI bridge
             product: 82801AA PCI Bridge
             vendor: Intel Corporation
             physical id: 1e
             bus info: pci@0000:00:1e.0
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: pci normal_decode bus_master
           *-system UNCLAIMED
                description: System peripheral
                product: ADSL AccessRunner PCI Arbitration Device
                vendor: Conexant
                physical id: 8
                bus info: pci@0000:02:08.0
                version: 01
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list
                configuration: latency=64
           *-network:0 UNCLAIMED
                description: ATM network controller
                product: AccessRunner PCI ADSL Interface Device
                vendor: Conexant
                physical id: 8.1
                bus info: pci@0000:02:08.1
                version: 01
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list
                configuration: latency=64
           *-network:1
                description: Ethernet interface
                product: RTL8139 Ethernet
                vendor: D-Link System Inc
                physical id: 9
                bus info: pci@0000:02:09.0
                logical name: eth0
                version: 10
                serial: 00:05:5d:49:eb:21
                size: 100MB/s
                capacity: 100MB/s
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd autonegotiation
                configuration: autonegotiation=on broadcast=yes driver=8139too driverversion=0.9.28 duplex=full ip=192.168.0.1 latency=66 link=yes maxlatency=64 mingnt=32 multicast=yes port=MII speed=100MB/s
           *-network:2
                description: Ethernet interface
                product: SMC2-1211TX
                vendor: Accton Technology Corporation
                physical id: a
                bus info: pci@0000:02:0a.0
                logical name: eth1
                version: 10
                serial: 00:10:b5:ac:ea:7d
                size: 100MB/s
                capacity: 100MB/s
                width: 32 bits
                clock: 33MHz
                capabilities: pm bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd autonegotiation
                configuration: autonegotiation=on broadcast=yes driver=8139too driverversion=0.9.28 duplex=full ip=192.168.1.1 latency=66 link=yes maxlatency=64 mingnt=32 multicast=yes port=MII speed=100MB/s
        *-isa
             description: ISA bridge
             product: 82801AA ISA Bridge (LPC)
             vendor: Intel Corporation
             physical id: 1f
             bus info: pci@0000:00:1f.0
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: isa bus_master
             configuration: latency=0
        *-ide
             description: IDE interface
             product: 82801AA IDE Controller
             vendor: Intel Corporation
             physical id: 1f.1
             bus info: pci@0000:00:1f.1
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: ide bus_master
             configuration: driver=PIIX_IDE latency=0
        *-usb
             description: USB Controller
             product: 82801AA USB Controller
             vendor: Intel Corporation
             physical id: 1f.2
             bus info: pci@0000:00:1f.2
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: uhci bus_master
             configuration: driver=uhci_hcd latency=0
           *-usbhost
                product: UHCI Host Controller
                vendor: Linux 2.6.27-05178-g2e532d6 uhci_hcd
                physical id: 1
                bus info: usb@1
                logical name: usb1
                version: 2.06
                capabilities: usb-1.10
                configuration: driver=hub slots=2 speed=12.0MB/s
        *-multimedia UNCLAIMED
             description: Multimedia audio controller
             product: 82801AA AC'97 Audio Controller
             vendor: Intel Corporation
             physical id: 1f.5
             bus info: pci@0000:00:1f.5
             version: 02
             width: 32 bits
             clock: 33MHz
             capabilities: bus_master
             configuration: latency=0

dmesg output:
0 io port: [1000, 1fff]
[    0.165595] bus: 02 index 1 mmio: [40000000, 407fffff]
[    0.165690] bus: 02 index 2 mmio: [0, 0]
[    0.165784] bus: 02 index 3 io port: [0, ffff]
[    0.165877] bus: 02 index 4 mmio: [0, ffffffff]
[    0.166048] NET: Registered protocol family 2
[    0.166722] IP route cache hash table entries: 2048 (order: 1, 8192 bytes)
[    0.167883] TCP established hash table entries: 8192 (order: 4, 65536 bytes)
[    0.168309] TCP bind hash table entries: 8192 (order: 6, 262144 bytes)
[    0.169636] TCP: Hash tables configured (established 8192 bind 8192)
[    0.169859] TCP reno registered
[    0.170527] NET: Registered protocol family 1
[    0.174313] msgmni has been set to 488
[    0.174912] alg: No test for cipher_null (cipher_null-generic)
[    0.175179] alg: No test for digest_null (digest_null-generic)
[    0.175351] alg: No test for compress_null (compress_null-generic)
[    0.181852] alg: No test for stdrng (krng)
[    0.182490] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 254)
[    0.182704] io scheduler noop registered
[    0.182801] io scheduler deadline registered
[    0.182950] io scheduler cfq registered (default)
[    0.183113] pci 0000:00:02.0: Boot video device
[    0.183955] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.184222] ACPI: Power Button (FF) [PWRF]
[    0.184656] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[    0.184832] ACPI: Power Button (CM) [PBTN]
[    0.185868] processor ACPI0007:00: registered as cooling_device0
[    0.185992] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.186539] isapnp: Scanning for PnP cards...
[    0.540378] isapnp: No Plug & Play device found
[    0.551839] 8139too Fast Ethernet driver 0.9.28
[    0.552082] 8139too 0000:02:09.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.553546] eth0: RealTek RTL8139 at 0x1000, 00:05:5d:49:eb:21, IRQ 17
[    0.553656] eth0:  Identified 8139 chip type 'RTL-8139C'
[    0.553775] 8139too 0000:02:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.555211] eth1: RealTek RTL8139 at 0x1400, 00:10:b5:ac:ea:7d, IRQ 18
[    0.555321] eth1:  Identified 8139 chip type 'RTL-8139B'
[    0.555451] tun: Universal TUN/TAP device driver, 1.6
[    0.555553] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.556232] console [netcon0] enabled
[    0.556339] netconsole: network logging started
[    0.556442] Uniform Multi-Platform E-IDE driver
[    0.556847] piix 0000:00:1f.1: IDE controller (0x8086:0x2411 rev 0x02)
[    0.557077] piix 0000:00:1f.1: not 100% native mode: will probe irqs later
[    0.557191]     ide0: BM-DMA at 0x2460-0x2467
[    0.557311]     ide1: BM-DMA at 0x2468-0x246f
[    0.557422] Probing IDE interface ide0...
[    0.668063] Switched to high resolution mode on CPU 0
[    0.844145] hda: Maxtor 6G160P0, ATA DISK drive
[    1.516373] hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    1.517555] hda: UDMA/66 mode selected
[    1.518784] Probing IDE interface ide1...
[    1.804143] hdc: Maxtor 6G160P0, ATA DISK drive
[    2.476227] hdc: host max PIO4 wanted PIO255(auto-tune) selected PIO4
[    2.477347] hdc: UDMA/66 mode selected
[    2.478608] ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
[    2.478865] ide1 at 0x170-0x177,0x376 on irq 15
[    2.479654] hda: max request size: 512KiB
[    2.499793] hda: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
[    2.501250] hda: cache flushes supported
[    2.501584]  hda: hda1 hda2 hda3 hda4
[    2.506851] hdc: max request size: 512KiB
[    2.521179] hdc: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
[    2.522556] hdc: cache flushes supported
[    2.522764]  hdc: hdc1 hdc2 hdc3 hdc4
[    2.532566] ide-cd driver 5.00
[    2.533417] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.533551] USB Universal Host Controller Interface driver v3.0
[    2.533818] uhci_hcd 0000:00:1f.2: PCI INT D -> GSI 19 (level, low) -> IRQ 19
[    2.533936] uhci_hcd 0000:00:1f.2: setting latency timer to 64
[    2.533946] uhci_hcd 0000:00:1f.2: UHCI Host Controller
[    2.534575] uhci_hcd 0000:00:1f.2: new USB bus registered, assigned bus number 1
[    2.534821] uhci_hcd 0000:00:1f.2: irq 19, io base 0x00002440
[    2.535565] usb usb1: configuration #1 chosen from 1 choice
[    2.535939] hub 1-0:1.0: USB hub found
[    2.536165] hub 1-0:1.0: 2 ports detected
[    2.640848] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
[    2.640968] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.641130] usb usb1: Product: UHCI Host Controller
[    2.641229] usb usb1: Manufacturer: Linux 2.6.27-05178-g2e532d6 uhci_hcd
[    2.641333] usb usb1: SerialNumber: 0000:00:1f.2
[    2.641581] Initializing USB Mass Storage driver...
[    2.641841] usbcore: registered new interface driver usb-storage
[    2.641951] USB Mass Storage support registered.
[    2.642402] PNP: PS/2 Controller [PNP0303:KBD,PNP0f0e:PS2M] at 0x60,0x64 irq 1,12
[    2.645489] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.645612] serio: i8042 AUX port at 0x60,0x64 irq 12
[    2.646122] mice: PS/2 mouse device common for all mice
[    2.647222] md: raid1 personality registered for level 1
[    2.647827] device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
[    2.649623] netem: version 1.2
[    2.649781] Netfilter messages via NETLINK v0.30.
[    2.650038] nf_conntrack version 0.5.0 (4080 buckets, 16320 max)
[    2.650409] CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
[    2.650576] nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
[    2.650738] sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
[    2.651076] ctnetlink v0.93: registering with nfnetlink.
[    2.654011] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.654361] arp_tables: (C) 2002 David S. Miller
[    2.654547] TCP bic registered
[    2.654645] TCP cubic registered
[    2.654740] TCP westwood registered
[    2.654837] TCP highspeed registered
[    2.654933] TCP htcp registered
[    2.655030] Initializing XFRM netlink socket
[    2.655313] NET: Registered protocol family 10
[    2.663135] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.663606] IPv6 over IPv4 tunneling driver
[    2.667299] NET: Registered protocol family 17
[    2.667554] NET: Registered protocol family 15
[    2.667978] Bridge firewalling registered
[    2.668165] 802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
[    2.668273] All bugs added by David S. Miller <davem@redhat.com>
[    2.668444] Using IPI Shortcut mode
[    2.683446] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[    3.455257] input: ImPS/2 Logitech Wheel Mouse as /devices/platform/i8042/serio1/input/input3
[    3.500068] md: Waiting for all devices to be available before autodetect
[    3.500180] md: If you don't use raid, use raid=noautodetect
[    3.501035] md: Autodetecting RAID arrays.
[    3.639646] md: Scanned 8 and added 8 devices.
[    3.639757] md: autorun ...
[    3.639853] md: considering hdc4 ...
[    3.639985] md:  adding hdc4 ...
[    3.640100] md: hdc3 has different UUID to hdc4
[    3.640210] md: hdc2 has different UUID to hdc4
[    3.640320] md: hdc1 has different UUID to hdc4
[    3.640431] md:  adding hda4 ...
[    3.640534] md: hda3 has different UUID to hdc4
[    3.640642] md: hda2 has different UUID to hdc4
[    3.640748] md: hda1 has different UUID to hdc4
[    3.641443] md: created md4
[    3.641545] md: bind<hda4>
[    3.641675] md: bind<hdc4>
[    3.641800] md: running: <hdc4><hda4>
[    3.642267] raid1: raid set md4 active with 2 out of 2 mirrors
[    3.653314] md4: bitmap initialized from disk: read 11/11 pages, set 0 bits
[    3.653427] created bitmap (169 pages) for device md4
[    3.673941] md: considering hdc3 ...
[    3.674067] md:  adding hdc3 ...
[    3.674180] md: hdc2 has different UUID to hdc3
[    3.674294] md: hdc1 has different UUID to hdc3
[    3.674413] md:  adding hda3 ...
[    3.674526] md: hda2 has different UUID to hdc3
[    3.674640] md: hda1 has different UUID to hdc3
[    3.675244] md: created md3
[    3.675346] md: bind<hda3>
[    3.675473] md: bind<hdc3>
[    3.675598] md: running: <hdc3><hda3>
[    3.676030] raid1: raid set md3 active with 2 out of 2 mirrors
[    3.691104] md3: bitmap initialized from disk: read 15/15 pages, set 13 bits
[    3.691218] created bitmap (233 pages) for device md3
[    3.718910] md: considering hdc2 ...
[    3.719057] md:  adding hdc2 ...
[    3.719180] md: hdc1 has different UUID to hdc2
[    3.719305] md:  adding hda2 ...
[    3.719425] md: hda1 has different UUID to hdc2
[    3.719997] md: created md2
[    3.720125] md: bind<hda2>
[    3.720273] md: bind<hdc2>
[    3.720400] md: running: <hdc2><hda2>
[    3.720805] raid1: raid set md2 active with 2 out of 2 mirrors
[    3.728818] md2: bitmap initialized from disk: read 8/8 pages, set 0 bits
[    3.728931] created bitmap (123 pages) for device md2
[    3.752704] md: considering hdc1 ...
[    3.752828] md:  adding hdc1 ...
[    3.752949] md:  adding hda1 ...
[    3.754731] md: created md1
[    3.754832] md: bind<hda1>
[    3.754962] md: bind<hdc1>
[    3.755084] md: running: <hdc1><hda1>
[    3.755472] raid1: raid set md1 active with 2 out of 2 mirrors
[    3.765460] md1: bitmap initialized from disk: read 10/10 pages, set 0 bits
[    3.765568] created bitmap (153 pages) for device md1
[    3.782441] md: ... autorun DONE.
[    3.784758] EXT3-fs: INFO: recovery required on readonly filesystem.
[    3.784879] EXT3-fs: write access will be enabled during recovery.
[    5.086389] kjournald starting.  Commit interval 5 seconds
[    5.086552] EXT3-fs: recovery complete.
[    5.087707] EXT3-fs: mounted filesystem with ordered data mode.
[    5.087913] VFS: Mounted root (ext3 filesystem) readonly.
[    5.089259] Freeing unused kernel memory: 300k freed
[    5.089806] Write protecting the kernel text: 3216k
[    5.090003] Write protecting the kernel read-only data: 908k
[   10.358767] EXT3 FS on md4, internal journal
[   22.780758] kjournald starting.  Commit interval 5 seconds
[   22.781391] EXT3 FS on md3, internal journal
[   22.781416] EXT3-fs: mounted filesystem with ordered data mode.
[   24.899570] Adding 1999992k swap on /dev/md2.  Priority:-1 extents:1 across:1999992k
[   44.237784] eth0: link up, 100Mbps, full-duplex, lpa 0xC5E1
[   49.506592] eth1: link up, 100Mbps, full-duplex, lpa 0x45E1
[   55.012033] eth0: no IPv6 routers present
[   59.640025] eth1: no IPv6 routers present
[   77.536141] warning: `proftpd' uses 32-bit capabilities (legacy support in use)
[  372.980378] BUG: unable to handle kernel NULL pointer dereference at 00000020
[  372.980400] IP: [<c0323d5c>] sock_poll+0xc/0x20
[  372.980425] *pde = 00000000
[  372.980435] Oops: 0000 [#1]
[  372.980574] last sysfs file: /sys/kernel/uevent_seqnum
[  372.980677]
[  372.980773] Pid: 5150, comm: squid Not tainted (2.6.27-05178-g2e532d6 #257) Deskpro
[  372.980934] EIP: 0060:[<c0323d5c>] EFLAGS: 00010246 CPU: 0
[  372.981036] EIP is at sock_poll+0xc/0x20
[  372.981133] EAX: cbf3c460 EBX: 00000000 ECX: 00000000 EDX: cddc8280
[  372.981235] ESI: cbf27f48 EDI: cd938ae0 EBP: cd938aec ESP: cbf27f20
[  372.981337]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[  372.981440] Process squid (pid: 5150, ti=cbf26000 task=cbec0510 task.ti=cbf26000)
[  372.981601] Stack:
[  372.981692]  00000296 c0195e8a cbf27f48 00002000 08553940 cbfba180 cbfba19c cbfba224
[  372.982004]  00000000 cbf26000 cd938aec cd938d2c cbfba224 cbfba180 00000003 cbf26000
[  372.982430]  c01963c7 00002000 08553940 cd938aec cbfba1f8 00000246 ca43f2d4 ca43f2c0
[  372.982940] Call Trace:
[  372.983033]  [<c0195e8a>] ep_send_events+0xea/0x2b0
[  372.983167]  [<c01963c7>] ep_poll+0x57/0x1c0
[  372.983297]  [<c016ed9e>] fget+0x9e/0xd0
[  372.983443]  [<c01965d8>] sys_epoll_wait+0xa8/0xb0
[  372.983571]  [<c0103431>] sysenter_do_call+0x12/0x30
[  372.983705] Code: 44 24 18 89 44 24 04 8b 44 24 14 89 04 24 89 f0 ff d3 8b 5c 24 08 8b 74 24 0c 83 c4 10 c3 90 53 89 d1 8b 90 80 00 00 00 8b 5a 0c <ff> 53 20 5b c3 eb 0d 90 90 90 90 90 90 90 90 90 90 90 90 90 53
[  372.984031] EIP: [<c0323d5c>] sock_poll+0xc/0x20 SS:ESP 0068:cbf27f20
[  372.986077] ---[ end trace 4574704b69c3a3e8 ]---
[ 1362.742876] resource map sanity check conflict: 0x9f000 0x9ffff 0x0 0x9fbff System RAM
[ 1362.743056] ------------[ cut here ]------------
[ 1362.743130] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x261/0x2d0()
[ 1362.743271] Pid: 6863, comm: lshw Tainted: G      D   2.6.27-05178-g2e532d6 #257
[ 1362.743404] Call Trace:
[ 1362.743493]  [<c012003a>] warn_on_slowpath+0x5a/0x90
[ 1362.743580]  [<c0422ad4>] _read_unlock+0x14/0x20
[ 1362.743665]  [<c012555c>] iomem_map_sanity_check+0x7c/0xd0
[ 1362.743743]  [<c0115e61>] __ioremap_caller+0x261/0x2d0
[ 1362.743819]  [<c0115f66>] xlate_dev_mem_ptr+0x96/0xc0
[ 1362.743916]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.743992]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.744095]  [<c0286dfc>] memory_lseek+0x2c/0xa0
[ 1362.744170]  [<c0286bd0>] read_mem+0x0/0x200
[ 1362.744260]  [<c016e839>] vfs_read+0x89/0xc0
[ 1362.744334]  [<c016e941>] sys_read+0x41/0x80
[ 1362.744416]  [<c0103431>] sysenter_do_call+0x12/0x30
[ 1362.744489] ---[ end trace 4574704b69c3a3e8 ]---
[ 1362.744591] resource map sanity check conflict: 0x9f000 0x9ffff 0x0 0x9fbff System RAM
[ 1362.744728] ------------[ cut here ]------------
[ 1362.745944] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x261/0x2d0()
[ 1362.746069] Pid: 6863, comm: lshw Tainted: G      D W 2.6.27-05178-g2e532d6 #257
[ 1362.746196] Call Trace:
[ 1362.746262]  [<c012003a>] warn_on_slowpath+0x5a/0x90
[ 1362.746334]  [<c0422ad4>] _read_unlock+0x14/0x20
[ 1362.746404]  [<c012555c>] iomem_map_sanity_check+0x7c/0xd0
[ 1362.746475]  [<c0115e61>] __ioremap_caller+0x261/0x2d0
[ 1362.746546]  [<c0115f66>] xlate_dev_mem_ptr+0x96/0xc0
[ 1362.746618]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.746693]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.746766]  [<c0286dfc>] memory_lseek+0x2c/0xa0
[ 1362.746840]  [<c0286bd0>] read_mem+0x0/0x200
[ 1362.746917]  [<c016e839>] vfs_read+0x89/0xc0
[ 1362.746990]  [<c016e941>] sys_read+0x41/0x80
[ 1362.747063]  [<c0103431>] sysenter_do_call+0x12/0x30
[ 1362.747137] ---[ end trace 4574704b69c3a3e8 ]---
[ 1362.754691] resource map sanity check conflict: 0x9f000 0x9ffff 0x0 0x9fbff System RAM
[ 1362.754867] ------------[ cut here ]------------
[ 1362.754941] WARNING: at arch/x86/mm/ioremap.c:226 __ioremap_caller+0x261/0x2d0()
[ 1362.755079] Pid: 6863, comm: lshw Tainted: G      D W 2.6.27-05178-g2e532d6 #257
[ 1362.755211] Call Trace:
[ 1362.755300]  [<c012003a>] warn_on_slowpath+0x5a/0x90
[ 1362.755388]  [<c0422ad4>] _read_unlock+0x14/0x20
[ 1362.755474]  [<c012555c>] iomem_map_sanity_check+0x7c/0xd0
[ 1362.755551]  [<c0115e61>] __ioremap_caller+0x261/0x2d0
[ 1362.755639]  [<c0108766>] read_tsc+0x6/0x40
[ 1362.755727]  [<c0241c4b>] rb_insert_color+0x7b/0xf0
[ 1362.755803]  [<c0115f66>] xlate_dev_mem_ptr+0x96/0xc0
[ 1362.755897]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.755971]  [<c0286c4d>] read_mem+0x7d/0x200
[ 1362.756082]  [<c0286dfc>] memory_lseek+0x2c/0xa0
[ 1362.756159]  [<c0286bd0>] read_mem+0x0/0x200
[ 1362.756244]  [<c016e839>] vfs_read+0x89/0xc0
[ 1362.756319]  [<c016e941>] sys_read+0x41/0x80
[ 1362.756394]  [<c0103431>] sysenter_do_call+0x12/0x30
[ 1362.756469] ---[ end trace 4574704b69c3a3e8 ]---



--------------000800030808000900040707
Content-Type: text/plain;
 name=".config"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename=".config"


--------------000800030808000900040707--
