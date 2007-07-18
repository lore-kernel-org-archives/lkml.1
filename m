Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbXGRJJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbXGRJJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 05:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbXGRJIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 05:08:54 -0400
Received: from box.memset.com ([89.200.136.113]:45306 "EHLO box.memset.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752289AbXGRJIx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 05:08:53 -0400
X-Greylist: delayed 1885 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jul 2007 05:08:53 EDT
To: linux-kernel@vger.kernel.org
Cc: Zan Lynx <zlynx@acm.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
In-Reply-To: <8HZlt-27o-7@gated-at.bofh.it>
References: <8HfVl-71J-15@gated-at.bofh.it> <8Hgoq-7Cd-21@gated-at.bofh.it> <8Hz7K-38K-37@gated-at.bofh.it> <8HHeZ-7R1-21@gated-at.bofh.it> <8HHoA-835-21@gated-at.bofh.it> <8HHI2-8r2-27@gated-at.bofh.it> <8HI1k-Dn-25@gated-at.bofh.it> <8HIb2-PD-11@gated-at.bofh.it> <8HIun-1e7-33@gated-at.bofh.it> <8HJA3-2Nq-9@gated-at.bofh.it> <8HXWo-8t2-17@gated-at.bofh.it> <8HYzd-PZ-25@gated-at.bofh.it> <8HZlt-27o-7@gated-at.bofh.it>
Date: Wed, 18 Jul 2007 09:37:24 +0100
Message-Id: <20070718083724.6639B14C167@irishsea.home.craig-wood.com>
From: nick@craig-wood.com (Nick Craig-Wood)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Zan Lynx <zlynx@acm.org> wrote:
>  There *are* crashes from LVM and ext3.  I had to change kernels to avoid
>  them.
> 
>  I had crashes with ext3 on LVM snapshot on DM mirror on SATA.

We've noticed these too... ext3/LVM/raid0/sata seems fine.  If you add
snapshot in that mix then it becomes rather unreliable.

-- 
Nick Craig-Wood <nick@craig-wood.com> -- http://www.craig-wood.com/nick
