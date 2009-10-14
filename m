Return-Path: <linux-kernel-owner+w=401wt.eu-S932118AbZJNHPT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932118AbZJNHPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:15:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756643AbZJNHPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:15:16 -0400
Received: from eazy.amigager.de ([213.239.192.238]:50211 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572AbZJNHPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:15:13 -0400
X-Greylist: delayed 1113 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2009 03:15:13 EDT
Date: Wed, 14 Oct 2009 08:55:55 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-kernel@vger.kernel.org
Subject: ATA related kernel warning after resume with 2.6.32-rc4
Message-ID: <20091014065555.GA6968@mac.home>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get this warning after resume from suspend to RAM:

ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
ata1.00: configured for UDMA/33
firewire_core: rediscovered device fw0
sd 2:0:1:0: [sda] Starting disk
firewire_core: phy config: card 0, new root=ffc1, gap_count=5
------------[ cut here ]------------
WARNING: at drivers/ata/libata-core.c:5039
ata_qc_complete+0x1ec/0x260()
Hardware name: Macmini2,1
Modules linked in: ipv6 fbcon font bitblit softcursor i915
drm_kms_helper drm fb i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect
loop btusb bluetooth firewire_sbp2 snd_hda_codec_idt dvb_usb dvb_core
video backlight output snd_hda_intel firewire_ohci usblp firewire_core
sky2 snd_hda_codec evdev crc_itu_t snd_pcm snd_timer snd_page_alloc
[last unloaded: dvb_usb_vp7045]
Pid: 254, comm: ata/0 Not tainted 2.6.32-rc4-00001-gd93a8f8 #24
Call Trace:
 [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
 [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
 [<ffffffff8103ceb4>] ? warn_slowpath_common+0x74/0xd0
 [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
 [<ffffffff81318100>] ? ata_do_link_abort+0xa0/0xe0
 [<ffffffff8131b01f>] ? ata_hsm_qc_complete+0x15f/0x170
 [<ffffffff8131b1ca>] ? ata_sff_hsm_move+0x19a/0x700
 [<ffffffff8131bacf>] ? ata_pio_task+0x2f/0x110
 [<ffffffff8131baa0>] ? ata_pio_task+0x0/0x110
 [<ffffffff8104eb8b>] ? worker_thread+0x12b/0x1f0
 [<ffffffff81052ee0>] ? autoremove_wake_function+0x0/0x30
 [<ffffffff8104ea60>] ? worker_thread+0x0/0x1f0
 [<ffffffff81052b56>] ? kthread+0x96/0xa0
 [<ffffffff8100cc1a>] ? child_rip+0xa/0x20
 [<ffffffff81052ac0>] ? kthread+0x0/0xa0
 [<ffffffff8100cc10>] ? child_rip+0x0/0x20
---[ end trace 158461bf60ae353f ]---
ata3.01: NODEV after polling detection
ata3.01: revalidation failed (errno=-2)

Regards,
Tino
