Return-Path: <linux-kernel-owner+w=401wt.eu-S1754534AbYANImn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbYANImn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 03:42:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbYANImf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 03:42:35 -0500
Received: from brick.kernel.dk ([87.55.233.238]:16589 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183AbYANIme (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 03:42:34 -0500
Date: Mon, 14 Jan 2008 09:42:32 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, David Dillow <dillowda@ornl.gov>,
       Guillaume Chazarain <guichaz@yahoo.fr>, linux-kernel@vger.kernel.org,
       linux-btrace@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080114084231.GQ6258@kernel.dk>
References: <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <20080111122802.GT6258@kernel.dk> <20080111132106.GA16496@elte.hu> <20080111171855.GX6258@kernel.dk> <20080114075114.GA13195@elte.hu> <20080114083901.GA17897@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114083901.GA17897@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 14 2008, Christoph Hellwig wrote:
> 
> Folks, this is getting a little silly.

It is

> Even if CONFIG_NO_HZ is new this is a an important regression, and
> yes we should avoid regressions wherever we can, and for such a quite
> important feature we should fix it.  On the other hand blktrace is using
> the wrong interface, and it has been told multiple times on lkml that
> sched_clock() should never ever be used outside the scheduler.  So the
> burden to fix this regression lies on the shoulders of the blktrace
> maintainer.

That is true. So far alternatives have all been slower though, so not
very tempting to transition to.

> No need for silly name calling here.

I don't know what thread you are reading, but neiter Ingo nor I have
resorted to silly name calling. The thread has long since diverted from
the original topic, though.

-- 
Jens Axboe

