Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbZEBJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbZEBJfa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 05:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbZEBJfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 05:35:20 -0400
Received: from samba.ing.unimo.it ([155.185.54.131]:50221 "EHLO
	samba.ing.unimo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751764AbZEBJfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 05:35:19 -0400
X-Greylist: delayed 2305 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 May 2009 05:35:18 EDT
Message-ID: <5678c0edb92482ea613d44a024eac6c1.squirrel@weblab.ing.unimo.it>
Date: Sat, 2 May 2009 10:56:42 +0200 (CEST)
Subject: BUG: scheduling while atomic upon USB HSDPA modem insertion
From: andreoli@samba.ing.unimo.it
To: linux-kernel@vger.kernel.org
Cc: andreoli@samba.ing.unimo.it
User-Agent: SquirrelMail/1.4.15
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
X-Spam_score: -4.4
X-Spam_score_int: -43
X-Spam_bar: ----
X-Spam_report: Spam detection software, running on the system "samba.ing.unimo.it", has
	identified this incoming email as possible spam.  The original message
	has been attached to this so you can view it (if it isn't spam) or label
	similar future email.  If you have any questions, see
	the administrator of that system for details.
	Content preview:  Hi all, just noticed that I get this upon plugging my USB
	HSDPA USB modem. Yes, it's a zeroCD device. Here's the (hopefully) relevant
	dmesg output. The machine is a 64bit Dell Latitude E6500, the distro I'm
	using is Ubuntu 9.04, the kernel is a 2.6.29 vanilla one. [...] 
	Content analysis details:   (-4.4 points, 5.0 required)
	pts rule name              description
	---- ---------------------- --------------------------------------------------
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

just noticed that I get this upon plugging my USB HSDPA USB modem. Yes,
it's a zeroCD device. Here's the (hopefully) relevant dmesg output. The
machine is a 64bit Dell Latitude E6500, the distro I'm using is Ubuntu
9.04, the kernel is a 2.6.29 vanilla one.

Best regards
Mauro Andreolini

[ 3154.033123] BUG: scheduling while atomic: usb_id/11592/0x10010000
[ 3154.033126] Modules linked in: isofs vmnet parport_pc vsock vmci vmmon
ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt i915 drm
i2c_algo_bit binfmt_misc ppdev btusb bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp vboxnetflt iptable_filter ip_tables vboxdrv x_tables bridge stp
kvm_intel kvm option lp parport snd_hda_codec_intelhdmi snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event
ecb joydev snd_seq snd_timer iwlagn pcmcia snd_seq_device iwlcore uvcvideo
videodev mac80211 psmouse v4l1_compat sdhci_pci sdhci iTCO_wdt
yenta_socket rsrc_nonstatic snd pcspkr serio_raw ricoh_mmc
v4l2_compat_ioctl32 led_class dcdbas intel_agp usbhid iTCO_vendor_support
pcmcia_core video soundcore snd_page_alloc cfg80211 output usb_storage
ohci1394 ieee1394 ehci_hcd uhci_hcd e1000e fuse [last unloaded: vmnet]
[ 3154.033179] CPU 0:
[ 3154.033180] Modules linked in: isofs vmnet parport_pc vsock vmci vmmon
ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt i915 drm
i2c_algo_bit binfmt_misc ppdev btusb bnep ipt_MASQUERADE iptable_nat
nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp vboxnetflt iptable_filter ip_tables vboxdrv x_tables bridge stp
kvm_intel kvm option lp parport snd_hda_codec_intelhdmi snd_hda_codec_idt
snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm
snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi arc4 snd_seq_midi_event
ecb joydev snd_seq snd_timer iwlagn pcmcia snd_seq_device iwlcore uvcvideo
videodev mac80211 psmouse v4l1_compat sdhci_pci sdhci iTCO_wdt
yenta_socket rsrc_nonstatic snd pcspkr serio_raw ricoh_mmc
v4l2_compat_ioctl32 led_class dcdbas intel_agp usbhid iTCO_vendor_support
pcmcia_core video soundcore snd_page_alloc cfg80211 output usb_storage
ohci1394 ieee1394 ehci_hcd uhci_hcd e1000e fuse [last unloaded: vmnet]
[ 3154.033218] Pid: 11592, comm: usb_id Not tainted 2.6.29 #1 Latitude E6500
[ 3154.033220] RIP: 0010:[<ffffffff802f60a6>]  [<ffffffff802f60a6>]
__follow_mount+0x46/0xb0
[ 3154.033230] RSP: 0018:ffff8800c3507c08  EFLAGS: 00000202
[ 3154.033232] RAX: 000000000000000c RBX: ffff8800c3507c28 RCX:
0000000000000002
[ 3154.033233] RDX: 0000000000000000 RSI: ffff88011f402000 RDI:
ffff880113c1f6c0
[ 3154.033234] RBP: ffffffff8021320e R08: 0000000000000000 R09:
0000000000000001
[ 3154.033235] R10: 0000000000000000 R11: 0000000000000246 R12:
ffff8800c3507bc8
[ 3154.033236] R13: ffffffff808f2a00 R14: 0000000000000292 R15:
ffff8800c3507b33
[ 3154.033238] FS:  00007faadc0016f0(0000) GS:ffffffff80a35000(0000)
knlGS:0000000000000000
[ 3154.033239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 3154.033240] CR2: 00007fffe4027f88 CR3: 0000000013d22000 CR4:
00000000000026a0
[ 3154.033242] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[ 3154.033243] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[ 3154.033244] Call Trace:
[ 3154.033246]  [<ffffffff802f60cb>] ? __follow_mount+0x6b/0xb0
[ 3154.033248]  [<ffffffff802f70f7>] ? do_lookup+0x147/0x250
[ 3154.033250]  [<ffffffff802f7343>] ? __link_path_walk+0x143/0xee0
[ 3154.033252]  [<ffffffff802f6170>] ? path_to_nameidata+0x20/0x60
[ 3154.033253]  [<ffffffff802f830e>] ? path_walk+0x6e/0xe0
[ 3154.033255]  [<ffffffff802f8524>] ? do_path_lookup+0xe4/0x200
[ 3154.033258]  [<ffffffff802eda03>] ? get_empty_filp+0x83/0x180
[ 3154.033259]  [<ffffffff802f8715>] ? path_lookup_open+0x65/0xd0
[ 3154.033261]  [<ffffffff802f92f9>] ? do_filp_open+0xb9/0x940
[ 3154.033264]  [<ffffffff802baa0b>] ? free_hot_page+0xb/0x10
[ 3154.033265]  [<ffffffff802baa8d>] ? free_pages+0x3d/0x50
[ 3154.033268]  [<ffffffff80305ce1>] ? mntput_no_expire+0x31/0x170
[ 3154.033269]  [<ffffffff80303f31>] ? alloc_fd+0x121/0x150
[ 3154.033271]  [<ffffffff802ea4a8>] ? do_sys_open+0x78/0x100
[ 3154.033273]  [<ffffffff802ea55b>] ? sys_open+0x1b/0x20
[ 3154.033275]  [<ffffffff8021272a>] ? system_call_fastpath+0x16/0x1b


