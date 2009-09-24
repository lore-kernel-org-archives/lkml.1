Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZIXI2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZIXI2x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 04:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZIXI2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 04:28:51 -0400
Received: from fmmailgate05.web.de ([217.72.192.243]:46064 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbZIXI2s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 04:28:48 -0400
Date: Thu, 24 Sep 2009 10:28:49 +0200
Message-Id: <1182477970@web.de>
MIME-Version: 1.0
From: clemens1509@web.de
To: linux-kernel@vger.kernel.org
Subject: kernel : USB sound problem
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX1+olftphZTix5al0wSlXbfcHWbtW+NeH1eeT2c+TcZWDPpiY
 ExoukGte0DjCLf6ohse78R7p13Ym9NLvFpEGIffmwBXOke5l55WVwcidIl7F
 Q==
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1.] One line summary of the problem:    logitech headset doesn't work
[2.] Full description of the problem/report: The logitech headset doen't work :
- system hangs
- no sound, no microphone
- message log :
-----------------------  snip ----------------------------
Sep 24 09:20:57 fedora kernel: INFO: task khubd:32 blocked for more than 120 seconds.
Sep 24 09:20:57 fedora kernel: "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Sep 24 09:20:57 fedora kernel: khubd         D ffff88023f2bdbe0     0    32      2
Sep 24 09:20:57 fedora kernel: ffff88023f2bdbb0 0000000000000046 ffff88023f2bdb32 fffffff00c489635
Sep 24 09:20:57 fedora kernel: ffff88023f2bdb70 000000000c489635 ffff880186cd9098 ffff880185899400
Sep 24 09:20:57 fedora kernel: ffff88023f2b4998 000000000000e2e8 ffff88023f2b4998 0000000000012cc0
Sep 24 09:20:57 fedora kernel: Call Trace:
Sep 24 09:20:57 fedora kernel: [<ffffffff814965ee>] schedule+0x21/0x49
Sep 24 09:20:57 fedora kernel: [<ffffffff8135265f>] usb_kill_urb+0xc2/0xf4
Sep 24 09:20:57 fedora kernel: [<ffffffff81070b57>] ? autoremove_wake_function+0x0/0x5f
Sep 24 09:20:57 fedora kernel: [<ffffffff81350ab4>] usb_hcd_flush_endpoint+0x139/0x1e2
Sep 24 09:20:57 fedora kernel: [<ffffffff813535da>] usb_disable_endpoint+0x6e/0x9d
Sep 24 09:20:57 fedora kernel: [<ffffffff81353664>] usb_disable_device+0x5b/0x1fb
Sep 24 09:20:57 fedora kernel: [<ffffffff8134cf9d>] usb_disconnect+0xfc/0x1cc
Sep 24 09:20:57 fedora kernel: [<ffffffff8134e8f6>] hub_events+0x61f/0x1184
Sep 24 09:20:57 fedora kernel: [<ffffffff81496557>] ? thread_return+0x4e/0xc4
Sep 24 09:20:57 fedora kernel: [<ffffffff8134f4a1>] hub_thread+0x46/0x1d1
Sep 24 09:20:57 fedora kernel: [<ffffffff81070b57>] ? autoremove_wake_function+0x0/0x5f
Sep 24 09:20:57 fedora kernel: [<ffffffff8134f45b>] ? hub_thread+0x0/0x1d1
Sep 24 09:20:57 fedora kernel: [<ffffffff81070665>] kthread+0x6d/0xae
Sep 24 09:20:57 fedora kernel: [<ffffffff8101313a>] child_rip+0xa/0x20
Sep 24 09:20:57 fedora kernel: [<ffffffff81012afd>] ? restore_args+0x0/0x30
Sep 24 09:20:57 fedora kernel: [<ffffffff810705f8>] ? kthread+0x0/0xae
Sep 24 09:20:57 fedora kernel: [<ffffffff81013130>] ? child_rip+0x0/0x20
Sep 24 09:24:51 fedora kernel: ALSA sound/usb/usbaudio.c:1335: 2:1:1: usb_set_interface failed
Sep 24 09:24:51 fedora kernel: ALSA sound/usb/usbaudio.c:1335: 2:1:1: usb_set_interface failed

-----------------------  snip ----------------------------

[3.] Keywords (i.e., modules, networking, kernel): usb, sound logitech

