Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbXE1WPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbXE1WPP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 18:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbXE1WPD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 18:15:03 -0400
Received: from kosatka.spsmb.cz ([82.117.151.132]:51549 "EHLO mail.spsmb.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbXE1WO7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 18:14:59 -0400
X-Greylist: delayed 636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 May 2007 18:14:58 EDT
Message-ID: <465B51DB.6000305@spsmb.cz>
Date: Tue, 29 May 2007 00:04:11 +0200
From: "vasek@spsmb.cz" <vasek@spsmb.cz>
User-Agent: Thunderbird 1.5.0.10 (X11/20070403)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: V4L2 - Leadtek Winfast PVR 2000 XP makes partial kernel
 freeze
Content-Type: text/plain; charset=windows-1250; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kernel very often freezes when I watch TV on my card TV Leadtek Winfast 
PVR 2000 XP.
When I watch TV in KdeTV, I got message like "problem with v4l2" and 
then no picture, only sound. (Some tv applications dont run at all). 
After that I can normally work witch computer but I can't run ps aux, 
which freezes and turn off computer.

Kernel version: 2.6.20.x (kernel in ubuntu 2.6.20-15 is ok, but 
2.6.20-16 is not), 2.6.21.1(my compilation), 2.6.21.2(my compilation)

This reports are from 2.6.20-15-generic:

cat /proc/cpuinfo:

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping        : 2
cpu MHz         : 1000.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 0
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca cmov
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 3dno
wext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips        : 2011.54
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 75
model name      : AMD Athlon(tm) 64 X2 Dual Core Processor 4200+
stepping        : 2
cpu MHz         : 1000.000
cache size      : 512 KB
physical id     : 0
siblings        : 2
core id         : 1
cpu cores       : 2
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge 
mca 
cmov                                                                                                    
pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt rdtscp 
lm 
3dno                                                                                                   
wext 3dnow pni cx16 lahf_lm cmp_legacy svm cr8_legacy
bogomips        : 2011.54
TLB size        : 1024 4K pages
clflush size    : 64
cache_alignment : 64
address sizes   : 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc



cat /proc/modules:

snd_rtctimer 5216 1 - Live 0xffffffff88c06000
rfcomm 45352 0 - Live 0xffffffff88bf9000
l2cap 28160 5 rfcomm, Live 0xffffffff88bf1000
bluetooth 62340 4 rfcomm,l2cap, Live 0xffffffff88be0000
ppdev 11272 0 - Live 0xffffffff88bdc000
capifs 7824 1 - Live 0xffffffff88bd9000
powernow_k8 16480 1 - Live 0xffffffff88bd3000
cpufreq_userspace 6176 0 - Live 0xffffffff88bd0000
cpufreq_stats 8416 0 - Live 0xffffffff88bcc000
cpufreq_powersave 3072 0 - Live 0xffffffff8807e000
cpufreq_ondemand 10640 1 - Live 0xffffffff88bc8000
freq_table 6336 3 powernow_k8,cpufreq_stats,cpufreq_ondemand, Live 
0xffffffff88bc5000
cpufreq_conservative 9736 0 - Live 0xffffffff88bc1000
tc1100_wmi 9224 0 - Live 0xffffffff88bbd000
sony_acpi 7064 0 - Live 0xffffffff88bba000
pcc_acpi 15616 0 - Live 0xffffffff88bb5000
dev_acpi 17028 0 - Live 0xffffffff88baf000
video 19080 0 - Live 0xffffffff88ba9000
sbs 17856 0 - Live 0xffffffff88ba3000
i2c_ec 6784 1 sbs, Live 0xffffffff88ba0000
dock 11992 0 - Live 0xffffffff88b9c000
container 6144 0 - Live 0xffffffff88b99000
button 10016 0 - Live 0xffffffff88b95000
battery 12040 0 - Live 0xffffffff88b91000
asus_acpi 19756 0 - Live 0xffffffff88b8b000
backlight 8448 1 asus_acpi, Live 0xffffffff88b87000
ac 6920 0 - Live 0xffffffff88b84000
nls_utf8 3456 1 - Live 0xffffffff88079000
ntfs 101960 1 - Live 0xffffffff88b6a000
reiserfs 248576 1 - Live 0xffffffff88b2c000
ext2 72464 1 - Live 0xffffffff88b19000
mbcache 11400 1 ext2, Live 0xffffffff88b15000
it87 24336 0 - Live 0xffffffff88b0e000
hwmon_vid 4864 1 it87, Live 0xffffffff88b0b000
i2c_isa 7680 1 it87, Live 0xffffffff88b08000
eeprom 9744 0 - Live 0xffffffff88b04000
lp 15048 0 - Live 0xffffffff88aff000
fuse 51888 0 - Live 0xffffffff88af1000
snd_intel8x0 38952 1 - Live 0xffffffff88ae6000
snd_ac97_codec 117720 1 snd_intel8x0, Live 0xffffffff88ac8000
ac97_bus 3968 1 snd_ac97_codec, Live 0xffffffff88071000
snd_pcm_oss 49536 0 - Live 0xffffffff88aba000
snd_mixer_oss 19840 1 snd_pcm_oss, Live 0xffffffff88ab4000
snd_pcm 92808 3 snd_intel8x0,snd_ac97_codec,snd_pcm_oss, Live 
0xffffffff88a9c000
tuner 67368 0 - Live 0xffffffff88a8a000
snd_seq_dummy 5380 0 - Live 0xffffffff88a87000
snd_seq_oss 36608 0 - Live 0xffffffff88a7d000
snd_seq_midi 11008 0 - Live 0xffffffff88a79000
snd_rawmidi 29696 1 snd_seq_midi, Live 0xffffffff88a70000
snd_seq_midi_event 9856 2 snd_seq_oss,snd_seq_midi, Live 0xffffffff88a6c000
snd_seq 61856 7 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live 
0xffffffff88a5b000
snd_timer 26632 3 snd_rtctimer,snd_pcm,snd_seq, Live 0xffffffff88a53000
snd_seq_device 10260 5 
snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq, Live 
0xffffffff88a4f000
cx8800 41100 0 - Live 0xffffffff88a43000
cx88xx 74532 1 cx8800, Live 0xffffffff88a2f000
nvidia 7761464 22 - Live 0xffffffff882c7000 (P)
ir_common 34308 1 cx88xx, Live 0xffffffff882bd000
snd 68904 13 
snd_intel8x0,snd_ac97_codec,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_oss,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, 
Live 0xffffffff882ab000
i2c_algo_bit 9608 1 cx88xx, Live 0xffffffff882a7000
video_buf 29700 2 cx8800,cx88xx, Live 0xffffffff8829e000
tveeprom 19216 1 cx88xx, Live 0xffffffff88298000
parport_pc 40104 1 - Live 0xffffffff8828d000
soundcore 10272 1 snd, Live 0xffffffff88289000
compat_ioctl32 11136 1 cx8800, Live 0xffffffff88285000
btcx_risc 6664 2 cx8800,cx88xx, Live 0xffffffff88282000
videodev 29824 2 cx8800,cx88xx, Live 0xffffffff88279000
i2c_nforce2 7680 0 - Live 0xffffffff88276000
v4l2_common 28800 4 tuner,cx8800,compat_ioctl32,videodev, Live 
0xffffffff8826d000
xpad 11272 0 - Live 0xffffffff88269000
psmouse 43536 0 - Live 0xffffffff8825d000
snd_page_alloc 11792 2 snd_intel8x0,snd_pcm, Live 0xffffffff88259000
v4l1_compat 14980 2 cx8800,videodev, Live 0xffffffff88254000
i2c_core 26624 10 
i2c_ec,it87,i2c_isa,eeprom,tuner,cx88xx,nvidia,i2c_algo_bit,tveeprom,i2c_nforce2, 
Live 0xffffffff8824c000
k8temp 7552 0 - Live 0xffffffff88249000
parport 43404 3 ppdev,lp,parport_pc, Live 0xffffffff8823d000
serio_raw 9092 0 - Live 0xffffffff88239000
pcspkr 4736 0 - Live 0xffffffff8809b000
shpchp 37404 0 - Live 0xffffffff8822e000
pci_hotplug 36228 1 shpchp, Live 0xffffffff88224000
ipv6 307072 14 - Live 0xffffffff881d8000
evdev 13056 4 - Live 0xffffffff881d3000
tsdev 10112 0 - Live 0xffffffff881cf000
joydev 12928 0 - Live 0xffffffff881ca000
xfs 533448 1 - Live 0xffffffff88146000
sg 40616 0 - Live 0xffffffff8813b000
sd_mod 25092 6 - Live 0xffffffff88133000
ide_disk 18304 2 - Live 0xffffffff8812d000
ide_cd 35104 0 - Live 0xffffffff88123000
cdrom 40744 1 ide_cd, Live 0xffffffff88118000
usbhid 29088 2 - Live 0xffffffff8810f000
hid 34048 1 usbhid, Live 0xffffffff88105000
sata_nv 24196 4 - Live 0xffffffff880fe000
ata_generic 10628 0 - Live 0xffffffff880fa000
libata 137000 2 sata_nv,ata_generic, Live 0xffffffff880d7000
scsi_mod 166968 3 sg,sd_mod,libata, Live 0xffffffff880ad000
forcedeth 48776 0 - Live 0xffffffff8809e000
floppy 67944 0 - Live 0xffffffff88089000
ohci_hcd 24196 0 - Live 0xffffffff88080000
generic 6532 0 [permanent], Live 0xffffffff8807b000
amd74xx 16944 0 [permanent], Live 0xffffffff88073000
ehci_hcd 37004 0 - Live 0xffffffff88066000
usbcore 154416 7 xpad,usbhid,ohci_hcd,ehci_hcd, Live 0xffffffff8803f000
thermal 16912 0 - Live 0xffffffff88039000
processor 34952 2 powernow_k8,thermal, Live 0xffffffff8802f000
fan 6536 0 - Live 0xffffffff8802c000
fbcon 44416 0 - Live 0xffffffff88020000
tileblit 4096 1 fbcon, Live 0xffffffff8801e000
font 9856 1 fbcon, Live 0xffffffff8801a000
bitblit 7296 1 fbcon, Live 0xffffffff88017000
softcursor 3712 1 bitblit, Live 0xffffffff88015000
vesafb 10376 0 - Live 0xffffffff88011000
cfbcopyarea 5120 1 vesafb, Live 0xffffffff8800e000
cfbimgblt 4096 1 vesafb, Live 0xffffffff8800c000
cfbfillrect 5632 1 vesafb, Live 0xffffffff88009000
capability 7048 0 - Live 0xffffffff88006000
commoncap 9472 1 capability, Live 0xffffffff88002000


cat /proc/ioports/proc/ioports/proc/ioports:

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
0170-0177 : 0000:00:06.0
  0170-0177 : ide1
01f0-01f7 : 0000:00:06.0
  01f0-01f7 : ide0
0290-0297 : it87-isa
0376-0376 : 0000:00:06.0
  0376-0376 : ide1
0378-037a : parport0
037b-037f : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:06.0
  03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0960-0967 : 0000:00:08.0
  0960-0967 : sata_nv
0970-0977 : 0000:00:07.0
  0970-0977 : sata_nv
09e0-09e7 : 0000:00:08.0
  09e0-09e7 : sata_nv
09f0-09f7 : 0000:00:07.0
  09f0-09f7 : sata_nv
0b60-0b63 : 0000:00:08.0
  0b60-0b63 : sata_nv
0b70-0b73 : 0000:00:07.0
  0b70-0b73 : sata_nv
0be0-0be3 : 0000:00:08.0
  0be0-0be3 : sata_nv
0bf0-0bf3 : 0000:00:07.0
  0bf0-0bf3 : sata_nv
0cf8-0cff : PCI conf1
4000-407f : motherboard
  4000-4003 : ACPI PM1a_EVT_BLK
  4004-4005 : ACPI PM1a_CNT_BLK
  4008-400b : ACPI PM_TMR
  401c-401c : ACPI PM2_CNT_BLK
  4020-4027 : ACPI GPE0_BLK
4080-40ff : motherboard
  4080-40ff : pnp 00:01
4400-447f : motherboard
  4400-447f : pnp 00:01
4480-44ff : motherboard
  44a0-44af : ACPI GPE1_BLK
4800-487f : motherboard
  4800-487f : pnp 00:01
4880-48ff : motherboard
  4880-48ff : pnp 00:01
4c00-4c3f : 0000:00:01.1
  4c00-4c3f : nForce2_smbus
4c40-4c7f : 0000:00:01.1
  4c40-4c7f : nForce2_smbus
bc00-bc07 : 0000:00:0a.0
  bc00-bc07 : forcedeth
c000-c00f : 0000:00:08.0
  c000-c00f : sata_nv
d400-d40f : 0000:00:07.0
  d400-d40f : sata_nv
e800-e80f : 0000:00:06.0
  e800-e807 : ide0
  e808-e80f : ide1
ec00-ecff : 0000:00:04.0
  ec00-ecff : NVidia CK804
f000-f0ff : 0000:00:04.0
  f000-f0ff : NVidia CK804
fc00-fc1f : 0000:00:01.1


cat /proc/iomem:

00000000-0009efff : System RAM
  00000000-00000000 : Crash kernel
0009f000-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cefff : Video ROM
000f0000-000fffff : System ROM
00100000-3fedffff : System RAM
  00200000-0042a620 : Kernel code
  0042a621-0054d1ff : Kernel data
3fee0000-3fee2fff : ACPI Non-volatile Storage
3fee3000-3feeffff : ACPI Tables
3fef0000-3fefffff : reserved
d0000000-dfffffff : PCI Bus #05
  d0000000-dfffffff : 0000:05:00.0
e0000000-efffffff : reserved
fa000000-fcffffff : PCI Bus #05
  fa000000-faffffff : 0000:05:00.0
    fa000000-faffffff : nvidia
  fb000000-fbffffff : 0000:05:00.0
  fcfe0000-fcffffff : 0000:05:00.0
fd000000-fdffffff : PCI Bus #01
  fd000000-fdffffff : 0000:01:07.0
    fd000000-fdffffff : cx88[0]
fe02a000-fe02afff : 0000:00:0a.0
  fe02a000-fe02afff : forcedeth
fe02b000-fe02bfff : 0000:00:08.0
  fe02b000-fe02bfff : sata_nv
fe02c000-fe02cfff : 0000:00:07.0
  fe02c000-fe02cfff : sata_nv
fe02d000-fe02dfff : 0000:00:04.0
  fe02d000-fe02dfff : NVidia CK804
fe02f000-fe02ffff : 0000:00:02.0
  fe02f000-fe02ffff : ohci_hcd
feb00000-feb000ff : 0000:00:02.1
  feb00000-feb000ff : ehci_hcd
fec00000-fec00fff : IOAPIC 0
fee00000-fee00fff : Local APIC


vasek@vasek:~$ lspci -vvv
00:00.0 Memory controller: nVidia Corporation CK804 Memory Controller 
(rev a3)
        Subsystem: ASUSTeK Computer Inc. Unknown device 815a
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Capabilities: <access denied>

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev f3)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:01.1 SMBus: nVidia Corporation CK804 SMBus (rev a2)
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 255
        Region 0: I/O ports at fc00 [size=32]
        Region 4: I/O ports at 4c00 [size=64]
        Region 5: I/O ports at 4c40 [size=64]
        Capabilities: <access denied>

