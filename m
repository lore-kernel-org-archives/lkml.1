Return-Path: <linux-kernel-owner+w=401wt.eu-S1752788AbZGYVge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788AbZGYVge (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 17:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752381AbZGYVgd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 17:36:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:47502 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbZGYVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 17:36:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:subject:x-enigmail-version:openpgp:content-type;
        b=F0y1ldH8bdcU2uP4pys4CSLHE8HACKDteBWjExHXniUEYwQEJKvRAmPe4n2BJFt6wj
         CKNou3ILVW9Jq0YrEP4qEBdMMeNE4fBLTAc32OOBZXoExTJXlUnT2B1lO3AK35Lt2Xtv
         Bg2ZyKhkDS8hEybQmeOePZgxOq33Ptj9HYlbw=
Message-ID: <4A6B7AD6.7000004@gmail.com>
Date: Sat, 25 Jul 2009 23:36:22 +0200
From: Marco Di Fresco <marco.difresco@gmail.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: kernel BUG at fs/buffer.c:3259
X-Enigmail-Version: 0.95.7
OpenPGP: id=F64CB282
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig90774D0D26F58D83BFC02586"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig90774D0D26F58D83BFC02586
Content-Type: multipart/mixed;
 boundary="------------030900020204020807060207"

This is a multi-part message in MIME format.
--------------030900020204020807060207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I found this oops that may be interesting.

[1.] Upon installing patch to World of Warcraft, the installer hanged
[2.] I was installing the patch 3.0.9.9551 to World of Warcraft
(installed with Wine) and I noticed the installer hanged at about 24%; I
checked 'dmesg' if there were any problem with the file system and I
noticed this oops
[3.] kernel, wine
[4.] Linux version 2.6.30.2-20090720 (root@PC-MARCO) (gcc version 4.3.3
(Ubuntu 4.3.3-5ubuntu4) ) #1 SMP PREEMPT Mon Jul 20 12:19:43 CEST 2009
[5.] Attached file 'oops.txt'
[6.] wine WoW-3.0.8.9506-to-3.0.9.9551-enGB-patch.exe
[7.] Kubuntu 9.04 64 Bits
[7.1.] Wine 1.1.26
[7.2.] Attached file cpuinfo.txt
[7.3.] Attached file 'modules.txt'
[7.4.] Attached files ioports.txt and iomem.txt
[7.5.] Attached file 'PCI.txt'
[7.6.] Attached file 'scsi.txt'
[7.7.] None

If you need more information, please do not hesitate to contact me.

Best regards.


Marco Di Fresco
http://www.silicongadget.com/





--------------030900020204020807060207
Content-Type: text/plain;
 name="modules.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="modules.txt"

isofs 36648 0 - Live 0xffffffffa0c64000
udf 87496 1 - Live 0xffffffffa0c4c000
crc_itu_t 2592 1 udf, Live 0xffffffffa0012000
binfmt_misc 10316 1 - Live 0xffffffffa0c47000
bridge 57344 0 - Live 0xffffffffa0c37000
stp 3236 1 bridge, Live 0xffffffffa09af000
bnep 15328 2 - Live 0xffffffffa0c31000
vboxnetadp 100204 0 - Live 0xffffffffa0c16000
vboxnetflt 107724 0 - Live 0xffffffffa0bf9000
vboxdrv 1711788 1 vboxnetflt, Live 0xffffffffa0a55000
video 23068 0 - Live 0xffffffffa0a4d000
output 4032 1 video, Live 0xffffffffa0a47000
lp 11844 0 - Live 0xffffffffa0a3f000
snd_usb_audio 101856 2 - Live 0xffffffffa0a21000
snd_usb_lib 19456 1 snd_usb_audio, Live 0xffffffffa0a1a000
gspca_sonixj 22368 0 - Live 0xffffffffa0a12000
gspca_main 27168 1 gspca_sonixj, Live 0xffffffffa0a09000
iTCO_wdt 13424 0 - Live 0xffffffffa0a03000
ppdev 9416 0 - Live 0xffffffffa09fe000
emu10k1_gp 3616 0 - Live 0xffffffffa0036000
videodev 42176 1 gspca_main, Live 0xffffffffa09f1000
v4l1_compat 18020 1 videodev, Live 0xffffffffa09ea000
v4l2_compat_ioctl32 11936 1 videodev, Live 0xffffffffa09e5000
intel_agp 31792 0 - Live 0xffffffffa09d8000
iTCO_vendor_support 4484 1 iTCO_wdt, Live 0xffffffffa09d1000
parport_pc 37704 1 - Live 0xffffffffa09c2000
parport 43568 3 lp,ppdev,parport_pc, Live 0xffffffffa09b2000
pcspkr 3200 0 - Live 0xffffffffa09ac000
gameport 14128 2 emu10k1_gp, Live 0xffffffffa09a3000
joydev 13152 0 - Live 0xffffffffa099d000
nvidia 9670504 36 - Live 0xffffffffa0062000 (P)
ohci1394 34356 0 - Live 0xffffffffa0054000
ieee1394 101280 1 ohci1394, Live 0xffffffffa0039000
r8169 38724 0 - Live 0xffffffffa002a000
mii 6592 1 r8169, Live 0xffffffffa0026000
usbhid 43584 1 - Live 0xffffffffa0016000
floppy 63048 0 - Live 0xffffffffa0000000


--------------030900020204020807060207
Content-Type: text/plain;
 name="cpuinfo.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="cpuinfo.txt"

processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9650  @ 3.00GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 0
cpu cores	: 4
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm con=
stant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx sm=
x est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexp=
riority
bogomips	: 5999.74
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 1
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9650  @ 3.00GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 3
cpu cores	: 4
apicid		: 3
initial apicid	: 3
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm con=
stant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx sm=
x est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexp=
riority
bogomips	: 6630.70
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 2
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9650  @ 3.00GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 1
cpu cores	: 4
apicid		: 1
initial apicid	: 1
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm con=
stant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx sm=
x est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexp=
riority
bogomips	: 6763.28
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:

processor	: 3
vendor_id	: GenuineIntel
cpu family	: 6
model		: 23
model name	: Intel(R) Core(TM)2 Quad CPU    Q9650  @ 3.00GHz
stepping	: 10
cpu MHz		: 2000.000
cache size	: 6144 KB
physical id	: 0
siblings	: 4
core id		: 2
cpu cores	: 4
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 13
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pa=
t pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx lm con=
stant_tsc arch_perfmon pebs bts rep_good pni dtes64 monitor ds_cpl vmx sm=
x est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm tpr_shadow vnmi flexp=
riority
bogomips	: 6630.67
clflush size	: 64
cache_alignment	: 64
address sizes	: 36 bits physical, 48 bits virtual
power management:



--------------030900020204020807060207
Content-Type: text/plain;
 name="oops.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="oops.txt"

[35575.931196] ------------[ cut here ]------------                      =
                                                                    =20
[35575.931202] kernel BUG at fs/buffer.c:3259!                           =
                                                                    =20
[35575.931205] invalid opcode: 0000 [#2] PREEMPT SMP                     =
                                                                    =20
[35575.931209] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.4/0000=
:03:00.0/host4/target4:0:0/4:0:0:0/block/sr0/size                   =20
[35575.931212] CPU 1                                                     =
                                                                    =20
[35575.931214] Modules linked in: isofs udf crc_itu_t binfmt_misc bridge =
stp bnep vboxnetadp vboxnetflt vboxdrv video output lp snd_usb_audio snd_=
usb_lib gspca_sonixj gspca_main iTCO_wdt ppdev emu10k1_gp videodev v4l1_c=
ompat v4l2_compat_ioctl32 intel_agp iTCO_vendor_support parport_pc parpor=
t pcspkr gameport joydev nvidia(P) ohci1394 ieee1394 r8169 mii usbhid flo=
ppy                                                           =20
[35575.931244] Pid: 21631, comm: Installer.exe Tainted: P      D    2.6.3=
0.2-20090720 #1 EP45-DS3L                                           =20
[35575.931248] RIP: 0010:[<ffffffff803261cf>]  [<ffffffff803261cf>] free_=
buffer_head+0x6f/0x90                                               =20
[35575.931257] RSP: 0000:ffff88007fcc7878  EFLAGS: 00210287              =
                                                                    =20
[35575.931259] RAX: ffff880030c5da58 RBX: ffff880030c5d9a0 RCX: ffff88003=
0c5da10                                                             =20
[35575.931261] RDX: ffff880030c5da10 RSI: 0000000000001000 RDI: ffff88003=
0c5da10                                                             =20
[35575.931264] RBP: ffff88007fcc7888 R08: ffff88012f56d590 R09: 000000000=
0000000                                                             =20
[35575.931266] R10: 0000000000000001 R11: 0000000000000000 R12: 000000000=
0000001                                                             =20
[35575.931269] R13: ffff88012f56d600 R14: 0000000000000001 R15: ffff88007=
fcc7cf8
[35575.931272] FS:  000000007ffc0000(0063) GS:ffff88002803c000(006b) knlG=
S:0000000009c4fb90
[35575.931276] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[35575.931278] CR2: 0000000015b7a000 CR3: 000000004b746000 CR4: 000000000=
00406e0
[35575.931281] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
[35575.931283] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000000000=
0000400
[35575.931286] Process Installer.exe (pid: 21631, threadinfo ffff88007fcc=
6000, task ffff88000178a000)
[35575.931288] Stack:
[35575.931290]  ffff88007fcc7888 ffff880030c5d9a0 ffff88007fcc78c8 ffffff=
ff80326259
[35575.931294]  000000002f4258e8 0000000000000001 ffff880030c5da10 ffffe2=
000029aff0
[35575.931298]  ffffe2000029b018 ffff88007fcc7b88 ffff88007fcc78d8 ffffff=
ff8032c7b5
[35575.931303] Call Trace:
[35575.931305]  [<ffffffff80326259>] try_to_free_buffers+0x69/0xb0
[35575.931309]  [<ffffffff8032c7b5>] blkdev_releasepage+0x45/0x50
[35575.931313]  [<ffffffff802bac02>] try_to_release_page+0x32/0x60
[35575.931317]  [<ffffffff802c944e>] shrink_page_list+0x56e/0x830
[35575.931322]  [<ffffffff8042a0ac>] ? __make_request+0x15c/0x530
[35575.931327]  [<ffffffff802c8739>] ? isolate_pages_global+0xb9/0x250
[35575.931331]  [<ffffffff802c9e40>] shrink_list+0x290/0x750
[35575.931334]  [<ffffffff8073c62a>] ? thread_return+0x5e/0x724
[35575.931339]  [<ffffffff802c4745>] ? determine_dirtyable_memory+0x15/0x=
30
[35575.931342]  [<ffffffff802c47e2>] ? get_dirty_limits+0x22/0x2c0
[35575.931345]  [<ffffffff802d13e1>] ? __mod_zone_page_state+0x21/0xa0
[35575.931350]  [<ffffffff802ca9de>] shrink_zone+0x2be/0x4c0
[35575.931354]  [<ffffffff802cacc2>] do_try_to_free_pages+0xe2/0x3f0
[35575.931357]  [<ffffffff802cb0e1>] try_to_free_pages+0x71/0x80
[35575.931361]  [<ffffffff802c8680>] ? isolate_pages_global+0x0/0x250
[35575.931364]  [<ffffffff802c1903>] __alloc_pages_internal+0x243/0x520
[35575.931369]  [<ffffffff802ed855>] alloc_page_vma+0x75/0x100
[35575.931373]  [<ffffffff802d7f76>] handle_mm_fault+0x326/0x900
[35575.931377]  [<ffffffff8073f21f>] ? _spin_lock_irqsave+0x2f/0x60
[35575.931380]  [<ffffffff8073f21f>] ? _spin_lock_irqsave+0x2f/0x60
[35575.931383]  [<ffffffff8073f55a>] ? _spin_unlock_irqrestore+0x1a/0x40
[35575.931387]  [<ffffffff80742108>] do_page_fault+0x148/0x390
[35575.931391]  [<ffffffff8073fa55>] page_fault+0x25/0x30
[35575.931395] Code: 80 ff 0b e8 c4 e7 ff ff bf 01 00 00 00 e8 9a c1 41 0=
0 65 48 8b 04 25 a8 b4 00 00 f6 80 38 e0 ff ff 08 75 10 48 83 c4 08 5b c9=
 c3 <0f> 0b eb fe 0f 1f 44 00 00 e8 93 6c 41 00 0f 1f 00 eb e6 66 66
[35575.931433] RIP  [<ffffffff803261cf>] free_buffer_head+0x6f/0x90
[35575.931437]  RSP <ffff88007fcc7878>
[35575.931440] ---[ end trace df5c1c7d413895ee ]---


--------------030900020204020807060207
Content-Type: text/plain;
 name="PCI.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="PCI.txt"

00:00.0 Host bridge: Intel Corporation 4 Series Chipset DRAM Controller (=
rev 03)
	Subsystem: Giga-byte Technology Device 5000
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: intel-agp

00:01.0 PCI bridge: Intel Corporation 4 Series Chipset PCI Express Root P=
ort (rev 03)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=3D00, secondary=3D01, subordinate=3D01, sec-latency=3D0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: e4000000-e7ffffff
	Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [88] Subsystem: Giga-byte Technology Device 5000
	Capabilities: [80] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [90] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/=
0 Enable+
		Address: fee0f00c  Data: 4159
	Capabilities: [a0] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 5GT/s, Width x16, ASPM L0s L1, Latency L0 <256ns=
, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot+
		LnkCtl:	ASPM L1 Enabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt+ ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  8, PowerLimit 75.000000; Interlock- NoCompl+
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [140] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1a.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #4
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 4: I/O ports at e000 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #5
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 21
	Region 4: I/O ports at e100 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #6
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at e500 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1a.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHC=
I Controller #2 (prog-if 20)
	Subsystem: Giga-byte Technology Device 5006
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 0: Memory at ea201000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ehci_hcd

00:1c.0 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express =
Port 1
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=3D00, secondary=3D02, subordinate=3D02, sec-latency=3D0
	I/O behind bridge: 0000f000-00000fff
	Memory behind bridge: fff00000-000fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <1us, L1=
 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x0, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot # 10, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/=
0 Enable+
		Address: fee0f00c  Data: 4161
	Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.4 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express =
Port 5
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=3D00, secondary=3D03, subordinate=3D03, sec-latency=3D0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: e8000000-e8ffffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #5, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, =
L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot # 14, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/=
0 Enable+
		Address: fee0f00c  Data: 4169
	Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1c.5 PCI bridge: Intel Corporation 82801JI (ICH10 Family) PCI Express =
Port 6
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=3D00, secondary=3D04, subordinate=3D04, sec-latency=3D0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: e9000000-e9ffffff
	Prefetchable memory behind bridge: 00000000ea000000-00000000ea0fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 128 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #6, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 <256ns, =
L1 <4us
			ClockPM- Suprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive+ BWMgm=
t- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug+ Surpise+
			Slot # 15, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-=

			Control: AttnInd Unknown, PwrInd Unknown, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet+ Interlock-
			Changed: MRL- PresDet+ LinkState+
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-=

		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Capabilities: [80] Message Signalled Interrupts: Mask- 64bit- Queue=3D0/=
0 Enable+
		Address: fee0f00c  Data: 4171
	Capabilities: [90] Subsystem: Giga-byte Technology Device 5001
	Capabilities: [a0] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0+,D1-,D2-,D3hot+,D3c=
old+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [180] Root Complex Link <?>
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:1d.0 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #1
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 4: I/O ports at e200 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.1 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #2
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 4: I/O ports at e300 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.2 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB UHCI=
 Controller #3
	Subsystem: Giga-byte Technology Device 5004
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin C routed to IRQ 18
	Region 4: I/O ports at e400 [size=3D32]
	Capabilities: [50] PCIe advanced features <?>
	Kernel driver in use: uhci_hcd

00:1d.7 USB Controller: Intel Corporation 82801JI (ICH10 Family) USB2 EHC=
I Controller #1 (prog-if 20)
	Subsystem: Giga-byte Technology Device 5006
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at ea200000 (32-bit, non-prefetchable) [size=3D1K]
	Capabilities: [50] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: ehci_hcd

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 90) (prog-if =
01)
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=3D00, secondary=3D05, subordinate=3D05, sec-latency=3D32
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: ea100000-ea1fffff
	Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [50] Subsystem: Giga-byte Technology Device 5000

00:1f.0 ISA bridge: Intel Corporation 82801JIB (ICH10) LPC Interface Cont=
roller
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR+ FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [e0] Vendor Specific Information <?>
	Kernel modules: iTCO_wdt

00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10 Family) 4 port SA=
TA IDE Controller (prog-if 8a [Master SecP PriP])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at 01f0 [size=3D8]
	Region 1: I/O ports at 03f4 [size=3D1]
	Region 2: I/O ports at 0170 [size=3D8]
	Region 3: I/O ports at 0374 [size=3D1]
	Region 4: I/O ports at f000 [size=3D16]
	Region 5: I/O ports at f100 [size=3D16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

00:1f.3 SMBus: Intel Corporation 82801JI (ICH10 Family) SMBus Controller
	Subsystem: Giga-byte Technology Device 5001
	Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin C routed to IRQ 3
	Region 0: Memory at ea202000 (64-bit, non-prefetchable) [size=3D256]
	Region 4: I/O ports at 0500 [size=3D32]
	Kernel modules: i2c-i801

00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 Family) 2 port SA=
TA IDE Controller (prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b002
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin B routed to IRQ 19
	Region 0: I/O ports at e700 [size=3D8]
	Region 1: I/O ports at e800 [size=3D4]
	Region 2: I/O ports at e900 [size=3D8]
	Region 3: I/O ports at ea00 [size=3D4]
	Region 4: I/O ports at eb00 [size=3D16]
	Region 5: I/O ports at ec00 [size=3D16]
	Capabilities: [70] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [b0] PCIe advanced features <?>
	Kernel driver in use: ata_piix

01:00.0 VGA compatible controller: nVidia Corporation G80 [GeForce 8800 G=
TX] (rev a2)
	Subsystem: nVidia Corporation Device 039c
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 16
	Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=3D16M]
	Region 1: Memory at d0000000 (64-bit, prefetchable) [size=3D256M]
	Region 3: Memory at e4000000 (64-bit, non-prefetchable) [size=3D32M]
	Region 5: I/O ports at a000 [size=3D128]
	[virtual] Expansion ROM at e7000000 [disabled] [size=3D128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [68] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/=
0 Enable-
		Address: 0000000000000000  Data: 0000
	Capabilities: [78] Express (v1) Endpoint, MSI 00
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <256ns, L1 <4us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <256=
ns, L1 <4us
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 128 bytes Disabled- Retrain- CommClk+
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMg=
mt- ABWMgmt-
	Capabilities: [100] Virtual Channel <?>
	Capabilities: [128] Power Budgeting <?>
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nvidiafb

03:00.0 IDE interface: JMicron Technologies, Inc. JMB368 IDE controller (=
prog-if 85 [Master SecO PriO])
	Subsystem: Giga-byte Technology Device b000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 16
	Region 0: I/O ports at b000 [size=3D8]
	Region 1: I/O ports at b100 [size=3D4]
	Region 2: I/O ports at b200 [size=3D8]
	Region 3: I/O ports at b300 [size=3D4]
	Region 4: I/O ports at b400 [size=3D16]
	Capabilities: [68] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Express (v1) Legacy Endpoint, MSI 01
		DevCap:	MaxPayload 128 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE- FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #1, Speed 2.5GT/s, Width x1, ASPM L0s, Latency L0 unlimite=
d, L1 unlimited
			ClockPM- Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
	Kernel driver in use: pata_jmicron

04:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168=
B PCI Express Gigabit Ethernet controller (rev 02)
	Subsystem: Giga-byte Technology Device e000
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dfast >TAbort- <TAbort=
- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at c000 [size=3D256]
	Region 2: Memory at ea010000 (64-bit, prefetchable) [size=3D4K]
	Region 4: Memory at ea000000 (64-bit, prefetchable) [size=3D64K]
	[virtual] Expansion ROM at ea020000 [disabled] [size=3D64K]
	Capabilities: [40] Power Management version 3
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA PME(D0+,D1+,D2+,D3hot+,D=
3cold+)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Capabilities: [50] Message Signalled Interrupts: Mask- 64bit+ Queue=3D0/=
1 Enable+
		Address: 00000000fee0f00c  Data: 4199
	Capabilities: [70] Express (v1) Endpoint, MSI 01
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <512ns, L1 <8us
			ExtTag- AttnBtn- AttnInd- PwrInd- RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop-
			MaxPayload 128 bytes, MaxReadReq 4096 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr+ TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512n=
s, L1 <64us
			ClockPM+ Suprise- LLActRep- BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgm=
t- ABWMgmt-
	Capabilities: [b0] MSI-X: Enable- Mask- TabSize=3D2
		Vector table: BAR=3D4 offset=3D00000000
		PBA: BAR=3D4 offset=3D00000800
	Capabilities: [d0] Vital Product Data <?>
	Capabilities: [100] Advanced Error Reporting <?>
	Capabilities: [140] Virtual Channel <?>
	Capabilities: [160] Device Serial Number 78-56-34-12-78-56-34-12
	Kernel driver in use: r8169
	Kernel modules: r8169

05:01.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
	Subsystem: Creative Labs Device 2002
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 19
	Region 0: I/O ports at d000 [size=3D64]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: EMU10K1_Audigy

05:01.1 Input device controller: Creative Labs SB Audigy Game Port (rev 0=
4)
	Subsystem: Creative Labs Device 0040
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 32
	Region 0: I/O ports at d100 [size=3D8]
	Capabilities: [dc] Power Management version 2
		Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=3D0mA PME(D0-,D1-,D2-,D3hot-,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
	Kernel driver in use: Emu10k1_gameport
	Kernel modules: emu10k1-gp

05:01.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev =
04) (prog-if 10)
	Subsystem: Creative Labs Device 0010
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Step=
ping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=3Dmedium >TAbort- <TAbo=
rt- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (500ns min, 1000ns max), Cache Line Size: 32 bytes
	Interrupt: pin B routed to IRQ 18
	Region 0: Memory at ea104000 (32-bit, non-prefetchable) [size=3D2K]
	Region 1: Memory at ea100000 (32-bit, non-prefetchable) [size=3D16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,D2+,D3hot+,D3c=
old-)
		Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+
	Kernel driver in use: ohci1394
	Kernel modules: firewire-ohci, ohci1394



--------------030900020204020807060207
Content-Type: text/plain;
 name="scsi.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="scsi.txt"

Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HDP72505 Rev: GM4O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi1 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: Hitachi HDP72505 Rev: GM4O
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD-ROM GDR8164B Rev: 0L06
  Type:   CD-ROM                           ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 01 Lun: 00
  Vendor: HL-DT-ST Model: DVD-RAM GSA-H22N Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 05


--------------030900020204020807060207
Content-Type: text/plain;
 name="iomem.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="iomem.txt"

00000000-00000fff : System RAM
00001000-00005fff : reserved
00006000-0009f7ff : System RAM
0009f800-0009ffff : reserved
000cc400-000cffff : pnp 00:0d
000e0000-000effff : pnp 00:0d
000f0000-000fffff : reserved
00100000-cfedffff : System RAM
  00200000-00746bd5 : Kernel code
  00746bd6-009ee59f : Kernel data
  013ae000-01504a97 : Kernel bss
cfee0000-cfee2fff : ACPI Non-volatile Storage
cfee3000-cfeeffff : ACPI Tables
cfef0000-cfefffff : reserved
d0000000-dfffffff : PCI Bus 0000:01
  d0000000-dfffffff : 0000:01:00.0
e0000000-e3ffffff : PCI MMCONFIG 0 [00-3f]
  e0000000-e3ffffff : reserved
    e0000000-e3ffffff : pnp 00:0c
e4000000-e7ffffff : PCI Bus 0000:01
  e4000000-e5ffffff : 0000:01:00.0
  e6000000-e6ffffff : 0000:01:00.0
    e6000000-e6ffffff : nvidia
  e7000000-e701ffff : 0000:01:00.0
e8000000-e8ffffff : PCI Bus 0000:03
e9000000-e9ffffff : PCI Bus 0000:04
ea000000-ea0fffff : PCI Bus 0000:04
  ea000000-ea00ffff : 0000:04:00.0
    ea000000-ea00ffff : r8169
  ea010000-ea010fff : 0000:04:00.0
    ea010000-ea010fff : r8169
  ea020000-ea02ffff : 0000:04:00.0
ea100000-ea1fffff : PCI Bus 0000:05
  ea100000-ea103fff : 0000:05:01.2
  ea104000-ea1047ff : 0000:05:01.2
    ea104000-ea1047ff : ohci1394
ea200000-ea2003ff : 0000:00:1d.7
  ea200000-ea2003ff : ehci_hcd
ea201000-ea2013ff : 0000:00:1a.7
  ea201000-ea2013ff : ehci_hcd
ea202000-ea2020ff : 0000:00:1f.3
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
    fec00000-fec00fff : pnp 00:0d
  fed00000-fed003ff : HPET 0
  fed10000-fed1dfff : pnp 00:0d
  fed20000-fed8ffff : pnp 00:0d
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : pnp 00:0d
  ffb00000-ffb7ffff : pnp 00:0d
  fff00000-ffffffff : pnp 00:0d
100000000-12fffffff : System RAM


--------------030900020204020807060207
Content-Type: text/plain;
 name="ioports.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="ioports.txt"

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
0170-0177 : 0000:00:1f.2
  0170-0177 : ata_piix
01f0-01f7 : 0000:00:1f.2
  01f0-01f7 : ata_piix
0290-029f : pnp 00:01
  0290-0294 : pnp 00:01
0376-0376 : 0000:00:1f.2
  0376-0376 : ata_piix
0378-037a : parport0
03c0-03df : vga+
03f2-03f2 : floppy
03f4-03f5 : floppy
03f6-03f6 : 0000:00:1f.2
  03f6-03f6 : ata_piix
03f7-03f7 : floppy
03f8-03ff : serial
0400-04bf : pnp 00:0b
  0400-0403 : ACPI PM1a_EVT_BLK
  0404-0405 : ACPI PM1a_CNT_BLK
  0408-040b : ACPI PM_TMR
  0410-0415 : ACPI CPU throttle
  0420-042f : ACPI GPE0_BLK
  0430-0433 : iTCO_wdt
  0460-047f : iTCO_wdt
04d0-04d1 : pnp 00:01
0500-051f : 0000:00:1f.3
0800-087f : pnp 00:01
0880-088f : pnp 00:01
0cf8-0cff : PCI conf1
a000-afff : PCI Bus 0000:01
  a000-a07f : 0000:01:00.0
b000-bfff : PCI Bus 0000:03
  b000-b007 : 0000:03:00.0
    b000-b007 : pata_jmicron
  b100-b103 : 0000:03:00.0
    b100-b103 : pata_jmicron
  b200-b207 : 0000:03:00.0
    b200-b207 : pata_jmicron
  b300-b303 : 0000:03:00.0
    b300-b303 : pata_jmicron
  b400-b40f : 0000:03:00.0
    b400-b40f : pata_jmicron
c000-cfff : PCI Bus 0000:04
  c000-c0ff : 0000:04:00.0
    c000-c0ff : r8169
d000-dfff : PCI Bus 0000:05
  d000-d03f : 0000:05:01.0
    d000-d03f : EMU10K1
  d100-d107 : 0000:05:01.1
    d100-d107 : emu10k1-gp
e000-e01f : 0000:00:1a.0
  e000-e01f : uhci_hcd
e100-e11f : 0000:00:1a.1
  e100-e11f : uhci_hcd
e200-e21f : 0000:00:1d.0
  e200-e21f : uhci_hcd
e300-e31f : 0000:00:1d.1
  e300-e31f : uhci_hcd
e400-e41f : 0000:00:1d.2
  e400-e41f : uhci_hcd
e500-e51f : 0000:00:1a.2
  e500-e51f : uhci_hcd
e700-e707 : 0000:00:1f.5
  e700-e707 : ata_piix
e800-e803 : 0000:00:1f.5
  e800-e803 : ata_piix
e900-e907 : 0000:00:1f.5
  e900-e907 : ata_piix
ea00-ea03 : 0000:00:1f.5
  ea00-ea03 : ata_piix
eb00-eb0f : 0000:00:1f.5
  eb00-eb0f : ata_piix
ec00-ec0f : 0000:00:1f.5
  ec00-ec0f : ata_piix
f000-f00f : 0000:00:1f.2
  f000-f00f : ata_piix
f100-f10f : 0000:00:1f.2
  f100-f10f : ata_piix


--------------030900020204020807060207
Content-Type: application/pgp-signature;
 name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC45IChH
TlUvTGludXgpCkNvbW1lbnQ6IFVzaW5nIEdudVBHIHdpdGggTW96aWxsYSAtIGh0dHA6Ly9l
bmlnbWFpbC5tb3pkZXYub3JnCgppUUljQkFFQkFnQUdCUUpLYTNvTUFBb0pFT0UxZTduMlRM
S0MzU2NQLzBmSElBQ1FUQ3QzSGVJSk1VT0V2QWQrClVXYmRQNVQwR01XdU5vcjBELzFPS216
aUM5NEYyZnY3cHp1VmZFRE5ZeVZRVDJ4VWxYVXcvSkdvVEQvMFN2ei8KNFEvYm1IVEU3bmNL
K09mSW1xRllYeDVrMTZGZC9TMW82bk5HTmNHN0ZYeUd0VGY0S1NFdDA3R1lwYUVnQUYzagpI
Y0huUW11QVAzbUFWdVRtdXRHbThOeVY1a2ZuNDdpTXpRV1dieUdnNE12RUt1ZVhNL2dTZDFX
QzllZ29hc05PCk85ZHJnWG9GVUhoTFBFamxXUUF2QjZNNEJnZTc4blBoQzd3eHYybXVHU0p4
RFVjalFlSWZhRjlXeUxHRmFIZysKWForNHpGTkY1MGozKzhkNVROUE5nY1RQU0lkbE1WMVh2
REZxMk1rSWtiSkNlN3FXTk54YkNXTFh6NWt5bkZpUQpmR1c4aWVWZHM3VVk0RGkrSmdMUldn
S3VrS2d2bHlCR242L0RmT3BTR3NKNlBBcjZYcysvdFlIVEFzdHMvc3NOClVSVEJQQnNqKzVj
QlBPYVJKbjZNZHEwUWZDM1dZTm53VzBvNXVBMGpUcEtaanNNOUMrS2xmREY3M1pZSmlHNDAK
NHBOSlZGWDl3enR2ZSs4YUlVUDJhSlNFRVM4ekVEaTN3V2didkpWWEdrYnR6RUh2OEhIRE4y
R2RKVWRIUTJjNwpwVW1SS3ZEWUhaWWhBS1Z5Tm5CNDVnN0dsUVVsZDFUdzF3d2d2K1BJZUxL
U0lMRVN2WUhkNHBWYmZYNTEvbUFHClFtT1k5Mk5CU3VkQSszK0JJODFpS3VuNG9tcyt2a2cv
Qm9FaEdFajlJMHFWYkdFelg5cHdkN0JOMU55VlhDZVoKVkhQMDF4ZEUwa3lDSkcwV2ZodDQK
PWk2bGIKLS0tLS1FTkQgUEdQIFNJR05BVFVSRS0tLS0tCgo=
--------------030900020204020807060207--

--------------enig90774D0D26F58D83BFC02586
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iQIcBAEBAgAGBQJKa3rWAAoJEOE1e7n2TLKCBAsP/1gGBdDetYX/djbc4jmPCg4v
cKwJKV4B9vDOtqi9jfuMRcgo/CTeboLJCPe3B5LjXKa9Q+6M87pRXSGQN1F6HUZG
4uzQL8k8xf8C/9dFGMEp/BZSQyJIgOXi8M7XIUT5A89zQcjEAmmyWysmRG1xc2Jj
ijKeRgUjKGMH/zIq+9w+0+oQ1v+jn0tCJOlfWsvxaVDAZUSaGWuAMaNQg8vjOe63
WzqZFTFtbeY+vWXEBfRyqX8Kff52DzvLyqtrRtfWaqyqYJBQu0L1ROWUZ7IDDoLC
N7keQz87IWrvIVCxCRjwa1YXJvtxbMXELaR6masEQdsIELGUFiYBIvYOyD3uR2Q5
HmkZShBEoH1/cZW5iF9tCcxbrrNW6SYWodrGl5/pVEigC0Axvz2fB22Pa4bZ4xff
qSWdEdH99fRiGydazYbas7ZfQC7a8h1cTMDFWgK7CKTDm8kmPnRM8H+HkuRXjZUj
h+gikbl4qPbMLXZudJCgmgQhYth/9qNRKZWCbVMtujWJXpFVQ6parqITHEogjG3w
g6mL1WAF7okAYWxFk46e+ap88rJS8VLzFJPB08O0tYYWFW8Psf4e1ysDSZixnaUt
jao0VKsp7OzVE8eL79Scv+ZJIbjxlwChMuJlnd8LK7qQTRCry8k7Eoeh7nAFNhQD
RHV1QGy9OKXYDKHlq1hW
=41Q+
-----END PGP SIGNATURE-----

--------------enig90774D0D26F58D83BFC02586--
