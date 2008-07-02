Return-Path: <linux-kernel-owner+w=401wt.eu-S1762642AbYGBHOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762642AbYGBHOb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 03:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759937AbYGBHOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 03:14:23 -0400
Received: from 62-63-40-67.customer.bbft.net ([62.63.40.67]:38547 "EHLO
	home.custopublish.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755653AbYGBHOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 03:14:20 -0400
X-Greylist: delayed 1459 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2008 03:14:19 EDT
Message-ID: <486B2514.50107@edbc.no>
Date: Wed, 02 Jul 2008 08:49:56 +0200
From: Svein Larsen <svein@edbc.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Kernel panic
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 080701-0, 01.07.2008), Outbound message
X-Antivirus-Status: Clean
X-Spam-Flag: NO
X-Virus-Found: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I have no idea where to report and didnt find the REPORTING-BUGS 
file in kernel tree so i send here. Hope it helps in some way.

- Svein

- Kernel panic

Linux version 2.6.9-55.ELsmp (brewbuilder@ls20-bc2-14.build.redhat.com) 
(gcc version 3.4.6 20060404 (Red Hat 3.4.6-3)) #1 SMP Fri Apr 20 
17:03:35 EDT 2007

Jul  2 07:52:56 web kernel: ------------[ cut here ]------------
Jul  2 07:52:56 web kernel: kernel BUG at fs/jbd/journal.c:576!
Jul  2 07:52:56 web kernel: invalid operand: 0000 [#1]
Jul  2 07:52:56 web kernel: SMP
Jul  2 07:52:56 web kernel: Modules linked in: autofs4 i2c_dev i2c_core 
sunrpc ipt_REJECT ipt_state ip_conntrack iptable_filter ip_tables sr_mod 
ide_scsi md5 ipv6 joydev button battery ac
   uhci_hcd ehci_hcd hw_random shpchp e1000(U) floppy ata_piix libata sg 
dm_snapshot dm_zero dm_mirror ext3 jbd dm_mod megaraid_mbox megaraid_mm 
sd_mod scsi_mod
Jul  2 07:52:56 web kernel: CPU:    3
Jul  2 07:52:56 web kernel: EIP:    0060:[<f88846f1>]    Not tainted VLI
Jul  2 07:52:56 web kernel: EFLAGS: 00010216   (2.6.9-55.ELsmp)
Jul  2 07:52:56 web kernel: EIP is at journal_next_log_block+0x39/0x83 [jbd]
Jul  2 07:52:56 web kernel: eax: 00000060   ebx: f7e00800   ecx: 
d1a8edcc   edx: f8887205
Jul  2 07:52:56 web kernel: esi: d87d418c   edi: f7e00814   ebp: 
d1a8ee14   esp: d1a8edc8
Jul  2 07:52:56 web kernel: ds: 007b   es: 007b   ss: 0068
Jul  2 07:52:56 web kernel: Process kjournald (pid: 2762, 
threadinfo=d1a8e000 task=f6c4c2b0)
Jul  2 07:52:56 web kernel: Stack: f8887205 f888602f f88871f4 00000240 
f888728f f7e00800 d87d418c ca53e23c
Jul  2 07:52:56 web kernel:        f7d6f900 f888190f 00000000 00000000 
00000e6c d87d4194 00000000 00000030
Jul  2 07:52:56 web kernel:        dc6c917c f7e00800 e45187dc 00001a2e 
00000000 f6c4c2b0 c012052d d1a8ee44
Jul  2 07:52:56 web kernel: Call Trace:
Jul  2 07:52:56 web kernel:  [<f888190f>] 
journal_commit_transaction+0x6d0/0xfd5 [jbd]
Jul  2 07:52:56 web kernel:  [<c012052d>] autoremove_wake_function+0x0/0x2d
Jul  2 07:52:56 web kernel:  [<c012052d>] autoremove_wake_function+0x0/0x2d
Jul  2 07:52:56 web kernel:  [<f8883ec5>] kjournald+0xc7/0x219 [jbd]
Jul  2 07:52:56 web kernel:  [<c012052d>] autoremove_wake_function+0x0/0x2d
Jul  2 07:52:56 web kernel:  [<c012052d>] autoremove_wake_function+0x0/0x2d
Jul  2 07:52:56 web kernel:  [<c011d69a>] schedule_tail+0x31/0xae
Jul  2 07:52:56 web kernel:  [<f8883df8>] commit_timeout+0x0/0x5 [jbd]
Jul  2 07:52:56 web kernel:  [<f8883dfe>] kjournald+0x0/0x219 [jbd]
Jul  2 07:52:56 web kernel:  [<c01041f5>] kernel_thread_helper+0x5/0xb
Jul  2 07:52:56 web kernel: Code: 51 03 a5 c7 83 bb c4 00 00 00 01 77 29 
68 8f 72 88 f8 68 40 02 00 00 68 f4 71 88 f8 68 2f 60 88 f8 68 05 72 88 
f8 e8 01 e2 89 c7 <0f> 0b 40 02 f4 71 88 f8 83 c4 14 ff 8b c4 00 00 00 
8b b3 bc 00
Jul  2 07:52:56 web kernel:  <0>Fatal exception: panic in 5 seconds


* /proc/cpuinfo:
processor : 0
vendor_id : GenuineIntel
cpu family  : 15
model   : 4
model name  : Intel(R) Xeon(TM) CPU 3.40GHz
stepping  : 10
cpu MHz   : 3392.243
cache size  : 2048 KB
physical id : 0
siblings  : 2
core id   : 0
cpu cores : 1
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 5
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est cid xtpr
bogomips  : 6787.31

processor : 1
vendor_id : GenuineIntel
cpu family  : 15
model   : 4
model name  : Intel(R) Xeon(TM) CPU 3.40GHz
stepping  : 10
cpu MHz   : 3392.243
cache size  : 2048 KB
physical id : 0
siblings  : 2
core id   : 0
cpu cores : 1
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 5
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est cid xtpr
bogomips  : 6783.48

processor : 2
vendor_id : GenuineIntel
cpu family  : 15
model   : 4
model name  : Intel(R) Xeon(TM) CPU 3.40GHz
stepping  : 10
cpu MHz   : 3392.243
cache size  : 2048 KB
physical id : 3
siblings  : 2
core id   : 3
cpu cores : 1
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 5
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est cid xtpr
bogomips  : 6783.76

processor : 3
vendor_id : GenuineIntel
cpu family  : 15
model   : 4
model name  : Intel(R) Xeon(TM) CPU 3.40GHz
stepping  : 10
cpu MHz   : 3392.243
cache size  : 2048 KB
physical id : 3
siblings  : 2
core id   : 3
cpu cores : 1
fdiv_bug  : no
hlt_bug   : no
f00f_bug  : no
coma_bug  : no
fpu   : yes
fpu_exception : yes
cpuid level : 5
wp    : yes
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm 
constant_tsc pni monitor ds_cpl est cid xtpr
bogomips  : 6783.50

*/proc/modules:
autofs4 25285 0 - Live 0xf8b93000
i2c_dev 14529 0 - Live 0xf8b8e000
i2c_core 26049 1 i2c_dev, Live 0xf8b86000
sunrpc 143909 1 - Live 0xf8ba5000
ipt_REJECT 10689 1 - Live 0xf8a11000
ipt_state 5953 25 - Live 0xf8a09000
ip_conntrack 46085 1 ipt_state, Live 0xf8a15000
iptable_filter 6977 1 - Live 0xf8870000
ip_tables 22721 3 ipt_REJECT,ipt_state,iptable_filter, Live 0xf89f7000
sr_mod 20965 0 - Live 0xf89b8000
ide_scsi 20553 0 [permanent], Live 0xf89b1000
md5 8129 1 - Live 0xf88e5000
ipv6 243425 69 - Live 0xf8a3f000
joydev 14465 0 - Live 0xf88f2000
button 10705 0 - Live 0xf88dd000
battery 12997 0 - Live 0xf88f7000
ac 8901 0 - Live 0xf88e1000
uhci_hcd 33241 0 - Live 0xf88e8000
ehci_hcd 32325 0 - Live 0xf88aa000
hw_random 9685 0 - Live 0xf889c000
shpchp 85061 0 - Live 0xf89e1000
e1000 95060 0 - Live 0xf8927000
floppy 58193 0 - Live 0xf8917000
ata_piix 19141 0 - Live 0xf88a4000
libata 106141 1 ata_piix, Live 0xf88fc000
sg 38369 0 - Live 0xf88d2000
dm_snapshot 21093 0 - Live 0xf888f000
dm_zero 6337 0 - Live 0xf886b000
dm_mirror 31173 0 - Live 0xf8876000
ext3 119113 8 - Live 0xf88b3000
jbd 59609 1 ext3, Live 0xf887f000
dm_mod 64617 17 dm_snapshot,dm_zero,dm_mirror, Live 0xf882f000
megaraid_mbox 37329 4 - Live 0xf8860000
megaraid_mm 17777 1 megaraid_mbox, Live 0xf8829000
sd_mod 20545 7 - Live 0xf8822000
scsi_mod 119757 6 sr_mod,ide_scsi,libata,sg,megaraid_mbox,sd_mod, Live 
0xf8841000

*/proc/ioports:
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
01f0-01f7 : ide2
03c0-03df : vga+
03f6-03f6 : ide2
03f8-03ff : serial
0800-087f : 0000:00:1f.0
   0800-0803 : PM1a_EVT_BLK
   0804-0805 : PM1a_CNT_BLK
   0808-080b : PM_TMR
   0828-082f : GPE0_BLK
0880-08bf : 0000:00:1f.0
bca0-bcbf : 0000:00:1d.2
   bca0-bcbf : uhci_hcd
bcc0-bcdf : 0000:00:1d.1
   bcc0-bcdf : uhci_hcd
bce0-bcff : 0000:00:1d.0
   bce0-bcff : uhci_hcd
c800-c8ff : 0000:0b:0d.0
cc70-cc7f : 0000:0b:06.0
cc80-ccbf : 0000:0b:05.1
   cc80-cc87 : serial
ccd0-ccd3 : 0000:0b:06.0
ccd8-ccdf : 0000:0b:06.0
cce4-cce7 : 0000:0b:06.0
cce8-ccef : 0000:0b:05.0
ccf0-ccf7 : 0000:0b:06.0
ccf8-ccff : 0000:0b:05.0
d000-efff : PCI Bus #05
   d000-dfff : PCI Bus #07
     dcc0-dcff : 0000:07:08.0
       dcc0-dcff : e1000
   e000-efff : PCI Bus #06
     ecc0-ecff : 0000:06:07.0
       ecc0-ecff : e1000
fc00-fc0f : 0000:00:1f.1
   fc00-fc07 : ide2

* /proc/iomem:
00000000-0009ffff : System RAM
000a0000-000bffff : Video RAM area
000c0000-000c7fff : Video ROM
000cb000-000cbfff : Adapter ROM
000cc000-000ccfff : Adapter ROM
000cd000-000d0bff : Adapter ROM
000d1000-000d31ff : Adapter ROM
000d3800-000d3dff : Adapter ROM
000f0000-000fffff : System ROM
00100000-bffbffff : System RAM
   00100000-002d6bdb : Kernel code
   002d6bdc-0039537f : Kernel data
bffc0000-bffcfbff : ACPI Tables
bffcfc00-bfffefff : reserved
c0000000-c00003ff : 0000:00:1f.1
c8000000-cfffffff : 0000:0b:0d.0
d7f00000-d7f7ffff : 0000:0b:05.1
d7fff000-d7ffffff : 0000:0b:05.0
d8000000-d80fffff : PCI Bus #01
   d8000000-d80fffff : PCI Bus #02
     d80f0000-d80fffff : 0000:02:0e.0
       d80f0000-d80fffff : MegaRAID: LSI Logic Corporation
df4e0000-df4effff : 0000:0b:0d.0
df4fec00-df4fecff : 0000:0b:06.0
   df4fec00-df4fecff : SiI680
df4ff000-df4fffff : 0000:0b:05.1
df600000-df6fffff : PCI Bus #08
df700000-dfbfffff : PCI Bus #05
   df800000-df9fffff : PCI Bus #07
     df8e0000-df8fffff : 0000:07:08.0
       df8e0000-df8fffff : e1000
   dfa00000-dfbfffff : PCI Bus #06
     dfae0000-dfafffff : 0000:06:07.0
       dfae0000-dfafffff : e1000
dfc00000-dfefffff : PCI Bus #01
   dfd00000-dfefffff : PCI Bus #02
     dfdc0000-dfdfffff : 0000:02:0e.0
       dfdc0000-dfdfffff : MegaRAID: LSI Logic Corporation
dff00000-dff003ff : 0000:00:1d.7
   dff00000-dff003ff : ehci_hcd
e0000000-fec8ffff : reserved
fed00000-fed003ff : reserved
fee00000-fee0ffff : reserved
ffb00000-ffffffff : reserved

*PCI Info:
00:00.0 Host bridge: Intel Corporation E7520 Memory Controller Hub (rev 09)
   Subsystem: Dell: Unknown device 016d
   Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Capabilities: [40] Vendor Specific Information

00:02.0 PCI bridge: Intel Corporation E7525/E7520/E7320 PCI Express Port 
A (rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=00, secondary=01, subordinate=03, sec-latency=0
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: dfc00000-dfefffff
   Prefetchable memory behind bridge: 00000000d8000000-00000000d8000000
   Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR+ <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
     Address: fee00000  Data: 0000
   Capabilities: [64] Express Root Port (Slot-) IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 2
     Link: Latency L0s <4us, L1 unlimited
     Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
     Root: Correctable- Non-Fatal- Fatal- PME-
   Capabilities: [100] Advanced Error Reporting

00:04.0 PCI bridge: Intel Corporation E7525/E7520 PCI Express Port B 
(rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: fff00000-000fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
     Address: fee00000  Data: 0000
   Capabilities: [64] Express Root Port (Slot-) IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 4
     Link: Latency L0s <4us, L1 unlimited
     Link: ASPM Disabled RCB 64 bytes Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
     Root: Correctable- Non-Fatal- Fatal- PME-
   Capabilities: [100] Advanced Error Reporting
00:05.0 PCI bridge: Intel Corporation E7520 PCI Express Port B1 (rev 09) 
(prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=00, secondary=05, subordinate=07, sec-latency=0
   I/O behind bridge: 0000d000-0000efff
   Memory behind bridge: df700000-dfbfffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR+ <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
     Address: fee00000  Data: 0000
   Capabilities: [64] Express Root Port (Slot-) IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
     Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 5
     Link: Latency L0s <4us, L1 unlimited
     Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x4
     Root: Correctable- Non-Fatal- Fatal- PME-
   Capabilities: [100] Advanced Error Reporting

00:06.0 PCI bridge: Intel Corporation E7520 PCI Express Port C (rev 09) 
(prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=00, secondary=08, subordinate=0a, sec-latency=0
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: df600000-df6fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR+ <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [58] Message Signalled Interrupts: 64bit- Queue=0/1 Enable-
     Address: fee00000  Data: 0000
   Capabilities: [64] Express Root Port (Slot-) IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 128 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 6
     Link: Latency L0s <4us, L1 unlimited
     Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
     Root: Correctable- Non-Fatal- Fatal- PME-
   Capabilities: [100] Advanced Error Reporting
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #1 (rev 02) (prog-if 00 [UHCI])
   Subsystem: Dell: Unknown device 016d
   Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Interrupt: pin A routed to IRQ 169
   Region 4: I/O ports at bce0 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #2 (rev 02) (prog-if 00 [UHCI])
   Subsystem: Dell: Unknown device 016d
   Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Interrupt: pin B routed to IRQ 177
   Region 4: I/O ports at bcc0 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB 
UHCI Controller #3 (rev 02) (prog-if 00 [UHCI])
   Subsystem: Dell: Unknown device 016d
   Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Interrupt: pin C routed to IRQ 185
   Region 4: I/O ports at bca0 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 
EHCI Controller (rev 02) (prog-if 20 [EHCI])
   Subsystem: Dell: Unknown device 016d
   Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Interrupt: pin D routed to IRQ 193
   Region 0: Memory at dff00000 (32-bit, non-prefetchable) [size=1K]
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 
00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Bus: primary=00, secondary=0b, subordinate=0b, sec-latency=32
   I/O behind bridge: 0000c000-0000cfff
   Memory behind bridge: df400000-df5fffff
   Prefetchable memory behind bridge: c8000000-d7ffffff
   Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC 
Interface Bridge (rev 02)
   Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr+ 
Stepping- SERR+ FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
   Subsystem: Dell: Unknown device 016d
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
   Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0
   Interrupt: pin A routed to IRQ 0
   Region 0: I/O ports at <unassigned>
   Region 1: I/O ports at <unassigned>
   Region 2: I/O ports at <unassigned>
   Region 3: I/O ports at <unassigned>
   Region 4: I/O ports at fc00 [size=16]
   Region 5: Memory at c0000000 (32-bit, non-prefetchable) [size=1K]
01:00.0 PCI bridge: Intel Corporation 80332 [Dobson] I/O processor 
(A-Segment Bridge) (rev 06) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=01, secondary=02, subordinate=02, sec-latency=64
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: dfd00000-dfefffff
   Prefetchable memory behind bridge: 00000000d8000000-00000000d8000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=133MHz
     Status: Bus=1 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting

01:00.2 PCI bridge: Intel Corporation 80332 [Dobson] I/O processor 
(B-Segment Bridge) (rev 06) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=01, secondary=03, subordinate=03, sec-latency=64
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: fff00000-000fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=133MHz
     Status: Bus=1 Dev=0 Func=2 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting
02:0e.0 RAID bus controller: Dell PowerEdge Expandable RAID controller 4 
(rev 06)
   Subsystem: Dell PowerEdge Expandable RAID Controller 4e/Di
   Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping+ SERR+ FastB2B-
   Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 64 (32000ns min), Cache Line Size 10
   Interrupt: pin A routed to IRQ 201
   Region 0: Memory at d80f0000 (32-bit, prefetchable) [size=64K]
   Region 2: Memory at dfdc0000 (32-bit, non-prefetchable) [size=256K]
   Expansion ROM at dfe00000 [disabled] [size=128K]
   Capabilities: [c0] Power Management version 2
     Flags: PMEClk- DSI- D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d0] Message Signalled Interrupts: 64bit+ Queue=0/1 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [e0] PCI-X non-bridge device.
     Command: DPERE- ERO- RBC=0 OST=3
     Status: Bus=2 Dev=14 Func=0 64bit+ 133MHz+ SCD- USC-, DC=bridge, 
DMMRBC=1, DMOST=3, DMCRS=1, RSCEM-

05:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
A (rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=05, secondary=06, subordinate=06, sec-latency=32
   I/O behind bridge: 0000e000-0000efff
   Memory behind bridge: dfa00000-dfbfffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=conv
     Status: Bus=5 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting
05:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
B (rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=05, secondary=07, subordinate=07, sec-latency=32
   I/O behind bridge: 0000d000-0000dfff
   Memory behind bridge: df800000-df9fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=conv
     Status: Bus=5 Dev=0 Func=2 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting

06:07.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet 
Controller (rev 05)
   Subsystem: Dell PowerEdge 1850
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 32 (63750ns min), Cache Line Size 10
   Interrupt: pin A routed to IRQ 209
   Region 0: Memory at dfae0000 (32-bit, non-prefetchable) [size=128K]
   Region 2: I/O ports at ecc0 [size=64]
   Capabilities: [dc] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=1 PME-
   Capabilities: [e4] PCI-X non-bridge device.
     Command: DPERE- ERO+ RBC=0 OST=0
     Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple, 
DMMRBC=2, DMOST=0, DMCRS=0, RSCEM-

07:08.0 Ethernet controller: Intel Corporation 82541GI Gigabit Ethernet 
Controller (rev 05)
   Subsystem: Dell PowerEdge 1850
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 32 (63750ns min), Cache Line Size 10
   Interrupt: pin A routed to IRQ 217
   Region 0: Memory at df8e0000 (32-bit, non-prefetchable) [size=128K]
   Region 2: I/O ports at dcc0 [size=64]
   Capabilities: [dc] Power Management version 2
     Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=1 PME-
   Capabilities: [e4] PCI-X non-bridge device.
     Command: DPERE- ERO+ RBC=0 OST=0
     Status: Bus=0 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, DC=simple, 
DMMRBC=2, DMOST=0, DMCRS=0, RSCEM-
08:00.0 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
A (rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=08, secondary=09, subordinate=09, sec-latency=64
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: fff00000-000fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=133MHz
     Status: Bus=8 Dev=0 Func=0 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting

08:00.2 PCI bridge: Intel Corporation 6700PXH PCI Express-to-PCI Bridge 
B (rev 09) (prog-if 00 [Normal decode])
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr+ 
Stepping- SERR- FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 0, Cache Line Size 10
   Bus: primary=08, secondary=0a, subordinate=0a, sec-latency=64
   I/O behind bridge: 0000f000-00000fff
   Memory behind bridge: fff00000-000fffff
   Prefetchable memory behind bridge: 00000000fff00000-0000000000000000
   Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
   BridgeCtl: Parity+ SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-
   Capabilities: [44] Express PCI/PCI-X Bridge IRQ 0
     Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-
     Device: Latency L0s <64ns, L1 <1us
     Device: AtnBtn- AtnInd- PwrInd-
     Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported-
     Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
     Device: MaxPayload 256 bytes, MaxReadReq 512 bytes
     Link: Supported Speed 2.5Gb/s, Width x8, ASPM L0s, Port 0
     Link: Latency L0s unlimited, L1 unlimited
     Link: ASPM Disabled CommClk- ExtSynch-
     Link: Speed 2.5Gb/s, Width x8
   Capabilities: [5c] Message Signalled Interrupts: 64bit+ Queue=0/0 Enable-
     Address: 0000000000000000  Data: 0000
   Capabilities: [6c] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
   Capabilities: [d8] PCI-X bridge device.
     Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, SRD- Freq=133MHz
     Status: Bus=8 Dev=0 Func=2 64bit- 133MHz- SCD- USC-, SCO-, SRD-
     : Upstream: Capacity=65535, Commitment Limit=65535
     : Downstream: Capacity=65535, Commitment Limit=65535
   Capabilities: [100] Advanced Error Reporting
   Capabilities: [300] Power Budgeting
0b:05.0 Class ff00: Dell Remote Access Card 4 Daughter Card
   Subsystem: Dell Remote Access Card 4 Daughter Card
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 32, Cache Line Size 10
   Interrupt: pin A routed to IRQ 225
   Region 0: Memory at d7fff000 (32-bit, prefetchable) [size=4K]
   Region 1: I/O ports at ccf8 [size=8]
   Region 2: I/O ports at cce8 [size=8]
   Expansion ROM at df500000 [disabled] [size=64K]
   Capabilities: [48] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0b:05.1 Class ff00: Dell Remote Access Card 4 Daughter Card Virtual UART
   Subsystem: Dell Remote Access Card 4 Daughter Card Virtual UART
   Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Interrupt: pin B routed to IRQ 233
   Region 0: Memory at df4ff000 (32-bit, non-prefetchable) [size=4K]
   Region 1: I/O ports at cc80 [size=64]
   Region 2: Memory at d7f00000 (32-bit, prefetchable) [size=512K]
   Capabilities: [48] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0b:05.2 Class ff00: Dell Remote Access Card 4 Daughter Card SMIC interface
   Subsystem: Dell Remote Access Card 4 Daughter Card SMIC interface
   Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Capabilities: [48] Power Management version 2
     Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-

0b:06.0 IDE interface: Silicon Image, Inc. PCI0680 Ultra ATA-133 Host 
Controller (rev 02) (prog-if 85 [Master SecO PriO])
   Subsystem: Silicon Image, Inc. PCI0680 Ultra ATA-133 Host Controller
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 32, Cache Line Size 01
   Interrupt: pin A routed to IRQ 193
   Region 0: I/O ports at ccf0 [size=8]
   Region 1: I/O ports at cce4 [size=4]
   Region 2: I/O ports at ccd8 [size=8]
   Region 3: I/O ports at ccd0 [size=4]
   Region 4: I/O ports at cc70 [size=16]
   Region 5: Memory at df4fec00 (32-bit, non-prefetchable) [size=256]
   Expansion ROM at df500000 [disabled] [size=512K]
   Capabilities: [60] Power Management version 2
     Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=2 PME-

0b:0d.0 VGA compatible controller: ATI Technologies Inc Radeon RV100 QY 
[Radeon 7000/VE] (prog-if 00 [VGA])
   Subsystem: Dell: Unknown device 016d
   Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop+ ParErr- 
Stepping+ SERR+ FastB2B-
   Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
   Latency: 32 (2000ns min), Cache Line Size 10
   Interrupt: pin A routed to IRQ 185
   Region 0: Memory at c8000000 (32-bit, prefetchable) [size=128M]
   Region 1: I/O ports at c800 [size=256]
   Region 2: Memory at df4e0000 (32-bit, non-prefetchable) [size=64K]
   Capabilities: [50] Power Management version 2
     Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
     Status: D0 PME-Enable- DSel=0 DScale=0 PME-
