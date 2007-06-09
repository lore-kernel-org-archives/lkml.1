Return-Path: <linux-kernel-owner+w=401wt.eu-S1761462AbXFIVTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761462AbXFIVTu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 17:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754739AbXFIVTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 17:19:42 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:41229 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbXFIVTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 17:19:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TYgVfl2Bf/R5LsgnQjrYXSJeS/MLAN3LgcL7oOkSdnSa4aNOiklQG2JiyhflkDfCX2kPVbKI+g1hztsnLXZ6tMoU+k0YvmtT8+uJ0K+hmH0OmWcs8+63cUNLxsxu0aVNgRaanzuCDz3zS4alXNnY56FqZWl95Zt6IYRvQKI1CrU=
Message-ID: <38e9c3450706091419n1a91a4d9xb0ddaed69caec095@mail.gmail.com>
Date: Sat, 9 Jun 2007 17:19:39 -0400
From: "Dan Collins" <en.wp.st47@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Fwd: BUG: 2.6.22-rc4 Ubuntu 7.04 AUDIO ALSA
In-Reply-To: <38e9c3450706091415m62c2d008m2a91c714773986e8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <38e9c3450706091415m62c2d008m2a91c714773986e8@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem: Audio card not detected under
kernel, card is SigmaTel, computer is a Dell XPS 400
[2.] Full description of the problem/report:
The volume control did not find any elements and/or devices to
control. This means either that you don't have the right GStreamer
plugins installed, or that you don't have a sound card configured.


You can remove the volume control from the panel by right-clicking the
speaker icon on the panel and selecting "Remove From Panel" from the
menu.

ON BOOT:

Jun  9 16:59:44 Ubuntu710XPS kernel: [
49.595280] ALSA sound/pci/hda/hda_intel.c:698: codec_mask = 0x1
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.727051] ALSA
sound/pci/hda/patch_sigmatel.c:2046: hda_codec: Unknown model for
STAC922x, using BIOS defaults

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.731042] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0a bios pin
config 02214030
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.735034] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0b bios pin
config 01a19021

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.739027] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0c bios pin
config 01111012
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.743021] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0d bios pin
config 01114010

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.747014] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0e bios pin
config 02a19020
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.751006] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 0f bios pin
config 01117011

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.755000] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 10 bios pin
config 400000f0
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.758993] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 11 bios pin
config 400000f1

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.762986] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 15 bios pin
config 01813122
Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.766986] ALSA
sound/pci/hda/patch_sigmatel.c:766: hda_codec: pin nid 1b bios pin
config 400000f2

Jun  9 16:59:44 Ubuntu710XPS kernel: [   49.810919] ALSA
sound/pci/hda/patch_sigmatel.c:1108: stac92xx_add_dyn_out_pins: total
dac count=4


[3.] Keywords (i.e., modules, networking, kernel): sound card, driver

[4.] Kernel version (from /proc/version): Linux version
2.6.22-rc4-devel (root@Ubuntu710XPS) (gcc version 4.1.2 (Ubuntu 4.
1.2-0ubuntu4)) #1 SMP Fri Jun 8 19:27:47 EDT 2007

[5.] Output of Oops.. message (if applicable) with symbolic information

     resolved (see Documentation/oops-tracing.txt)
[6.] A small shell script or example program which triggers the
     problem (if possible)
[7.] Environment
[7.1.] Software (add the output of the ver_linux script here)


If some fields are empty or look unusual you may have an old
version.
Compare to the current minimal requirements in
Documentation/Changes.

Linux Ubuntu710XPS 2.6.22-rc4-devel #1 SMP Fri Jun 8 19:27:47 EDT 2007
i686 GNU/Linux


Gnu C                  gcc (GCC) 4.1.2 (Ubuntu 4.1.2-0ubuntu4)
Copyright (C) 2006 Free Software Foundation, Inc. This is free
software; see the source for copying conditions. There is NO warranty;
not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Gnu make               3.81
util-linux             2.12r
mount                  2.12r
modutils               3.3-pre2
e2fsprogs              1.40-WIP
PPP                    2.4.4
Linux C Library        >
libc.2.5
Dynamic linker (ldd)   2.5
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
Modules Loaded         isofs udf binfmt_misc rfcomm l2cap bluetooth
ppdev capability commoncap speedstep_lib cpufreq_conservative
cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table
cpufreq_powersave ipv6 dock asus_acpi video ac sbs battery button
container dm_crypt dm_mod parport_pc lp parport snd_hda_intel
snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
snd_seq_device af_packet snd psmouse soundcore serio_raw intel_agp
pcspkr snd_page_alloc agpgart shpchp pci_hotplug joydev tsdev evdev
ext3 jbd mbcache sr_mod cdrom piix generic sg sd_mod ata_piix usbhid
hid floppy ehci_hcd ahci ata_generic libata scsi_mod e1000 uhci_hcd
usbcore thermal processor fan



