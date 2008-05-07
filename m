Return-Path: <linux-kernel-owner+w=401wt.eu-S1756985AbYEGODs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985AbYEGODs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYEGODh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:03:37 -0400
Received: from po-out-1718.google.com ([72.14.252.158]:1165 "EHLO
	po-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYEGODe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:03:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=T6la7HAOF4gejmEvPZz3WWxJQolueNbG0okOxNQ+mV2HD6qJQ+NcePIiAT6ImQfNEBTSdMjXylxJrzb654G+D8AFjZ+w5V3RhWTyKz7OgGbrGhF+0jb0IwA+w5sHPeaYs/hYRxgFgyi/mehj1utzONLK9PVNqy1/ZDgQYMx+gl4=
Message-ID: <c4e36d110805070703s63c2426csd795d0e953a6e7bb@mail.gmail.com>
Date: Wed, 7 May 2008 16:03:33 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Subject: general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

Unsure whether this is already fixed with latest git - I've got this ooops with
commit 8a3415c4a692732de8278396bf3d3dda36ed4384

My machine 2GB T61 C2D
And after this boot  audio was not working.

Next reboot seemed to go just ok.

Zdenek


ACPI: PCI Interrupt 0000:00:1b.0[B] -> GSI 17 (level, low) -> IRQ 17
hda_intel: probe_mask set to 0x1 for device 17aa:20ac
general protection fault: 0000 [1] PREEMPT SMP DEBUG_PAGEALLOC
CPU 0
Modules linked in: kvm_intel kvm snd_hda_intel mmc_block arc4 ecb
snd_seq_oss snd_seq_midi_event snd_seq crypto_blkcipher snd_seq_device
snd_pcm_oss cryptomgr snd_mixer_oss snd_pcm rtc_cmos snd_timer sdhci
evdev rtc_core crypto_algapi iwl3945 mac80211 thinkpad_acpi snd video
mmc_core rtc_lib led_class psmouse i2c_i801 i2c_core sr_mod backlight
nvram iTCO_wdt iTCO_vendor_support cdrom serio_raw cfg80211 e1000e
soundcore output ac battery snd_page_alloc button intel_agp uhci_hcd
ohci_hcd ehci_hcd usbcore
Pid: 608, comm: udevd Not tainted 2.6.26-rc1 #4
RIP: 0010:[kernel_map_pages+158/368]  [kernel_map_pages+158/368]
kernel_map_pages+0x9e/0x170
RSP: 0018:ffff81007db45c28  EFLAGS: 00010206
RAX: 0000000000000660 RBX: 0000000000000001 RCX: ffff81007db45c28
RDX: 00000000000006e0 RSI: ffff81007db45be4 RDI: ffffffff81000000
RBP: ffff81007db45c78 R08: 000000007cb6b000 R09: ffff810000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffffe20002e467c0
R13: 0000000000000002 R14: ffff81007ca74920 R15: 0000000000000282
FS:  00007f5eb4aef780(0000) GS:ffffffff81494000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 00007fffbcb28ef0 CR3: 000000007d88e000 CR4: 0000000000002660
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process udevd (pid: 608, threadinfo ffff81007db44000, task ffff81007ca74920)
Stack:  ffff81007b66c000 0000000000000003 0000000000000000 0000000100000001
 000000000007b66b 0000000000000000 ffff81007db45c78 0000000000000005
 ffffe20002e467c0 0000000000000000 ffff81007db45d38 ffffffff810923b9
Call Trace:
 [get_page_from_freelist+1161/1632] get_page_from_freelist+0x489/0x660
 [__alloc_pages_internal+271/1408] __alloc_pages_internal+0x10f/0x580
 [kmem_cache_alloc+168/208] ? kmem_cache_alloc+0xa8/0xd0
 [__alloc_pages+11/16] __alloc_pages+0xb/0x10
 [__get_free_pages+28/96] __get_free_pages+0x1c/0x60
 [copy_process+187/5184] copy_process+0xbb/0x1440
 [put_lock_stats+14/48] ? put_lock_stats+0xe/0x30
 [do_fork+116/816] do_fork+0x74/0x330
 [trace_hardirqs_on+305/400] ? trace_hardirqs_on+0x131/0x190
 [_spin_unlock_irqrestore+69/144] ? _spin_unlock_irqrestore+0x45/0x90
 [__up_write+208/304] ? __up_write+0xd0/0x130
 [trace_hardirqs_on_thunk+53/58] ? trace_hardirqs_on_thunk+0x35/0x3a
 [system_call_after_swapgs+123/128] ? system_call_after_swapgs+0x7b/0x80
 [sys_clone+35/48] sys_clone+0x23/0x30
 [ptregscall_common+103/176] ptregscall_common+0x67/0xb0


Code: 7d b0 48 0f af c2 48 ba 00 00 00 00 00 81 ff ff 48 c1 e0 0c 48
01 d0 48 89 45 b0 e8 2d f6 ff ff 0f 20 e2 48 89 d0 24 7f 0f 22 e0 <0f>
22 e2 31 ff e8 18 f5 ff ff 48 8b 5d e8 4c 8b 65 f0 4c 8b 6d
RIP  [kernel_map_pages+158/368] kernel_map_pages+0x9e/0x170
 RSP <ffff81007db45c28>
---[ end trace cfd75e758edeef62 ]---
