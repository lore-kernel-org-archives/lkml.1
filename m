Return-Path: <linux-kernel-owner+w=401wt.eu-S1752573AbZHISCy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbZHISCy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 14:02:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751972AbZHISCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 14:02:54 -0400
Received: from drokz.nl ([80.101.76.176]:34204 "EHLO mx.drokz.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935AbZHISCw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 14:02:52 -0400
X-Greylist: delayed 166635 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Aug 2009 14:02:51 EDT
X-Mailer: QUALCOMM Windows Eudora Version 7.1.0.9
Date: Sun, 09 Aug 2009 20:02:51 +0200
To: "John Stoffel" <john@stoffel.org>
From: Frank de Jong <frapex@xs4all.nl>
Subject: Re: PROBLEM: crash / hang with linux-2.6.30.x on PII-350 SMP
  system
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <19068.35186.871460.166069@stoffel.org>
References: <20090807194541.0F0D11D27F20@mx.drokz.nl>
 <19068.35186.871460.166069@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Message-Id: <20090809180251.F1C8C1D27F20@mx.drokz.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Our problem is related to: "2.6.30.1-4 kernels freezes dual pentium-3 
system" (http://marc.info/?t=124928942600006&r=1&w=2)
This email is to relate those two problems.

I have seen reports of a "clocksource unstable" message before the 
system crashes / hangs. I changed the default clocksource from tsc to 
jiffies, but the system still crashes / hangs.

Good to know: I see these "clocksource unstable" messages because I 
have my syslog-ng sending messages to /dev/tty12

Regards,
Frank de Jong

At 22:07 7-8-2009, John Stoffel wrote:
> >>>>> "Frank" == Frank de Jong <frapex@xs4all.nl> writes:
>
>Frank> Bug report follows.
>
>Oh good, I'm not the only one!  I've been seeing random hangs on my
>main file/backup server (Dual PIII Xeon, 550Mhz) as well when trying
>to run greater than 2.6.29.  I haven't had the time to test this since
>it's so random the lockups, and my wife depends on her files being
>available too.
>
>I'll see what I can do this weekend, testing 2.6.31-rc5 and whether it
>crashes or not.
>
>Frank> [1.] One line summary of the problem:
>Frank> Crash / hang with linux-2.6.30.x on PII SMP system (PREEMPT)
>
>Frank> [2.] Full description of the problem/report:
>Frank> Crash / hang with linux-2.6.30.x on PII SMP system (PREEMPT).
>Frank> First occured in linux-2.6.30-rc1 (probably, rc1(?) & rc2 do 
>OOPS on SMP)
>Frank> Still exists in linux-2.6.30.2, linux-2.6.30.3, linux-2.6.30.4.
>
>Frank> TRIED:
>Frank> - linux-2.6.29.6 (result: STABLE)
>
>Frank> - linux-2.6.30   (result: CRASH)
>Frank> - linux-2.6.30.3 (result: CRASH)
>Frank> - linux-2.6.30.4 (result: CRASH)
>Frank> - linux-2.6.30.4, PREEMPT disabled (result: CRASH)
>Frank> - removed "-fno-delete-null-pointer-checks" from Makefile 
>(result: CRASH)
>Frank> - kernel optimized for processor family:
>Frank>    * Pentium-II/Celeron(pre-Coppermine) (result: CRASH)
>Frank>    * Pentium-Pro (result: CRASH)
>Frank>    * Pentium-MMX (result: CRASH)
>Frank>    * Pentium-Classic (result: CRASH)
>Frank>    * 486 (result: CRASH)
>Frank>    * 386 (result: CRASH)
>
>Frank> - linux-2.6.30-rc7 (result: CRASH)
>Frank> - linux-2.6.30-rc6 (result: CRASH)
>Frank> - linux-2.6.30-rc5 (result: CRASH)
>Frank> - linux-2.6.30-rc4 (result: CRASH)
>Frank> - linux-2.6.30-rc3 (result: CRASH)
>Frank> - linux-2.6.30-rc2 (result: OOPS@BOOT)
>Frank> - linux-2.6.30-rc1 (result: OOPS@BOOT(?))
>
>Frank> SYMPTOMS:
>Frank> - Console output freezes, cursor stops blinking, no errors, nothing;
>Frank> - Can occur at any moment (1 minute - 4 hours);
>Frank> - Completely random crash / hang;
>Frank> - Putting the machine to work gets it to crash / hang sooner.
>
>Frank> The crashing box:
>Frank> - Dual PII-350-894MB (SMP kernel, optimized for processor family:
>Frank> Pentium-II/Celeron(pre-Coppermine)
>
>Frank> Other boxes:
>Frank> - Pentium 100-128MB (kernel optimized for processor family: 
>Pentium-Classic)
>Frank> - AMD 2400XP+-1GB (kernel optimized for processor family: 
>Athlon/Duron/K7)
>
>Frank> The systems above (other boxes) do not seem to have any problems.
>Frank> Please note that all boxes run the same distribution and use the same
>Frank> libraries / gcc / binutils.
>Frank> It only occurs on the system described running a 
>linux-2.6.30.x SMP kernel.
>
>Frank> As I have no idea why this bug is happening, I suppose it will be
>Frank> hard to solve.
>Frank> The Changelog from linux-2.6.29.6 -> linux-2.6.30-rc1 is very big, I
>Frank> have no idea where to begin.
>Frank> Anyone?
>
>
>Frank> [3.] Keywords (i.e., modules, networking, kernel):
>Frank> linux-2.6.30, SMP
>
>
>Frank> [4.] Kernel information
>Frank> Linux helium 2.6.30.4 #1 SMP PREEMPT Sat Aug 1 13:38:28 CEST 2009
>Frank> i686 pentium2 i386 GNU/Linux
>
>
>Frank> [5.] Most recent kernel version which did not have the bug:
>Frank> linux-2.6.29.6
>
>
>Frank> [6.] Output of Oops.. message (if applicable) with symbolic
>Frank> information resolved (see Documentation/oops-tracing.txt)
>Frank> N/A
>
>
>Frank> [7.] A small shell script or example program which triggers the
>Frank> problem (if possible)
>Frank> N/A
>
>
>Frank> [8.] Environment
>Frank> [8.1.] Software (add the output of the ver_linux script here)
>Frank> Linux helium 2.6.30.4 #1 SMP PREEMPT Fri Jul 31 19:36:55 CEST 2009
>Frank> i686 pentium2 i386 GNU/Linux
>
>Frank> Gnu C                  4.3.3
>Frank> Gnu make               3.81
>Frank> binutils               2.19
>Frank> util-linux             2.14.1
>Frank> mount                  support
>Frank> module-init-tools      3.5
>Frank> e2fsprogs              1.41.4
>Frank> xfsprogs               3.0.0
>Frank> PPP                    2.4.4
>Frank> Linux C Library        2.8
>Frank> Dynamic linker (ldd)   2.8
>Frank> Linux C++ Library      6.0.10
>Frank> Procps                 3.2.7
>Frank> Net-tools              1.60
>Frank> Kbd                    1.15
>Frank> Sh-utils               6.12
>Frank> Modules Loaded         w83781d hwmon_vid hwmon tun ne 8390p bonding
>Frank> ext2 mbcache snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device
>Frank> snd_hwdep pwc videodev v4l1_compat 3c59x mii intel_agp agpgart nfsd
>Frank> lockd auth_rpcgss sunrpc snd_pcm_oss snd_pcm snd_timer snd_page_alloc
>Frank> snd_mixer_oss snd soundcore lp parport_pc parport floppy xfs exportfs
>Frank> raid1 md_mod sg sd_mod usb_storage uhci_hcd ohci_hcd ide_gd_mod
>Frank> aic7xxx scsi_transport_spi ehci_hcd pdc202xx_new ide_pci_generic
>Frank> scsi_mod usbcore ide_core
>
>
>Frank> [8.2.] Processor information (from /proc/cpuinfo):
>Frank> processor       : 0
>Frank> vendor_id       : GenuineIntel
>Frank> cpu family      : 6
>Frank> model           : 5
>Frank> model name      : Pentium II (Deschutes)
>Frank> stepping        : 1
>Frank> cpu MHz         : 350.811
>Frank> cache size      : 512 KB
>Frank> fdiv_bug        : no
>Frank> hlt_bug         : no
>Frank> f00f_bug        : no
>Frank> coma_bug        : no
>Frank> fpu             : yes
>Frank> fpu_exception   : yes
>Frank> cpuid level     : 2
>Frank> wp              : yes
>Frank> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
>Frank> pge mca cmov pse36 mmx fxsr
>Frank> bogomips        : 701.62
>Frank> clflush size    : 32
>Frank> power management:
>
>Frank> processor       : 1
>Frank> vendor_id       : GenuineIntel
>Frank> cpu family      : 6
>Frank> model           : 5
>Frank> model name      : Pentium II (Deschutes)
>Frank> stepping        : 2
>Frank> cpu MHz         : 350.811
>Frank> cache size      : 512 KB
>Frank> fdiv_bug        : no
>Frank> hlt_bug         : no
>Frank> f00f_bug        : no
>Frank> coma_bug        : no
>Frank> fpu             : yes
>Frank> fpu_exception   : yes
>Frank> cpuid level     : 2
>Frank> wp              : yes
>Frank> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
>Frank> pge mca cmov pse36 mmx fxsr
>Frank> bogomips        : 701.66
>Frank> clflush size    : 32
>Frank> power management:
>
>
>Frank> [8.3.] Module information (from /proc/modules):
>Frank> w83781d 24760 0 - Live 0xfb699000
>Frank> hwmon_vid 2348 1 w83781d, Live 0xfb578000
>Frank> hwmon 2252 1 w83781d, Live 0xfb525000
>Frank> tun 11072 2 - Live 0xfb509000
>Frank> ne 5824 0 - Live 0xfb201000
>Frank> 8390p 8684 1 ne, Live 0xfb223000
>Frank> bonding 75832 0 - Live 0xfb684000
>Frank> ext2 47824 1 - Live 0xfb2c6000
>Frank> mbcache 6952 1 ext2, Live 0xfb17b000
>Frank> snd_usb_audio 71696 0 - Live 0xfb1da000
>Frank> snd_usb_lib 13384 1 snd_usb_audio, Live 0xfb170000
>Frank> snd_rawmidi 18444 1 snd_usb_lib, Live 0xfb162000
>Frank> snd_seq_device 6120 1 snd_rawmidi, Live 0xf90ca000
>Frank> snd_hwdep 6044 1 snd_usb_audio, Live 0xf90c3000
>Frank> pwc 74296 0 - Live 0xfb14d000
>Frank> videodev 31824 1 pwc, Live 0xf90b1000
>Frank> v4l1_compat 11216 1 videodev, Live 0xf8045000
>Frank> 3c59x 35364 0 - Live 0xf8031000
>Frank> mii 4624 1 3c59x, Live 0xf8002000
>Frank> intel_agp 22868 1 - Live 0xfb700000
>Frank> agpgart 30500 1 intel_agp, Live 0xfb6e7000
>Frank> nfsd 200928 9 - Live 0xfb6a3000
>Frank> lockd 57456 1 nfsd, Live 0xfb657000
>Frank> auth_rpcgss 32320 1 nfsd, Live 0xfb634000
>Frank> sunrpc 163576 8 nfsd,lockd,auth_rpcgss, Live 0xfb5fb000
>Frank> snd_pcm_oss 31936 0 - Live 0xfb5bb000
>Frank> snd_pcm 60892 2 snd_usb_audio,snd_pcm_oss, Live 0xfb59a000
>Frank> snd_timer 17320 1 snd_pcm, Live 0xfb57a000
>Frank> snd_page_alloc 7768 1 snd_pcm, Live 0xfb56a000
>Frank> snd_mixer_oss 12168 1 snd_pcm_oss, Live 0xfb55c000
>Frank> snd 44432 8
>Frank> 
>snd_usb_audio,snd_rawmidi,snd_seq_device,snd_hwdep,snd_pcm_oss,snd_pcm,snd_timer,snd_mixer_oss, 
>
>Frank> Live 0xfb545000
>Frank> soundcore 6296 1 snd, Live 0xfb52d000
>Frank> lp 7848 0 - Live 0xfb521000
>Frank> parport_pc 28312 1 - Live 0xfb50f000
>Frank> parport 30928 2 lp,parport_pc, Live 0xfb4f5000
>Frank> floppy 45000 0 - Live 0xfb4d8000
>Frank> xfs 414160 5 - Live 0xfb2fc000
>Frank> exportfs 3692 2 nfsd,xfs, Live 0xfb27e000
>Frank> raid1 17508 2 - Live 0xfb270000
>Frank> md_mod 72840 3 raid1, Live 0xfb250000
>Frank> sg 22016 0 - Live 0xfb227000
>Frank> sd_mod 20968 10 - Live 0xfb211000
>Frank> usb_storage 47868 1 - Live 0xfb1f3000
>Frank> uhci_hcd 18828 0 - Live 0xfb1d3000
>Frank> ohci_hcd 19492 0 - Live 0xfb1c0000
>Frank> ide_gd_mod 19652 4 - Live 0xfb1aa000
>Frank> aic7xxx 103952 5 - Live 0xfb17e000
>Frank> scsi_transport_spi 19048 1 aic7xxx, Live 0xf90f9000
>Frank> ehci_hcd 28864 0 - Live 0xf90ec000
>Frank> pdc202xx_new 4900 2 - Live 0xf8049000
>Frank> ide_pci_generic 3592 0 - Live 0xf803e000
>Frank> scsi_mod 121440 5 sg,sd_mod,usb_storage,aic7xxx,scsi_transport_spi,
>Frank> Live 0xfb12d000
>Frank> usbcore 117148 8
>Frank> snd_usb_audio,snd_usb_lib,pwc,usb_storage,uhci_hcd,ohci_hcd,ehci_hcd,
>Frank> Live 0xf90cd000
>Frank> ide_core 80928 3 ide_gd_mod,pdc202xx_new,ide_pci_generic, 
>Live 0xf801b000
>
>
>Frank> [8.4.] Loaded driver and hardware information (/proc/ioports, 
>/proc/iomem)
>Frank> 0000-001f : dma1
>Frank> 0020-0021 : pic1
>Frank> 0040-0043 : timer0
>Frank> 0050-0053 : timer1
>Frank> 0060-0060 : keyboard
>Frank> 0064-0064 : keyboard
>Frank> 0070-0077 : rtc
>Frank> 0080-008f : dma page reg
>Frank> 00a0-00a1 : pic2
>Frank> 00c0-00df : dma2
>Frank> 00f0-00ff : fpu
>Frank> 0170-0177 : 0000:00:07.1
>Frank> 01f0-01f7 : 0000:00:07.1
>Frank> 0208-020f : pnp 00:0b
>Frank> 0213-0213 : ISAPnP
>Frank> 0220-023f : ne
>Frank> 0290-0297 : w83781d
>Frank>    0295-0296 : w83781d
>Frank> 02f8-02ff : serial
>Frank> 0376-0376 : 0000:00:07.1
>Frank> 0378-037a : parport0
>Frank> 037b-037f : parport0
>Frank> 03c0-03df : vga+
>Frank> 03f2-03f2 : floppy
>Frank> 03f4-03f5 : floppy
>Frank> 03f6-03f6 : 0000:00:07.1
>Frank> 03f7-03f7 : floppy
>Frank> 03f8-03ff : serial
>Frank> 0778-077a : parport0
>Frank> 0a79-0a79 : isapnp write
>Frank> 0cf8-0cff : PCI conf1
>Frank> 4000-403f : 0000:00:07.3
>Frank> 5000-500f : 0000:00:07.3
>Frank> c000-c01f : 0000:00:07.2
>Frank>    c000-c01f : uhci_hcd
>Frank> c400-c4ff : 0000:00:0b.0
>Frank> c800-c87f : 0000:00:11.0
>Frank> cc00-cc7f : 0000:00:12.0
>Frank> d000-d007 : 0000:00:13.0
>Frank>    d000-d007 : pdc202xx_new
>Frank> d400-d403 : 0000:00:13.0
>Frank>    d400-d403 : pdc202xx_new
>Frank> d800-d807 : 0000:00:13.0
>Frank>    d800-d807 : pdc202xx_new
>Frank> dc00-dc03 : 0000:00:13.0
>Frank>    dc00-dc03 : pdc202xx_new
>Frank> e000-e00f : 0000:00:13.0
>Frank>    e000-e00f : pdc202xx_new
>Frank> f000-f00f : 0000:00:07.1
>Frank> 00000000-0009ffff : System RAM
>Frank> 000a0000-000bffff : Video RAM area
>Frank> 000c0000-000cbbff : Video ROM
>Frank> 000cc000-000d17ff : Adapter ROM
>Frank> 000d2000-000d27ff : Adapter ROM
>Frank> 000d3000-000d37ff : Adapter ROM
>Frank> 000d4000-000d67ff : Adapter ROM
>Frank> 000d6800-000d7fff : pnp 00:08
>Frank> 000f0000-000fffff : reserved
>Frank>    000f0000-000fffff : System ROM
>Frank> 00100000-37ffffff : System RAM
>Frank>    00100000-002a97bc : Kernel code
>Frank>    002a97bd-0036d02f : Kernel data
>Frank>    003b3000-003de2cf : Kernel bss
>Frank> 40000000-4001ffff : 0000:00:11.0
>Frank> 40020000-4003ffff : 0000:00:12.0
>Frank> 40040000-4004ffff : 0000:00:0b.0
>Frank> 40050000-40053fff : 0000:00:13.0
>Frank> d0000000-d7ffffff : PCI Bus 0000:01
>Frank>    d0000000-d7ffffff : 0000:01:00.0
>Frank>      d0000000-d7ffffff : rivafb
>Frank> d8000000-dbffffff : 0000:00:00.0
>Frank> dc000000-ddffffff : PCI Bus 0000:01
>Frank>    dc000000-dcffffff : 0000:01:00.0
>Frank>      dc000000-dcffffff : rivafb
>Frank>    dd000000-dd00ffff : 0000:01:00.0
>Frank> df000000-df003fff : 0000:00:13.0
>Frank> df004000-df00407f : 0000:00:11.0
>Frank> df005000-df00507f : 0000:00:12.0
>Frank> df006000-df006fff : 0000:00:0b.0
>Frank>    df006000-df006fff : aic7xxx
>Frank> df007000-df007fff : 0000:00:14.0
>Frank>    df007000-df007fff : ohci_hcd
>Frank> df008000-df008fff : 0000:00:14.1
>Frank>    df008000-df008fff : ohci_hcd
>Frank> df009000-df0090ff : 0000:00:14.2
>Frank>    df009000-df0090ff : ehci_hcd
>Frank> fec00000-fec00fff : IOAPIC 0
>Frank>    fec00000-fec00fff : reserved
>Frank> fee00000-fee00fff : Local APIC
>Frank>    fee00000-fee00fff : reserved
>Frank> ffff0000-ffffffff : reserved
>
>
>Frank> [8.5.] PCI information ('lspci -vvv' as root)
>Frank> 00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX
>Frank> Host bridge (rev 03)
>Frank>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort+ >SERR- <PERR- INTx-
>Frank>          Latency: 32
>Frank>          Region 0: Memory at d8000000 (32-bit, prefetchable) [size=64M]
>Frank>          Capabilities: [a0] AGP version 1.0
>Frank>                  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA+ ITACoh-
>Frank> GART64- HTrans- 64bit- FW- AGP3- Rate=x1,x2
>Frank>                  Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
>Frank> FW- Rate=<none>
>Frank>          Kernel driver in use: agpgart-intel
>Frank>          Kernel modules: intel-agp
>
>Frank> 00:01.0 PCI bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX AGP
>Frank> bridge (rev 03) (prog-if 00 [Normal decode])
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR+ FastB2B- DisINTx-
>Frank>          Status: Cap- 66MHz+ UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 64
>Frank>          Bus: primary=00, secondary=01, subordinate=01, sec-latency=32
>Frank>          I/O behind bridge: 0000f000-00000fff
>Frank>          Memory behind bridge: dc000000-ddffffff
>Frank>          Prefetchable memory behind bridge: d0000000-d7ffffff
>Frank>          Secondary status: 66MHz+ FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
>Frank>          BridgeCtl: Parity- SERR- NoISA- VGA+ MAbort- >Reset- FastB2B+
>Frank>                  PriDiscTmr- SecDiscTmr- DiscTmrStat- DiscTmrSERREn-
>
>Frank> 00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 02)
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 0
>
>Frank> 00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev
>Frank> 01) (prog-if 80 [Master])
>Frank>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32
>Frank>          Region 0: [virtual] Memory at 000001f0 (32-bit,
>Frank> non-prefetchable) [size=8]
>Frank>          Region 1: [virtual] Memory at 000003f0 (type 3,
>Frank> non-prefetchable) [size=1]
>Frank>          Region 2: [virtual] Memory at 00000170 (32-bit,
>Frank> non-prefetchable) [size=8]
>Frank>          Region 3: [virtual] Memory at 00000370 (type 3,
>Frank> non-prefetchable) [size=1]
>Frank>          Region 4: I/O ports at f000 [size=16]
>Frank>          Kernel modules: piix
>
>Frank> 00:07.2 USB Controller: Intel Corporation 82371AB/EB/MB PIIX4 USB
>Frank> (rev 01) (prog-if 00 [UHCI])
>Frank>          Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32
>Frank>          Interrupt: pin D routed to IRQ 19
>Frank>          Region 4: I/O ports at c000 [size=32]
>Frank>          Kernel driver in use: uhci_hcd
>Frank>          Kernel modules: uhci-hcd
>
>Frank> 00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
>Frank>          Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap- 66MHz- UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Interrupt: pin ? routed to IRQ 9
>Frank>          Kernel modules: i2c-piix4
>
>Frank> 00:0b.0 SCSI storage controller: Adaptec AIC-7880U (rev 01)
>Frank>          Subsystem: Adaptec AIC-7880P Ultra/Ultra Wide SCSI Chipset
>Frank>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (2000ns min, 2000ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin A routed to IRQ 16
>Frank>          Region 0: I/O ports at c400 [disabled] [size=256]
>Frank>          Region 1: Memory at df006000 (32-bit, 
>non-prefetchable) [size=4K]
>Frank>          [virtual] Expansion ROM at 40040000 [disabled] [size=64K]
>Frank>          Capabilities: [dc] Power Management version 1
>Frank>                  Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA
>Frank> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Kernel driver in use: aic7xxx
>Frank>          Kernel modules: aic7xxx
>
>Frank> 00:11.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M 
>[Tornado] (rev 74)
>Frank>          Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink
>Frank> for PC Management NIC
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (2500ns min, 2500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin A routed to IRQ 18
>Frank>          Region 0: I/O ports at c800 [size=128]
>Frank>          Region 1: Memory at df004000 (32-bit, 
>non-prefetchable) [size=128]
>Frank>          [virtual] Expansion ROM at 40000000 [disabled] [size=128K]
>Frank>          Capabilities: [dc] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>Frank> PME(D0+,D1+,D2+,D3hot+,D3cold+)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>Frank>          Kernel driver in use: 3c59x
>Frank>          Kernel modules: 3c59x
>
>Frank> 00:12.0 Ethernet controller: 3Com Corporation 3c905C-TX/TX-M 
>[Tornado] (rev 74)
>Frank>          Subsystem: 3Com Corporation 3C905CX-TX/TX-M Fast Etherlink
>Frank> for PC Management NIC
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (2500ns min, 2500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin A routed to IRQ 17
>Frank>          Region 0: I/O ports at cc00 [size=128]
>Frank>          Region 1: Memory at df005000 (32-bit, 
>non-prefetchable) [size=128]
>Frank>          [virtual] Expansion ROM at 40020000 [disabled] [size=128K]
>Frank>          Capabilities: [dc] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>Frank> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=2 PME-
>Frank>          Kernel driver in use: 3c59x
>Frank>          Kernel modules: 3c59x
>
>Frank> 00:13.0 Mass storage controller: Promise Technology, Inc. PDC20268
>Frank> (Ultra100 TX2) (rev 02) (prog-if 85)
>Frank>          Subsystem: Promise Technology, Inc. Ultra100TX2
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz+ UDF- FastB2B- ParErr-
>Frank> DEVSEL=slow >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (1000ns min, 4500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin A routed to IRQ 16
>Frank>          Region 0: I/O ports at d000 [size=8]
>Frank>          Region 1: I/O ports at d400 [size=4]
>Frank>          Region 2: I/O ports at d800 [size=8]
>Frank>          Region 3: I/O ports at dc00 [size=4]
>Frank>          Region 4: I/O ports at e000 [size=16]
>Frank>          Region 5: Memory at df000000 (32-bit, 
>non-prefetchable) [size=16K]
>Frank>          [virtual] Expansion ROM at 40050000 [disabled] [size=16K]
>Frank>          Capabilities: [60] Power Management version 1
>Frank>                  Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA
>Frank> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Kernel driver in use: Promise_IDE
>Frank>          Kernel modules: pdc202xx_new
>
>Frank> 00:14.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 
>10 [OHCI])
>Frank>          Subsystem: Belkin Root Hub
>Frank>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (250ns min, 10500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin A routed to IRQ 19
>Frank>          Region 0: Memory at df007000 (32-bit, 
>non-prefetchable) [size=4K]
>Frank>          Capabilities: [40] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>Frank> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Kernel driver in use: ohci_hcd
>Frank>          Kernel modules: ohci-hcd
>
>Frank> 00:14.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 
>10 [OHCI])
>Frank>          Subsystem: Belkin Root Hub
>Frank>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (250ns min, 10500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin B routed to IRQ 16
>Frank>          Region 0: Memory at df008000 (32-bit, 
>non-prefetchable) [size=4K]
>Frank>          Capabilities: [40] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>Frank> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Kernel driver in use: ohci_hcd
>Frank>          Kernel modules: ohci-hcd
>
>Frank> 00:14.2 USB Controller: NEC Corporation USB 2.0 (rev 02) 
>(prog-if 20 [EHCI])
>Frank>          Subsystem: Belkin Root Hub
>Frank>          Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz- UDF- FastB2B- ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (4000ns min, 8500ns max), Cache Line 
>Size: 32 bytes
>Frank>          Interrupt: pin C routed to IRQ 17
>Frank>          Region 0: Memory at df009000 (32-bit, 
>non-prefetchable) [size=256]
>Frank>          Capabilities: [40] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
>Frank> PME(D0+,D1+,D2+,D3hot+,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Kernel driver in use: ehci_hcd
>Frank>          Kernel modules: ehci-hcd
>
>Frank> 01:00.0 VGA compatible controller: nVidia Corporation NV11GL [Quadro2
>Frank> MXR/EX/Go] (rev a1) (prog-if 00 [VGA controller])
>Frank>          Subsystem: Guillemot Corporation Device 7100
>Frank>          Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>Frank> ParErr- Stepping- SERR- FastB2B- DisINTx-
>Frank>          Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr-
>Frank> DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>Frank>          Latency: 32 (1250ns min, 250ns max)
>Frank>          Interrupt: pin A routed to IRQ 0
>Frank>          Region 0: Memory at dc000000 (32-bit, 
>non-prefetchable) [size=16M]
>Frank>          Region 1: Memory at d0000000 (32-bit, prefetchable) 
>[size=128M]
>Frank>          [virtual] Expansion ROM at dd000000 [disabled] [size=64K]
>Frank>          Capabilities: [60] Power Management version 2
>Frank>                  Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
>Frank> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>Frank>                  Status: D0 PME-Enable- DSel=0 DScale=0 PME-
>Frank>          Capabilities: [44] AGP version 2.0
>Frank>                  Status: RQ=32 Iso- ArqSz=0 Cal=0 SBA- ITACoh-
>Frank> GART64- HTrans- 64bit- FW+ AGP3- Rate=x1,x2,x4
>Frank>                  Command: RQ=1 ArqSz=0 Cal=0 SBA- AGP- GART64- 64bit-
>Frank> FW- Rate=<none>
>Frank>          Kernel driver in use: rivafb
>
>
>Frank> [8.6.] SCSI information (from /proc/scsi/scsi)
>Frank> Attached devices:
>Frank> Host: scsi0 Channel: 00 Id: 01 Lun: 00
>Frank>    Vendor: COMPAQ   Model: BF0728A4CB       Rev: HPB5
>Frank>    Type:   Direct-Access                    ANSI  SCSI revision: 03
>Frank> Host: scsi0 Channel: 00 Id: 02 Lun: 00
>Frank>    Vendor: COMPAQ   Model: BF07285A36       Rev: HPB7
>Frank>    Type:   Direct-Access                    ANSI  SCSI revision: 03
>Frank> Host: scsi0 Channel: 00 Id: 03 Lun: 00
>Frank>    Vendor: FUJITSU  Model: MAW3073NC        Rev: 0103
>Frank>    Type:   Direct-Access                    ANSI  SCSI revision: 03
>Frank> Host: scsi1 Channel: 00 Id: 00 Lun: 00
>Frank>    Vendor: Maxtor 6 Model: L300R0           Rev: BAJ4
>Frank>    Type:   Direct-Access                    ANSI  SCSI revision: 00
>
>
>Frank> [8.7.] Other information that might be relevant to the problem
>Frank> (please look in /proc and include all information that you think to
>Frank> be relevant):
>Frank> N/A
>
>
>Frank> [X.] Other notes, patches, fixes, workarounds:
>
>Frank> --
>Frank> To unsubscribe from this list: send the line "unsubscribe 
>linux-kernel" in
>Frank> the body of a message to majordomo@vger.kernel.org
>Frank> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Frank> Please read the FAQ at  http://www.tux.org/lkml/

