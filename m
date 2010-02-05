Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756327Ab0BEBhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 20:37:50 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:48782 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754405Ab0BEBhs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 20:37:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=YkQ2H7qdZ2wnKTY1u11OcDwNUXDjutw2O6X3D3T6iAmplZIIePl/aJnqEbqlCGSMCm
         cskZEkUdG0cy065Bjbdn3ucedQqFjmmYgjLpb9RSA+jgmK+0mwu0pCz++1aq9qxDnkYy
         37BeRzoCow+4sWTl6IO+Gy8YtxRR7n4fz0LX8=
MIME-Version: 1.0
Date: Fri, 5 Feb 2010 09:37:46 +0800
Message-ID: <dbcb72f71002041737n421d592eib5dfe9399d69e3b3@mail.gmail.com>
Subject: Oops for 2.6.31.12 BUG: unable to handle kernel paging request
From: Fly Emu <emufly@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

# dmesg
BUG: unable to handle kernel paging request at 02930619
IP: [<c0216ff9>] 0xc0216ff9
*pde = 00000000
Oops: 0002 [#1]
last sysfs file:
/sys/devices/pci0000:00/0000:00:12.0/net/eth1/statistics/tx_bytes
Modules linked in: xt_NOTRACK sch_ingress act_mirred sch_sfq pcspkr
cls_u32 sch_htb ppp_mppe xt_hashlimit nf_nat_pptp nf_nat_proto_gre
nf_conntrack_pptp nf_conntrack_proto_gre ipt_REDIRECT ts_bm ipt_set
xt_length xt_mark xt_TCPMSS ip_set_iphash ip_set xt_conntrack
iptable_raw arpt_mangle 8250_pnp 8250_pci 8250 serial_core pppoe pppox
ppp_generic slhc nf_nat_ftp nf_conntrack_ftp nf_conntrack_netlink
xt_owner xt_TEE xt_condition ipt_NETMAP arptable_filter arp_tables
ipt_MASQUERADE ipt_ULOG xt_recent xt_multiport ipt_REJECT xt_DSCP
xt_layer7 xt_iprange xt_ipp2p iptable_mangle iptable_filter
iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 ip_tables
xt_connlimit xt_helper xt_string xt_MARK xt_comment xt_state
nf_conntrack xt_limit xt_mac xt_tcpudp xt_time xt_ACCOUNT
compat_xtables x_tables nfnetlink ifb via_rhine ath5k mac80211
led_class ath cfg80211 dm9601 usbnet fbcon font bitblit softcursor
vga16fb fb cfbcopyarea vgastate cfbimgblt cfbfillrect tcp_bic

Pid: 21220, comm: rrdtool Not tainted (2.6.31.12-i386 #8) VT8623-8235
EIP: 0060:[<c0216ff9>] EFLAGS: 00010082 CPU: 0
EAX: c0643414 EBX: de4e7c00 ECX: 00000001 EDX: de4e7c00
ESI: de4e7c2c EDI: 00000000 EBP: de4e7c2c ESP: de701ee8
 DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process rrdtool (pid: 21220, ti=de700000 task=de4e7c00 task.ti=de700000)
Stack:
 00000056 00000011 de4e7c00 00040001 000052e4 c0643414 00000000 00000018
 00000000 00000021 de4e7c00 de4e7c2c 00000000 de4e7c00 c0218009 c022b7ac
 00000246 c053928c 0f2d7d20 00000000 c021782b 00000001 c06433d8 00000012
Call Trace:
 [<c0218009>] ? 0xc0218009
 [<c022b7ac>] ? 0xc022b7ac
 [<c021782b>] ? 0xc021782b
 [<c0535726>] ? 0xc0535726
 [<c021d864>] ? 0xc021d864
 [<c021d8aa>] ? 0xc021d8aa
 [<c021d8e1>] ? 0xc021d8e1
 [<c0202c95>] ? 0xc0202c95
Code: 31 f6 e8 81 fe ff ff 89 c3 59 89 d8 89 f2 5b 5b 5e 5f 5d c3 55
57 56 53 83 ec 1c 89 44 24 08 8b 68 30 8b 54 24 08 8b 80 9c 03 00 <00>
85 ed 89 44 24 04 8b 92 a0 03 00 00 89 14 24 0f 84 fc 00 00
EIP: [<c0216ff9>]  SS:ESP 0068:de701ee8
CR2: 0000000002930619
---[ end trace 061ba6e36576e10a ]---
Fixing recursive fault but reboot is needed!


# cat /proc/version
Linux version 2.6.31.12-i386(root@test.com) (gcc version 4.3.2 (GCC) )
#8 Wed Jan 20 10:15:48 CST 2010


# lspci -vv
00:00.0 Host bridge: VIA Technologies, Inc. VT8623 [Apollo CLE266]
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR-
        Latency: 8
        Region 0: Memory at d0000000 (32-bit, prefetchable) [size=128M]
        Capabilities: [a0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit- FW- Rate=x4
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:01.0 PCI bridge: VIA Technologies, Inc. VT8633 [Apollo Pro266 AGP]
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ >SERR- <PERR+
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        Memory behind bridge: dc000000-ddffffff
        Prefetchable memory behind bridge: d8000000-dbffffff
        Secondary status: 66MHz+ FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR+
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0f.0 Ethernet controller: VIA Technologies, Inc. VT6105/VT6106S
[Rhine-III] (rev 8b)
        Subsystem: VIA Technologies, Inc. Unknown device 0106
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: I/O ports at d000 [size=256]
        Region 1: Memory at de012000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 12
        Region 4: I/O ports at d400 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin B routed to IRQ 11
        Region 4: I/O ports at d800 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
Controller (rev 80) (prog-if 00 [UHCI])
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin C routed to IRQ 11
        Region 4: I/O ports at dc00 [size=32]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:10.3 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 82)
(prog-if 20 [EHCI])
        Subsystem: VIA Technologies, Inc. USB 2.0
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32, Cache Line Size: 32 bytes
        Interrupt: pin D routed to IRQ 11
        Region 0: Memory at de010000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=375mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.0 ISA bridge: VIA Technologies, Inc. VT8235 ISA Bridge
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping+ SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:11.1 IDE interface: VIA Technologies, Inc.
VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
(prog-if 8a [Master SecP PriP
        Subsystem: VIA Technologies, Inc. Unknown device aa01
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32
        Interrupt: pin A routed to IRQ 12
        Region 0: [virtual] Memory at 000001f0 (32-bit,
non-prefetchable) [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit,
non-prefetchable) [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3,
non-prefetchable) [size=1]
        Region 4: I/O ports at e000 [size=16]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:12.0 Ethernet controller: VIA Technologies, Inc. VT6102 [Rhine-II] (rev 74)
        Subsystem: VIA Technologies, Inc. VT6102 [Rhine II] Embeded
Ethernet Controller on VT8235
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (750ns min, 2000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at e400 [size=256]
        Region 1: Memory at de011000 (32-bit, non-prefetchable) [size=256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:14.0 Ethernet controller: Atheros Communications Inc. Atheros
AR5001X+ Wireless Network Adapter (rev 01)
        Subsystem: D-Link System Inc D-Link AirPlus DWL-G520 Wireless
PCI Adapter(rev.B)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 168 (2500ns min, 7000ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at de000000 (32-bit, non-prefetchable) [size=64K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=2 PME-

01:00.0 VGA compatible controller: VIA Technologies, Inc. VT8623
[Apollo CLE266] integrated CastleRock graphics (rev 03) (prog-if 00
[VGA co
        Subsystem: VIA Technologies, Inc. VT8623 [Apollo CLE266]
integrated CastleRock graphics
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (500ns min)
        Interrupt: pin A routed to IRQ 12
        Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
        Region 1: Memory at dc000000 (32-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at dd000000 [disabled] [size=64K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [70] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64-
HTrans- 64bit- FW- AGP3- Rate=x1,x2,x4
                Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
FW- Rate=<none>

# cat /proc/cpuinfo
processor   : 0
vendor_id   : CentaurHauls
cpu family  : 6
model       : 7
model name  : VIA Samuel 2
stepping    : 3
cpu MHz     : 601.459
cache size  : 64 KB
fdiv_bug    : no
hlt_bug     : no
f00f_bug    : no
coma_bug    : no
fpu     : yes
fpu_exception   : yes
cpuid level : 1
wp      : yes
flags       : fpu de tsc msr cx8 mtrr pge mmx 3dnow
bogomips    : 1202.91
clflush size    : 32
power management:

# cat /proc/iomem
00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000cdfff : Video ROM
000ce000-000cffff : pnp 00:00
000f0000-000fffff : reserved
  000f0000-000fffff : System ROM
00100000-1efeffff : System RAM
  00200000-00536e29 : Kernel code
  00536e2a-006768b3 : Kernel data
  006bf000-006e902b : Kernel bss
1eff0000-1eff2fff : ACPI Non-volatile Storage
1eff3000-1effffff : ACPI Tables
1f000000-1fffffff : RAM buffer
d0000000-d7ffffff : 0000:00:00.0
d8000000-dbffffff : PCI Bus 0000:01
  d8000000-dbffffff : 0000:01:00.0
dc000000-ddffffff : PCI Bus 0000:01
  dc000000-dcffffff : 0000:01:00.0
  dd000000-dd00ffff : 0000:01:00.0
de000000-de00ffff : 0000:00:14.0
  de000000-de00ffff : ath5k
de010000-de0100ff : 0000:00:10.3
  de010000-de0100ff : ehci_hcd
de011000-de0110ff : 0000:00:12.0
  de011000-de0110ff : via-rhine
de012000-de0120ff : 0000:00:0f.0
  de012000-de0120ff : via-rhine
fee00000-fee00fff : pnp 00:00
fff80000-fffeffff : pnp 00:00
ffff0000-ffffffff : reserved
  ffff0000-ffffffff : pnp 00:00

# cat /proc/ioports
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-0060 : keyboard
0064-0064 : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:11.1
  0170-0177 : via82cxxx
01f0-01f7 : 0000:00:11.1
  01f0-01f7 : via82cxxx
02e8-02ef : serial
02f8-02ff : serial
0376-0376 : 0000:00:11.1
  0376-0376 : via82cxxx
03c0-03df : vga+
03e8-03ef : serial
03f6-03f6 : 0000:00:11.1
  03f6-03f6 : via82cxxx
03f8-03ff : serial
0400-047f : 0000:00:11.0
  0400-047f : pnp 00:02
    0400-0403 : ACPI PM1a_EVT_BLK
    0404-0405 : ACPI PM1a_CNT_BLK
    0408-040b : ACPI PM_TMR
    0410-0415 : ACPI CPU throttle
    0420-0423 : ACPI GPE0_BLK
04d0-04d1 : pnp 00:03
0500-050f : 0000:00:11.0
  0500-050f : pnp 00:02
0cf8-0cff : PCI conf1
d000-d0ff : 0000:00:0f.0
  d000-d0ff : via-rhine
d400-d41f : 0000:00:10.0
  d400-d41f : uhci_hcd
d800-d81f : 0000:00:10.1
  d800-d81f : uhci_hcd
dc00-dc1f : 0000:00:10.2
  dc00-dc1f : uhci_hcd
e000-e00f : 0000:00:11.1
  e000-e00f : via82cxxx
e400-e4ff : 0000:00:12.0
  e400-e4ff : via-rhine

# cat /proc/modules
xt_NOTRACK 436 2 - Live 0xe1252000
sch_ingress 640 2 - Live 0xe1231000
act_mirred 1552 6 - Live 0xe1228000
sch_sfq 3196 4 - Live 0xe121e000
pcspkr 832 0 - Live 0xe1214000
cls_u32 4008 30 - Live 0xe120b000
sch_htb 9100 8 - Live 0xe11ff000
ppp_mppe 4124 0 - Live 0xe1172000
xt_hashlimit 4624 4 - Live 0xe0fd3000
nf_nat_pptp 1132 0 - Live 0xe0f5e000
nf_nat_proto_gre 584 1 nf_nat_pptp, Live 0xe0f55000
nf_conntrack_pptp 2388 1 nf_nat_pptp, Live 0xe0f4c000
nf_conntrack_proto_gre 1748 1 nf_conntrack_pptp, Live 0xe0f42000
ipt_REDIRECT 564 6 - Live 0xe0d8a000
ts_bm 1088 6 - Live 0xe0d0a000
ipt_set 688 4 - Live 0xe0bd3000
xt_length 568 1 - Live 0xe07ae000
xt_mark 536 1 - Live 0xe0201000
xt_TCPMSS 1508 1 - Live 0xe01cb000
ip_set_iphash 4472 2 - Live 0xe00b8000
ip_set 7784 3 ipt_set,ip_set_iphash, Live 0xe00a3000
xt_conntrack 2184 1 - Live 0xdffaa000
iptable_raw 540 1 - Live 0xdfd72000
arpt_mangle 732 3 - Live 0xdfd4c000
8250_pnp 3044 0 - Live 0xdfd33000
8250_pci 16604 0 - Live 0xdfd21000
8250 12220 4 8250_pnp,8250_pci, Live 0xdfd0b000
serial_core 9476 1 8250, Live 0xdfcfe000
pppoe 5280 2 - Live 0xdfcf0000
pppox 816 1 pppoe, Live 0xdfce5000
ppp_generic 13272 7 ppp_mppe,pppoe,pppox, Live 0xdfcd9000
slhc 3404 1 ppp_generic, Live 0xdfcce000
nf_nat_ftp 932 0 - Live 0xdfcc4000
nf_conntrack_ftp 3756 1 nf_nat_ftp, Live 0xdfcbb000
nf_conntrack_netlink 10620 0 - Live 0xdfcae000
xt_owner 1128 0 - Live 0xdfca1000
xt_TEE 1236 0 - Live 0xdfc98000
xt_condition 1280 78 - Live 0xdfc8f000
ipt_NETMAP 596 0 - Live 0xdfc85000
arptable_filter 532 1 - Live 0xdfc7c000
arp_tables 5420 1 arptable_filter, Live 0xdfc71000
ipt_MASQUERADE 960 0 - Live 0xdfc66000
ipt_ULOG 3296 3 - Live 0xdfc5d000
xt_recent 3964 0 - Live 0xdfc53000
xt_multiport 1388 11 - Live 0xdfc48000
ipt_REJECT 1288 5 - Live 0xdfc3f000
xt_DSCP 1464 0 - Live 0xdfc36000
xt_layer7 7008 0 - Live 0xdfc2b000
xt_iprange 1136 4 - Live 0xdfc1f000
xt_ipp2p 4548 0 - Live 0xdfc15000
iptable_mangle 808 1 - Live 0xdfc0a000
iptable_filter 660 1 - Live 0xdfc00000
iptable_nat 2032 1 - Live 0xdfbf6000
nf_nat 8692 7 nf_nat_pptp,nf_nat_proto_gre,ipt_REDIRECT,nf_nat_ftp,ipt_NETMAP,ipt_MASQUERADE,iptable_nat,
Live 0xdfbea000
nf_conntrack_ipv4 5632 17 iptable_nat,nf_nat, Live 0xdfbdc000
nf_defrag_ipv4 508 1 nf_conntrack_ipv4, Live 0xdfbd0000
ip_tables 6320 4
iptable_raw,iptable_mangle,iptable_filter,iptable_nat, Live 0xdfbc6000
xt_connlimit 1836 4 - Live 0xdfbba000
xt_helper 612 0 - Live 0xdfbb0000
xt_string 700 6 - Live 0xdfba7000
xt_MARK 744 0 - Live 0xdfb9e000
xt_comment 396 11 - Live 0xdfb95000
xt_state 664 9 - Live 0xdfb8c000
nf_conntrack 30880 16
xt_NOTRACK,nf_nat_pptp,nf_conntrack_pptp,nf_conntrack_proto_gre,xt_conntrack,nf_nat_ftp,nf_conntrack_ftp,nf_conntrack_netlink,ipt_MASQUERADE,xt_layer7,iptable_nat,nf_nat,nf_conntrack_ipv4,xt_connlimit,xt_helper,xt_state,
Live 0xdfb7c000
xt_limit 712 1 - Live 0xdfb64000
xt_mac 480 3 - Live 0xdfb5b000
xt_tcpudp 1436 60 - Live 0xdfb52000
xt_time 1164 0 - Live 0xdfb49000
xt_ACCOUNT 6728 11 - Live 0xdfb3f000
compat_xtables 1016 2 xt_TEE,xt_ACCOUNT, Live 0xdfb37000
x_tables 6200 35
xt_NOTRACK,xt_hashlimit,ipt_REDIRECT,ipt_set,xt_length,xt_mark,xt_TCPMSS,xt_conntrack,arpt_mangle,xt_owner,xt_condition,ipt_NETMAP,arp_tables,ipt_MASQUERADE,ipt_ULOG,xt_recent,xt_multiport,ipt_REJECT,xt_DSCP,xt_layer7,xt_iprange,xt_ipp2p,iptable_nat,ip_tables,xt_connlimit,xt_helper,xt_string,xt_MARK,xt_comment,xt_state,xt_limit,xt_mac,xt_tcpudp,xt_time,compat_xtables,
Live 0xdfb2c000
nfnetlink 1248 1 nf_conntrack_netlink, Live 0xdfb20000
ifb 1304 0 - Live 0xdfb16000
via_rhine 12616 0 - Live 0xdfaf1000
ath5k 95840 0 - Live 0xdfacb000
mac80211 85404 1 ath5k, Live 0xdfa90000
led_class 1240 1 ath5k, Live 0xdfa68000
ath 5312 1 ath5k, Live 0xdfa60000
cfg80211 50496 3 ath5k,mac80211,ath, Live 0xdfa4c000
dm9601 3960 0 - Live 0xdfa30000
usbnet 7184 1 dm9601, Live 0xdfa24000
fbcon 27392 66 - Live 0xdf933000
font 6772 1 fbcon, Live 0xdf925000
bitblit 3388 1 fbcon, Live 0xdf91d000
softcursor 708 1 bitblit, Live 0xdf916000
vga16fb 8212 2 - Live 0xdf90b000
fb 27308 6 fbcon,bitblit,softcursor,vga16fb, Live 0xdf8fc000
cfbcopyarea 2700 1 vga16fb, Live 0xdf8e5000
vgastate 6444 1 vga16fb, Live 0xdf8dd000
cfbimgblt 1676 1 vga16fb, Live 0xdf8d5000
cfbfillrect 2264 1 vga16fb, Live 0xdf8cf000
tcp_bic 1228 4 - Live 0xdf8c5000


# rrdtool
RRDtool 1.2.30
