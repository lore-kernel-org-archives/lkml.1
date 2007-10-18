Return-Path: <linux-kernel-owner+w=401wt.eu-S1765399AbXJRMKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765399AbXJRMKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 08:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbXJRMK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 08:10:29 -0400
Received: from brick.kernel.dk ([87.55.233.238]:14880 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760971AbXJRMK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 08:10:28 -0400
Date: Thu, 18 Oct 2007 14:09:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018120950.GX5063@kernel.dk>
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071018.050554.115911163.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Thu, 18 Oct 2007 13:57:02 +0200
> 
> > Thanks a lot, Dave! The patch is a monster right now, I'll work on
> > splitting it into a 3-step process. Any arch help is greatly
> > appreciated.
> 
> I have some other bits that my compile hit, such as some things in the
> crypto layer.

Yeah, I have tons of that so far. I hope to have an allyesconfig
compiling pretty soonish, will send that out then.

> But I hesitate to send them to you because I think the on-stack cases
> need some helpers such that DEBUG_SG works for them.

Indeed. I convert where appropriate, but I'm not anal about it. If they
don't use sg_next() and/or for_each_sg() on their list, it should be ok.
Don't want to make the changes more than necessary right now.

> BTW, you missed a case in drivers/usb/core/message.c because of
> the config used in your build.  This thing below is a good
> argument for trying to avoid HIGHMEM et al. ifdefs in drivers :-)

Thanks :-)

-- 
Jens Axboe

