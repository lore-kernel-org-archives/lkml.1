Return-Path: <linux-kernel-owner+w=401wt.eu-S965154AbXCFPfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965154AbXCFPfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 10:35:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965157AbXCFPfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 10:35:19 -0500
Received: from main.gmane.org ([80.91.229.2]:43951 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965155AbXCFPfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 10:35:16 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Dirk Schoebel <dirk@liji-und-dirk.de>
Subject: Re: OOPS with 2.6.20 and 2.6.21-rc2 (mos7720)
Followup-To: gmane.linux.usb.devel
Date: Tue, 06 Mar 2007 16:31:15 +0100
Message-ID: <esk1g3$nik$1@sea.gmane.org>
References: <esjg1h$l8d$1@sea.gmane.org> <200703061207.53484.oliver@neukum.org> <esjv78$g3h$1@sea.gmane.org> <200703061618.26402.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-91-111.dynamic.qsc.de
User-Agent: KNode/0.10.4
Cc: linux-usb-devel@lists.sourceforge.net
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

new trace
(if i should activate some kernel debugging optioons just mention it)

Mar  6 16:28:02 emerald usbcore: registered new interface driver moschip7720
Mar  6 16:28:12 emerald Unable to handle kernel NULL pointer dereference at
0000000000000070 RIP:
Mar  6 16:28:12 emerald
[<ffffffff881895fb>] :mos7720:mos7720_open+0x3fb/0x580
Mar  6 16:28:12 emerald PGD 10ba92067 PUD 1321b3067 PMD 0
Mar  6 16:28:12 emerald Oops: 0000 [2] SMP
Mar  6 16:28:12 emerald CPU 0
Mar  6 16:28:12 emerald Modules linked in: mos7720 snd_rtctimer snd_seq_midi
snd_emu10k1_synth snd_emux_synth snd_seq_virmidi snd_seq_midi_emul
snd_pcm_oss snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi_event
snd_seq nls_iso8859_15 vmnet(PF) vmmon(PF) it87 hwmon_vid i2c_isa eeprom
lm90 rfcomm l2cap fuse nls_iso8859_1 nls_cp850 eth1394 kqemu capability
dazuko commoncap tuner tvaudio msp3400 nvidia(P) usbserial psmouse bttv
video_buf ir_common compat_ioctl32 btcx_risc zaurus cdc_ether usbnet
tveeprom videodev v4l2_common v4l1_compat hci_usb bluetooth snd_emu10k1
snd_rawmidi snd_seq_device snd_util_mem snd_hwdep skge snd_intel8x0
snd_ac97_codec ac97_bus snd_bt87x snd_pcm snd_timer ohci1394 snd
snd_page_alloc k8temp i2c_nforce2 forcedeth
Mar  6 16:28:12 emerald Pid: 15042, comm: minicom Tainted: PF R   
2.6.21-rc2-emi #1
Mar  6 16:28:12 emerald RIP: 0010:[<ffffffff881895fb>] 
[<ffffffff881895fb>] :mos7720:mos7720_open+0x3fb/0x580
Mar  6 16:28:12 emerald RSP: 0018:ffff810138a97d58  EFLAGS: 00010202
Mar  6 16:28:12 emerald RAX: 0000000040000780 RBX: ffff81011926cc00 RCX:
ffff81013ff96000
Mar  6 16:28:12 emerald RDX: 0000000000000000 RSI: ffff810001000138 RDI:
0000000000000000
Mar  6 16:28:12 emerald RBP: ffff810138a97d6f R08: ffff810138a96000 R09:
ffff810138a97b58
Mar  6 16:28:12 emerald R10: 0000000000000000 R11: 0000000000000000 R12:
ffff81011926cc00
Mar  6 16:28:12 emerald R13: ffff8100be0e1240 R14: ffff8100bc2a4540 R15:
ffff810136a3fe20
Mar  6 16:28:12 emerald FS:  00002b640ead7da0(0000) GS:ffffffff808a200
(0000) knlGS:00000000f65019c0
Mar  6 16:28:12 emerald CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
Mar  6 16:28:12 emerald CR2: 0000000000000070 CR3: 0000000138617000 CR4:
00000000000006e0
Mar  6 16:28:12 emerald Process minicom (pid: 15042, threadinfo
ffff810138a96000, task ffff81011d76eee0)
Mar  6 16:28:12 emerald Stack:  ffff81011926cc00 ffff81013d1cd000
0c00000000000282 ffff81011926cc00
Mar  6 16:28:12 emerald ffff8100be0e1240 ffff81013ae12800 ffff81011926cc18
00000000ffffffed
Mar  6 16:28:12 emerald ffff8100baad1680 ffffffff8817d487 ffff8100bd27f940
000000000bc00002
Mar  6 16:28:12 emerald Call Trace:
Mar  6 16:28:12 emerald
[<ffffffff8817d487>] :usbserial:serial_open+0x117/0x190
Mar  6 16:28:12 emerald [<ffffffff805253a6>] tty_open+0x1b6/0x360
Mar  6 16:28:12 emerald [<ffffffff8024afe2>] chrdev_open+0x182/0x1e0
Mar  6 16:28:12 emerald [<ffffffff8024ae60>] chrdev_open+0x0/0x1e0
Mar  6 16:28:12 emerald [<ffffffff8021eccd>] __dentry_open+0xed/0x1e0
Mar  6 16:28:12 emerald [<ffffffff8022855d>] do_filp_open+0x2d/0x40
Mar  6 16:28:12 emerald [<ffffffff80234c6f>] do_setitimer+0x16f/0x350
Mar  6 16:28:12 emerald [<ffffffff802199ca>] do_sys_open+0x5a/0x100
Mar  6 16:28:12 emerald [<ffffffff802601ce>] system_call+0x7e/0x83
Mar  6 16:28:12 emerald
Mar  6 16:28:12 emerald
Mar  6 16:28:12 emerald Code: 44 8b 47 70 09 c2 48 8b 43 38 c7 47 04 01 00
00 00 48 89 4f
Mar  6 16:28:12 emerald RIP 
[<ffffffff881895fb>] :mos7720:mos7720_open+0x3fb/0x580
Mar  6 16:28:12 emerald RSP <ffff810138a97d58>
Mar  6 16:28:12 emerald CR2: 0000000000000070


