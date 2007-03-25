Return-Path: <linux-kernel-owner+w=401wt.eu-S1750964AbXCYPD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750964AbXCYPD1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 11:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXCYPD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 11:03:27 -0400
Received: from mail.alinto.citycable.ch ([85.218.0.110]:40972 "HELO
	citycable.ch" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750964AbXCYPDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 11:03:22 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 11:03:21 EDT
Date: Sun, 25 Mar 2007 09:05:52 +0200
From: Dominique Michel <dominique.michel@citycable.ch>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc3-rt0 hang randomely + usb can't set config #1, error -62
Message-ID: <20070325090552.4f759b68@localhost>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.9; i686-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEXy8ubtkoXo7+b1+fbN
 cGKCeWDtamweFA8eMkmKPkPtvcWRoqyV0Pn7AAACbElEQVQ4jXXTMWvbQBQA4MOlizsdXEXp
 KAi09mKcLZ0EJxONDRJVkikg9AtqTm63gtHDmVJs1GsnC0JiaTMJGN2f67uzznJb+gZj9PFO
 7717IqdtvCAmem4bxMLp/2BEyEBF1+U/0H8uhI6rv+BVLNrY/gH9T0L8yAxk2yMY3YuZxDCn
 TY/gpBByyTGktIcZOIvFjPNJmqYJDwrx3cIoBrE0zzG4FF8tfBAwM+DonKCYWjgROZ6Upjcm
 5Qje58JAmlKKGfIAjzaDUuogZBY2Bjg14eDbywMIqZvwqgqFBcVFB0seYONLb00ZZlh4p0F6
 FHNoUMyKAzxowJSQTyj+XloYs3MN3GeMpzyYSTMshLM00ODpWlPp4SDbqs4cViDcGAgmlK/a
 PsaOg7DvIQ3wzANMqB/iQW/XTkoTLO6XhSeHUoQKe+NLjyY/Ldx7CW2D4WTYhZ3V0GP64RpP
 Q/E66IUWMLj3+nDn4w2ejMACyXFeHZy6ETcZehc49bv1GQ/0bazNuzm97mDkhnoie9i30WYM
 w/YCnYT7Fx308s98n0IT//Jod1+aOzdzYXLVbftol+PC+REG3u+0AxdEtuSMB6G+DLGwMH4E
 vXGmJn8VCLM9LhmrOAMQYt5Wi/DFgIC52iFkUzMpDVmjAaDZRGC+JGwDqzJ/G5fUUcWZAaE7
 YfvPLYtIU1Wb4A2IeS7uDMgcIFutiCr766qGfKHyuxvTIERKXVNSN27lDgCuBuojlpxIyJV6
 ritS1uWWuHF2Ww7qcIKbqEFVNbmtmm3vGSCHbVXjikrY3SpVxwQWw2aIjwG+ueXTJDmHeK6a
 HfwGyU5ZSlGeSRQAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-aduser: dominique.michel@citycable.ch/85.218.2.153
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

My system hang randomly with a 2.6.21-rc3-rt0. I also have a
2.6.19.1-rt15 that is working fine. I googled a lot and find at I missed the
shift to the APIC timer with such rt kernels with the 2.6.19-rt15. I try to
enable it in the 2.6.21-rc3-rt0, but it continue to hang from time to time.

/proc/version:
Linux version 2.6.21-rc3-rt0 (root@localhost) (gcc version 4.1.1 (Gentoo
4.1.1-r3)) #1 PREEMPT Fri Mar 23 15:48:12 CET 2007

I get no Oops.

ver_linux:
Linux localhost 2.6.21-rc3-rt0 #1 PREEMPT Fri Mar 23 15:48:12 CET 2007 i686
Intel(R) Pentium(R) 4 CPU 2.40GHz GenuineIntel GNU/Linux 
Gnu C                  4.1.1
Gnu make               3.81
binutils               2.16.1
util-linux             2.12r
mount                  2.12r
module-init-tools      3.2.2
e2fsprogs              1.39
reiserfsprogs          3.6.19
xfsprogs               2.8.11
Linux C Library        > libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Kbd                    1.12
Sh-utils               6.4
udev                   104
Modules Loaded         af_packet snd_seq_midi snd_emu10k1_synth snd_emux_synth
snd_seq_midi_emul snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss
snd_virmidi snd_seq_virmidi snd_seq_midi_event snd_seq sd_mod sg genrtc lp ipv6
realcap commoncap mousedev usbhid snd_usb_audio snd_usb_lib pwc eth1394
usb_storage scsi_mod psmouse serio_raw parport_pc parport tuner bttv video_buf
ir_common compat_ioctl32 i2c_algo_bit btcx_risc tveeprom videodev v4l2_common
v4l1_compat rtc_cmos rtc_core rtc_lib snd_emu10k1 snd_rawmidi firmware_class
snd_ac97_codec ac97_bus snd_pcm snd_seq_device snd_timer snd_page_alloc
snd_util_mem snd_hwdep snd soundcore pcspkr emu10k1_gp gameport sis_agp ide_cd
cdrom ohci1394 ieee1394 ehci_hcd sis900 mii ohci_hcd usbcore i2c_sis96x
i2c_core unix

Note: all the modules are from the kernel, no external modules at all.

/proc/cpuinfo:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Pentium(R) 4 CPU 2.40GHz
stepping        : 7
cpu MHz         : 2400.260
cache size      : 512 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid bogomips        :
4801.53 clflush size    : 64

/proc/modules:
af_packet 16548 2 - Live 0xf8c4c000
snd_seq_midi 5664 0 - Live 0xf8c19000
snd_emu10k1_synth 5120 0 - Live 0xf8c11000
snd_emux_synth 25088 1 snd_emu10k1_synth, Live 0xf8c44000
snd_seq_midi_emul 4480 1 snd_emux_synth, Live 0xf8c0e000
snd_pcm_oss 31904 0 - Live 0xf8c3b000
snd_mixer_oss 12672 1 snd_pcm_oss, Live 0xf8c14000
snd_seq_dummy 2180 0 - Live 0xf8be8000
snd_seq_oss 22912 0 - Live 0xf8c27000
snd_virmidi 3136 0 - Live 0xf8bfa000
snd_seq_virmidi 4608 2 snd_emux_synth,snd_virmidi, Live 0xf8bea000
snd_seq_midi_event 3968 3 snd_seq_midi,snd_seq_oss,snd_seq_virmidi, Live
0xf8b96000 snd_seq 32400 12
snd_seq_midi,snd_emux_synth,snd_seq_midi_emul,snd_seq_dummy,snd_seq_oss,snd_seq_virmidi,snd_seq_midi_event,
Live 0xf8c1e000 sd_mod 15816 4 - Live 0xf8bed000 sg 28216 0 - Live 0xf8bf2000
genrtc 6628 0 - Live 0xf8b91000
lp 9092 0 - Live 0xf8ba3000
ipv6 201440 14 - Live 0xf8c56000
realcap 3464 0 - Live 0xf8b94000
commoncap 3072 1 realcap, Live 0xf8aee000
snd_usb_audio 51296 0 - Live 0xf8c00000
snd_usb_lib 11136 1 snd_usb_audio, Live 0xf8b9f000
eth1394 14980 0 - Live 0xf8b72000
mousedev 8760 1 - Live 0xf8b63000
usbhid 20576 0 - Live 0xf8b98000
pwc 74496 0 - Live 0xf8ba7000
usb_storage 24964 3 - Live 0xf8b6a000
scsi_mod 100200 3 sd_mod,sg,usb_storage, Live 0xf8bbb000
parport_pc 26564 1 - Live 0xf8b87000
parport 26400 2 lp,parport_pc, Live 0xf8b7f000
psmouse 27912 0 - Live 0xf8b77000
serio_raw 4868 0 - Live 0xf8b67000
tuner 49192 0 - Live 0xf8b19000
bttv 161652 0 - Live 0xf8b30000
video_buf 15364 1 bttv, Live 0xf8b00000
ir_common 23556 1 bttv, Live 0xf8af9000
compat_ioctl32 768 2 pwc,bttv, Live 0xf8aec000
i2c_algo_bit 6152 1 bttv, Live 0xf8ae1000
btcx_risc 2952 1 bttv, Live 0xf8ae4000
tveeprom 12048 1 bttv, Live 0xf8ae8000
videodev 23680 2 pwc,bttv, Live 0xf8ad6000
v4l2_common 11136 3 tuner,bttv,videodev, Live 0xf8add000
v4l1_compat 13060 2 bttv,videodev, Live 0xf8ab8000
rtc_cmos 5908 0 - Live 0xf8ac0000
rtc_core 5448 1 rtc_cmos, Live 0xf8abd000
rtc_lib 2176 1 rtc_core, Live 0xf8963000
ide_cd 32672 0 - Live 0xf8acd000
cdrom 30016 1 ide_cd, Live 0xf8ac4000
ohci1394 29616 0 - Live 0xf8aa5000
ieee1394 63288 2 eth1394,ohci1394, Live 0xf8a69000
sis_agp 5892 1 - Live 0xf8926000
snd_emu10k1 107200 4 snd_emu10k1_synth, Live 0xf8993000
snd_rawmidi 15264 4 snd_seq_midi,snd_seq_virmidi,snd_usb_lib,snd_emu10k1, Live
0xf8967000 firmware_class 6400 2 bttv,snd_emu10k1, Live 0xf8921000
snd_ac97_codec 72736 1 snd_emu10k1, Live 0xf893b000
ac97_bus 1536 1 snd_ac97_codec, Live 0xf8924000
snd_pcm 47136 6 snd_pcm_oss,snd_usb_audio,snd_emu10k1,snd_ac97_codec, Live
0xf8951000 snd_seq_device 4748 8
snd_seq_midi,snd_emu10k1_synth,snd_emux_synth,snd_seq_dummy,snd_seq_oss,snd_seq,snd_emu10k1,snd_rawmidi,
Live 0xf88f7000 snd_timer 15644 3 snd_seq,snd_emu10k1,snd_pcm, Live 0xf8929000
snd_page_alloc 6408 2 snd_emu10k1,snd_pcm, Live 0xf88da000 snd_util_mem 2048 2
snd_emux_synth,snd_emu10k1, Live 0xf88dd000 snd_hwdep 6148 3
snd_emux_synth,snd_usb_audio,snd_emu10k1, Live 0xf88f0000 snd 32260 20
snd_emux_synth,snd_pcm_oss,snd_mixer_oss,snd_seq_oss,snd_virmidi,snd_seq_virmidi,snd_seq,snd_usb_audio,snd_emu10k1,snd_rawmidi,snd_ac97_codec,snd_pcm,snd_seq_device,snd_timer,snd_hwdep,
Live 0xf8932000 soundcore 4448 1 snd, Live 0xf88e1000 pcspkr 2072 0 - Live
0xf891f000 i2c_sis96x 4484 0 - Live 0xf88f4000
i2c_core 12584 5 tuner,bttv,i2c_algo_bit,tveeprom,i2c_sis96x, Live 0xf891a000
ehci_hcd 27276 0 - Live 0xf8912000
emu10k1_gp 2688 0 - Live 0xf88df000
gameport 9760 2 emu10k1_gp, Live 0xf88ea000
sis900 18048 0 - Live 0xf88e4000
mii 3328 1 sis900, Live 0xf88cb000
ohci_hcd 17028 0 - Live 0xf88d4000
usbcore 91212 8
snd_usb_audio,snd_usb_lib,usbhid,pwc,usb_storage,ehci_hcd,ohci_hcd, Live
0xf88fa000 unix 21296 374 - Live 0xf88cd000

/proc/ioports:
0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0073 : rtc0
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : 0000:00:02.5
  0170-0177 : ide1
01f0-01f7 : 0000:00:02.5
  01f0-01f7 : ide0
0295-0296 : pnp 00:0c
0376-0376 : 0000:00:02.5
  0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f6-03f6 : 0000:00:02.5
  03f6-03f6 : ide0
0480-048f : pnp 00:02
0778-077a : parport0
0cf8-0cff : PCI conf1
9000-9007 : 0000:00:0a.1
  9000-9007 : emu10k1-gp
9400-943f : 0000:00:0a.0
  9400-943f : EMU10K1
9800-98ff : 0000:00:04.0
  9800-98ff : sis900
b400-b40f : 0000:00:02.5
  b400-b407 : ide0
  b408-b40f : ide1
e400-e47f : pnp 00:02
  e400-e403 : ACPI PM1a_EVT_BLK
  e404-e405 : ACPI PM1a_CNT_BLK
  e408-e40b : ACPI PM_TMR
  e420-e423 : ACPI GPE0_BLK
  e430-e433 : ACPI GPE1_BLK
e480-e4ff : pnp 00:02
e600-e61f : 0000:00:02.1
  e600-e61f : pnp 00:02
    e600-e61f : sis96x_smbus

/proc/iomem:
00000000-0009fbff : System RAM
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000f0000-000fffff : System ROM
00100000-5fffbfff : System RAM
  00100000-002c0009 : Kernel code
  002c000a-0033a2af : Kernel data
5fffc000-5fffefff : ACPI Tables
5ffff000-5fffffff : ACPI Non-volatile Storage
e3000000-e3003fff : 0000:00:0a.2
e3800000-e38007ff : 0000:00:0a.2
  e3800000-e38007ff : ohci1394
e4000000-e4000fff : 0000:00:04.0
  e4000000-e4000fff : sis900
e4800000-e4800fff : 0000:00:03.3
  e4800000-e4800fff : ehci_hcd
e5000000-e5000fff : 0000:00:03.2
  e5000000-e5000fff : ohci_hcd
e5800000-e5800fff : 0000:00:03.1
  e5800000-e5800fff : ohci_hcd
e6000000-e6000fff : 0000:00:03.0
  e6000000-e6000fff : ohci_hcd
e7000000-e7ffffff : PCI Bus #01
  e7000000-e7ffffff : 0000:01:00.0
e8000000-ebffffff : 0000:00:00.0
ee000000-ee000fff : 0000:00:0d.1
ee800000-ee800fff : 0000:00:0d.0
  ee800000-ee800fff : bttv0
ef6c0000-ef6dffff : 0000:00:04.0
ef700000-febfffff : PCI Bus #01
  ef7e0000-ef7fffff : 0000:01:00.0
  ef800000-ef87ffff : 0000:01:00.0
  f0000000-f7ffffff : 0000:01:00.0
fec00000-fec00fff : reserved
fee00000-fee00fff : reserved
ffee0000-ffefffff : pnp 00:02
ffff0000-ffffffff : reserved

lspci -vvv:
00:00.0 Host bridge: Silicon Integrated Systems [SiS] 645xx (rev 02)
        Subsystem: ASUSTeK Computer Inc. Unknown device 8086
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- Latency: 32
        Region 0: Memory at e8000000 (32-bit, non-prefetchable) [size=64M]
        Capabilities: [c0] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3- Rate=x1,x2,x4 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64-
64bit- FW- Rate=<none>

00:01.0 PCI bridge: Silicon Integrated Systems [SiS] Virtual PCI-to-PCI bridge
(AGP) (prog-if 00 [Normal decode]) Control: I/O+ Mem+ BusMaster+ SpecCycle-
MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF-
FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency:
64 Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: e7000000-e7ffffff
        Prefetchable memory behind bridge: ef700000-febfffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
<MAbort+ <SERR- <PERR- BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset-
FastB2B-

00:02.0 ISA bridge: Silicon Integrated Systems [SiS] SiS963 [MuTIOL Media IO]
(rev 04) Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B- ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 0

00:02.1 SMBus: Silicon Integrated Systems [SiS] SiS961/2 SMBus Controller
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Interrupt: pin B routed
to IRQ 0 Region 4: I/O ports at e600 [size=32]

00:02.5 IDE interface: Silicon Integrated Systems [SiS] 5513 [IDE] (prog-if 80
[Master]) Subsystem: ASUSTeK Computer Inc. Unknown device 8087
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B- ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 128
        Interrupt: pin ? routed to IRQ 11
        Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable)
