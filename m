Return-Path: <linux-kernel-owner+w=401wt.eu-S1765818AbXINOeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765818AbXINOeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 10:34:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753128AbXINOd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 10:33:58 -0400
Received: from gir.skynet.ie ([193.1.99.77]:55683 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbXINOd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 10:33:57 -0400
Date: Fri, 14 Sep 2007 15:33:55 +0100
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/13] Reduce external fragmentation by grouping pages by mobility v30
Message-ID: <20070914143355.GD30407@skynet.ie>
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie> <20070913180156.ee0cdec4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070913180156.ee0cdec4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (13/09/07 18:01), Andrew Morton didst pronounce:
> On Mon, 10 Sep 2007 12:20:11 +0100 (IST) Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Here is a restacked version of the grouping pages by mobility patches
> > based on the patches currently in your tree. It should be  a drop-in
> > replacement for what is in 2.6.23-rc4-mm1 and is what I propose for merging
> > to mainline.
> 
> It really gives me the creeps to throw away a large set of large patches
> and to then introduce a new set.
> 

I can understand that logic.

> What would go wrong if we just merged the patches I already have?
> 

Nothing, the end result is more or less the same. There are three style
cleanups in the restack and for some reason, one of the functions moved
but otherwise they are identical.

The restacked version was provided to illustrate what the final stack really
looks like and because I thought you would prefer it over a stack that had
one patch introducing a change and a later patch removing it (like making
it configurable for example). It also allowed us to test against mainline
to make sure everything was ok prior to the merge.

Go ahead with the patches you already
have if you prefer. Just make sure not to include
breakout-page_order-to-internalh-to-avoid-special-knowledge-of-the-buddy-allocator.patch
as it's only required for page-owner-tracking.

Thanks Andrew.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
