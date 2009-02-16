Return-Path: <linux-kernel-owner+w=401wt.eu-S1753857AbZBPToS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857AbZBPToS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:44:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbZBPToF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:44:05 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40290 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZBPToE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:44:04 -0500
Date: Mon, 16 Feb 2009 19:44:01 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lin Ming <ming.m.lin@intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [patch] SLQB slab allocator (try 2)
Message-ID: <20090216194401.GC31264@csn.ul.ie>
References: <20090123154653.GA14517@wotan.suse.de> <200902041748.41801.nickpiggin@yahoo.com.au> <20090204152709.GA4799@csn.ul.ie> <200902051459.30064.nickpiggin@yahoo.com.au> <20090216184200.GA31264@csn.ul.ie> <84144f020902161125r59de8a53nfe01566d20ff1658@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <84144f020902161125r59de8a53nfe01566d20ff1658@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 09:25:35PM +0200, Pekka Enberg wrote:
> Hi Mel,
> 
> On Mon, Feb 16, 2009 at 8:42 PM, Mel Gorman <mel@csn.ul.ie> wrote:
> > Slightly later than hoped for, but here are the results of the profile
> > run between the different slab allocators. It also includes information on
> > the performance on SLUB with the allocator pass-thru logic reverted by commit
> > http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=97a4871761e735b6f1acd3bc7c3bac30dae3eab9
> 
> Did you just cherry-pick the patch or did you run it with the
> topic/slub/perf branch?

Cherry picked to minimise the number of factors involved.

> There's a follow-up patch from Yanmin which
> will make a difference for large allocations when page-allocator
> pass-through is reverted:
> 
> http://git.kernel.org/?p=linux/kernel/git/penberg/slab-2.6.git;a=commitdiff;h=79b350ab63458ef1d11747b4f119baea96771a6e
> 

Is this expected to make a difference to workloads that are not that
allocator intensive? I doubt it'll make much different to speccpu but
conceivably it makes a difference to sysbench.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