[disabled] [size=8] Region 1: [virtual] Memory at 000003f0 (type 3,
non-prefetchable) [disabled] [size=1] Region 2: [virtual] Memory at 00000170
(32-bit, non-prefetchable) [disabled] [size=8] Region 3: [virtual] Memory at
00000370 (type 3, non-prefetchable) [disabled] [size=1] Region 4: I/O ports at
b400 [size=16]

00:03.0 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller
(rev 0f) (prog-if 10 [OHCI]) Subsystem: ASUSTeK Computer Inc. Unknown device
8087 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (20000ns
max), Cache Line Size: 32 bytes Interrupt: pin A routed to IRQ 3
        Region 0: Memory at e6000000 (32-bit, non-prefetchable) [size=4K]

00:03.1 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller
(rev 0f) (prog-if 10 [OHCI]) Subsystem: ASUSTeK Computer Inc. Unknown device
8087 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (20000ns
max), Cache Line Size: 32 bytes Interrupt: pin B routed to IRQ 5
        Region 0: Memory at e5800000 (32-bit, non-prefetchable) [size=4K]

00:03.2 USB Controller: Silicon Integrated Systems [SiS] USB 1.0 Controller
(rev 0f) (prog-if 10 [OHCI]) Subsystem: ASUSTeK Computer Inc. Unknown device
8087 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (20000ns
max), Cache Line Size: 32 bytes Interrupt: pin C routed to IRQ 6
        Region 0: Memory at e5000000 (32-bit, non-prefetchable) [size=4K]