00:02.0 USB Controller: nVidia Corporation CK804 USB Controller (rev a2) 
(prog-if 10 [OHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

00:02.1 USB Controller: nVidia Corporation CK804 USB Controller (rev a3) 
(prog-if 20 [EHCI])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin B routed to IRQ 23
        Region 0: Memory at feb00000 (32-bit, non-prefetchable) [size=256]
        Capabilities: <access denied>

00:04.0 Multimedia audio controller: nVidia Corporation CK804 AC'97 
Audio Controller (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device 822c
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (500ns min, 1250ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: I/O ports at f000 [size=256]
        Region 1: I/O ports at ec00 [size=256]
        Region 2: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

00:06.0 IDE interface: nVidia Corporation CK804 IDE (rev f2) (prog-if 8a 
[Master SecP PriP])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Region 0: [virtual] Memory at 000001f0 (32-bit, 
non-prefetchable) [disabled] [size=8]
        Region 1: [virtual] Memory at 000003f0 (type 3, 
non-prefetchable) [disabled] [size=1]
        Region 2: [virtual] Memory at 00000170 (32-bit, 
non-prefetchable) [disabled] [size=8]
        Region 3: [virtual] Memory at 00000370 (type 3, 
non-prefetchable) [disabled] [size=1]
        Region 4: I/O ports at e800 [size=16]
        Capabilities: <access denied>

00:07.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. Unknown device 815a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: I/O ports at 09f0 [size=8]
        Region 1: I/O ports at 0bf0 [size=4]
        Region 2: I/O ports at 0970 [size=8]
        Region 3: I/O ports at 0b70 [size=4]
        Region 4: I/O ports at d400 [size=16]
        Region 5: Memory at fe02c000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

00:08.0 IDE interface: nVidia Corporation CK804 Serial ATA Controller 
(rev f3) (prog-if 85 [Master SecO PriO])
        Subsystem: ASUSTeK Computer Inc. K8N4-E Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (750ns min, 250ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at 09e0 [size=8]
        Region 1: I/O ports at 0be0 [size=4]
        Region 2: I/O ports at 0960 [size=8]
        Region 3: I/O ports at 0b60 [size=4]
        Region 4: I/O ports at c000 [size=16]
        Region 5: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: <access denied>

00:09.0 PCI bridge: nVidia Corporation CK804 PCI Bridge (rev f2) 
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=128
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fd000000-fdffffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-

00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev f3)
        Subsystem: ASUSTeK Computer Inc. Unknown device 812a
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 23
        Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at bc00 [size=8]
        Capabilities: <access denied>

00:0b.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) 
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: <access denied>

00:0c.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) 
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: <access denied>

00:0d.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev f3) 
(prog-if 00 [Normal decode])
        Control: I/O- Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
        Capabilities: <access denied>

00:0e.0 PCI bridge: nVidia Corporation CK804 PCIE Bridge (rev a3) 
(prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 32 bytes
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fa000000-fcffffff
        Prefetchable memory behind bridge: 00000000d0000000-00000000dfffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR- NoISA+ VGA+ MAbort- >Reset- FastB2B-
        Capabilities: <access denied>

00:18.0 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
HyperTransport Technology Configuration
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: <access denied>

00:18.1 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Address Map
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:18.2 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
DRAM Controller
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-

00:18.3 Host bridge: Advanced Micro Devices [AMD] K8 [Athlon64/Opteron] 
Miscellaneous Control
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Capabilities: <access denied>

01:07.0 Multimedia video controller: Conexant CX23880/1/2/3 PCI Video 
and Audio Decoder (rev 05)
        Subsystem: LeadTek Research Inc. Unknown device 6611
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (5000ns min, 13750ns max), Cache Line Size: 32 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
        Capabilities: <access denied>

05:00.0 VGA compatible controller: nVidia Corporation GeForce 7300 GS 
(rev a1) (prog-if 00 [VGA])
        Subsystem: ASUSTeK Computer Inc. Unknown device 81f3
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at fa000000 (32-bit, non-prefetchable) [size=16M]
        Region 1: Memory at d0000000 (64-bit, prefetchable) [size=256M]
        Region 3: Memory at fb000000 (64-bit, non-prefetchable) [size=16M]
        [virtual] Expansion ROM at fcfe0000 [disabled] [size=128K]
        Capabilities: <access denied>



