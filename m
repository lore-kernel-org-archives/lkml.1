Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbYH1O2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbYH1O2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752746AbYH1O2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:28:06 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:38990 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752303AbYH1O2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:28:05 -0400
Date: Thu, 28 Aug 2008 16:28:00 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: kmalloc args reversed, small function  definition  fixes
Message-ID: <20080828142800.GG20055@kernel.dk>
References: <1219868669.6069.53.camel@brick> <20080828072621.GQ20055@kernel.dk> <20080828141933.GA8937@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828141933.GA8937@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28 2008, Christoph Hellwig wrote:
> On Thu, Aug 28, 2008 at 09:26:21AM +0200, Jens Axboe wrote:
> > On Wed, Aug 27 2008, Harvey Harrison wrote:
> > > Noticed by sparse:
> > > block/blk-softirq.c:156:12: warning: symbol 'blk_softirq_init' was not declared. Should it be static?
> > > block/genhd.c:583:28: warning: function 'bdget_disk' with external linkage has definition
> > > block/genhd.c:659:17: warning: incorrect type in argument 1 (different base types)
> > > block/genhd.c:659:17:    expected unsigned int [unsigned] [usertype] size
> > > block/genhd.c:659:17:    got restricted gfp_t
> > > block/genhd.c:659:29: warning: incorrect type in argument 2 (different base types)
> > > block/genhd.c:659:29:    expected restricted gfp_t [usertype] flags
> > > block/genhd.c:659:29:    got unsigned int
> > > block: kmalloc args reversed
> > 
> > Woops, that kmalloc() is nasty. Thanks a lot, applied to for-2.6.28.
> 
> Umm, the gfp bit sounds like a clear 2.6.27 candidate.

I would agree, except the bug is introduced by a patch in the 2.6.28
series :-)

-- 
Jens Axboe

