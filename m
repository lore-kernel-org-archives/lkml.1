Return-Path: <linux-kernel-owner+w=401wt.eu-S1760684AbXEPQuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760684AbXEPQuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 12:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756270AbXEPQt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 12:49:59 -0400
Received: from nz-out-0506.google.com ([64.233.162.228]:27513 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbXEPQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 12:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WuGcbkP6XmZUOqtkO/jeFkZCzyn09DSmkpofkLi3HhDS52O4GnjNQ8Qb+8mb+r+dVGJ21gfkXcO7+mHaMsGzuFhWjlXcOK3YorA6GQ8C1yLtBkH5vUUI2Ueve83ag+106QM2BTrYvNZsmRuLdSVv1ng+3aSsQokZ7oS4IfVKKrY=
Message-ID: <6bffcb0e0705160949m7486705s1b2fc5bbe8a025df@mail.gmail.com>
Date: Wed, 16 May 2007 18:49:57 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Bernd Schubert" <bschubert@q-leap.de>
Subject: Re: mkfs.ext2 triggered softlockup
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <f2fcc1$otm$2@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2fcc1$otm$2@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bernd,

On 16/05/07, Bernd Schubert <bschubert@q-leap.de> wrote:
> Maybe you still remember my report about an mkfs.ext2 triggered ram disk
> corruption?
>
> http://lkml.org/lkml/2007/5/4/272
>
> Well, in principle I'm now doing the same stuff, only this time with another
> initrd, which mounts the root-fs over nfs.
>
> [ 1596.928552] BUG: soft lockup detected on CPU#2!
> [ 1596.933109]
> [ 1596.933110] Call Trace:
> [ 1596.933111]  <IRQ>  [<ffffffff8025167b>] softlockup_tick+0xd8/0xef
> [ 1596.933129]  [<ffffffff802329f8>] run_local_timers+0x13/0x15
> [ 1596.933132]  [<ffffffff80232a44>] update_process_times+0x4a/0x77
> [ 1596.933138]  [<ffffffff8021434b>] smp_local_timer_interrupt+0x34/0x54
> [ 1596.933143]  [<ffffffff802143cc>] smp_apic_timer_interrupt+0x61/0x78
> [ 1596.933147]  [<ffffffff8020a29b>] apic_timer_interrupt+0x6b/0x70
> [ 1596.933151]  <EOI>  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> [ 1596.933162]  [<ffffffff80272a63>] kmem_cache_free+0x1f4/0x201
> [ 1596.933170]  [<ffffffff80299dff>] free_buffer_head+0x24/0x3e
> [ 1596.933175]  [<ffffffff80299ea1>] try_to_free_buffers+0x88/0x9f
> [ 1596.933181]  [<ffffffff802565a9>] try_to_release_page+0x39/0x40
> [ 1596.933188]  [<ffffffff8025b76d>] invalidate_mapping_pages+0x9d/0x121
> [ 1596.933196]  [<ffffffff8025b800>] invalidate_inode_pages+0xf/0x11
> [ 1596.933200]  [<ffffffff80299053>] invalidate_bdev+0x3b/0x3f
> [ 1596.933203]  [<ffffffff8029c9ee>] kill_bdev+0x13/0x29
> [ 1596.933208]  [<ffffffff8029d6e8>] __blkdev_put+0x62/0x141
> [ 1596.933213]  [<ffffffff8029db62>] blkdev_put+0xb/0xd
> [ 1596.933218]  [<ffffffff8029dbf7>] blkdev_close+0x2e/0x33
> [ 1596.933222]  [<ffffffff8027a3c3>] __fput+0xc3/0x172
> [ 1596.933228]  [<ffffffff8027a486>] fput+0x14/0x16
> [ 1596.933233]  [<ffffffff80278c4f>] filp_close+0x61/0x6d
> [ 1596.933238]  [<ffffffff80278ce7>] sys_close+0x8c/0xce
> [ 1596.933244]  [<ffffffff8020965e>] system_call+0x7e/0x83
> [ 1596.933250]

Can you tell me which kernel version you are using?

Regards,
Michal

-- 
Michal K. K. Piotrowski
Kernel Monkeys
(http://kernel.wikidot.com/start)
