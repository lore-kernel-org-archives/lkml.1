Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbYG2Smb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbYG2Smb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 14:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbYG2SmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 14:42:23 -0400
Received: from mail.springl.ukfsn.org ([84.45.199.6]:36548 "EHLO
	mail.springl.ukfsn.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbYG2SmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 14:42:21 -0400
X-Greylist: delayed 1135 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 14:42:20 EDT
From: Steven Jan Springl <steven@springl.ukfsn.org>
To: linux-kernel@vger.kernel.org
Subject: Kernel oops in 2.6.27-rc1 qdisc.
Date: Tue, 29 Jul 2008 19:23:22 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_aA2jIDTu+M3CifH"
Message-Id: <200807291923.22803.steven@springl.ukfsn.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_aA2jIDTu+M3CifH
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello

Issuing the following command causes a kernel oops:
	tc qdisc add dev eth0 handle ffff: ingress

The problem is recreatable.
The kernel is 2.6.27-rc1.
I am using Debian etch.

The oops is attached.

Regards

Steven.

--Boundary-00=_aA2jIDTu+M3CifH
Content-Type: text/plain;
  charset="us-ascii";
  name="qdisc-oops.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="qdisc-oops.txt"

Duron(tm) processor stepping 01
Checking 'hlt' instruction... OK.
=46reeing SMP alternatives: 0k freed
ACPI: Core revision 20080609
ACPI: setting ELCR to 0800 (from 0e20)
net_namespace: 784 bytes
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb690, last bus=3D2
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:07.4: quirk: region 6000-607f claimed by vt82c686 HW-mon
pci 0000:00:07.4: quirk: region 5000-500f claimed by vt82c686 SMB
pci 0000:00:0b.0: supports D1
pci 0000:00:0b.0: supports D2
pci 0000:00:0b.0: PME# supported from D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 *10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 13 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
NET: Registered protocol family 8
NET: Registered protocol family 20
system 00:00: iomem range 0xca800-0xcbfff has been reserved
system 00:00: iomem range 0xf0000-0xf7fff could not be reserved
system 00:00: iomem range 0xf8000-0xfbfff could not be reserved
system 00:00: iomem range 0xfc000-0xfffff could not be reserved
system 00:00: iomem range 0x2fff0000-0x2fffffff could not be reserved
system 00:00: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:00: iomem range 0x0-0x9ffff could not be reserved
system 00:00: iomem range 0x100000-0x2ffeffff could not be reserved
system 00:00: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: disabled
pci 0000:00:01.0:   MEM window: 0xf6000000-0xf7ffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000f4000000-0x000000f5ffffff
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: 0xc000-0xcfff
pci 0000:00:0d.0:   MEM window: 0xf8000000-0xf9ffffff
pci 0000:00:0d.0:   PREFETCH window: 0x00000040000000-0x000000400fffff
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 6, 262144 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
=46reeing initrd memory: 3251k freed
audit: initializing netlink socket (disabled)
type=3D2000 audit(1217338387.568:1): initialized
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1516
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:07.0: Disabling VIA external APIC routing
pci 0000:01:05.0: Boot video device
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
00:08: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
00:09: ttyS1 at I/O 0x2f8 (irq =3D 3) is a 16550A
brd: module loaded
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 17
Using IPI Shortcut mode
=46reeing unused kernel memory: 208k freed
input: AT Translated Set 2 keyboard as /class/input/input0
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 2 throttling states)
Uniform Multi-Platform E-IDE driver
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
8139cp 0000:00:0b.0: This (id 10ec:8139 rev 10) is not an 8139C+ compatible=
 chip
8139cp 0000:00:0b.0: Try the "8139too" driver instead.
via82cxxx 0000:00:07.1: VIA vt82c686b (rev 40) IDE UDMA100
via82cxxx 0000:00:07.1: IDE controller (0x1106:0x0571 rev 0x06)
via82cxxx 0000:00:07.1: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0xd000-0xd007
    ide1: BM-DMA at 0xd008-0xd00f
