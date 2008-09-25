Return-Path: <linux-kernel-owner+w=401wt.eu-S1755383AbYIYOJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383AbYIYOJV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 10:09:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbYIYOJN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 10:09:13 -0400
Received: from filter2.host.bg ([87.120.40.156]:36536 "EHLO filter2.host.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752363AbYIYOJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 10:09:12 -0400
Message-ID: <48DB9B4F.9050703@saturnosoft.biz>
Date: Thu, 25 Sep 2008 17:08:15 +0300
From: Todor Gyumyushev <todor@saturnosoft.biz>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: bug report
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sep 25 16:21:09 macmini kernel: ------------[ cut here ]------------
Sep 25 16:21:09 macmini kernel: WARNING: at 
drivers/net/wireless/ath5k/hw.c:3795 ath5k_hw_setup_4word_tx_desc+0x1a3/0x2
50 [ath5k]()
Sep 25 16:21:09 macmini kernel: Modules linked in: ipt_MASQUERADE 
iptable_nat nf_nat nf_conntrack_ipv4 nf_conntrack ip_
tables x_tables vboxdrv i915 drm tun kvm acpi_cpufreq hci_usb rfcomm 
l2cap pktcdvd nfsd lockd nfs_acl auth_rpcgss sunrp
c exportfs aes_generic fan ac battery microcode firmware_class loop 
usbhid usblp arc4 ecb crypto_blkcipher snd_hda_inte
l cryptomgr tpm_infineon sg tpm snd_pcm_oss snd_mixer_oss ath5k ohci1394 
rng_core thermal processor ieee1394 tpm_bios s
nd_pcm mac80211 sr_mod evdev thermal_sys iTCO_wdt cdrom hwmon 
iTCO_vendor_support cfg80211 snd_timer ehci_hcd uhci_hcd
sky2 intel_agp button snd soundcore snd_page_alloc [last unloaded: 
kvm_intel]
Sep 25 16:21:09 macmini kernel: Pid: 10072, comm: icedove-bin Not 
tainted 2.6.26.5 #1
Sep 25 16:21:09 macmini kernel:
Sep 25 16:21:09 macmini kernel: Call Trace:
Sep 25 16:21:09 macmini kernel: [<ffffffff80235dd4>] 
warn_on_slowpath+0x64/0xc0
Sep 25 16:21:09 macmini kernel: [<ffffffff80346516>] __ratelimit+0x86/0xe0
Sep 25 16:21:09 macmini kernel: [<ffffffffa01063b3>] 
:ath5k:ath5k_hw_setup_4word_tx_desc+0x1a3/0x250
Sep 25 16:21:09 macmini kernel: [<ffffffffa0101fb2>] 
:ath5k:ath5k_tx+0x262/0x4c0
Sep 25 16:21:09 macmini kernel: [<ffffffffa0106210>] 
:ath5k:ath5k_hw_setup_4word_tx_desc+0x0/0x250
Sep 25 16:21:09 macmini kernel: [<ffffffffa009b3bd>] 
:mac80211:__ieee80211_tx+0x2d/0x150
Sep 25 16:21:09 macmini kernel: [<ffffffffa009baf0>] 
:mac80211:ieee80211_master_start_xmit+0x460/0x7a0
Sep 25 16:21:09 macmini kernel: [<ffffffff8042dc2b>] __qdisc_run+0x1db/0x250
Sep 25 16:21:09 macmini kernel: [<ffffffff8041e548>] 
dev_queue_xmit+0x2c8/0x3b0
Sep 25 16:21:09 macmini kernel: [<ffffffffa009c225>] 
:mac80211:ieee80211_subif_start_xmit+0x3f5/0x760
Sep 25 16:21:09 macmini kernel: [<ffffffffa043cbbb>] 
:nf_conntrack:__nf_conntrack_confirm+0x29b/0x2b0
Sep 25 16:21:09 macmini kernel: [<ffffffff80432ab8>] nf_iterate+0x68/0xa0
Sep 25 16:21:09 macmini kernel: [<ffffffff8042dc2b>] __qdisc_run+0x1db/0x250
Sep 25 16:21:09 macmini kernel: [<ffffffff8043e2f0>] 
ip_finish_output+0x0/0x2b0
Sep 25 16:21:09 macmini kernel: [<ffffffff8041e548>] 
dev_queue_xmit+0x2c8/0x3b0
Sep 25 16:21:09 macmini kernel: [<ffffffff8043d78f>] 
ip_push_pending_frames+0x2df/0x410
Sep 25 16:21:09 macmini kernel: [<ffffffff8045d44e>] 
udp_push_pending_frames+0x13e/0x3c0
Sep 25 16:21:09 macmini kernel: [<ffffffff8045ecbc>] udp_sendmsg+0x34c/0x700
Sep 25 16:21:09 macmini kernel: [<ffffffff80311ef7>] 
journal_stop+0x167/0x1e0
Sep 25 16:21:09 macmini kernel: [<ffffffff802bc40a>] __d_lookup+0xaa/0x140
Sep 25 16:21:09 macmini kernel: [<ffffffff8041031b>] sock_sendmsg+0xcb/0x100
Sep 25 16:21:09 macmini kernel: [<ffffffff802bcd62>] dput+0x92/0x140
Sep 25 16:21:09 macmini kernel: [<ffffffff80435da7>] 
__ip_route_output_key+0x167/0xa70
Sep 25 16:21:09 macmini kernel: [<ffffffff8024c040>] 
autoremove_wake_function+0x0/0x30
Sep 25 16:21:09 macmini kernel: [<ffffffff802b29ec>] path_walk+0xbc/0xd0
Sep 25 16:21:09 macmini kernel: [<ffffffff802b2be2>] 
do_path_lookup+0xa2/0x290
Sep 25 16:21:09 macmini kernel: [<ffffffff8045b130>] 
ip4_datagram_connect+0x230/0x2a0
Sep 25 16:21:09 macmini kernel: [<ffffffff8040fad2>] 
sockfd_lookup_light+0x22/0x90
Sep 25 16:21:09 macmini kernel: [<ffffffff80411049>] sys_sendto+0x119/0x180
Sep 25 16:21:09 macmini kernel: [<ffffffff80411195>] sys_connect+0xd5/0xe0
Sep 25 16:21:09 macmini kernel: [<ffffffff8020b73b>] 
system_call_after_swapgs+0x7b/0x80
Sep 25 16:21:09 macmini kernel:
Sep 25 16:21:09 macmini kernel: ---[ end trace 4bba0750c2376f51 ]---