00:03.3 USB Controller: Silicon Integrated Systems [SiS] USB 2.0 Controller
(prog-if 20 [EHCI]) Subsystem: ASUSTeK Computer Inc. Unknown device 8087
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (20000ns max)
        Interrupt: pin D routed to IRQ 6
        Region 0: Memory at e4800000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:04.0 Ethernet controller: Silicon Integrated Systems [SiS] SiS900 PCI Fast
Ethernet (rev 91) Subsystem: ASUSTeK Computer Inc. Unknown device 80a7
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (13000ns
min, 2750ns max) Interrupt: pin A routed to IRQ 4
        Region 0: I/O ports at 9800 [size=256]
        Region 1: Memory at e4000000 (32-bit, non-prefetchable) [size=4K]
        Expansion ROM at ef6c0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
        Subsystem: Creative Labs SB0240 Audigy 2 Platinum 6.1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (500ns min,
5000ns max) Interrupt: pin A routed to IRQ 10
        Region 0: I/O ports at 9400 [size=64]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
        Subsystem: Creative Labs SB Audigy MIDI/Game Port
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32
        Region 0: I/O ports at 9000 [size=8]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0a.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)
(prog-if 10 [OHCI]) Subsystem: Creative Labs SB Audigy FireWire Port
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (500ns min,
1000ns max), Cache Line Size: 32 bytes Interrupt: pin B routed to IRQ 4
        Region 0: Memory at e3800000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at e3000000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME+