Probing IDE interface ide0...
8139too Fast Ethernet driver 0.9.28
Linux Tulip driver version 1.1.15-NAPI (Feb 27, 2007)
hda: WDC WD200EB-00CPF0, ATA DISK drive
hda: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
Probing IDE interface ide1...
hdc: COMPAQ CR-587, ATAPI CD/DVD-ROM drive
hdc: host max PIO5 wanted PIO255(auto-tune) selected PIO4
hdc: MWDMA2 mode selected
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
8139too 0000:00:0b.0: PCI INT A -> Link[LNKD] -> GSI 10 (level, low) -> IRQ=
 10
eth0: RealTek RTL8139 at 0xdc00, 00:40:f4:4d:77:73, IRQ 10
eth0:  Identified 8139 chip type 'RTL-8100B/8139D'
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
tulip 0000:02:04.0: PCI INT A -> Link[LNKB] -> GSI 11 (level, low) -> IRQ 11
tulip0:  EEPROM default media type Autosense.
tulip0:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) =
block.
tulip0:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY =
(2) block.
tulip0:  Index #2 - Media 100baseTx (#3) described by a 21143 SYM PHY (4) b=
lock.
tulip0:  Index #3 - Media 100baseTx-FDX (#5) described by a 21143 SYM PHY (=
4) block.
eth1: Digital DS21142/43 Tulip rev 65 at Port 0xc000, 00:c0:95:e0:a5:8c, IR=
Q 11.
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
tulip 0000:02:05.0: PCI INT A -> Link[LNKA] -> GSI 5 (level, low) -> IRQ 5
tulip1:  EEPROM default media type Autosense.
tulip1:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) =
block.
tulip1:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY =
(2) block.
tulip1:  Index #2 - Media 100baseTx (#3) described by a 21143 SYM PHY (4) b=
lock.
tulip1:  Index #3 - Media 100baseTx-FDX (#5) described by a 21143 SYM PHY (=
4) block.
eth2: Digital DS21142/43 Tulip rev 65 at Port 0xc400, 00:c0:95:e0:a5:8d, IR=
Q 5.
tulip 0000:02:06.0: PCI INT A -> Link[LNKD] -> GSI 10 (level, low) -> IRQ 10
tulip2:  EEPROM default media type Autosense.
tulip2:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) =
block.
tulip2:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY =
(2) block.
tulip2:  Index #2 - Media 100baseTx (#3) described by a 21143 SYM PHY (4) b=
lock.
tulip2:  Index #3 - Media 100baseTx-FDX (#5) described by a 21143 SYM PHY (=
4) block.
eth3: Digital DS21142/43 Tulip rev 65 at Port 0xc800, 00:c0:95:e0:a5:8e, IR=
Q 10.
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
tulip 0000:02:07.0: PCI INT A -> Link[LNKC] -> GSI 11 (level, low) -> IRQ 11
tulip3:  EEPROM default media type Autosense.
tulip3:  Index #0 - Media 10baseT (#0) described by a 21142 Serial PHY (2) =
block.
tulip3:  Index #1 - Media 10baseT-FDX (#4) described by a 21142 Serial PHY =
(2) block.
tulip3:  Index #2 - Media 100baseTx (#3) described by a 21143 SYM PHY (4) b=
lock.
tulip3:  Index #3 - Media 100baseTx-FDX (#5) described by a 21143 SYM PHY (=
4) block.
eth4: Digital DS21142/43 Tulip rev 65 at Port 0xcc00, 00:c0:95:e0:a5:8f, IR=
Q 11.
hda: max request size: 128KiB
hda: 39102336 sectors (20020 MB) w/2048KiB Cache, CHS=3D38792/16/63
hda: cache flushes not supported
 hda: hda1 hda2