[7.2.] Processor information (from /proc/cpuinfo):
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) D CPU 2.80GHz

stepping        : 4
cpu MHz         : 2793.300
cache size      : 1024 KB
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
cpuid level     : 5
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov

pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni
 monitor ds_cpl cid cx16 xtpr
bogomips        : 5590.93
clflush size    : 64

processor       : 1
vendor_id       : GenuineIntel

cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 4
cpu MHz         : 2793.300
cache size      : 1024 KB
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
cpuid level     : 5
wp              : yes

flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe nx lm constant_tsc pni
 monitor ds_cpl cid cx16 xtpr
bogomips        :
5586.14
clflush size    : 64

[7.3.] Module information (from /proc/modules):

isofs 36668 1 - Live 0xf8b7e000
udf 87076 0 - Live 0xf8b67000
binfmt_misc 13064 1 - Live 0xf8b8b000
rfcomm 41752 0 - Live 0xf8b5b000

l2cap 26368 5 rfcomm, Live 0xf8b9b000
bluetooth 56676 4 rfcomm,l2cap, Live 0xf8b4c000
ppdev 10500 0 - Live 0xf8b37000
capability 6024 0 - Live 0xf8b34000
commoncap 8576 1 capability, Live 0xf8b30000
speedstep_lib 6660 0 - Live 0xf8b2d000

cpufreq_conservative 8328 0 - Live 0xf8b29000
cpufreq_stats 7360 0 - Live 0xf8b3c000
cpufreq_userspace 5408 0 - Live 0xf8ada000
cpufreq_ondemand 9484 0 - Live 0xf8b42000
freq_table 6048 2 cpufreq_stats,cpufreq_ondemand, Live 0xf8ad7000

cpufreq_powersave 2944 0 - Live 0xf889b000
ipv6 271908 10 - Live 0xf8ae5000
dock 10784 0 - Live 0xf8ad3000
asus_acpi 17564 0 - Live 0xf8acd000
video 17800 0 - Live 0xf8ac7000
ac 6404 0 - Live 0xf89fa000

sbs 19720 0 - Live 0xf8ac1000
battery 11140 0 - Live 0xf8ae1000
button 9104 0 - Live 0xf8add000
container 5632 0 - Live 0xf89a0000
dm_crypt 15112 0 - Live 0xf8a7b000
dm_mod 58560 1 dm_crypt, Live 0xf8ba5000

parport_pc 37668 0 - Live 0xf8a70000
lp 12708 0 - Live 0xf8a6b000
parport 37832 3 ppdev,parport_pc,lp, Live 0xf8a60000
snd_hda_intel 279832 0 - Live 0xf8c79000
snd_pcm_oss 54144 0 - Live 0xf8a51000
snd_mixer_oss 18304 1 snd_pcm_oss, Live 0xf8a01000

snd_pcm 89348 2 snd_hda_intel,snd_pcm_oss, Live 0xf8a3a000
snd_seq_dummy 4996 0 - Live 0xf8922000
snd_seq_oss 35328 0 - Live 0xf89f0000
snd_seq_midi 10880 0 - Live 0xf89ec000
snd_rawmidi 27520 1 snd_seq_midi, Live 0xf89e4000

snd_seq_midi_event 8576 2 snd_seq_oss,snd_seq_midi, Live 0xf89fd000
snd_seq 58096 6 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_seq_midi_event, Live
0xf89d4000
snd_timer 26244 2 snd_pcm,snd_seq, Live 0xf89c0000

snd_seq_device 9868 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi,snd_rawmidi,snd_seq
, Live 0xf8996000
af_packet 24840 2 - Live 0xf898e000
snd 61060 11 snd_hda_intel,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_seq_dummy,snd_s