00:0d.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture
(rev 11) Subsystem: Scion Corporation Unknown device 0012
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (4000ns min,
10000ns max) Interrupt: pin A routed to IRQ 10
        Region 0: Memory at ee800000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:0d.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev
11) Subsystem: Scion Corporation Unknown device 0012
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
Stepping- SERR- FastB2B- Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 32 (1000ns min,
63750ns max) Interrupt: pin A routed to IRQ 10
        Region 0: Memory at ee000000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME-

01:00.0 VGA compatible controller: nVidia Corporation NV25 [GeForce4 Ti 4200]
(rev a3) (prog-if 00 [VGA]) Subsystem: Micro-Star International Co., Ltd.
Unknown device 8700 Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr-
DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- Latency: 64 (1250ns min,
250ns max) Interrupt: pin A routed to IRQ 11
        Region 0: Memory at e7000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Region 2: Memory at ef800000 (32-bit, prefetchable) [size=512K]
        Expansion ROM at ef7e0000 [disabled] [size=128K]
        Capabilities: [60] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-) Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [44] AGP version 2.0
                Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh- GART64- HTrans-
64bit- FW+ AGP3- Rate=x1,x2,x4 Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64-
64bit- FW- Rate=<none>

/proc/scsi/scsi:
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: SAMSUNG  Model: SP2014N          Rev: VC10
  Type:   Direct-Access                    ANSI  SCSI revision: 00

