Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbZBZUXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbZBZUXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 15:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZBZUXn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 15:23:43 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:36984 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbZBZUXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 15:23:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=JPgmJLzVW93AvnbUmnkAzgS4Ods9sCehIdUgw0rHHC+eb9A7xcEA79+hT+HJJcu2wO
         ghf58hc7K1Z1M75rXVqjxBb2wx0k8ElzjFqxFd1ASNKbrBDMGlYnfjZWIL4DkFkNSr/f
         ni4dVkxteWy17cedHisVXZyI2S6dPFzxGi6v8=
MIME-Version: 1.0
Date: Thu, 26 Feb 2009 21:23:38 +0100
Message-ID: <c4e36d110902261223v34f6fdd7xcec34ff89fff8f6e@mail.gmail.com>
Subject: WARNING: at drivers/gpu/drm/i915/i915_gem.c:3051 i915_gem_idle+0x314/0x320 
	[i915]()
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Karsten Wiese <fzu@wemgehoertderstaat.de>, keithp@keithp.com,
       eric@anholt.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I'm getting this warning message

My kernel is  2.6.29-rc6  f7e603ad8f78cd3b59e33fa72707da0cbabdf699

so it contains:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=6c0594a306790ab03db345086c0c6c922a900bf6

Zdenek

hw: T61, i965, 4GB


------------[ cut here ]------------
WARNING: at drivers/gpu/drm/i915/i915_gem.c:3051
i915_gem_idle+0x314/0x320 [i915]()
Hardware name: 6464CTO
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT
xt_tcpudp iptabl
e_filter ip_tables x_tables bridge stp llc sco l2cap bluetooth autofs4
sunrpc ipv6 binfmt_misc dm_mirror dm_region_hash dm_log dm_mod
kvm_intel kvm i915 drm i2c_alg
o_bit uinput snd_hda_codec_analog snd_hda_intel snd_hda_codec arc4
snd_seq_oss ecb snd_seq_midi_event cryptomgr snd_seq aead
snd_seq_device snd_pcm_oss crypto_blkci
pher crypto_hash snd_mixer_oss crypto_algapi iwl3945 mac80211 snd_pcm
snd_timer thinkpad_acpi snd sdhci_pci rfkill backlight evdev sdhci
mmc_core led_class lib80211
 sr_mod cdrom i2c_i801 cfg80211 usbhid psmouse serio_raw i2c_core
nvram soundcore hid e1000e rtc_cmos rtc_core intel_agp iTCO_wdt
iTCO_vendor_support snd_page_alloc
 battery ac rtc_lib button uhci_hcd ohci_hcd ehci_hcd usbcore [last
unloaded: oprofile]
Pid: 2610, comm: X Not tainted 2.6.29-rc6 #37
Call Trace:
 [<ffffffff80246b8f>] warn_slowpath+0xaf/0xf0
 [<ffffffff802dcb3e>] ? kfree+0xbe/0x140
 [<ffffffff8027275a>] ? trace_hardirqs_on_caller+0x18a/0x1f0
 [<ffffffff802727cd>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa031ad68>] ? i915_gem_retire_requests+0x128/0x180 [i915]
 [<ffffffffa031c204>] i915_gem_idle+0x314/0x320 [i915]
 [<ffffffffa031c291>] i915_gem_leavevt_ioctl+0x31/0x50 [i915]
 [<ffffffffa02e4afe>] drm_ioctl+0x10e/0x360 [drm]
 [<ffffffffa031c260>] ? i915_gem_leavevt_ioctl+0x0/0x50 [i915]
 [<ffffffff802f010c>] vfs_ioctl+0x7c/0xa0
 [<ffffffff802f046b>] do_vfs_ioctl+0x33b/0x5d0
 [<ffffffff8054dad3>] ? error_sti+0x5/0x6
 [<ffffffff8020d369>] ? retint_swapgs+0xe/0x13
 [<ffffffff8020d369>] ? retint_swapgs+0xe/0x13
 [<ffffffff802f0781>] sys_ioctl+0x81/0xa0
 [<ffffffff8020c88b>] system_call_fastpath+0x16/0x1b
---[ end trace 50149c514c3a95c4 ]---
[drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for
disabled pipe 0
X:2610 freeing invalid memtype e0000000-f0000000
X:2610 freeing invalid memtype e0000000-f0000000
