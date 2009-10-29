Return-Path: <linux-kernel-owner+w=401wt.eu-S1756854AbZJ2XRq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbZJ2XRq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 19:17:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbZJ2XRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 19:17:45 -0400
Received: from mail-bw0-f227.google.com ([209.85.218.227]:45526 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbZJ2XRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 19:17:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=eOE6D9lyk1oIZJBf9dY7eRW6+FzxzrJNFqwfNTZ2Or8e+p8cBENJ4mUDUMb2RUiynU
         nf4PbfOVOaalEFNmV2ICIfxWJ78/Gf6MdwK9w7QI8mCke4+vnU3KLjmQ4LXYVdOEU8Da
         6BjmdUz/lUZEPQlAfETP2zeNp54PpUwfswtFw=
MIME-Version: 1.0
Date: Thu, 29 Oct 2009 19:17:48 -0400
Message-ID: <f7848160910291617q2b168089l5ce489d2f47ebe96@mail.gmail.com>
Subject: OOPS in cfg80211_conn_work
From: Parag Warudkar <parag.lkml@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oct 29 18:59:06 parag-laptop kernel: [  143.180037] wlan0:
deauthenticating from 00:16:01:d6:6f:12 by local choice (reason=3)
Oct 29 18:59:06 parag-laptop kernel: [  143.181137] wlan0: direct
probe to AP 00:16:01:d6:6f:12 (try 1)
Oct 29 18:59:06 parag-laptop kernel: [  143.181148] wlan0:
deauthenticating from 00:16:01:d6:6f:12 by local choice (reason=3)
Oct 29 18:59:06 parag-laptop kernel: [  143.203375] BUG: unable to
handle kernel NULL pointer dereference at (null)
Oct 29 18:59:06 parag-laptop kernel: [  143.203432] IP:
[<ffffffffa0139161>] cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.203476] PGD 138abc067 PUD
136d87067 PMD 0
Oct 29 18:59:06 parag-laptop kernel: [  143.203530] Oops: 0000 [#1] SMP
Oct 29 18:59:06 parag-laptop kernel: [  143.203571] last sysfs file:
/sys/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/controlC1/uevent
Oct 29 18:59:06 parag-laptop kernel: [  143.203597] CPU 0
Oct 29 18:59:06 parag-laptop kernel: [  143.203629] Modules linked in:
aes_generic radeon ttm drm_kms_helper drm i2c_algo_bit cfbcopyarea
cfbimgblt cfbfillrect binfmt_misc snd_hda_codec_atihdmi rfcomm
snd_hda_codec_analog sco bnep ppdev l2cap snd_hda_intel arc4
snd_hda_codec snd_pcm_oss snd_mixer_oss snd_hwdep snd_seq_dummy
snd_pcm snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event iwlagn
iptable_filter ext3 snd_seq iwlcore snd_timer led_class snd_seq_device
ip_tables jbd snd mac80211 psmouse btusb x_tables tpm_infineon
soundcore serio_raw bluetooth snd_page_alloc cfg80211 tpm tpm_bios
evdev lp parport ext4 mbcache jbd2 fuse ahci libata video output
intel_agp e1000e
Oct 29 18:59:06 parag-laptop kernel: [  143.204560] Pid: 9, comm:
events/0 Not tainted 2.6.32-rc5 #2 HP EliteBook 8530p
Oct 29 18:59:06 parag-laptop kernel: [  143.204588] RIP:
0010:[<ffffffffa0139161>]  [<ffffffffa0139161>]
cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.204634] RSP:
0000:ffff88013f8b5dc0  EFLAGS: 00010246
Oct 29 18:59:06 parag-laptop kernel: [  143.204656] RAX:
0000000000000000 RBX: ffff88013e8db690 RCX: ffff88013cb80118
Oct 29 18:59:06 parag-laptop kernel: [  143.204679] RDX:
0000000000000000 RSI: 0000000000000282 RDI: ffff88013e8db690
Oct 29 18:59:06 parag-laptop kernel: [  143.204702] RBP:
ffff88013f8b5e30 R08: 0000000000000000 R09: 0000000000000001
Oct 29 18:59:06 parag-laptop kernel: [  143.204724] R10:
0000000000000000 R11: ffff880028295718 R12: ffff88013e8db6b8
Oct 29 18:59:06 parag-laptop kernel: [  143.204747] R13:
ffff88013cb800a8 R14: ffff88013cb80000 R15: ffff88013f8b5df0
Oct 29 18:59:06 parag-laptop kernel: [  143.204770] FS:
0000000000000000(0000) GS:ffff880028200000(0000)
knlGS:0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.204799] CS:  0010 DS: 0018
ES: 0018 CR0: 000000008005003b
Oct 29 18:59:06 parag-laptop kernel: [  143.204820] CR2:
0000000000000000 CR3: 000000013dde3000 CR4: 00000000000406f0
Oct 29 18:59:06 parag-laptop kernel: [  143.204843] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.204866] DR3:
0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Oct 29 18:59:06 parag-laptop kernel: [  143.204889] Process events/0
(pid: 9, threadinfo ffff88013f8b4000, task ffff88013f885980)
Oct 29 18:59:06 parag-laptop kernel: [  143.204917] Stack:
Oct 29 18:59:06 parag-laptop kernel: [  143.204936]  ffff88013f8b5dc0
ffff88013f8b5dc0 0000000000000282 ffffffff8162afb8
Oct 29 18:59:06 parag-laptop kernel: [  143.204996] <0>
ffff88013cb80018 ffff88013cb80088 ffff880028218040 ffff88013f8b5fd8
Oct 29 18:59:06 parag-laptop kernel: [  143.205085] <0>
ffff88013f8b5e10 ffff88013cb80130 ffff880028218040 ffffffffa01390b0
Oct 29 18:59:06 parag-laptop kernel: [  143.205190] Call Trace:
Oct 29 18:59:06 parag-laptop kernel: [  143.205215]
[<ffffffffa01390b0>] ? cfg80211_conn_work+0x0/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.205242]
[<ffffffff8106c86f>] worker_thread+0x17f/0x2c0
Oct 29 18:59:06 parag-laptop kernel: [  143.205265]
[<ffffffff810710d0>] ? autoremove_wake_function+0x0/0x40
Oct 29 18:59:06 parag-laptop kernel: [  143.205289]
[<ffffffff8106c6f0>] ? worker_thread+0x0/0x2c0
Oct 29 18:59:06 parag-laptop kernel: [  143.205311]
[<ffffffff81070cfe>] kthread+0x8e/0xa0
Oct 29 18:59:06 parag-laptop kernel: [  143.205334]
[<ffffffff81012f2a>] child_rip+0xa/0x20
Oct 29 18:59:06 parag-laptop kernel: [  143.205356]
[<ffffffff81070c70>] ? kthread+0x0/0xa0
Oct 29 18:59:06 parag-laptop kernel: [  143.205378]
[<ffffffff81012f20>] ? child_rip+0x0/0x20
Oct 29 18:59:06 parag-laptop kernel: [  143.205399] Code: 63 28 4c 89
e7 e8 c0 02 2b e1 48 8b 43 20 f6 40 48 01 74 c6 83 bb 8c 00 00 00 01
75 bd 48 8b 83 90 00 00 00 48 89 df 48 8b 40 08 <8b> 10 41 89 17 0f b7
40 04 66 41 89 47 04 e8 fc ee ff ff 85 c0
Oct 29 18:59:06 parag-laptop kernel: [  143.206242] RIP
[<ffffffffa0139161>] cfg80211_conn_work+0xb1/0x140 [cfg80211]
Oct 29 18:59:06 parag-laptop kernel: [  143.206286]  RSP <ffff88013f8b5dc0>
Oct 29 18:59:06 parag-laptop kernel: [  143.206306] CR2: 0000000000000000
Oct 29 18:59:06 parag-laptop kernel: [  143.206327] ---[ end trace
ccb079f99bd67991 ]---
Oct 29 18:59:58 parag-laptop kernel: Kernel logging (proc) stopped.
