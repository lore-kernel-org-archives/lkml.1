Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbZLRJ5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbZLRJ5P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 04:57:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753096AbZLRJ5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 04:57:14 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:40403 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbZLRJ5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 04:57:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=orXE5HJhn8z7pPFFzcx9Bqe559qBCRw5zRcAT6BFR7FoIgE0JqH6agKkw8e0eF/4By
         gfJL5qO5OblJfBCR5byd2KCOYrLuSKHtT93gdGoEXpN1lBI1wStJEZXOU5rBqKph1/X8
         dKYoWGdlDI68UTFmZDKVzNVKk7zY93En24EWI=
MIME-Version: 1.0
In-Reply-To: <696f7f5e0912180144j27a6fd7cj2492b57259314871@mail.gmail.com>
References: <696f7f5e0912180141n23658a18l428157b0ea1d8f47@mail.gmail.com>
	 <696f7f5e0912180144j27a6fd7cj2492b57259314871@mail.gmail.com>
Date: Fri, 18 Dec 2009 13:57:09 +0400
Message-ID: <1a297b360912180157m24da5eb2q2df4508e7280e521@mail.gmail.com>
Subject: Re: Technotrend S2-1600 - initialization bug
From: Manu Abraham <abraham.manu@gmail.com>
To: Andrey Gangan <a.gangan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 18, 2009 at 1:44 PM, Andrey Gangan <a.gangan@gmail.com> wrote:
> Hello!
>
> I have Technotrend S2-1600 satellite tv tuner. Fedora 11 used kernel,
> which do not support this tuner.
> I have installed Fedora 12 x64 kernel 2.6.31-14
> When booting I have to wait very long and did not get login screen.
> I pressed ESC and I
> and saw the error connected with this tuner.
> I made a picture of the screen by digital camera, and type it below:
>
> udev: BUG: unable to handle kernel NULL pointer dereference at 00000000000000b0
> IP: [<ffffffffa01220d6>] dvb_frontend_detach+0xc/0x82 [dvb_core]
> PGD 0
> Oops: 0000 [#1] SMP
> last sysfs file: /sys/module/snd_timer/initstate
> CPU 0
> Modules linked in: ath5k(+) snd_hwdep mac80211 firewire_ohci(+)
> snd_seq snd_seq_device budget(+) snd_pcm atl1e budget_core ath
> firewire_core saa7146 snd_timer cfg80211 iTCO_vendor_support
> ttpci_eeprom crc_itu_t snd dvb_core soundcore rfkill serio_raw
> i2c_i801 sbnd_page_alloc asus_atk0110 nouveau ttm drm_kms_helper drm
> i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
> Pid: 578, comm: work_for_cpu Not tainted 2.6.31.6-166.fc12.x86_64 #1 P5Q PRO
> RIP: 0010:[<ffffffffa01220d6>]dvb_frontend_detach+0xc/0x82 [dvb_core]
> RSP: 0018:ffff88012a4f3de0  EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff880126582000 RCX: 0000000000000891
> RDX: 0000000000000000 RSI: 0000000000000046 RDI: 0000000000000000
> RBP: ffff88012a4f3df0 R08: ffffffff815f61c0 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff880124e361c8 R12: 0000000000000000
> R13: ffff880128984800 R14: ffffffffa01c7f20 R15: 0000000000001000
> FS:  0000000000000000(0000) GS: ffff880028022000(0000) knlGS: 0000000000000000
> CS:   0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000000 CR3: 0000000001001000 CR4: 00000000000006f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process work_for_cpu (pid: 578, threadinfo ffff88012a4f2000, task
> ffff880124e35e00)
> Stack:
>  ffff880126582000 0000000000000000 ffff88012a4f3e60 ffffffffa01c5913
> [<ffffffffa01c5913>] budget_attach+0xc87/0xd50 [budget]
> [<ffffffff81418c2f>] ? printk+0x41/0x4a
> [<ffffffff8102ee3e>] ? x86_swiotlb_alloc_coherent+0x21/0x40
> [<ffffffffa0183960>] saa7146_init_one+0x44f/0x563 [saa7146]
> [<ffffffff81063b56>] ? do_work_for_cpu+0x0/0x2a
> [<ffffffff81210311>] local_pci_probe+0x17/0x1b
> [<ffffffff81063b6e>] do_work_for_cpu+0x18/0x2a
> [<ffffffff81067781>] kthread+0x91/0x99
> [<ffffffff81012daa>] child_rip+0xa/0x20
> [<ffffffff810676f0>] ? kthread+0x0/0x99
> [<ffffffff81012da0>] ? child_rip+0x0/0x20
> Code: 90 55 48 89 e5 48 83 ec 20 0f 1f 44 00 00 48 39 f1 8d 81 40 42
> 0f 00 7c 02 89 c8 29 f0 c9 c3 55 48 89 e5 41 54 53 0f 1f 44 00 00 <48>
> 8b 87 b0 00 00 00 48 89 fb 48 85 c0 74 0e ff d0 48 8b bb b0
> RIP [<ffffffffa01220d6>] dvb_frontend_detach+0xc/0x82 [dvb_core]
>  RSP <ffff88012a4f3de0>
> CR2: 0000000000000000
> ---[ end trace b0f11a44bf3a4233 ]---

Are you able to reproduce the same issue, when you this repository:
http://linuxtv.org/hg/v4l-dvb


Regards,
Manu
