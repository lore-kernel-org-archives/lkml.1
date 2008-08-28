Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYH1OTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYH1OTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 10:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbYH1OTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 10:19:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39053 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726AbYH1OTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 10:19:45 -0400
Date: Thu, 28 Aug 2008 10:19:33 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: kmalloc args reversed, small function
	definition  fixes
Message-ID: <20080828141933.GA8937@infradead.org>
References: <1219868669.6069.53.camel@brick> <20080828072621.GQ20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080828072621.GQ20055@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2008 at 09:26:21AM +0200, Jens Axboe wrote:
> On Wed, Aug 27 2008, Harvey Harrison wrote:
> > Noticed by sparse:
> > block/blk-softirq.c:156:12: warning: symbol 'blk_softirq_init' was not declared. Should it be static?
> > block/genhd.c:583:28: warning: function 'bdget_disk' with external linkage has definition
> > block/genhd.c:659:17: warning: incorrect type in argument 1 (different base types)
> > block/genhd.c:659:17:    expected unsigned int [unsigned] [usertype] size
> > block/genhd.c:659:17:    got restricted gfp_t
> > block/genhd.c:659:29: warning: incorrect type in argument 2 (different base types)
> > block/genhd.c:659:29:    expected restricted gfp_t [usertype] flags
> > block/genhd.c:659:29:    got unsigned int
> > block: kmalloc args reversed
> 
> Woops, that kmalloc() is nasty. Thanks a lot, applied to for-2.6.28.

Umm, the gfp bit sounds like a clear 2.6.27 candidate.