[4.] Kernel version (from /proc/version): Linux version 2.6.30.5-43.fc11.x86_64 (mockbuild@xenbuilder4.fedora.phx.redhat.com) (gcc version 4.4.1 20090725 (Red Hat 4.4.1-2) (GCC) ) #1 SMP Thu Aug 27 21:
39:52 EDT 2009

[5.] Output of Oops.. message (if applicable) with symbolic information 
     resolved (see Documentation/oops-tracing.txt) : not seen

[6.] A small shell script or example program which triggers the
     problem (if possible)

[7.] Environment
[7.1.] Software (add the output of the ver_linux script here) : no such script avaible

[7.2.] Processor information (from /proc/cpuinfo):
-----------------------  cpuinfo ----------------------------
processor	: 2
vendor_id	: AuthenticAMD
cpu family	: 16
model		: 4
model name	: AMD Phenom(tm) II X3 720 Processor
stepping	: 2
cpu MHz		: 2800.290
cache size	: 512 KB
physical id	: 0
siblings	: 3
core id		: 2
cpu cores	: 3
apicid		: 2
initial apicid	: 2
fpu		: yes
fpu_exception	: yes
cpuid level	: 5
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm
 3dnowext 3dnow constant_tsc rep_good nonstop_tsc extd_apicid pni monitor cx16 lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch os
vw ibs skinit wdt
bogomips	: 5599.98
TLB size	: 1024 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 48 bits physical, 48 bits virtual
power management: ts ttp tm stc 100mhzsteps hwpstate

-----------------------  cpuinfo ----------------------------

[7.3.] Module information (from /proc/modules):