eq_oss,snd_seq_midi,snd_rawmidi,snd_seq,snd_timer,snd_seq_device, Live 0xf89b000
0
psmouse 40208 0 - Live 0xf8983000
soundcore 9056 1 snd, Live 0xf899c000
serio_raw 8324 0 - Live 0xf89ac000
intel_agp 25372 1 - Live 0xf897b000

pcspkr 4352 0 - Live 0xf88bd000
snd_page_alloc 11656 2 snd_hda_intel,snd_pcm, Live 0xf89a3000
agpgart 35400 1 intel_agp, Live 0xf8971000
shpchp 34836 0 - Live 0xf8967000
pci_hotplug 32960 1 shpchp, Live 0xf89ca000

joydev 11584 0 - Live 0xf891e000
tsdev 9536 0 - Live 0xf891a000
evdev 11392 3 - Live 0xf8916000
ext3 134024 1 - Live 0xf8945000
jbd 60328 1 ext3, Live 0xf8a2a000
mbcache 9860 1 ext3, Live 0xf88e5000

sr_mod 17828 1 - Live 0xf8910000
cdrom 37792 1 sr_mod, Live 0xf8905000
piix 10756 0 [permanent], Live 0xf88e1000
generic 6020 0 [permanent], Live 0xf88ba000
sg 36892 0 - Live 0xf88fa000
sd_mod 30336 3 - Live 0xf88b1000

ata_piix 16004 3 - Live 0xf88ac000
usbhid 29664 0 - Live 0xf88a3000
hid 29184 1 usbhid, Live 0xf8892000
floppy 59940 0 - Live 0xf88ea000
ehci_hcd 36108 0 - Live 0xf8883000
ahci 21892 0 - Live 0xf887a000

ata_generic 8708 0 - Live 0xf889d000
libata 127284 3 ata_piix,ahci,ata_generic, Live 0xf8859000
scsi_mod 147212 4 sr_mod,sg,sd_mod,libata, Live 0xf8834000
e1000 125888 0 - Live 0xf8925000
uhci_hcd 26768 0 - Live 0xf8827000

usbcore 136964 4 usbhid,ehci_hcd,uhci_hcd, Live 0xf8a07000
thermal 14600 0 - Live 0xf8822000
processor 32200 1 thermal, Live 0xf8819000
fan 6020 0 - Live 0xf8831000


[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)


IOPORTS

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

0170-0177 : 0000:00:1f.1
  0170-0177 : libata
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : libata
0200-0277 : pnp 00:08
0280-02e7 : pnp 00:08
02e8-02ef : pnp 00:08
02f0-02f7 : pnp 00:08
02f8-02ff : pnp 00:08

0376-0376 : 0000:00:1f.1
  0376-0376 : libata
0380-03bb : pnp 00:08
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : libata
03f7-03f7 : floppy DIR
0800-085f : pnp 00:01

  0800-0803 : ACPI PM1a_EVT_BLK
  0804-0805 : ACPI PM1a_CNT_BLK
  0808-080b : ACPI PM_TMR
  0810-0815 : ACPI CPU throttle
  0828-082f : ACPI GPE0_BLK
0860-08ff : pnp 00:01
0c00-0c7f : pnp 00:01
0cf8-0cff : PCI conf1

b000-bfff : PCI Bus #05
  bcf8-bcff : 0000:05:05.0
c000-cfff : PCI Bus #04
  cce0-ccff : 0000:04:00.0
    cce0-ccff : e1000
d000-dfff : PCI Bus #01
  dc00-dcff : 0000:01:00.0
ece0-ecff : 0000:00:1f.3

fe00-fe07 : 0000:00:1f.2
fe10-fe13 : 0000:00:1f.2
fe20-fe27 : 0000:00:1f.2
fe30-fe33 : 0000:00:1f.2
fea0-feaf : 0000:00:1f.2
ff20-ff3f : 0000:00:1d.3
  ff20-ff3f : uhci_hcd
ff40-ff5f : 0000:00:1d.2

  ff40-ff5f : uhci_hcd
ff60-ff7f : 0000:00:1d.1
  ff60-ff7f : uhci_hcd
ff80-ff9f : 0000:00:1d.0
  ff80-ff9f : uhci_hcd
ffa0-ffaf : 0000:00:1f.1
  ffa0-ffaf : libata

