Return-Path: <linux-kernel-owner+w=401wt.eu-S932847AbZHDPUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932847AbZHDPUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932649AbZHDPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:20:53 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:57101 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbZHDPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:20:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jvAkXHkXjA3VvgsdW0loI4WFN45GSwJSDEjdqNcMMJ7cvWH5O4T35d493hDlxLegQq
         3Gll3h8kD6AVubH/Ib+YpYL9OY+zofXK/VlxUN8IUa8xHfmxzSItSORYNtWdeqTjsjuv
         UiGY5Ft96oGQK8FImm0/kS3vGZyLcoNPmF9T4=
MIME-Version: 1.0
Date: Tue, 4 Aug 2009 17:12:43 +0200
Message-ID: <c4e36d110908040812k48dfc946ka9a0161d7aa03031@mail.gmail.com>
Subject: Oprofile warnings
From: Zdenek Kabelac <zdenek.kabelac@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: oprofile-list@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

These two warning messages appeared in my message log while using oprofile.
(2.6.31-rc5 and oprofile-0.9.4-13.fc12.x86_64)



oprofile: using NMI interrupt.
------------[ cut here ]------------
WARNING: at kernel/trace/ring_buffer.c:2289 rb_advance_reader+0xc1/0xd0()
Hardware name: 6464CTO
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc sunrpc autofs4 ipv6
nf_conntrack_ftp nf_conntrack binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 drm i2c_algo_bit uinput
snd_hda_codec_analog arc4 h826d ecb averusbh826d dvb_core cryptomgr
videodev aead v4l1_compat v4l2_compat_ioctl32 snd_hda_intel
snd_hda_codec snd_seq_oss pcompress crypto_blkcipher crypto_hash
crypto_algapi btusb snd_seq_midi_event snd_seq iwl3945 sdhci_pci
iwlcore snd_seq_device sdhci bluetooth mac80211 snd_pcm_oss mmc_core
cfg80211 snd_mixer_oss snd_pcm snd_timer i2c_i801 snd sr_mod i2c_core
psmouse iTCO_wdt video cdrom soundcore usbhid hid evdev thinkpad_acpi
led_class serio_raw iTCO_vendor_support intel_agp snd_page_alloc
rtc_cmos rtc_core rtc_lib rfkill e1000e backlight output nvram battery
button ac uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 10, comm: events/1 Not tainted 2.6.31-rc5-00002-g43e068f #79
Call Trace:
 [<ffffffff8104c4eb>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff8104c544>] warn_slowpath_null+0x14/0x20
 [<ffffffff810ae041>] rb_advance_reader+0xc1/0xd0
 [<ffffffff810aed4a>] ring_buffer_consume+0xca/0x170
 [<ffffffffa061138d>] op_cpu_buffer_read_entry+0x2d/0xc0 [oprofile]
 [<ffffffffa061233f>] ? sync_buffer+0x1ef/0x520 [oprofile]
 [<ffffffffa061227e>] sync_buffer+0x12e/0x520 [oprofile]
 [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
 [<ffffffffa0611920>] ? wq_sync_buffer+0x0/0x90 [oprofile]
 [<ffffffffa0611951>] wq_sync_buffer+0x31/0x90 [oprofile]
 [<ffffffff810613d8>] worker_thread+0x1e8/0x3a0
 [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
 [<ffffffff8137c11b>] ? thread_return+0x3e/0x703
 [<ffffffff81066d60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810611f0>] ? worker_thread+0x0/0x3a0
 [<ffffffff8106697e>] kthread+0x9e/0xb0
 [<ffffffff8100d1da>] child_rip+0xa/0x20
 [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
 [<ffffffff810668e0>] ? kthread+0x0/0xb0
 [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
---[ end trace 6ac8f069d92dd483 ]---
------------[ cut here ]------------
WARNING: at kernel/trace/ring_buffer.c:2289 rb_advance_reader+0xc1/0xd0()
Hardware name: 6464CTO
Modules linked in: oprofile fuse ipt_MASQUERADE iptable_nat nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_state ipt_REJECT xt_tcpudp
iptable_filter ip_tables x_tables bridge stp llc sunrpc autofs4 ipv6
nf_conntrack_ftp nf_conntrack binfmt_misc dm_mirror dm_region_hash
dm_log dm_mod kvm_intel kvm i915 drm i2c_algo_bit uinput
snd_hda_codec_analog arc4 h826d ecb averusbh826d dvb_core cryptomgr
videodev aead v4l1_compat v4l2_compat_ioctl32 snd_hda_intel
snd_hda_codec snd_seq_oss pcompress crypto_blkcipher crypto_hash
crypto_algapi btusb snd_seq_midi_event snd_seq iwl3945 sdhci_pci
iwlcore snd_seq_device sdhci bluetooth mac80211 snd_pcm_oss mmc_core
cfg80211 snd_mixer_oss snd_pcm snd_timer i2c_i801 snd sr_mod i2c_core
psmouse iTCO_wdt video cdrom soundcore usbhid hid evdev thinkpad_acpi
led_class serio_raw iTCO_vendor_support intel_agp snd_page_alloc
rtc_cmos rtc_core rtc_lib rfkill e1000e backlight output nvram battery
button ac uhci_hcd ohci_hcd ehci_hcd usbcore [last unloaded:
microcode]
Pid: 9, comm: events/0 Tainted: G        W  2.6.31-rc5-00002-g43e068f #79
Call Trace:
 [<ffffffff8104c4eb>] warn_slowpath_common+0x7b/0xc0
 [<ffffffff8104c544>] warn_slowpath_null+0x14/0x20
 [<ffffffff810ae041>] rb_advance_reader+0xc1/0xd0
 [<ffffffff810aed4a>] ring_buffer_consume+0xca/0x170
 [<ffffffffa061138d>] op_cpu_buffer_read_entry+0x2d/0xc0 [oprofile]
 [<ffffffffa061227e>] sync_buffer+0x12e/0x520 [oprofile]
 [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
 [<ffffffffa0611920>] ? wq_sync_buffer+0x0/0x90 [oprofile]
 [<ffffffffa0611951>] wq_sync_buffer+0x31/0x90 [oprofile]
 [<ffffffff810613d8>] worker_thread+0x1e8/0x3a0
 [<ffffffff81061386>] ? worker_thread+0x196/0x3a0
 [<ffffffff8137c11b>] ? thread_return+0x3e/0x703
 [<ffffffff81066d60>] ? autoremove_wake_function+0x0/0x40
 [<ffffffff810611f0>] ? worker_thread+0x0/0x3a0
 [<ffffffff8106697e>] kthread+0x9e/0xb0
 [<ffffffff8100d1da>] child_rip+0xa/0x20
 [<ffffffff8100cb7c>] ? restore_args+0x0/0x30
 [<ffffffff810668e0>] ? kthread+0x0/0xb0
 [<ffffffff8100d1d0>] ? child_rip+0x0/0x20
---[ end trace 6ac8f069d92dd484 ]---

Zdenek
