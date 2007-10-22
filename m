Return-Path: <linux-kernel-owner+w=401wt.eu-S1755522AbXJVTX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522AbXJVTX4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 15:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752546AbXJVTXt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 15:23:49 -0400
Received: from rrcs-24-97-168-122.nys.biz.rr.com ([24.97.168.122]:4057 "EHLO
	mx1.ittagteam.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752770AbXJVTXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 15:23:47 -0400
X-Greylist: delayed 1178 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Oct 2007 15:23:47 EDT
From: Syd Alsobrook <syd@ittagteam.com>
To: linux-kernel@vger.kernel.org
Subject: Problem: OOPS in khubd on disconnect of Labtec USB Headset
Date: Mon, 22 Oct 2007 15:03:54 -0400
User-Agent: KMail/1.8.1
Organization: IT Tag Team, Inc
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710221503.54949.syd@ittagteam.com>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (mx1.ittagteam.com [192.168.2.11]); Mon, 22 Oct 2007 15:04:05 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

OOPS in khubd on disconnect of Labtec USB Headset

Linux version 2.6.23.1 (alsobrsp@karma) (gcc version 4.1.3 20070831 
(prerelease) (Debian 4.1.2-16)) #5 SMP PREEMPT Sat Oct 20 11:53:38 EDT 2007

BUG: unable to handle kernel paging request at virtual address 00100100
 printing eip:
f89b5faa
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: snd_rtctimer dv1394 raw1394 nfsd exportfs auth_rpcgss ppdev 
lp fan ac battery autofs4 nfs lockd nfs_acl sunrpc ipv6 fuse dm_snapshot 
dm_mirror dm_mod rtc_rs5c372 rtc_rs5c348 rtc_v3020 rtc_x1205 rtc_pcf8563 
rtc_max6902 rtc_m48t86 rtc_isl1208 rtc_ds1742 rtc_ds1672 rtc_ds1553 
rtc_ds1307 rtc_cmos lm85 hwmon_vid loop sg sr_mod usblp snd_emu10k1_synth 
snd_usb_audio snd_emux_synth snd_usb_lib snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq 
snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd ohci1394 
parport_pc parport ieee1394 emu10k1_gp gameport soundcore tg3 ohci_hcd floppy 
pcspkr rtc thermal button psmouse usb_storage processor generic i2c_i801 
serio_raw iTCO_wdt piix i2c_core intel_agp agpgart shpchp pci_hotplug 
ide_disk tsdev joydev evdev
CPU:    0
EIP:    0060:[<f89b5faa>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23.1 #5)
EIP is at snd_ctl_dev_disconnect+0x4b/0x7c [snd]
eax: ef6ade70   ebx: 00100100   ecx: 00020004   edx: 0000001d
esi: f7fd6200   edi: f7fd634c   ebp: f78f1800   esp: c217de70
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 153, ti=c217c000 task=c217e790 task.ti=c217c000)
Stack: 00000000 f79ec600 f7fd6200 00000000 f89b7a88 00000213 f79ec600 f7fd6200
       f89b7cb7 00000000 f7fd6200 f8b51a20 f89b4dcc c031ad37 c0288fb9 f7f81800
       c20e8d80 f8b41631 f7fd6200 f7f81800 f7f8181c f8b51a20 f78f1800 c0289b7c
Call Trace:
 [<f89b7a88>] snd_device_disconnect+0x28/0x60 [snd]
 [<f89b7cb7>] snd_device_disconnect_all+0x19/0x3e [snd]
 [<f89b4dcc>] snd_card_disconnect+0x11b/0x13f [snd]
 [<c031ad37>] _spin_unlock_irqrestore+0xf/0x23
 [<c0288fb9>] usb_autopm_do_device+0xc7/0xd1
 [<f8b41631>] usb_audio_disconnect+0x44/0xea [snd_usb_audio]
 [<c0289b7c>] usb_unbind_interface+0x44/0x94
 [<c024fb8c>] __device_release_driver+0x71/0x8e
 [<c024ff14>] device_release_driver+0x1e/0x34
 [<c024f587>] bus_remove_device+0x6d/0x7dBUG: unable to handle kernel paging 
request at virtual address 00100100
 printing eip:
f89b5faa
*pde = 00000000
Oops: 0000 [#1]
PREEMPT SMP
Modules linked in: snd_rtctimer dv1394 raw1394 nfsd exportfs auth_rpcgss ppdev 
lp fan ac battery autofs4 nfs lockd nfs_acl sunrpc ipv6 fuse dm_snapshot 
dm_mirror dm_mod rtc_rs5c372 rtc_rs5c348 rtc_v3020 rtc_x1205 rtc_pcf8563 
rtc_max6902 rtc_m48t86 rtc_isl1208 rtc_ds1742 rtc_ds1672 rtc_ds1553 
rtc_ds1307 rtc_cmos lm85 hwmon_vid loop sg sr_mod usblp snd_emu10k1_synth 
snd_usb_audio snd_emux_synth snd_usb_lib snd_seq_virmidi snd_seq_midi_emul 
snd_emu10k1 snd_seq_dummy snd_seq_oss snd_seq_midi snd_seq_midi_event snd_seq 
snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm 
snd_seq_device snd_timer snd_page_alloc snd_util_mem snd_hwdep snd ohci1394 
parport_pc parport ieee1394 emu10k1_gp gameport soundcore tg3 ohci_hcd floppy 
pcspkr rtc thermal button psmouse usb_storage processor generic i2c_i801 
serio_raw iTCO_wdt piix i2c_core intel_agp agpgart shpchp pci_hotplug 
ide_disk tsdev joydev evdev
CPU:    0
EIP:    0060:[<f89b5faa>]    Not tainted VLI
EFLAGS: 00010246   (2.6.23.1 #5)
EIP is at snd_ctl_dev_disconnect+0x4b/0x7c [snd]
eax: ef6ade70   ebx: 00100100   ecx: 00020004   edx: 0000001d
esi: f7fd6200   edi: f7fd634c   ebp: f78f1800   esp: c217de70
ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
Process khubd (pid: 153, ti=c217c000 task=c217e790 task.ti=c217c000)
Stack: 00000000 f79ec600 f7fd6200 00000000 f89b7a88 00000213 f79ec600 f7fd6200
       f89b7cb7 00000000 f7fd6200 f8b51a20 f89b4dcc c031ad37 c0288fb9 f7f81800
       c20e8d80 f8b41631 f7fd6200 f7f81800 f7f8181c f8b51a20 f78f1800 c0289b7c
Call Trace:
 [<f89b7a88>] snd_device_disconnect+0x28/0x60 [snd]
 [<f89b7cb7>] snd_device_disconnect_all+0x19/0x3e [snd]
 [<f89b4dcc>] snd_card_disconnect+0x11b/0x13f [snd]
 [<c031ad37>] _spin_unlock_irqrestore+0xf/0x23
 [<c0288fb9>] usb_autopm_do_device+0xc7/0xd1
 [<f8b41631>] usb_audio_disconnect+0x44/0xea [snd_usb_audio]
 [<c0289b7c>] usb_unbind_interface+0x44/0x94
 [<c024fb8c>] __device_release_driver+0x71/0x8e
 [<c024ff14>] device_release_driver+0x1e/0x34
 [<c024f587>] bus_remove_device+0x6d/0x7d
 [<c024dd7d>] device_del+0x1cc/0x240
 [<c0287525>] usb_disable_device+0x5c/0xbb
 [<c0283c55>] usb_disconnect+0x83/0x11b
 [<c0284363>] hub_thread+0x388/0xa8d
 [<c0133e18>] autoremove_wake_function+0x0/0x35
 [<c0283fdb>] hub_thread+0x0/0xa8d
 [<c0133d49>] kthread+0x38/0x5f
 [<c0133d11>] kthread+0x0/0x5f
 [<c0104aa7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 18 c7 04 24 00 00 00 00 b9 01 00 00 00 ba 03 00 00 00 e8 41 68 76 c7 8d 
43 30 b9 04 00 02 00 ba 1d 00 00 00 e8 32 b2 7b c7 8b 1b <8b> 03 0f 18 00 90 
8d 86 78 01 00 00 39 c3 75 c3 89 f8 e8 6d 0f
EIP: [<f89b5faa>] snd_ctl_dev_disconnect+0x4b/0x7c [snd] SS:ESP 0068:c217de70

 [<c024dd7d>] device_del+0x1cc/0x240
 [<c0287525>] usb_disable_device+0x5c/0xbb
 [<c0283c55>] usb_disconnect+0x83/0x11b
 [<c0284363>] hub_thread+0x388/0xa8d
 [<c0133e18>] autoremove_wake_function+0x0/0x35
 [<c0283fdb>] hub_thread+0x0/0xa8d
 [<c0133d49>] kthread+0x38/0x5f
 [<c0133d11>] kthread+0x0/0x5f
 [<c0104aa7>] kernel_thread_helper+0x7/0x10
 =======================
Code: 18 c7 04 24 00 00 00 00 b9 01 00 00 00 ba 03 00 00 00 e8 41 68 76 c7 8d 
43 30 b9 04 00 02 00 ba 1d 00 00 00 e8 32 b2 7b c7 8b 1b <8b> 03 0f 18 00 90 
8d 86 78 01 00 00 39 c3 75 c3 89 f8 e8 6d 0f
EIP: [<f89b5faa>] snd_ctl_dev_disconnect+0x4b/0x7c [snd] SS:ESP 0068:c217de70

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux karma 2.6.23.1 #5 SMP PREEMPT Sat Oct 20 11:53:38 EDT 2007 i686 
GNU/Linux

Gnu C                  4.1.3
Gnu make               3.81
binutils               Binutils
util-linux             2.13
mount                  2.13
module-init-tools      3.3-pre11
e2fsprogs              1.40.2
PPP                    2.4.4
Linux C Library        6.1
Dynamic linker (ldd)   2.6.1
Procps                 3.2.7
Net-tools              1.60
Console-tools          0.2.3
Sh-utils               5.97
udev                   114
wireless-tools         29


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
  0170-0177 : ide1
01f0-01f7 : 0000:00:1f.1
  01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : 0000:00:1f.1
  0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f2-03f5 : floppy
03f6-03f6 : 0000:00:1f.1
  03f6-03f6 : ide0
03f7-03f7 : floppy DIR
03f8-03ff : serial
0400-041f : pnp 00:0c
0420-043f : pnp 00:0c
0440-045f : pnp 00:0c
0460-047f : pnp 00:0c
  0460-0461 : ACPI PM1b_CNT_BLK
04d0-04d1 : pnp 00:0b
0778-077a : parport0
0cf8-0cff : PCI conf1
1000-1fff : PCI Bus #05
  1000-101f : 0000:05:09.0
    1000-101f : EMU10K1
  1020-1027 : 0000:05:09.1
    1020-1027 : emu10k1-gp
2440-245f : 0000:00:1d.0
  2440-245f : uhci_hcd
2460-247f : 0000:00:1d.1
  2460-247f : uhci_hcd
2480-249f : 0000:00:1d.2
  2480-249f : uhci_hcd
24c0-24cf : 0000:00:1f.1
24d0-24df : 0000:00:1f.2
  24d0-24df : libata
24e0-24e7 : 0000:00:02.0
24f8-24ff : 0000:00:1f.2
  24f8-24ff : libata
2800-2807 : 0000:00:1f.2
  2800-2807 : libata
2810-2813 : 0000:00:1f.2
  2810-2813 : libata
2814-2817 : 0000:00:1f.2
  2814-2817 : libata
f800-f87f : 0000:00:1f.0
  f800-f81f : pnp 00:0c
    f800-f803 : ACPI PM1a_EVT_BLK
    f804-f805 : ACPI PM1a_CNT_BLK
    f808-f80b : ACPI PM_TMR
    f810-f815 : ACPI CPU throttle
  f820-f83f : pnp 00:0c
    f828-f82f : ACPI GPE0_BLK
  f840-f85f : pnp 00:0c
  f860-f87f : pnp 00:0c
fa00-fa3f : 0000:00:1f.0
fc00-fc1f : 0000:00:1f.3
  fc00-fc1f : i801_smbus

00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000ca5ff : Video ROM
000f0000-000fffff : System ROM
00100000-7f7effff : System RAM
  00100000-0031bc4f : Kernel code
  0031bc50-003f3f23 : Kernel data
7f7f0000-7fffffff : reserved
88000000-880003ff : 0000:00:1f.1
e0000000-efffffff : 0000:00:00.0
f0000000-f7ffffff : 0000:00:02.0
f8400000-f847ffff : 0000:00:02.0
f8480000-f84803ff : 0000:00:1d.7
  f8480000-f84803ff : ehci_hcd
f8500000-f87fffff : PCI Bus #05
  f8500000-f850ffff : 0000:05:02.0
    f8500000-f850ffff : tg3
  f8510000-f8513fff : 0000:05:09.2
  f8514000-f8514fff : 0000:05:04.0
    f8514000-f8514fff : ohci_hcd
  f8515000-f8515fff : 0000:05:04.1
    f8515000-f8515fff : ohci_hcd
  f8516000-f85167ff : 0000:05:09.2
    f8516000-f85167ff : ohci1394
  f8516800-f85168ff : 0000:05:04.2
    f8516800-f85168ff : ehci_hcd
fec00000-ffffffff : reserved


00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub 
Interface (rev 02)
        Subsystem: Hewlett-Packard Company Unknown device 12bc
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort+ >SERR- <PERR-
        Latency: 0
        Region 0: Memory at e0000000 (32-bit, prefetchable) [size=256M]
        Capabilities: [e4] Vendor Specific Information

00:02.0 VGA compatible controller: Intel Corporation 82865G Integrated 
Graphics Controller (rev 02) (prog-if 00 [VGA])
        Subsystem: Hewlett-Packard Company D530 sff(dc578av)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 10
        Region 0: Memory at f0000000 (32-bit, prefetchable) [size=128M]
        Region 1: Memory at f8400000 (32-bit, non-prefetchable) [size=512K]
        Region 2: I/O ports at 24e0 [size=8]
        Capabilities: [d0] Power Management version 1
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #1 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 19
        Region 4: I/O ports at 2440 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #2 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin B routed to IRQ 20
        Region 4: I/O ports at 2460 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #3 (rev 02) (prog-if 00 [UHCI])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin C routed to IRQ 16
        Region 4: I/O ports at 2480 [size=32]

00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI 
Controller (rev 02) (prog-if 20 [EHCI])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin D routed to IRQ 17
        Region 0: Memory at f8480000 (32-bit, non-prefetchable) [size=1K]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA 
PME(D0+,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Capabilities: [58] Debug port

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2) (prog-if 00 
[Normal decode])
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Bus: primary=00, secondary=05, subordinate=05, sec-latency=64
        I/O behind bridge: 00001000-00001fff
        Memory behind bridge: f8500000-f87fffff
        Prefetchable memory behind bridge: fff00000-000fffff
        Secondary status: 66MHz- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort+ <SERR- <PERR-
        BridgeCtl: Parity- SERR+ NoISA+ VGA- MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface 
Bridge (rev 02)
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 01f0 [size=8]
        Region 1: I/O ports at 03f4 [size=1]
        Region 2: I/O ports at 0170 [size=8]
        Region 3: I/O ports at 0374 [size=1]
        Region 4: I/O ports at 24c0 [size=16]
        Region 5: Memory at 88000000 (32-bit, non-prefetchable) [size=1K]

00:1f.2 IDE interface: Intel Corporation 82801EB (ICH5) SATA Controller (rev 
02) (prog-if 8f [Master SecP SecO PriP PriO])
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 24f8 [size=8]
        Region 1: I/O ports at 2810 [size=4]
        Region 2: I/O ports at 2800 [size=8]
        Region 3: I/O ports at 2814 [size=4]
        Region 4: I/O ports at 24d0 [size=16]

00:1f.3 SMBus: Intel Corporation 82801EB/ER (ICH5/ICH5R) SMBus Controller (rev 
02)
        Subsystem: Hewlett-Packard Company Unknown device 12bc
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B-
        Status: Cap- 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin B routed to IRQ 21
        Region 4: I/O ports at fc00 [size=32]

05:02.0 Ethernet controller: Broadcom Corporation NetXtreme BCM5782 Gigabit 
Ethernet (rev 03)
        Subsystem: Hewlett-Packard Company d530 CMT (DG746A)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (16000ns min)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at f8500000 (64-bit, non-prefetchable) [size=64K]
        Capabilities: [48] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=1 PME-
        Capabilities: [50] Vital Product Data
        Capabilities: [58] Message Signalled Interrupts: Mask- 64bit+ 
Queue=0/3 Enable-
                Address: 7fff7fef4ffebffc  Data: ffff

05:04.0 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
        Subsystem: Asustek Computer, Inc. PCI-USB2 (OHCI subsystem)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (250ns min, 10500ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 19
        Region 0: Memory at f8514000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:04.1 USB Controller: NEC Corporation USB (rev 41) (prog-if 10 [OHCI])
        Subsystem: Asustek Computer, Inc. PCI-USB2 (OHCI subsystem)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (250ns min, 10500ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 16
        Region 0: Memory at f8515000 (32-bit, non-prefetchable) [size=4K]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:04.2 USB Controller: NEC Corporation USB 2.0 (rev 02) (prog-if 20 [EHCI])
        Subsystem: Asustek Computer, Inc. PCI-USB2 (EHCI subsystem)
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (4000ns min, 8500ns max), Cache Line Size: 128 bytes
        Interrupt: pin C routed to IRQ 18
        Region 0: Memory at f8516800 (32-bit, non-prefetchable) [size=256]
        Capabilities: [40] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:09.0 Multimedia audio controller: Creative Labs SB Audigy (rev 03)
        Subsystem: Creative Labs SB0090 Audigy Player
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64 (500ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 16
        Region 0: I/O ports at 1000 [size=32]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:09.1 Input device controller: Creative Labs SB Audigy Game Port (rev 03)
        Subsystem: Creative Labs SB Audigy MIDI/Game Port
        Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 64
        Region 0: I/O ports at 1020 [size=8]
        Capabilities: [dc] Power Management version 2
                Flags: PMEClk- DSI+ D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

05:09.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (prog-if 
10 [OHCI])
        Subsystem: Creative Labs SB Audigy FireWire Port
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR+ FastB2B-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 66 (500ns min, 1000ns max), Cache Line Size: 64 bytes
        Interrupt: pin B routed to IRQ 18
        Region 0: Memory at f8516000 (32-bit, non-prefetchable) [size=2K]
        Region 1: Memory at f8510000 (32-bit, non-prefetchable) [size=16K]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0+,D1+,D2+,D3hot+,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME+

-- 
Syd Alsobrook
IT Tag Team, Inc.
518-598-6025
http://www.ittagteam.com