-----------------------  modules ----------------------------
fuse 64448 2 - Live 0xffffffffa0e06000
nfsd 298192 9 - Live 0xffffffffa0dbb000
lockd 78708 1 nfsd, Live 0xffffffffa0da2000
nfs_acl 3328 1 nfsd, Live 0xffffffffa0d9f000
auth_rpcgss 44992 1 nfsd, Live 0xffffffffa0d8f000
exportfs 4672 1 nfsd, Live 0xffffffffa0d8b000
bridge 61280 0 - Live 0xffffffffa0d77000
stp 2836 1 bridge, Live 0xffffffffa0d74000
llc 6816 2 bridge,stp, Live 0xffffffffa0d6d000
bnep 20320 2 - Live 0xffffffffa0d63000
sco 21220 2 - Live 0xffffffffa0d58000
l2cap 40992 3 bnep, Live 0xffffffffa0d48000
bluetooth 99028 5 bnep,sco,l2cap, Live 0xffffffffa0d2a000
sunrpc 207352 11 nfsd,lockd,nfs_acl,auth_rpcgss, Live 0xffffffffa0cf2000
vmnet 48684 13 - Live 0xffffffffa0ce4000
ppdev 8456 0 - Live 0xffffffffa0cdc000
parport_pc 28968 0 - Live 0xffffffffa0ccf000
parport 36640 2 ppdev,parport_pc, Live 0xffffffffa0cc1000
vmblock 16704 1 - Live 0xffffffffa0cba000
vmci 56600 1 - Live 0xffffffffa0caa000
vmmon 77376 9 - Live 0xffffffffa0c95000
ipt_MASQUERADE 4112 1 - Live 0xffffffffa0c8e000
iptable_nat 8016 1 - Live 0xffffffffa0c87000
nf_nat 23716 2 ipt_MASQUERADE,iptable_nat, Live 0xffffffffa0c7c000
nf_conntrack_netbios_ns 2928 0 - Live 0xffffffffa0c76000
nf_conntrack_ftp 14456 0 - Live 0xffffffffa0c6d000
ip6t_REJECT 5968 2 - Live 0xffffffffa0c66000
nf_conntrack_ipv6 23384 12 - Live 0xffffffffa0c5e000
ip6table_filter 4208 1 - Live 0xffffffffa0162000
ip6_tables 20576 1 ip6table_filter, Live 0xffffffffa0c56000
ipv6 322280 38 ip6t_REJECT,nf_conntrack_ipv6, Live 0xffffffffa0c05000
dm_multipath 18152 0 - Live 0xffffffffa0bf7000
uinput 9856 0 - Live 0xffffffffa00d6000
nvidia 10312376 20 - Live 0xffffffffa021f000 (P)
snd_hda_codec_nvhdmi 4096 1 - Live 0xffffffffa00ca000
snd_hda_codec_realtek 281476 1 - Live 0xffffffffa01d8000
asus_atk0110 13056 0 - Live 0xffffffffa01d2000
snd_hda_intel 30488 3 - Live 0xffffffffa01c8000
snd_hda_codec 78608 3 snd_hda_codec_nvhdmi,snd_hda_codec_realtek,snd_hda_intel, Live 0xffffffffa01b2000
hwmon 3464 1 asus_atk0110, Live 0xffffffffa0108000
shpchp 36940 0 - Live 0xffffffffa01a6000
pcspkr 3152 0 - Live 0xffffffffa00de000
forcedeth 58252 0 - Live 0xffffffffa0195000
i2c_nforce2 9416 0 - Live 0xffffffffa00d1000
snd_usb_audio 100176 0 - Live 0xffffffffa017a000
firewire_ohci 24980 0 - Live 0xffffffffa016e000
pata_amd 15124 0 - Live 0xffffffffa0165000
firewire_core 51476 1 firewire_ohci, Live 0xffffffffa0153000
snd_usb_lib 19504 1 snd_usb_audio, Live 0xffffffffa014c000
wmi 7744 0 - Live 0xffffffffa0145000
snd_rawmidi 25792 1 snd_usb_lib, Live 0xffffffffa0139000
snd_seq_device 8308 1 snd_rawmidi, Live 0xffffffffa0131000
snd_pcm 88440 4 snd_hda_intel,snd_hda_codec,snd_usb_audio, Live 0xffffffffa0116000
snd_timer 24224 1 snd_pcm, Live 0xffffffffa010b000
snd_hwdep 9736 2 snd_hda_codec,snd_usb_audio, Live 0xffffffffa0103000
snd 73016 15 snd_hda_codec_realtek,snd_hda_intel,snd_hda_codec,snd_usb_audio,snd_usb_lib,snd_rawmidi,snd_seq_device,snd_pcm,snd_timer,snd_hwdep, Live 0xfffffff
fa00ec000
snd_page_alloc 10064 2 snd_hda_intel,snd_pcm, Live 0xffffffffa00e4000
crc_itu_t 2128 1 firewire_core, Live 0xffffffffa00e1000
soundcore 7584 1 snd, Live 0xffffffffa00da000
ata_generic 6004 0 - Live 0xffffffffa00cd000
pata_acpi 5520 0 - Live 0xffffffffa000b000
nouveau 494608 0 - Live 0xffffffffa004f000
drm 228580 1 nouveau, Live 0xffffffffa0012000
i2c_algo_bit 6612 1 nouveau, Live 0xffffffffa000e000
i2c_core 33504 5 nvidia,i2c_nforce2,nouveau,drm,i2c_algo_bit, Live 0xffffffffa0000000

-----------------------  modules ----------------------------

[7.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)

----------------------- iomem ----------------------
00000000-0000ffff : reserved
00010000-0009efff : System RAM
0009f000-0009ffff : reserved
000cd200-000cffff : pnp 00:0b
000f0000-000fffff : reserved
00100000-afedffff : System RAM
  00200000-0069fbd2 : Kernel code
  0069fbd3-0090faaf : Kernel data
  00aa9000-00bd0f5f : Kernel bss
  20000000-23ffffff : GART
afee0000-afee2fff : ACPI Non-volatile Storage
afee3000-afeeffff : ACPI Tables
afef0000-afefffff : reserved
b0000000-bfffffff : reserved
  b0000000-bfffffff : pnp 00:01
d8000000-e7ffffff : PCI Bus 0000:02
  d8000000-dfffffff : 0000:02:00.0
  e0000000-e001ffff : 0000:02:00.0
  e6000000-e7ffffff : 0000:02:00.0
f0000000-f3ffffff : PCI MMCONFIG 0 [00-3f]
  f0000000-f3ffffff : reserved
    f0000000-f3ffffff : pnp 00:0a
fb000000-fcffffff : PCI Bus 0000:02
  fb000000-fbffffff : 0000:02:00.0
    fb000000-fbffffff : nvidia