IOMEM

00000000-0009ffff : System RAM

  00000000-00000000 : Crash kernel
000a0000-000bffff : Video RAM area
000c0000-000ccfff : Video ROM
000cf000-000cffff : Adapter ROM
000f0000-000fffff : System ROM
00100000-7fe8cbff : System RAM
  00100000-002fd8f5 : Kernel code

  002fd8f6-003e1863 : Kernel data
7fe8cc00-7fe8ebff : ACPI Non-volatile Storage
7fe8ec00-7fe90bff : ACPI Tables
7fe90c00-7fffffff : reserved
e0000000-e3ffffff : PCI MMCONFIG 0
f0000000-f7ffffff : PCI Bus #01

  f0000000-f7ffffff : 0000:01:00.0
fe200000-fe2fffff : PCI Bus #05
  fe2f0000-fe2fffff : 0000:05:05.0
fe300000-fe7fffff : PCI Bus #04
  fe3e0000-fe3fffff : 0000:04:00.0
    fe3e0000-fe3fffff : e1000

  fe400000-fe7fffff : 0000:04:00.0
    fe400000-fe7fffff : e1000
fe800000-fe8fffff : PCI Bus #02
fe900000-feafffff : PCI Bus #01
  fe9e0000-fe9effff : 0000:01:00.0
  fe9f0000-fe9fffff : 0000:01:00.1
  fea00000-fea1ffff : 0000:01:
00.0
febfbc00-febfbfff : 0000:00:1f.2
  febfbc00-febfbfff : ahci
febfc000-febfffff : 0000:00:1b.0
fed00000-fed003ff : HPET 0
fed20000-fed9ffff : reserved
feda0000-fedacfff : pnp 00:08
fee00000-feefffff : reserved

ffa80800-ffa80bff : 0000:00:1d.7
  ffa80800-ffa80bff : ehci_hcd
ffb00000-ffffffff : reserved

[7.5.] PCI information ('lspci -vvv' as root)

00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub

        Subsystem: Dell Unknown device 01d1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ >SERR- <PERR-

        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:01.0 PCI bridge: Intel Corporation 82945G/GZ/P/PL PCI Express Root
Port (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=01, subordinate=01, sec-latency=0

        I/O behind bridge: 0000d000-0000dfff
        Memory behind bridge: fe900000-feafffff
        Prefetchable memory behind bridge: 00000000f0000000-00000000f7ffffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

        BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-
        Capabilities: [88] Subsystem: Intel Corporation Unknown device 0000
        Capabilities: [80] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)

                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0300c  Data: 41b9
        Capabilities: [a0] Express Root Port (Slot+) IRQ 0

                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+

                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s, Port 2
                Link: Latency L0s <256ns, L1 <4us

                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x16
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug- Surpise-
                Slot: Number 7680, PowerLimit
25.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Off, PwrInd On, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [100] Virtual Channel

        Capabilities: [140] Unknown (5)

00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
Definition Audio Controller (rev 01)
        Subsystem: Dell Unknown device 01d1
        Control: I/O- Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin A routed to IRQ 16
        Region 0: Memory at febfc000 (64-bit, non-prefetchable) [size=16K]

        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=55mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [60] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-

                Address: 0000000000000000  Data: 0000
        Capabilities: [70] Express Unknown type IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <64ns, L1 <1us

                Device: Errors: Correctable- Non-Fatal- Fatal- Unsupported-
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop+
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes

                Link: Supported Speed unknown, Width x0, ASPM unknown, Port 0
                Link: Latency L0s <64ns, L1 <1us
                Link: ASPM Disabled CommClk- ExtSynch-
                Link: Speed unknown, Width x0

        Capabilities: [100] Virtual Channel
        Capabilities: [130] Unknown (5)

00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express
Port 1 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=02, subordinate=02, sec-latency=0

        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fe800000-fe8fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-

        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-

                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes

                Link: Supported Speed 2.5Gb/s, Width x4, ASPM L0s, Port 1
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed
2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 2, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-

                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+

                Address: fee0300c  Data: 41c1
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device 0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)

                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1c.4 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 5 (rev 01) (prog-if 00 [Normal decode])

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
        I/O behind bridge: 0000f000-00000fff
        Memory behind bridge: fff00000-000fffff

        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+

                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 5

                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed 2.5Gb/s, Width x0
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+

                Slot: Number 3, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-
                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-

        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+
                Address: fee0300c  Data: 41c9
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device 0000

        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel

        Capabilities: [180] Unknown (5)

