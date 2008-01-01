Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYAAVSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYAAVSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 16:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754887AbYAAVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 16:17:53 -0500
Received: from home.nigel.suspend2.net ([203.171.70.205]:54180 "EHLO
	server1.example.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754641AbYAAVRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 16:17:52 -0500
Message-ID: <477AADF4.4080305@nigel.suspend2.net>
Date: Wed, 02 Jan 2008 08:17:40 +1100
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Berthold Cogel <cogel@rrz.uni-koeln.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops in evdev_disconnect for kernel 2.6.23.12
References: <477A93CD.9030707@rrz.uni-koeln.de>
In-Reply-To: <477A93CD.9030707@rrz.uni-koeln.de>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Berthold.

Berthold Cogel wrote:
> Jan  1 17:34:39 wonderland kernel: usb 2-2: USB disconnect, address 3
> Jan  1 17:34:39 wonderland kernel: usb 2-2.5: USB disconnect, address 4
> Jan  1 17:34:39 wonderland kernel: drivers/input/tablet/wacom_sys.c:
> wacom_sys_irq - usb_submit_urb failed with result -19
> Jan  1 17:34:39 wonderland kernel: usb 2-2.6: USB disconnect, address 5
> Jan  1 17:34:39 wonderland kernel: BUG: unable to handle kernel paging
> request at virtual address 00100100
> Jan  1 17:34:39 wonderland kernel:  printing eip:
> Jan  1 17:34:39 wonderland kernel: f8819668
> Jan  1 17:34:39 wonderland kernel: *pde = 00000000
> Jan  1 17:34:39 wonderland kernel: Oops: 0000 [#1]
> Jan  1 17:34:39 wonderland kernel: PREEMPT
> Jan  1 17:34:39 wonderland kernel: Modules linked in: isofs
> nls_iso8859_1 nls_cp437 vfat fat radeon drm rfcomm l2cap bluetooth ppdev
> lp fan ac battery joydev dm_crypt wacom dm_snapshot dm_mirror sr_mod
> sd_mod sbp2 usbhid hid ff_memless usb_storage snd_emu10k1_synth
> snd_emux_synth snd_seq_virmidi snd_seq_midi_emul snd_emu10k1
> firmware_class snd_ac97_codec ac97_bus snd_util_mem snd_hwdep
> snd_pcm_oss snd_pcm snd_page_alloc snd_mixer_oss snd_seq_dummy
> snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq
> snd_timer snd_seq_device parport_pc parport rtc i2c_viapro ohci1394
> via_agp ide_cd agpgart snd ehci_hcd emu10k1_gp gameport 8139too
> soundcore thermal uhci_hcd ieee1394 processor button evdev
> Jan  1 17:34:39 wonderland kernel: CPU:    0
> Jan  1 17:34:39 wonderland kernel: EIP:    0060:[<f8819668>]    Not
> tainted VLI
> Jan  1 17:34:39 wonderland kernel: EFLAGS: 00010206   (2.6.23.12 #1)
> Jan  1 17:34:39 wonderland kernel: EIP is at evdev_disconnect+0x65/0x9e
> [evdev]
> Jan  1 17:34:39 wonderland kernel: eax: 00000000   ebx: 000ffcf0   ecx:
> c1926760   edx: 00000033
> Jan  1 17:34:39 wonderland kernel: esi: f7415600   edi: f741564c   ebp:
> f7415654   esp: c1967e68
> Jan  1 17:34:39 wonderland kernel: ds: 007b   es: 007b   fs: 0000  gs:
> 0000  ss: 0068
> Jan  1 17:34:39 wonderland kernel: Process khubd (pid: 136, ti=c1966000
> task=c1926570 task.ti=c1966000)
> Jan  1 17:34:39 wonderland kernel: Stack: f7415800 f7402000 f7402758
> f740276c f7b94458 c03454b2 00000000 c03c6eb6
> Jan  1 17:34:39 wonderland kernel:        f7bda054 c029178a f788f520
> f7bda000 f9b3c608 f9b3a3ab f7bda000 f7bda000
> Jan  1 17:34:39 wonderland kernel:        f7bda01c c0337954 f7bda01c
> f9b3c638 00000000 c02fdb59 f7bda01c f7bda01c
> Jan  1 17:34:39 wonderland kernel: Call Trace:
> Jan  1 17:34:39 wonderland kernel:  [<c03454b2>]
> input_unregister_device+0x6f/0xff
> Jan  1 17:34:39 wonderland kernel:  [<c03c6eb6>] klist_release+0x27/0x30
> Jan  1 17:34:39 wonderland kernel:  [<c029178a>] kref_put+0x5f/0x6c
> Jan  1 17:34:39 wonderland kernel:  [<f9b3a3ab>]
> wacom_disconnect+0x2b/0x66 [wacom]
> Jan  1 17:34:39 wonderland kernel:  [<c0337954>]
> usb_unbind_interface+0x2d/0x6e
> Jan  1 17:34:39 wonderland kernel:  [<c02fdb59>]
> __device_release_driver+0x6e/0x8b
> Jan  1 17:34:39 wonderland kernel:  [<c02fdeaf>]
> device_release_driver+0x1d/0x32
> Jan  1 17:34:39 wonderland kernel:  [<c02fd599>]
> bus_remove_device+0x6a/0x7a
> Jan  1 17:34:39 wonderland kernel:  [<c02fbde3>] device_del+0x1c3/0x234
> Jan  1 17:34:39 wonderland kernel:  [<c033567f>]
> usb_disable_device+0x5c/0xbb
> Jan  1 17:34:39 wonderland kernel:  [<c0331ff9>] usb_disconnect+0x7e/0xe6
> Jan  1 17:34:39 wonderland kernel:  [<c0331fea>] usb_disconnect+0x6f/0xe6
> Jan  1 17:34:39 wonderland kernel:  [<c03324db>] hub_thread+0x31c/0xa10
> Jan  1 17:34:39 wonderland kernel:  [<c0114e17>] update_curr+0x102/0x12c
> Jan  1 17:34:39 wonderland kernel:  [<c0114a13>]
> update_stats_wait_end+0x96/0xb9
> Jan  1 17:34:39 wonderland kernel:  [<c01281c7>]
> autoremove_wake_function+0x0/0x33
> Jan  1 17:34:39 wonderland kernel:  [<c03321bf>] hub_thread+0x0/0xa10
> Jan  1 17:34:39 wonderland kernel:  [<c012810e>] kthread+0x36/0x5c
> Jan  1 17:34:39 wonderland kernel:  [<c01280d8>] kthread+0x0/0x5c
> Jan  1 17:34:39 wonderland kernel:  [<c01048f7>]
> kernel_thread_helper+0x7/0x10
> Jan  1 17:34:39 wonderland kernel:  =======================
> Jan  1 17:34:39 wonderland kernel: Code: 5e 4c 81 eb 10 04 00 00 eb 21
> 8d 83 08 04 00 00 b9 06 00 02 00 ba 1d 00 00 00 e8 6a 93 95 c7 8b 9b 10
> 04 00 00 81 eb 10 04 00 00 <8b> 83 10 04 00 00 0f 18 00 90 8d 83 10 04
> 00 00 39 f8 75 cb 8d
> Jan  1 17:34:39 wonderland kernel: EIP: [<f8819668>]
> evdev_disconnect+0x65/0x9e [evdev] SS:ESP 0068:c1967e68
> 
> 
> I'm using Debian stable/testing/unstable with homemade kernel 2.6.23.12
> (patched with tuxonice-3.0-rc3-for-2.6.23.9).
> 
> I tried to get my Wacom Bamboo grafic tablet to work with linux and the
> xorg driver from linuxwacom-0.7.9-4
> (http://linuxwacom.sourceforge.net/). After 'configure/make/make
> install' from source and configuring Xorg, I got the tablet working for
> a simple user. But each time I tried to login with X as root (I know
> .... Bad idea .... :-)) xserver got restarted. I tried to trace the
> situation with stracing gdm. I did this via an ssh session from a second
> computer. Because I tried to follow the forks, I had to kill strace
> after this. Some time after the 'kill', while examining the trace files,
> I recognised the Oops in the window with the ssh session on the second
> computer. The system is still up and running with X.
> 
> At the top of the log extract, you can see USB disconnect messages,
> perhaps leading to the Oops. That's strange because I haven't
> disconneted any USB device. The tablet is still connected to the system
> while I write this.
> 
> lspci
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo KT266/A/333]
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8366/A/7 [Apollo
> KT266/A/333 AGP]
> 00:06.0 RAID bus controller: Promise Technology, Inc. PDC20276
> (MBFastTrak133 Lite) (rev 01)
> 00:07.0 FireWire (IEEE 1394): Texas Instruments TSB43AB22/A
> IEEE-1394a-2000 Controller (PHY/Link)
> 00:09.0 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 50)
> 00:09.1 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 50)
> 00:09.2 USB Controller: VIA Technologies, Inc. USB 2.0 (rev 51)
> 00:0e.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL-8139/8139C/8139C+ (rev 10)
> 00:0f.0 Multimedia audio controller: Creative Labs SB Live! EMU10k1 (rev
> 07)
> 00:0f.1 Input device controller: Creative Labs SB Live! Game Port (rev 07)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8233A ISA Bridge
> 00:11.1 IDE interface: VIA Technologies, Inc.
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:11.2 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 23)
> 00:11.3 USB Controller: VIA Technologies, Inc. VT82xxxxx UHCI USB 1.1
> Controller (rev 23)
> 01:00.0 VGA compatible controller: ATI Technologies Inc RV350 AR [Radeon
> 9600]
> 01:00.1 Display controller: ATI Technologies Inc RV350 AR [Radeon 9600]
> (Secondary)
> 
> The USB system seems to be a wreck at the moment after the Oops. lsusb
> and usbview don't work. But keyboard and trackball are still working.

If you can reproduce it, would you please send the information to the
USB maintainers? I don't modify USB drivers, so it will be an issue in
vanilla. Even if you can't reproduce it immediately, they may well like
to see this report.

Regards,

Nigel