fd500000-fd5fffff : PCI Bus 0000:06
fd600000-fd6fffff : PCI Bus 0000:06
fd700000-fd7fffff : PCI Bus 0000:05
fd800000-fd8fffff : PCI Bus 0000:05
fd900000-fd9fffff : PCI Bus 0000:04
fda00000-fdafffff : PCI Bus 0000:04
fdb00000-fdbfffff : PCI Bus 0000:03
fdc00000-fdcfffff : PCI Bus 0000:03
fdd00000-fddfffff : PCI Bus 0000:01
fde00000-fdefffff : PCI Bus 0000:01
  fdeff000-fdefffff : 0000:01:0a.0
    fdeff000-fdefffff : firewire_ohci
fdf80000-fdffffff : 0000:00:01.3
fe020000-fe023fff : 0000:00:07.0
  fe020000-fe023fff : ICH HD audio
fe026000-fe027fff : 0000:00:09.0
  fe026000-fe027fff : ahci
fe029000-fe02900f : 0000:00:0a.0
  fe029000-fe02900f : forcedeth
fe02a000-fe02a0ff : 0000:00:0a.0
  fe02a000-fe02a0ff : forcedeth
fe02b000-fe02bfff : 0000:00:0a.0
  fe02b000-fe02bfff : forcedeth
fe02c000-fe02c0ff : 0000:00:04.1
  fe02c000-fe02c0ff : ehci_hcd
fe02d000-fe02dfff : 0000:00:04.0
  fe02d000-fe02dfff : ohci_hcd
fe02e000-fe02e0ff : 0000:00:02.1
  fe02e000-fe02e0ff : ehci_hcd
fe02f000-fe02ffff : 0000:00:02.0
  fe02f000-fe02ffff : ohci_hcd
fec00000-ffffffff : reserved
  fec00000-fec00fff : IOAPIC 0
  fee00000-feefffff : pnp 00:0b
    fee00000-fee00fff : Local APIC
  fefe1000-fefe10ff : pnp 00:01
  feff0000-feff03ff : HPET 0
    feff0000-feff00ff : pnp 00:0b
  fefff000-feffffff : pnp 00:0b
  fff80000-fff80fff : pnp 00:0b
  fff90000-fffbffff : pnp 00:0b
  fffed000-fffeffff : pnp 00:0b
  ffff0000-ffffffff : pnp 00:0b
100000000-23fffffff : System RAM

----------------------- iomem ----------------------

[7.5.] PCI information ('lspci -vvv' as root)
----------------------- lspci ----------------------

00:00.0 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Capabilities: [94] HyperTransport: #1a
	Capabilities: [60] HyperTransport: Retry Mode
	Capabilities: [44] HyperTransport: Slave or Primary Interface
		Command: BaseUnitID=0 UnitCnt=0 MastHost- DefDir- DUL-
		Link Control 0: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 0: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Link Control 1: CFlE- CST- CFE- <LkFail+ Init- EOC+ TXO+ <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config 1: MLWI=8bit DwFcIn- MLWO=8bit DwFcOut- LWI=8bit DwFcInEn- LWO=8bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency 0: [b]
		Link Error 0: <Prot+ <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 0: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA- UIDRD+
		Link Frequency 1: 200MHz
		Link Error 1: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability 1: 200MHz- 300MHz- 400MHz- 500MHz- 600MHz- 800MHz- 1.0GHz- 1.2GHz- 1.4GHz- 1.6GHz- Vend-
		Error Handling: PFlE- OFlE- PFE- OFE- EOCFE- RFE- CRCFE- SERRFE- CF- RE- PNFE- ONFE- EOCNFE- RNFE- CRCNFE- SERRNFE-
		Prefetchable memory behind bridge Upper: 00-00
		Bus Number: 00
	Capabilities: [d0] HyperTransport: #1c

