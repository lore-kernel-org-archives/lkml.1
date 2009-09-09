Return-Path: <linux-kernel-owner+w=401wt.eu-S1752963AbZIIJbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963AbZIIJbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 05:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbZIIJbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 05:31:48 -0400
Received: from mail.turknet.net.tr ([193.192.98.182]:15230 "EHLO
	mail.turknet.net.tr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZIIJbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 05:31:46 -0400
From: Tarkan Erimer <tarkan.erimer@turknet.net.tr>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [BUG] Sound related problem with Linux-2.6.31-rc8-git1-rt9
Date: Wed, 9 Sep 2009 12:31:40 +0300
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-git1; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <200909041445.29212.tarkan.erimer@turknet.net.tr> <200909071001.15718.tarkan.erimer@turknet.net.tr> <s5h8wgr5iuq.wl%tiwai@suse.de>
In-Reply-To: <s5h8wgr5iuq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909091231.41194.tarkan.erimer@turknet.net.tr>
X-OriginalArrivalTime: 09 Sep 2009 09:31:45.0042 (UTC) FILETIME=[58BC7F20:01CA3130]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009 10:12:13 am Takashi Iwai wrote:
> At Mon, 7 Sep 2009 10:01:15 +0300,
> 
> Tarkan Erimer wrote:
> > On Saturday 05 September 2009 11:44:32 am Takashi Iwai wrote:
> > > At Fri, 4 Sep 2009 14:45:28 +0300,
> > >
> > > Tarkan Erimer wrote:
> > > > When I ran a movie, I got these errors in dmesg. Also, sound began to
> > > > skip too fastly. My audio device is:
> > > >
> > > > tarkane@tarkane:~$ lspci | grep -i audio
> > > > 00:1b.0 Audio device: Intel Corporation 82801G (ICH7 Family) High
> > > > Definition Audio Controller (rev 01)
> > > >
> > > >
> > > > Tarkan Erimer
> > > >
> > > >
> > > > [81001.954666] BUG: unable to handle kernel NULL pointer dereference
> > > > at 00000000000000a8
> > > > [81001.954677] IP: [<ffffffffa010f4b5>]
> > > > snd_pcm_period_elapsed+0x11/0x1ec [snd_pcm]
> > > > [81001.954701] PGD 1a028067 PUD 1a022067 PMD 0
> > > > [81001.954708] Oops: 0000 [#1] PREEMPT SMP
> > > > [81001.954713] last sysfs file:
> > > > /sys/devices/pci0000:00/0000:00:1d.7/usb5/5-8/5-8:1.0/host5/target5:0
> > > >:0/5
> > > >
> > > >:0:0:0/block/sdb/size [81001.954718] CPU 1
> > > >
> > > > [81001.954721] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat
> > > > usb_storage nfs lockd fscache nfs_acl auth_rpcgss sunrpc xt_multiport
> > > > iptable_filter ip_tables x_tables binfmt_misc bridge stp llc bnep
> > > > xfrm_user xfrm4_tunnel tunnel4 ipcomp xfrm_ipcomp esp4 ah4 deflate
> > > > ctr twofish twofish_common camellia serpent blowfish cast5
> > > > des_generic cbc aes_x86_64 aes_generic xcbc rmd160 sha256_generic
> > > > sha1_generic crypto_null af_key xfs exportfs btrfs zlib_deflate
> > > > crc32c libcrc32c snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> > > > snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss
> > > > snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer
> > > > iTCO_wdt snd_seq_device iTCO_vendor_support snd soundcore
> > > > snd_page_alloc psmouse serio_raw pcspkr usbhid ehci_hcd uhci_hcd tg3
> > > > floppy
> > > > [81001.954806] Pid: 2180, comm: hd-audio0 Not tainted 2.6.31-rc8-git1
> > > > #4 HP Compaq dc7600 Small Form Factor
> > > > [81001.954810] RIP: 0010:[<ffffffffa010f4b5>]  [<ffffffffa010f4b5>]
> > > > snd_pcm_period_elapsed+0x11/0x1ec [snd_pcm]
> > > > [81001.954827] RSP: 0018:ffff88003a0cddd0  EFLAGS: 00010282
> > > > [81001.954831] RAX: 0000000000000000 RBX: ffff88003a1cf9e0 RCX:
> > > > 0000000000000000
> > > > [81001.954834] RDX: 0000000000000001 RSI: 0000000000000003 RDI:
> > > > 0000000000000000
> > > > [81001.954837] RBP: 0000000000000004 R08: ffff88003a1cf9e0 R09:
> > > > 00000000ffffffff
> > > > [81001.954841] R10: 0000000000000013 R11: ffffffff81033a48 R12:
> > > > ffff88003a49cc48
> > > > [81001.954844] R13: 0000000000000000 R14: ffff88003a49cc00 R15:
> > > > ffffffffa014c092
> > > > [81001.954849] FS:  0000000000000000(0000) GS:ffff8800017f8000(0000)
> > > > knlGS:0000000000000000
> > > > [81001.954853] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> > > > [81001.954856] CR2: 00000000000000a8 CR3: 000000001a01b000 CR4:
> > > > 00000000000006a0
> > > > [81001.954860] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> > > > 0000000000000000
> > > > [81001.954863] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> > > > 0000000000000400
> > > > [81001.954868] Process hd-audio0 (pid: 2180, threadinfo
> > > > ffff88003a0cc000, task ffff88003f197750)
> > > > [81001.954870] Stack:
> > > > [81001.954872]  0000000000000000 ffff88003a1cf9e0 0000000000000004
> > > > ffff88003a49cc48
> > > > [81001.954878] <0> 0000000000000000 ffff88003a49cc00 ffffffffa014c092
> > > > ffffffffa014c11c
> > > > [81001.954884] <0> ffff88003a0cdec8 ffffc9000260c100 ffff88003a49cdf0
> > > > ffff88003a49cdf8
> > > > [81001.954892] Call Trace:
> > > > [81001.954905]  [<ffffffffa014c092>] ? azx_irq_pending_work+0x0/0xbc
> > > > [snd_hda_intel]
> > > > [81001.954914]  [<ffffffffa014c11c>] ? azx_irq_pending_work+0x8a/0xbc
> > > > [snd_hda_intel]
> > > > [81001.954923]  [<ffffffff81051f35>] ? worker_thread+0x1cb/0x268
> > > > [81001.954928]  [<ffffffff81056355>] ?
> > > > autoremove_wake_function+0x0/0x2e [81001.954933] 
> > > > [<ffffffff81051d6a>] ? worker_thread+0x0/0x268 [81001.954938] 
> > > > [<ffffffff81055f9c>] ? kthread+0x8b/0x93
> > > > [81001.954944]  [<ffffffff81011c5a>] ? child_rip+0xa/0x20
> > > > [81001.954949]  [<ffffffff81055f11>] ? kthread+0x0/0x93
> > > > [81001.954953]  [<ffffffff81011c50>] ? child_rip+0x0/0x20
> > > > [81001.954955] Code: 01 00 00 31 c9 ba 01 00 00 00 be 06 00 00 00 e8
> > > > 5d 7c f2 e0 31 c9 89 c8 5f c3 41 57 41 56 41 55 41 54 55 53 48 83 ec
> > > > 08 49 89 fd <4c> 8b bf a8 00 00 00 49 8b 87 b0 02 00 00 48 85 c0 74
> > > > 02 ff d0 [81001.955011] RIP  [<ffffffffa010f4b5>]
> > > > snd_pcm_period_elapsed+0x11/0x1ec [snd_pcm]
> > > > [81001.955026]  RSP <ffff88003a0cddd0>
> > > > [81001.955029] CR2: 00000000000000a8
> > > > [81001.955033] ---[ end trace 552f354de445b720 ]---
> > >
> > > It's the first case of such a report.  Might be some races.
> > > Did you set CONFIG_SND_DEBUG=y?
> > >
> > >
> > > thanks,
> > >
> > > Takashi
> >
> > Thanks for your respond.
> >
> > No, I didn't. But; today, I will try with CONFIG_SND_DEBUG=y and then
> > will try to reproduce the problem.
> 
> Thanks, that'll be helpful.
> Also, there should be some relevant messages from the driver before
> entering this point.  Could you check it?
> 
> Another questions:
> - how often does it happen, how reproducible is it?
> - is whether it's a regression in 2.6.31 -- have you ever gotten this
>   in the earlier version?
> 
> There are a few changes in the codec communication code since 2.6.30,
> but I don't see any obvious problem in them...
> 
> 
> thanks,
> 
> Takashi
> 

Hi again Takashi,

I compiled the same kernel version with CONFIG_SND_DENUG=y. But; 
unfortunately, I wasn't able to reproduce it. It happened when I was playing 
some HD movie content and it only happened with this (2.6.31-rc8-git1-rt9) 
kernel release. All the previous versions, that I tried, don't have this 
issue. Just I discovered this warning in dmesg. Maybe, it can give some clue :
\ 

[   24.197420] hda-intel: azx_pcm_prepare: bufsize=0x10000, format=0x31
[   24.197431] hda_codec_setup_stream: NID=0x2, stream=0x5, channel=0, 
format=0x31
[   24.219842] hda-intel: IRQ timing workaround is activated for card #0. 
Suggest a bigger bdl_pos_adj.

Tarkan