hdc: ATAPI 24X CD-ROM drive, 128kB Cache
Uniform CD-ROM driver Revision: 3.20
EXT3-fs: INFO: recovery required on readonly filesystem.
EXT3-fs: write access will be enabled during recovery.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: recovery complete.
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.103
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: HPC vendor_id 1022 device_id 700f ss_vid 0 ss_did 0
shpchp: shpc_init: cannot reserve MMIO region
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
parport_pc: VIA 686A/8231 detected
parport_pc: probing current configuration
parport_pc: Current parallel port base: 0x378
parport0: PC-style at 0x378, irq 7 [PCSPP,EPP]
input: Power Button (FF) as /class/input/input1
agpgart: Detected AMD 761 chipset
agpgart: AGP aperture is 64M @ 0xf0000000
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input2
ACPI: Power Button (CM) [PWRB]
input: Sleep Button (CM) as /class/input/input3
parport_pc: VIA parallel port: io=3D0x378, irq=3D7
ACPI: Sleep Button (CM) [SLPB]
input: PC Speaker as /class/input/input4
=46loppy drive(s): fd0 is 1.44M
=46DC 0 is a post-1991 82077
input: GenPS/2 Genius Mouse as /class/input/input5
Adding 497972k swap on /dev/hda1.  Priority:-1 extents:1 across:497972k
EXT3 FS on hda2, internal journal
loop: module loaded
Bridge firewalling registered
br0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth2 entered promiscuous mode
device eth1 entered promiscuous mode
br0: port 2(eth1) entering learning state
br0: port 1(eth2) entering learning state
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
br0: topology change detected, propagating
br0: port 2(eth1) entering forwarding state
br0: topology change detected, propagating
br0: port 1(eth2) entering forwarding state
br1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
device eth4 entered promiscuous mode
device eth3 entered promiscuous mode
br1: port 2(eth3) entering learning state
br1: port 1(eth4) entering learning state
br1: topology change detected, propagating
br1: port 2(eth3) entering forwarding state
br1: topology change detected, propagating
br1: port 1(eth4) entering forwarding state
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
0000:02:07.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb38620c2)
0000:02:06.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb38620c2)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
0000:02:04.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
0000:02:07.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
0000:02:06.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
br0: no IPv6 routers present
br1: no IPv6 routers present
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:04.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
eth1: no IPv6 routers present
eth4: no IPv6 routers present
eth3: no IPv6 routers present
eth2: no IPv6 routers present
0000:02:07.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:06.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:04.0: tulip_stop_rxtx() failed (CSR5 0xf0260000 CSR6 0xb3862002)
0000:02:04.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:07.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:07.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:06.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
0000:02:05.0: tulip_stop_rxtx() failed (CSR5 0xf0660000 CSR6 0xb3862002)
Netfilter messages via NETLINK v0.30.
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (12288 buckets, 49152 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=3D1 kernel paramater, acct=3D1 nf_conntrack module option=
 or
sysctl net.netfilter.nf_conntrack_acct=3D1 to enable it.
ctnetlink v0.93: registering with nfnetlink.
ClusterIP Version 0.8 loaded successfully
HTB: quantum of class 20001 is big. Consider r2q change.
BUG: unable to handle kernel NULL pointer dereference at 00000044
IP: [<c023c894>] qdisc_create+0x18f/0x1e7
*pde =3D 00000000=20
Oops: 0000 [#1]=20
Modules linked in: sch_ingress sch_htb ipt_ULOG ipt_TTL ipt_ttl ipt_REJECT =
ipt_REDIRECT ipt_recent ipt_NETMAP ipt_MASQUERADE ipt_LOG ipt_ECN ipt_ecn i=
pt_CLUSTERIP ipt_ah ipt_addrtype nf_nat_tftp nf_nat_snmp_basic nf_nat_sip n=
f_nat_pptp nf_nat_proto_gre nf_nat_irc nf_nat_h323 nf_nat_ftp nf_nat_amanda=
 ts_kmp nf_conntrack_amanda nf_conntrack_sane nf_conntrack_tftp nf_conntrac=
k_sip nf_conntrack_pptp nf_conntrack_proto_gre nf_conntrack_netlink nf_conn=
track_netbios_ns nf_conntrack_irc nf_conntrack_h323 nf_conntrack_ftp xt_tcp=
mss xt_pkttype xt_physdev xt_owner xt_NFQUEUE xt_NFLOG xt_multiport xt_MARK=
 xt_mark xt_mac xt_limit xt_length xt_iprange xt_helper xt_hashlimit xt_DSC=
P xt_dscp xt_dccp xt_conntrack xt_CONNMARK xt_connmark xt_CLASSIFY xt_tcpud=
p xt_state iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack iptable_mangle=
 iptable_filter ip_tables x_tables nfnetlink ipv6 bridge stp loop floppy se=
rio_raw i2c_viapro pcspkr i2c_core psmouse via686a amd_k7_agp button parpor=
t_pc parport shpchp pci_hotplug agpgart evdev ext3 jbd mbcache ide_cd_mod c=
drom ide_disk tulip 8139too via82cxxx 8139cp mii ide_core thermal processor=
 fan

Pid: 3011, comm: tc Not tainted (2.6.27-rc1 #1)
EIP: 0060:[<c023c894>] EFLAGS: 00010202 CPU: 0
EIP is at qdisc_create+0x18f/0x1e7
EAX: 00000040 EBX: efb9d280 ECX: 00000000 EDX: efb9d2c0
ESI: 00000000 EDI: efb9d280 EBP: f0a2f620 ESP: ef139c64
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process tc (pid: 3011, ti=3Def138000 task=3Deeea4040 task.ti=3Def138000)
Stack: fffffff1 eedf197c eedf1800 00df73b4 72676e69 00737365 00000009 00000=
008=20
       ef139cb0 eedf1800 00000000 eef0da10 c023d2e4 fffffff1 ef139cb0 ef139=
cd4=20
       eef0da00 eec8d620 fffffff1 00000000 eef0da24 eef0da30 00000000 00000=
000=20
Call Trace:
 [<c023d2e4>] tc_modify_qdisc+0x2ae/0x35e
 [<c023d036>] tc_modify_qdisc+0x0/0x35e
 [<c0235519>] rtnetlink_rcv_msg+0x190/0x1aa
 [<c0235389>] rtnetlink_rcv_msg+0x0/0x1aa
 [<c0240aab>] netlink_rcv_skb+0x2d/0x71
 [<c0235383>] rtnetlink_rcv+0x14/0x1a
 [<c02408db>] netlink_unicast+0x186/0x1e8
 [<c0241312>] netlink_sendmsg+0x237/0x244
 [<c0224dfa>] sock_sendmsg+0xc6/0xe0
 [<c01249d4>] autoremove_wake_function+0x0/0x2d
 [<c01249d4>] autoremove_wake_function+0x0/0x2d
 [<c022ae7e>] verify_iovec+0x3e/0x70
 [<c0224fa1>] sys_sendmsg+0x18d/0x1f0
 [<c022585f>] sys_recvmsg+0x146/0x1c8
 [<c013c501>] get_page_from_freelist+0x93/0x345
 [<c013c74c>] get_page_from_freelist+0x2de/0x345
 [<c0225f76>] sys_socketcall+0x164/0x19c
 [<c0110fb3>] do_page_fault+0x0/0x529
 [<c0103525>] sysenter_do_call+0x12/0x25
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: be fb fe ff 85 c0 89 c7 5e 74 0d 8b 55 34 85 d2 74 34 89 d8 ff d2 eb =
2e 83 3c 24 00 74 5b 8b 54 24 04 8b 42 04 8d 53 40 83 c0 40 <8b> 48 04 89 4=
3 40 89 50 04 89 11 89 4a 04 eb 3e 89 35 54 1e 33=20
EIP: [<c023c894>] qdisc_create+0x18f/0x1e7 SS:ESP 0068:ef139c64
=2D--[ end trace 37f0692c1922ef37 ]---

--Boundary-00=_aA2jIDTu+M3CifH--
