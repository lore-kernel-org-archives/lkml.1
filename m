Return-Path: <linux-kernel-owner+w=401wt.eu-S932422AbXH3Oqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932422AbXH3Oqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 10:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762189AbXH3OqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 10:46:17 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:4826 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760556AbXH3OqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 10:46:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:disposition-notification-to:date:from:user-agent:mime-version:to:subject:x-enigmail-version:openpgp:content-type;
        b=gWA00XI/0ZOpMWD4CT7uxAGKm0cyfWRcxWY/7IdDUC+e3liMjBypo7UnRRDUVoPs7KkUpKBtY95qRNAXRN1JfloFZzryL/pMkG0SjMU/KuM5HovT0AjvvDGgCh+pjBcwdJepvLetJwTrmaPuB03WlD/rKVOd7kbjlqUeuble7eU=
Message-ID: <46D6D85A.30003@gmail.com>
Date: Thu, 30 Aug 2007 11:46:50 -0300
From: Santiago L Hasenclever <tuxpoweruser@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070809)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: probable kernel Bug
X-Enigmail-Version: 0.95.2
OpenPGP: id=623B05A6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig731FDF68C53D1AA7C2A5EC4C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig731FDF68C53D1AA7C2A5EC4C
Content-Type: multipart/mixed;
 boundary="------------070009000803050701050105"

This is a multi-part message in MIME format.
--------------070009000803050701050105
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Summary: network driver crashes when setting wireless interface as ahd-ho=
c

Description:
(Excuse my english i'm from argentina and i don't know if there is a
mail list in spanish)
When i configure the wireless interface with the following command
"iwconfig eth1 essid darkz mode ad-hoc key s:clave key on" as espected
nothing happens and changes seems to be applied
y set de ip address with the following command "ip addr add 192.168.1/24
dev eth1" and set the interface up with "ip link set eth1 up" so far so
good every thing ok
the i put de dhcpd server up and wait for connections. the following
error appears on screen.