00:1c.5 PCI bridge: Intel Corporation 82801GR/GH/GHM (ICH7 Family) PCI
Express Port 6 (rev 01) (prog-if 00 [Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Bus: primary=00, secondary=04, subordinate=04, sec-latency=0

        I/O behind bridge: 0000c000-0000cfff
        Memory behind bridge: fe300000-fe7fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- <SERR- <PERR-

        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [40] Express Root Port (Slot+) IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-

                Device: Latency L0s unlimited, L1 unlimited
                Device: Errors: Correctable+ Non-Fatal+ Fatal+ Unsupported+
                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes

                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s, Port 6
                Link: Latency L0s <256ns, L1 <4us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-
                Link: Speed
2.5Gb/s, Width x1
                Slot: AtnBtn- PwrCtrl- MRL- AtnInd- PwrInd- HotPlug+ Surpise+
                Slot: Number 4, PowerLimit 10.000000
                Slot: Enabled AtnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq-

                Slot: AttnInd Unknown, PwrInd Unknown, Power-
                Root: Correctable- Non-Fatal- Fatal- PME-
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+

                Address: fee0300c  Data: 41d1
        Capabilities: [90] Subsystem: Gammagraphx, Inc. Unknown device 0000
        Capabilities: [a0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)

                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [100] Virtual Channel
        Capabilities: [180] Unknown (5)

00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #1 (rev 01) (prog-if 00 [UHCI])

        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 4: I/O ports at ff80 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #2 (rev 01) (prog-if 00 [UHCI])

        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin B routed to IRQ 19
        Region 4: I/O ports at ff60 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #3 (rev 01) (prog-if 00 [UHCI])

        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin C routed to IRQ 20
        Region 4: I/O ports at ff40 [size=32]

00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB
UHCI #4 (rev 01) (prog-if 00 [UHCI])

        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin D routed to IRQ 21
        Region 4: I/O ports at ff20 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2
EHCI Controller (rev 01) (prog-if 20 [EHCI])

        Subsystem: Dell Unknown device 01d1
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin A routed to IRQ 18
        Region 0: Memory at ffa80800 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)

                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
(prog-if 01 [Subtractive decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=32
        I/O behind bridge: 0000b000-0000bfff

        Memory behind bridge: fe200000-fe2fffff
        Prefetchable memory behind bridge: 00000000fff00000-00000000000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort+ <SERR- <PERR-

        BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
        Capabilities: [50] Subsystem: Gammagraphx, Inc. Unknown device 0000

00:1f.0 ISA bridge: Intel Corporation 82801GH (ICH7DH) LPC Interface
Bridge (rev 01)

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Capabilities: [e0] Vendor Specific Information

00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE
Controller (rev 01) (prog-if 8a [Master SecP PriP])
        Subsystem: Dell Unknown device 01d1

        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]

        Region 4: I/O ports at ffa0 [size=16]

00:1f.2 SATA controller: Intel Corporation 82801GR/GH (ICH7 Family)
Serial ATA Storage Controller AHCI (rev 01) (prog-if 01 [AHCI 1.0])
        Subsystem: Dell Unknown device 01d1

        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 0
        Interrupt: pin C routed to IRQ 219
        Region 0: I/O ports at fe00 [size=8]
        Region 1: I/O ports at fe10 [size=4]
        Region 2: I/O ports at fe20 [size=8]
        Region 3: I/O ports at fe30 [size=4]

        Region 4: I/O ports at fea0 [size=16]
        Region 5: Memory at febfbc00 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit-
Queue=0/0 Enable+

                Address: fee0300c  Data: 4142
        Capabilities: [70] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-

        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 10
        Region 4: I/O ports at ece0 [size=32]


01:00.0 VGA compatible controller: ATI Technologies Inc RV380 [Radeon
X600 (PCIE)] (prog-if 00 [VGA])
        Subsystem: ATI Technologies Inc Unknown device 0602
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 11
        Region 0: Memory at f0000000 (64-bit, prefetchable) [size=128M]

        Region 2: Memory at fe9e0000 (64-bit, non-prefetchable) [size=64K]
        Region 4: I/O ports at dc00 [size=256]
        Expansion ROM at fea00000 [disabled] [size=128K]
        Capabilities: [50] Power Management version 2

                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag+

                Device: Latency L0s <128ns, L1 <2us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd+ ExtTag+ PhantFunc- AuxPwr- NoSnoop+

                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-

                Link: Speed 2.5Gb/s, Width x16
        Capabilities: [80] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable-
                Address: 0000000000000000  Data: 0000
        Capabilities: [100] Advanced Error Reporting


01:00.1 Display controller: ATI Technologies Inc RV380 [Radeon X600]
        Subsystem: ATI Technologies Inc Unknown device 0603
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-

        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0, Cache Line Size: 64 bytes
        Region 0: Memory at fe9f0000 (64-bit, non-prefetchable) [size=64K]

        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Express Endpoint IRQ 0

                Device: Supported: MaxPayload 128 bytes, PhantFunc 0, ExtTag-
                Device: Latency L0s <128ns, L1 <2us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-

                Device: RlxdOrd- ExtTag- PhantFunc- AuxPwr- NoSnoop-
                Device: MaxPayload 128 bytes, MaxReadReq 128 bytes
                Link: Supported Speed 2.5Gb/s, Width x16, ASPM L0s L1, Port 0

                Link: Latency L0s <128ns, L1 <1us
                Link: ASPM Disabled RCB 64 bytes CommClk- ExtSynch-
                Link: Speed 2.5Gb/s, Width x16

04:00.0 Ethernet controller: Intel Corporation 82573L Gigabit Ethernet
Controller (rev 01)

        Subsystem: Dell Unknown device 01d1
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-

        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 218
        Region 0: Memory at fe3e0000 (32-bit, non-prefetchable) [size=128K]
        Region 1: Memory at fe400000 (32-bit, non-prefetchable) [size=4M]

        Region 2: I/O ports at cce0 [size=32]
        Capabilities: [c8] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-

        Capabilities: [d0] Message Signalled Interrupts: Mask- 64bit+
Queue=0/0 Enable+
                Address: 00000000fee0300c  Data: 414a
        Capabilities: [e0] Express Endpoint IRQ 0
                Device: Supported: MaxPayload 256 bytes, PhantFunc 0, ExtTag-

                Device: Latency L0s <512ns, L1 <64us
                Device: AtnBtn- AtnInd- PwrInd-
                Device: Errors: Correctable- Non-Fatal+ Fatal+ Unsupported-
                Device: RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+

                Device: MaxPayload 128 bytes, MaxReadReq 512 bytes
                Link: Supported Speed 2.5Gb/s, Width x1, ASPM L0s L1, Port 0
                Link: Latency L0s <128ns, L1 <64us
                Link: ASPM Disabled RCB 64 bytes CommClk+ ExtSynch-

                Link: Speed 2.5Gb/s, Width x1
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [140] Device Serial Number 04-38-11-ff-ff-72-13-00

05:05.0 Communication controller: Conexant HSF 56k Data/Fax Modem

        Subsystem: Conexant Unknown device 200f
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium
>TAbort- <TAbort- <MAbort- >SERR- <PERR-

        Latency: 64
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at fe2f0000 (32-bit, non-prefetchable) [size=64K]
        Region 1: I/O ports at bcf8 [size=8]
        Capabilities: [40] Power Management version 2

                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-


[7.6.] SCSI information (from /proc/scsi/scsi)


  Vendor: ATA      Model: ST3160828AS      Rev: 8.04
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: ST3160811AS      Rev: 3.AA

  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi4 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD+-RW GWA4164B Rev: D108
  Type:   CD-ROM                           ANSI  SCSI revision: 05

Host: scsi4 Channel: 00 Id: 01 Lun: 00
  Vendor: ATA      Model: Maxtor 6L120P0   Rev: BAJ4
  Type:   Direct-Access                    ANSI  SCSI revision: 05

[7.7.] Other information that might be relevant to the problem

       (please look in /proc and include all information that you
       think to be relevant):
/proc/asound/cards
--- no soundcards ---
/proc/asound/devices
  2:        : timer
  3:        : sequencer

/proc/asound/modules is blank, as is /pcm


[X.] Other notes, patches, fixes, workarounds:

-- 
ST47
