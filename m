Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZJNHaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZJNHaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 03:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZJNHaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 03:30:14 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48847 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371AbZJNHaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 03:30:13 -0400
Message-ID: <4AD57DDD.3040201@garzik.org>
Date: Wed, 14 Oct 2009 03:29:33 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: tino.keitel@tikei.de
CC: linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: Re: ATA related kernel warning after resume with 2.6.32-rc4
References: <20091014065555.GA6968@mac.home>
In-Reply-To: <20091014065555.GA6968@mac.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2009 02:55 AM, Tino Keitel wrote:
> Hi,
>
> I get this warning after resume from suspend to RAM:
>
> ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 (SET FEATURES) filtered out
> ata1.00: ACPI cmd ef/03:42:00:00:00:a0 (SET FEATURES) filtered out
> ata1.00: configured for UDMA/33
> firewire_core: rediscovered device fw0
> sd 2:0:1:0: [sda] Starting disk
> firewire_core: phy config: card 0, new root=ffc1, gap_count=5
> ------------[ cut here ]------------
> WARNING: at drivers/ata/libata-core.c:5039
> ata_qc_complete+0x1ec/0x260()
> Hardware name: Macmini2,1
> Modules linked in: ipv6 fbcon font bitblit softcursor i915
> drm_kms_helper drm fb i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect
> loop btusb bluetooth firewire_sbp2 snd_hda_codec_idt dvb_usb dvb_core
> video backlight output snd_hda_intel firewire_ohci usblp firewire_core
> sky2 snd_hda_codec evdev crc_itu_t snd_pcm snd_timer snd_page_alloc
> [last unloaded: dvb_usb_vp7045]
> Pid: 254, comm: ata/0 Not tainted 2.6.32-rc4-00001-gd93a8f8 #24
> Call Trace:
>   [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
>   [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
>   [<ffffffff8103ceb4>] ? warn_slowpath_common+0x74/0xd0
>   [<ffffffff8130b5ac>] ? ata_qc_complete+0x1ec/0x260
>   [<ffffffff81318100>] ? ata_do_link_abort+0xa0/0xe0
>   [<ffffffff8131b01f>] ? ata_hsm_qc_complete+0x15f/0x170
>   [<ffffffff8131b1ca>] ? ata_sff_hsm_move+0x19a/0x700
>   [<ffffffff8131bacf>] ? ata_pio_task+0x2f/0x110
>   [<ffffffff8131baa0>] ? ata_pio_task+0x0/0x110
>   [<ffffffff8104eb8b>] ? worker_thread+0x12b/0x1f0
>   [<ffffffff81052ee0>] ? autoremove_wake_function+0x0/0x30
>   [<ffffffff8104ea60>] ? worker_thread+0x0/0x1f0
>   [<ffffffff81052b56>] ? kthread+0x96/0xa0
>   [<ffffffff8100cc1a>] ? child_rip+0xa/0x20
>   [<ffffffff81052ac0>] ? kthread+0x0/0xa0
>   [<ffffffff8100cc10>] ? child_rip+0x0/0x20
> ---[ end trace 158461bf60ae353f ]---
> ata3.01: NODEV after polling detection
> ata3.01: revalidation failed (errno=-2)

Can you email your full dmesg and lspci?

Also, note that linux-ide was added to CC.

	Jeff