####################

I don't see anything wrong in the above messages, but dmesg found more iomem
could not be reserved messages as with the 2.6.19, and also a usb error (I get
the same with the 2.6.19-rt15):

es, LIFO batch:31
DMI 2.3 present.
ACPI: RSDP 000F5810, 0014 (r0 ASUS  )
ACPI: RSDT 5FFFC000, 002C (r1 ASUS   P4S8X    42302E31 MSFT 31313031)
ACPI: FACP 5FFFC0BC, 0074 (r1 ASUS   P4S8X    42302E31 MSFT 31313031)
ACPI: DSDT 5FFFC130, 2A21 (r1   ASUS P4S8X        1000 MSFT  100000B)
ACPI: FACS 5FFFF000, 0040
ACPI: T��_ 5FFFC02C, 0028 (r1 ASUS   P4S8X    42302E31 MSFT 31313031)
ACPI: PM-Timer IO Port: 0xe408
Allocating PCI resources starting at 70000000 (gap: 60000000:9ec00000)
Real-Time Preemption Support (C) 2004-2007 Ingo Molnar
Built 1 zonelists.  Total pages: 390141
Kernel command line: root=/dev/hdb1 ro X_DRIVER=nv
Found and enabled local APIC!
mapped APIC to ffffd000 (fee00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
WARNING: experimental RCU implementation.
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2400.260 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1555944k/1572848k available (1792k kernel code, 15860k reserved, 488k
data, 184k init, 655344k highmem) virtual kernel memory layout:
    fixmap  : 0xfffaa000 - 0xfffff000   ( 340 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc033e000 - 0xc036c000   ( 184 kB)
      .data : 0xc02c000a - 0xc033a2b0   ( 488 kB)
      .text : 0xc0100000 - 0xc02c000a   (1792 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4801.53 BogoMIPS (lpj=2400765)
Security Framework v1.0.0 initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 00000400
00000000 00000000 CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps: bfebfbff 00000000 00000000 00003080 00000400
00000000 00000000 Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
CPU: Intel(R) Pentium(R) 4 CPU 2.40GHz stepping 07
Checking 'hlt' instruction... OK.
ACPI: Core revision 20070126
ACPI: setting ELCR to 0200 (from 0e78)
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf11b0, last bus=1
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Enabling SiS 96x SMBus.
0000:00:02.5: trying to change BAR0 from D800 to 01F0
0000:00:02.5: trying to change BAR1 from D400 to 03F4
0000:00:02.5: trying to change BAR2 from D000 to 0170
0000:00:02.5: trying to change BAR3 from B800 to 0374
Boot video device is 0000:01:00.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 15) *9
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 *6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 *6 7 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
######################## ???
pnp: 00:00: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:00: iomem range 0xf0000-0xfffff could not be reserved
pnp: 00:00: iomem range 0x100000-0x5fffffff could not be reserved
pnp: 00:00: iomem range 0xfec00000-0xfec000ff could not be reserved
pnp: 00:02: ioport range 0xe400-0xe47f has been reserved
pnp: 00:02: ioport range 0xe480-0xe4ff has been reserved
pnp: 00:02: ioport range 0xe600-0xe61f has been reserved
Time: tsc clocksource has been installed.
pnp: 00:02: ioport range 0x480-0x48f has been reserved
pnp: 00:02: iomem range 0xffee0000-0xffefffff has been reserved
pnp: 00:03: iomem range 0xfffe0000-0xffffffff could not be reserved
pnp: 00:0c: ioport range 0x295-0x296 has been reserved
PCI: Bridge: 0000:00:01.0
############### ???
  IO window: disabled.
  MEM window: e7000000-e7ffffff
  PREFETCH window: ef700000-febfffff
PCI: Setting latency timer of device 0000:00:01.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 65536 (order: 9, 2359296 bytes)
TCP bind hash table entries: 65536 (order: 8, 1835008 bytes)
TCP: Hash tables configured (established 65536 bind 65536)
TCP reno registered
highmem bounce pool size: 64 pages
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux agpgart interface v0.102 (c) Dave Jones
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
RAMDISK driver initialized: 1 RAM disks of 12228K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller at PCI slot 0000:00:02.5
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:00:02.5[A] -> Link [LNKA] -> GSI 11 (level, low) ->
IRQ 11 SIS5513: chipset revision 0
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
    ide0: BM-DMA at 0xb400-0xb407, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xb408-0xb40f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: IC35L040AVER07-0, ATA DISK drive
hdb: IBM-DTLA-307030, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: DVD-RW IDE1004, ATAPI CD/DVD-ROM drive
hdd: LITE-ON LTR-24102B, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 80418240 sectors (41174 MB) w/1916KiB Cache, CHS=65535/16/63, UDMA(100)
hda: cache flushes not supported
 hda: hda1 hda2 hda3 hda4 < hda5 >
hdb: max request size: 128KiB
hdb: 60036480 sectors (30738 MB) w/1916KiB Cache, CHS=59560/16/63, UDMA(100)
hdb: cache flushes not supported
 hdb: hdb1
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
TCP cubic registered
Using IPI Shortcut mode
input: AT Translated Set 2 keyboard as /class/input/input0
ReiserFS: hdb1: found reiserfs format "3.6" with standard journal
ReiserFS: hdb1: using ordered data mode
ReiserFS: hdb1: journal params: device hdb1, size 8192, journal first block 18,
max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hdb1: checking transaction log (hdb1) ReiserFS: hdb1: Using r5 hash
to sort names VFS: Mounted root (reiserfs filesystem) readonly.
Freeing unused kernel memory: 184k freed
NET: Registered protocol family 1
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 3
PCI: setting IRQ 3 as level-triggered
ACPI: PCI Interrupt 0000:00:03.0[A] -> Link [LNKE] -> GSI 3 (level, low) -> IRQ
3 ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:03.0: irq 3, io mem 0xe6000000
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:00:03.1[B] -> Link [LNKF] -> GSI 5 (level, low) -> IRQ
5 ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:03.1: irq 5, io mem 0xe5800000
sis900.c: v1.08.10 Apr. 2 2006
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 6
PCI: setting IRQ 6 as level-triggered
ACPI: PCI Interrupt 0000:00:03.2[C] -> Link [LNKG] -> GSI 6 (level, low) -> IRQ
6 ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 3
input: PC Speaker as /class/input/input1
ohci_hcd 0000:00:03.2: irq 6, io mem 0xe5000000
usb 1-2: new low speed USB device using ohci_hcd and address 2
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 4
PCI: setting IRQ 4 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LNKD] -> GSI 4 (level, low) -> IRQ
4 0000:00:04.0: Realtek RTL8201 PHY transceiver found at address 1.
0000:00:04.0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x9800, IRQ 4, 00:e0:18:aa:c7:e9.
gameport: EMU10K1 is pci0000:00:0a.1/gameport0, io 0x9000, speed 1455kHz
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 6
ACPI: PCI Interrupt 0000:00:03.3[D] -> Link [LNKH] -> GSI 6 (level, low) -> IRQ
6 ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 4
PCI: cache line size of 128 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: irq 6, io mem 0xe4800000
ehci_hcd 0000:00:03.3: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
usb 1-2: configuration #1 chosen from 1 choice
############## error here:
usb 1-2: can't set config #1, error -62
sis96x_smbus 0000:00:02.1: SiS96x SMBus base address: 0xe600
usb 1-2: USB disconnect, address 2
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKC] -> GSI 10 (level, low) ->
IRQ 10 Installing spdif_bug patch: Audigy 2 [SB0240]
agpgart: Detected SiS 648 chipset
agpgart: AGP aperture is 64M @ 0xe8000000
ieee1394: Initialized config rom entry `ip1394'
ACPI: PCI Interrupt 0000:00:0a.2[B] -> Link [LNKD] -> GSI 4 (level, low) -> IRQ
4 ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[4]  MMIO=[e3800000-e38007ff]
Max Packet=[2048]  IR/IT contexts=[4/8] usb 4-3: new high speed USB device
using ehci_hcd and address 3 usb 4-3: configuration #1 chosen from 1 choice
hdc: ATAPI 40X DVD-ROM DVD-R CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
hdd: ATAPI 40X CD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
rtc_cmos 00:07: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month
usb 2-1: new full speed USB device using ohci_hcd and address 2
Linux video capture interface: v2.00
bttv: driver version 0.9.17 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: pci latency fixup [32]
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LNKB] -> GSI 10 (level, low) ->
IRQ 10 bttv0: Bt878 (rev 17) at 0000:00:0d.0, irq: 10, latency: 32, mmio:
0xee800000 bttv0: subsystem: 11ff:0012 (UNKNOWN)
please mail id, board name and the correct card= insmod option to
video4linux-list@redhat.com bttv0: using: Pinnacle PCTV Studio/Rave
[card=39,insmod option] bttv0: setting pci timer to 32
bttv0: gpio: en=00000000, out=00000000 in=00fff3ff [init]
i2c-algo-bit.o: (0) scl=1, sda=1
i2c-algo-bit.o: (1) scl=1, sda=0
i2c-algo-bit.o: (2) scl=1, sda=1
i2c-algo-bit.o: (3) scl=0, sda=1
i2c-algo-bit.o: (4) scl=1, sda=1
i2c-algo-bit.o: bt878 #0 [sw] passed test.
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: pinnacle/mt: id=4 info="PAL+SECAM / mono" radio=no
bttv0: using tuner=33
bttv0: i2c: checking for MSP34xx @ 0x80... not found
bttv0: i2c: checking for TDA9875 @ 0xb0... not found
bttv0: i2c: checking for TDA7432 @ 0x8a... not found
tuner 1-0043: chip found @ 0x86 (bt878 #0 [sw])
tda9887 1-0043: tda988[5/6/7] found @ 0x43 (tuner)
tuner 1-0060: Chip ID is not zero. It is not a TEA5767
tuner 1-0060: chip found @ 0xc0 (bt878 #0 [sw])
tuner 1-0060: microtune: companycode=4d54 part=04 rev=04
usb 2-1: configuration #1 chosen from 1 choice
tuner 1-0060: microtune MT2032 found, OK
tuner 1-0060: microtune: companycode=4d54 part=04 rev=04
tuner 1-0060: microtune MT2032 found, OK
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00023c010102585a]
usb 1-2: new low speed USB device using ohci_hcd and address 3
usb 1-2: configuration #1 chosen from 1 choice
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378 (0x778), irq 7, dma 3
[PCSPP,TRISTATE,COMPAT,EPP,ECP,DMA] SCSI subsystem initialized
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
pwc: Philips webcam module version 10.0.12 loaded.
pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 &
PCVC830/840. pwc: Also supports the Askey VC010, various Logitech Quickcams,
Samsung MPC-C10 and MPC-C30, pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina
Eye and Visionite VCS-UC300 and VCS-UM100. pwc: Logitech QuickCam 4000 Pro USB
webcam detected. pwc: Registered as /dev/video1.
usbcore: registered new interface driver Philips webcam
usbcore: registered new interface driver hiddev
input: Logitech USB-PS/2 Optical Mouse as /class/input/input2
input: USB HID v1.10 Mouse [Logitech USB-PS/2 Optical Mouse] on
usb-0000:00:03.0-2 usbcore: registered new interface driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
mice: PS/2 mouse device common for all mice
eth1394: eth1: IEEE-1394 IPv4 over 1394 Ethernet (fw-host0)
usbcore: registered new interface driver snd-usb-audio
Realtime LSM initialized (group 18, mlock=1)
NET: Registered protocol family 10
lp0: using parport0 (interrupt-driven).
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1196800k swap on /dev/hda5.  Priority:-1 extents:1 across:1196800k
rtc: I/O resource 70 is not free.
Generic RTC Driver v1.07
scsi 0:0:0:0: Direct-Access     SAMSUNG  SP2014N          VC10 PQ: 0 ANSI: 0 CCS
usb-storage: device scan complete
scsi 0:0:0:0: Attached scsi generic sg0 type 0
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
sda: Mode Sense: 00 14 00 00
sda: assuming drive cache: write through
SCSI device sda: 390721968 512-byte hdwr sectors (200050 MB)
sda: Write Protect is off
sda: Mode Sense: 00 14 00 00
sda: assuming drive cache: write through
 sda: sda1 sda2 sda3
sd 0:0:0:0: Attached scsi disk sda

Do you have any clue on how to solve this? I also try the 2.6.20-r8 before the
2.6.21, but the pc was hanging the same.

Last, /proc/interrupts:
           CPU0       
  0:        270    XT-PIC-XT        timer
  1:        176    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:       5982    XT-PIC-XT        ohci_hcd:usb1
  4:       1669    XT-PIC-XT        ohci1394, eth0
  5:         98    XT-PIC-XT        ohci_hcd:usb2
  6:        783    XT-PIC-XT        ohci_hcd:usb3, ehci_hcd:usb4
  7:          1    XT-PIC-XT        parport0
  8:          2    XT-PIC-XT        rtc
  9:          0    XT-PIC-XT        acpi
 10:          4    XT-PIC-XT        bttv0
 11:     427702    XT-PIC-XT        EMU10K1
 12:          4    XT-PIC-XT        i8042
 14:      21349    XT-PIC-XT        ide0
 15:       6951    XT-PIC-XT        ide1
NMI:          0 
LOC:     477708 
ERR:          0
MIS:          0

Cheers,
Dominique