kernel BUG at net/core/skbuff.c:93!
invalid opcode: 0000 [#1]
PREEMPT SMP
Modules linked in: ndiswrapper rng_core
CPU:    0
EIP:    0060:[<c03d8f49>]    Tainted: P       VLI
EFLAGS: 00010296   (2.6.21-gentoo-r3 #7)
EIP is at skb_over_panic+0x59/0x60
eax: 00000073   ebx: f6aec166   ecx: 00000001   edx: 00000002
esi: 00000000   edi: f6aec010   ebp: f4aca500   esp: f2345cdc
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process ntos_wq/0 (pid: 5466, ti=3Df2344000 task=3Df617da70 task.ti=3Df23=
44000)
Stack: c054f71c f89b9d8d 00000156 00000156 f6aec166 f6aec000 f6aec000
f6aec180
       c0525cc1 f1d4a83a f65de480 f89b9d92 ffffffff f2345d44 f2345d38
f2345d40
       f2345d3c 00000010 00000156 f4535bc0 f65de480 00000000 f65de4cb
f1d4a83a
Call Trace:
 [<f89b9d8d>] NdisMIndicateReceivePacket+0x21d/0x260 [ndiswrapper]
 [<f89b9d92>] NdisMIndicateReceivePacket+0x222/0x260 [ndiswrapper]
 [<f89b3ac0>] WRITE_REGISTER_ULONG+0x0/0x10 [ndiswrapper]
 [<f89b8b04>] deserialized_irq_handler+0x14/0x40 [ndiswrapper]
 [<f89b8af0>] deserialized_irq_handler+0x0/0x40 [ndiswrapper]
 [<f89be09f>] kdpc_worker+0x3f/0xd0 [ndiswrapper]
 [<c0133333>] run_workqueue+0x93/0x140
 [<f89be060>] kdpc_worker+0x0/0xd0 [ndiswrapper]
 [<c0133b87>] worker_thread+0x147/0x170
 [<c011de30>] default_wake_function+0x0/0x10
 [<c0133a40>] worker_thread+0x0/0x170
 [<c013685b>] kthread+0xbb/0xf0
 [<c01367a0>] kthread+0x0/0xf0
 [<c01037b3>] kernel_thread_helper+0x7/0x14
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Code: 00 00 89 5c 24 14 8b 98 94 00 00 00 89 54 24 0c 89 5c 24 10 8b 40
60 89 4c 24 04 c7 04 24 1c f7 54 c0 89 44 24 08 e8 17 aa d4 ff <0f> 0b
eb fe 8d 76 00 55 89 d5 57 56 53 83 ec 38 89 44 24 20 8b
EIP: [<c03d8f49>] skb_over_panic+0x59/0x60 SS:ESP 0068:f2345cdc
note: ntos_wq/0[5466] exited with preempt_count 2


The kernel Version is: Linux version 2.6.21-gentoo-r3 (root@Street) (gcc
version 4.1.2 (Gentoo 4.1.2)) #7 SMP PREEMPT Wed Aug 29 19:02:14 ART 2007=



To duplicate the problem this scripts does the trick.

------------------- BEGIN  SCRIPT. ------------------

#!/bin/bash

#load the module
/bin/echo "Loading ndiswrapper module"
/sbin/modprobe ndiswrapper && /bin/echo "OK"


#configure the wireless interface
/bin/echo "configuring wireless mode"
/sbin/iwconfig eth1 essid darkz mode ad-hoc key s:clave key on &&
/bin/echo "Ok"

#set the ip address
/bin/echo "Configuring the ip address"
/sbin/ip addr add 192.168.1/24 dev eth1 && /bin/echo "Ok"

#and put the link up
/bin/echo "putting the link up"
/sbin/ip link set eth1 up && /bin/echo "Ok"


#enable dhcp server with the following configuration
#
#-------------------------------/etc/dhcp/dhcpd.conf-------------
#option domain-name "darkz";
#default-lease-time 600;
#max-lease-time 7200;
#ddns-update-style interim;
#option domain-name-servers 10.0.100.2;
#deny bootp;
#
#shared-network NetworkName {
#        subnet 192.168.1.0 netmask 255.255.255.0 {
#                option routers 192.168.1.1;
#                option subnet-mask 255.255.255.0;
#                pool {
#                        range 192.168.1.100 192.168.1.200;
#                }
#        }
#}
#----------------------------/etc/dhcpd/dhcpd.conf----------------

/bin/echo "Putting dhcp server up"
/usr/sbin/dhcpd eth1 && /bin/echo "OK"


#then a client try to connect an the error appears.
/bin/echo "Configuration Set. Waiting for a client to connect."

------------END SCRIPT--------------


VER_LINUX script output:

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux Street 2.6.21-gentoo-r3 #7 SMP PREEMPT Wed Aug 29 19:02:14 ART
2007 i686 Genuine Intel(R) CPU T2050 @ 1.60GHz GenuineIntel GNU/Linux

Gnu C                  4.1.2
Gnu make               3.81
binutils               2.17
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
PPP                    2.4.4
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.9
udev                   114
wireless-tools         28
Modules Loaded

Processor information :
cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2050  @ 1.60GHz
stepping        : 8
cpu MHz         : 1596.466
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
constant_tsc pni monitor est tm2 xtpr
bogomips        : 3195.65
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel
cpu family      : 6
model           : 14
model name      : Genuine Intel(R) CPU           T2050  @ 1.60GHz
stepping        : 8
cpu MHz         : 1596.466
cache size      : 2048 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 10
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge
mca cmov pat clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx
constant_tsc pni monitor est tm2 xtpr
bogomips        : 3192.87
clflush size    : 64


No modules loaded.

Hardware information:

/proc/ioports :

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:1f.2
  0170-0177 : ide1
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : libata
0376-0376 : 0000:00:1f.2
  0376-0376 : ide1
03c0-03df : vga+
  03c0-03df : vesafb
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : libata
04d0-04d1 : pnp 00:02
0910-091f : pnp 00:08
0920-092f : pnp 00:08
0930-097f : pnp 00:08
0cb0-0cbf : pnp 00:08
0cf8-0cff : PCI conf1
1000-107f : 0000:00:1f.0
  1000-1005 : pnp 00:02
    1000-1003 : ACPI PM1a_EVT_BLK
    1004-1005 : ACPI PM1a_CNT_BLK
  1006-1007 : pnp 00:03
  1008-100f : pnp 00:02
    1008-100b : ACPI PM_TMR
  1010-1015 : ACPI CPU throttle
  1020-1020 : ACPI PM2_CNT_BLK
  1028-102f : ACPI GPE0_BLK
  1060-107f : pnp 00:03
1080-10bf : 0000:00:1f.0
  1080-10bf : pnp 00:03
10c0-10df : 0000:00:1f.3
  10c0-10df : pnp 00:03
    10c0-10df : i801_smbus
bf20-bf3f : 0000:00:1d.3
  bf20-bf3f : uhci_hcd
bf40-bf5f : 0000:00:1d.2
  bf40-bf5f : uhci_hcd
bf60-bf7f : 0000:00:1d.1
  bf60-bf7f : uhci_hcd
bf80-bf9f : 0000:00:1d.0
  bf80-bf9f : uhci_hcd
bfa0-bfaf : 0000:00:1f.2
  bfa0-bfaf : libata
d000-dfff : PCI Bus #0d
eff8-efff : 0000:00:02.0
f400-f4fe : pnp 00:03


/proc/iomem :

00000000-0009efff : System RAM
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000ce800-000cffff : Adapter ROM
000f0000-000fffff : System ROM
00100000-3f6d33ff : System RAM
  00100000-00490390 : Kernel code
  00490391-005c884b : Kernel data
3f6d3400-3fffffff : reserved
d0000000-dfffffff : 0000:00:02.0
  d0000000-d07affff : vesafb
e0000000-e01fffff : PCI Bus #0d
ef900000-ef9fffff : PCI Bus #02
  ef9fd400-ef9fd4ff : 0000:02:01.1
    ef9fd400-ef9fd4ff : sdhci:slot0
  ef9fd500-ef9fd5ff : 0000:02:01.2
  ef9fd600-ef9fd6ff : 0000:02:01.3
  ef9fd700-ef9fd7ff : 0000:02:01.4
  ef9fd800-ef9fdfff : 0000:02:01.0
  ef9fe000-ef9fffff : 0000:02:00.0
    ef9fe000-ef9fffff : b44
efa00000-efcfffff : PCI Bus #0d
efd00000-efdfffff : PCI Bus #0c
  efdfc000-efdfffff : 0000:0c:00.0
efebc000-efebffff : 0000:00:1b.0
  efebc000-efebffff : ICH HD audio
efec0000-efefffff : 0000:00:02.0
eff00000-eff7ffff : 0000:00:02.0
eff80000-efffffff : 0000:00:02.1
f0000000-f4006fff : reserved
f4008000-f400bfff : reserved
fec00000-fec0ffff : reserved
fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
fee00000-fee0ffff : reserved
ffa80000-ffa803ff : 0000:00:1d.7
  ffa80000-ffa803ff : ehci_hcd
ffb00000-ffffffff : reserved


lspci -vvv output:

00:00.0 Host bridge: Intel Corporation Mobile 945GM/PM/GMS/940GML and
945GT Express Memory Controller Hub (rev 03)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation Mobile
945GM/GMS/940GML Express Integrated Graphics Controller (rev 03)
(prog-if 00 [VGA])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at eff00000 (32-bit, non-prefetchable) [size=3D5=
12K]
        Region 1: I/O ports at eff8 [size=3D8]
        Region 2: Memory at d0000000 (32-bit, prefetchable) [size=3D256M]=

        Region 3: Memory at efec0000 (32-bit, non-prefetchable) [size=3D2=
56K]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/940GML
Express Integrated Graphics Controller (rev 03)
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Region 0: Memory at eff80000 (32-bit, non-prefetchable) [size=3D5=
12K]
        Capabilities: [d0] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at efebc000 (64-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=3D0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed unknown, Width x0, ASPM unknown,
Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0
        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0b, subordinate=3D0b, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 1
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 2, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable+
                Address: fee0300c  Data: 41c1
        Capabilities: [90] Subsystem: Dell Unknown device 01d8
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 2 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0c, subordinate=3D0c, sec-latency=3D=
0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: efd00000-efdfffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 2
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM L0s Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 3, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable+
                Address: fee0300c  Data: 41c9
        Capabilities: [90] Subsystem: Dell Unknown device 01d8
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.3 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 4 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=3D00, secondary=3D0d, subordinate=3D0e, sec-latency=3D=
0
        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: efa00000-efcfffff
        Prefetchable memory behind bridge: 00000000e0000000-00000000e01ff=
fff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupporte=
d+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Por=
t 4
                Link: Latency L0s <1us, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+
Surpise+
                Slot: Number 5, PowerLimit 6.500000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet+ CmdCplt- HPIr=
q-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable+
                Address: fee0300c  Data: 41d1
        Capabilities: [90] Subsystem: Dell Unknown device 01d8
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#1 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 4: I/O ports at bf80 [size=3D32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#2 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at bf60 [size=3D32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#3 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 21
        Region 4: I/O ports at bf40 [size=3D32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI
#4 (rev 01) (prog-if 00 [UHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 22
        Region 4: I/O ports at bf20 [size=3D32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI
Controller (rev 01) (prog-if 20 [EHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at ffa80000 (32-bit, non-prefetchable) [size=3D1=
K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev e1)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D=
32
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: ef900000-ef9fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000ff=
fff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Dell Unknown device 01d8

00:1f.0 ISA bridge: Intel Corporation 82801GBM (ICH7-M) LPC Interface
Bridge (rev 01)
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.2 IDE interface: Intel Corporation 82801GBM/GHM (ICH7 Family)
Serial ATA Storage Controller IDE (rev 01) (prog-if 80 [Master])
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 17
        Region 0: I/O ports at 01f0 [size=3D8]
        Region 1: I/O ports at 03f4 [size=3D1]
        Region 2: I/O ports at 0170 [size=3D8]
        Region 3: I/O ports at 0374 [size=3D1]
        Region 4: I/O ports at bfa0 [size=3D16]
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller
(rev 01)
        Subsystem: Dell Unknown device 01d8
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 17
        Region 4: I/O ports at 10c0 [size=3D32]

02:00.0 Ethernet controller: Broadcom Corporation BCM4401-B0 100Base-TX
(rev 02)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 224
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at ef9fe000 (32-bit, non-prefetchable) [size=3D8=
K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

02:01.0 FireWire (IEEE 1394): Ricoh Co Ltd Unknown device 0832 (prog-if
10 [OHCI])
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 72 (500ns min, 1000ns max)
        Interrupt: pin A routed to IRQ 3
        Region 0: Memory at ef9fd800 (32-bit, non-prefetchable) [size=3D2=
K]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

02:01.1 Generic system peripheral [0805]: Ricoh Co Ltd R5C822
SD/SDIO/MMC/MS/MSPro Host Adapter (rev 19) (prog-if 01)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 72
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at ef9fd400 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

02:01.2 System peripheral: Ricoh Co Ltd Unknown device 0843 (rev 01)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at ef9fd500 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

02:01.3 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
Adapter (rev 0a)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at ef9fd600 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

02:01.4 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 0=
5)
        Subsystem: Dell Unknown device 01d8
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort=
-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 11
        Region 0: Memory at ef9fd700 (32-bit, non-prefetchable) [size=3D2=
56]
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-

0c:00.0 Network controller: Broadcom Corporation Unknown device 4311
(rev 01)
        Subsystem: Dell Unknown device 0007
        Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at efdfc000 (32-bit, non-prefetchable) [size=3D1=
6K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=3D0 DScale=3D2 PME-
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit-
Queue=3D0/0 Enable-
                Address: 00000000  Data: 0000
        Capabilities: [d0] Express Legacy Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0,
ExtTag+
                Device: Latency L0s <4us, L1 unlimited
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupporte=
d-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 0=

                Link: Latency L0s <4us, L1 <64us
                Link: ASPM L0s Enabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [13c] Virtual Channel


No Scsi Devices.

=2E


This machine is a  Dell Inspiron E1405.

I have no other information, if you need anything else please ask or if
you tink that this mail should ve sent elsewere.


Thanks.















--------------070009000803050701050105
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC42IChH
TlUvTGludXgpCgppRDhEQlFGRzFnZnFyTitpQW1JN0JhWVJBbWh3QUprQkZ0Q21UOXVFdHEv
S2I5d0hXaXQ4Y3JQeUpRQ2ZTcUNyCkdGWDNIQ2xQZXlqYitUSlZFSU5zYm9zPQo9NHB5Kwot
LS0tLUVORCBQR1AgU0lHTkFUVVJFLS0tLS0KCg==
--------------070009000803050701050105--

--------------enig731FDF68C53D1AA7C2A5EC4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1therN+iAmI7BaYRArbRAKCQv3Ge0d1d/bocfzFYaOu6cH4kJQCfbakl
KsO+iUVsEIZyQaidYkkDBzI=
=uH4V
-----END PGP SIGNATURE-----

--------------enig731FDF68C53D1AA7C2A5EC4C--