00:01.0 ISA bridge: nVidia Corporation MCP78S [GeForce 8200] LPC Bridge (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0

00:01.1 SMBus: nVidia Corporation MCP78S [GeForce 8200] SMBus (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Interrupt: pin A routed to IRQ 10
	Region 0: I/O ports at ff00 [size=64]
	Region 4: I/O ports at 1c00 [size=64]
	Region 5: I/O ports at 1c40 [size=64]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: nForce2_smbus
	Kernel modules: i2c-nforce2

00:01.2 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:01.3 Co-processor: nVidia Corporation MCP78S [GeForce 8200] Co-Processor (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 7
	Region 0: Memory at fdf80000 (32-bit, non-prefetchable) [size=512K]

00:01.4 RAM memory: nVidia Corporation MCP78S [GeForce 8200] Memory Controller (rev a1)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:02.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1 Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fe02f000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:02.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0 Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 22
	Region 0: Memory at fe02e000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ehci_hcd

00:04.0 USB Controller: nVidia Corporation MCP78S [GeForce 8200] OHCI USB 1.1 Controller (rev a1) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 23
	Region 0: Memory at fe02d000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: ohci_hcd

00:04.1 USB Controller: nVidia Corporation MCP78S [GeForce 8200] EHCI USB 2.0 Controller (rev a1) (prog-if 20 [EHCI])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin B routed to IRQ 21
	Region 0: Memory at fe02c000 (32-bit, non-prefetchable) [size=256]
	Capabilities: [44] Debug port: BAR=1 offset=00a0
	Capabilities: [80] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: ehci_hcd

00:06.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] IDE (rev a1) (prog-if 8a [Master SecP PriP])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Region 0: [virtual] Memory at 000001f0 (32-bit, non-prefetchable) [size=8]
	Region 1: [virtual] Memory at 000003f0 (type 3, non-prefetchable) [size=1]
	Region 2: [virtual] Memory at 00000170 (32-bit, non-prefetchable) [size=8]
	Region 3: [virtual] Memory at 00000370 (type 3, non-prefetchable) [size=1]
	Region 4: I/O ports at fc00 [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Kernel driver in use: pata_amd
	Kernel modules: ata_generic, pata_acpi, pata_amd

00:07.0 Audio device: nVidia Corporation MCP72XE/MCP72P/MCP78U/MCP78S High Definition Audio (rev a1)
	Subsystem: ASUSTeK Computer Inc. M3N72-D
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (500ns min, 1250ns max)
	Interrupt: pin A routed to IRQ 20
	Region 0: Memory at fe020000 (32-bit, non-prefetchable) [size=16K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
		Address: 0000000000000000  Data: 0000
		Masking: 00000000  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: HDA Intel
	Kernel modules: snd-hda-intel

00:08.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1) (prog-if 01 [Subtractive decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
	I/O behind bridge: 0000e000-0000efff
	Memory behind bridge: fde00000-fdefffff
	Prefetchable memory behind bridge: fdd00000-fddfffff
	Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr+ DiscTmrStat- DiscTmrSERREn-
	Capabilities: [b8] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [8c] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000

00:09.0 IDE interface: nVidia Corporation MCP78S [GeForce 8200] SATA Controller (non-AHCI mode) (rev a2) (prog-if 85 [Master SecO PriO])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (750ns min, 250ns max)
	Interrupt: pin A routed to IRQ 28
	Region 0: I/O ports at 09f0 [size=8]
	Region 1: I/O ports at 0bf0 [size=4]
	Region 2: I/O ports at 0970 [size=8]
	Region 3: I/O ports at 0b70 [size=4]
	Region 4: I/O ports at f700 [size=16]
	Region 5: Memory at fe026000 (32-bit, non-prefetchable) [size=8K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [8c] SATA HBA <?>
	Capabilities: [b0] MSI: Enable+ Count=1/8 Maskable- 64bit+
		Address: 00000000fee0100c  Data: 4179
	Capabilities: [ec] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: ahci
	Kernel modules: ata_generic, pata_acpi

00:0a.0 Ethernet controller: nVidia Corporation MCP77 Ethernet (rev a2)
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0 (250ns min, 5000ns max)
	Interrupt: pin A routed to IRQ 29
	Region 0: Memory at fe02b000 (32-bit, non-prefetchable) [size=4K]
	Region 1: I/O ports at f600 [size=8]
	Region 2: Memory at fe02a000 (32-bit, non-prefetchable) [size=256]
	Region 3: Memory at fe029000 (32-bit, non-prefetchable) [size=16]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable+ DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/16 Maskable+ 64bit+
		Address: 00000000fee0200c  Data: 41a1
		Masking: 0000fffe  Pending: 00000000
	Capabilities: [6c] HyperTransport: MSI Mapping Enable+ Fixed+
	Kernel driver in use: forcedeth
	Kernel modules: forcedeth

00:0b.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
	I/O behind bridge: 0000d000-0000dfff
	Memory behind bridge: fb000000-fcffffff
	Prefetchable memory behind bridge: 00000000d8000000-00000000e7ffffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [48] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Kernel modules: shpchp

00:10.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
	I/O behind bridge: 0000c000-0000cfff
	Memory behind bridge: fdc00000-fdcfffff
	Prefetchable memory behind bridge: 00000000fdb00000-00000000fdbfffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0700c  Data: 4151
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v2) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #0, Speed 2.5GT/s, Width x16, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot+
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x16, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  1, PowerLimit 75.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
		DevCap2: Completion Timeout: Range AB, TimeoutDis+ ARIFwd-
		DevCtl2: Completion Timeout: 65ms to 210ms, TimeoutDis- ARIFwd-
		LnkCtl2: Target Link Speed: 2.5GT/s, EnterCompliance- SpeedDis-, Selectable De-emphasis: -6dB
			 Transmit Margin: Normal Operating Range, EnterModifiedCompliance- ComplianceSOS-
			 Compliance De-emphasis: -6dB
		LnkSta2: Current De-emphasis Level: -3.5dB
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:12.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Express Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=04, subordinate=04, sec-latency=0
	I/O behind bridge: 0000b000-0000bfff
	Memory behind bridge: fda00000-fdafffff
	Prefetchable memory behind bridge: 00000000fd900000-00000000fd9fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0700c  Data: 4159
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #2, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x4, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  3, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:13.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=05, subordinate=05, sec-latency=0
	I/O behind bridge: 0000a000-0000afff
	Memory behind bridge: fd800000-fd8fffff
	Prefetchable memory behind bridge: 00000000fd700000-00000000fd7fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0700c  Data: 4161
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 256 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #3, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  4, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:14.0 PCI bridge: nVidia Corporation MCP78S [GeForce 8200] PCI Bridge (rev a1) (prog-if 00 [Normal decode])
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0, Cache Line Size: 32 bytes
	Bus: primary=00, secondary=06, subordinate=06, sec-latency=0
	I/O behind bridge: 00009000-00009fff
	Memory behind bridge: fd600000-fd6fffff
	Prefetchable memory behind bridge: 00000000fd500000-00000000fd5fffff
	Secondary status: 66MHz- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- <SERR- <PERR-
	BridgeCtl: Parity- SERR- NoISA+ VGA- MAbort- >Reset- FastB2B-
		PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
	Capabilities: [40] Subsystem: ASUSTeK Computer Inc. Device 82e2
	Capabilities: [48] Power Management version 3
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold+)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [50] MSI: Enable+ Count=1/2 Maskable- 64bit+
		Address: 00000000fee0700c  Data: 4169
	Capabilities: [60] HyperTransport: MSI Mapping Enable+ Fixed-
		Mapping Address Base: 00000000fee00000
	Capabilities: [80] Express (v1) Root Port (Slot+), MSI 00
		DevCap:	MaxPayload 256 bytes, PhantFunc 0, Latency L0s <64ns, L1 <1us
			ExtTag+ RBE+ FLReset-
		DevCtl:	Report errors: Correctable- Non-Fatal- Fatal- Unsupported-
			RlxdOrd+ ExtTag- PhantFunc- AuxPwr- NoSnoop+
			MaxPayload 128 bytes, MaxReadReq 512 bytes
		DevSta:	CorrErr- UncorrErr- FatalErr- UnsuppReq- AuxPwr- TransPend-
		LnkCap:	Port #4, Speed 2.5GT/s, Width x1, ASPM L0s L1, Latency L0 <512ns, L1 <4us
			ClockPM- Surprise- LLActRep+ BwNot-
		LnkCtl:	ASPM Disabled; RCB 64 bytes Disabled- Retrain- CommClk-
			ExtSynch- ClockPM- AutWidDis- BWInt- AutBWInt-
		LnkSta:	Speed 2.5GT/s, Width x1, TrErr- Train- SlotClk+ DLActive- BWMgmt- ABWMgmt-
		SltCap:	AttnBtn- PwrCtrl- MRL- AttnInd- PwrInd- HotPlug- Surpise-
			Slot #  5, PowerLimit 10.000000; Interlock- NoCompl-
		SltCtl:	Enable: AttnBtn- PwrFlt- MRL- PresDet- CmdCplt- HPIrq- LinkChg-
			Control: AttnInd Off, PwrInd On, Power- Interlock-
		SltSta:	Status: AttnBtn- PowerFlt- MRL- CmdCplt- PresDet- Interlock-
			Changed: MRL- PresDet- LinkState-
		RootCtl: ErrCorrectable- ErrNon-Fatal- ErrFatal- PMEIntEna- CRSVisible-
		RootCap: CRSVisible-
		RootSta: PME ReqID 0000, PMEStatus- PMEPending-
	Kernel driver in use: pcieport-driver
	Kernel modules: shpchp

00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] HyperTransport Configuration
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [80] HyperTransport: Host or Secondary Interface
		Command: WarmRst+ DblEnd- DevNum=0 ChainSide- HostHide+ Slave- <EOCErr- DUL-
		Link Control: CFlE- CST- CFE- <LkFail- Init+ EOC- TXO- <CRCErr=0 IsocEn- LSEn- ExtCTL- 64b-
		Link Config: MLWI=16bit DwFcIn- MLWO=16bit DwFcOut- LWI=16bit DwFcInEn- LWO=16bit DwFcOutEn-
		Revision ID: 3.00
		Link Frequency: [b]
		Link Error: <Prot- <Ovfl- <EOC- CTLTm-
		Link Frequency Capability: 200MHz+ 300MHz- 400MHz+ 500MHz- 600MHz+ 800MHz+ 1.0GHz+ 1.2GHz+ 1.4GHz- 1.6GHz- Vend-
		Feature Capability: IsocFC+ LDTSTOP+ CRCTM- ECTLT- 64bA+ UIDRD- ExtRS- UCnfE-

00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Address Map
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] DRAM Controller
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Miscellaneous Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Capabilities: [f0] Secure device <?>

00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 10h [Opteron, Athlon64, Sempron] Link Control
	Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-

01:0a.0 FireWire (IEEE 1394): Agere Systems FW322/323 (rev 70) (prog-if 10 [OHCI])
	Subsystem: ASUSTeK Computer Inc. IEEE 1394a Firewire Controller
	Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 32 (3000ns min, 6000ns max), Cache Line Size: 32 bytes
	Interrupt: pin A routed to IRQ 19
	Region 0: Memory at fdeff000 (32-bit, non-prefetchable) [size=4K]
	Capabilities: [44] Power Management version 2
		Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA PME(D0+,D1+,D2+,D3hot+,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME+
	Kernel driver in use: firewire_ohci
	Kernel modules: firewire-ohci

02:00.0 VGA compatible controller: nVidia Corporation GeForce 8300 (rev a2) (prog-if 00 [VGA controller])
	Subsystem: ASUSTeK Computer Inc. Device 82e2
	Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx-
	Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
	Latency: 0
	Interrupt: pin A routed to IRQ 22
	Region 0: Memory at fb000000 (32-bit, non-prefetchable) [size=16M]
	Region 1: Memory at d8000000 (64-bit, prefetchable) [size=128M]
	Region 3: Memory at e6000000 (64-bit, prefetchable) [size=32M]
	Region 5: I/O ports at dc00 [size=128]
	[virtual] Expansion ROM at e0000000 [disabled] [size=128K]
	Capabilities: [60] Power Management version 2
		Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
		Status: D0 NoSoftRst- PME-Enable- DSel=0 DScale=0 PME-
	Capabilities: [68] MSI: Enable- Count=1/1 Maskable- 64bit+
		Address: 0000000000000000  Data: 0000
	Kernel driver in use: nvidia
	Kernel modules: nvidia, nouveau, nvidiafb

----------------------- lspci ----------------------

[7.6.] SCSI information (from /proc/scsi/scsi)

----------------------- scsi ----------------------
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: ATA      Model: WDC WD10EADS-00L Rev: 01.0
  Type:   Direct-Access                    ANSI  SCSI revision: 05
Host: scsi2 Channel: 00 Id: 00 Lun: 00
  Vendor: HL-DT-ST Model: DVD-RAM GH22LS30 Rev: 1.01
  Type:   CD-ROM                           ANSI  SCSI revision: 05
----------------------- scsi ----------------------

[7.7.] Other information that might be relevant to the problem
       (please look in /proc and include all information that you
       think to be relevant):
[X.] Other notes, patches, fixes, workarounds:



Best Regards
Clemens

________________________________________________________________
Neu: WEB.DE Doppel-FLAT mit Internet-Flatrate + Telefon-Flatrate
für nur 19,99 Euro/mtl.!* http://produkte.web.de/go/02/

