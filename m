Return-Path: <linux-kernel-owner+w=401wt.eu-S1161263AbXDQRsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161263AbXDQRsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 13:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161260AbXDQRst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 13:48:49 -0400
Received: from waste.org ([66.93.16.53]:41578 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161263AbXDQRst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 13:48:49 -0400
Date: Tue, 17 Apr 2007 12:35:23 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417173522.GE11115@waste.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu> <20070415213153.GW11115@waste.org> <20070416030349.GB13626@wotan.suse.de> <20070416142823.GX11115@waste.org> <20070417033120.GC25513@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070417033120.GC25513@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 05:31:20AM +0200, Nick Piggin wrote:
> On Mon, Apr 16, 2007 at 09:28:24AM -0500, Matt Mackall wrote:
> > On Mon, Apr 16, 2007 at 05:03:49AM +0200, Nick Piggin wrote:
> > > I'd prefer if we kept a single CPU scheduler in mainline, because I
> > > think that simplifies analysis and focuses testing.
> > 
> > I think you'll find something like 80-90% of the testing will be done
> > on the default choice, even if other choices exist. So you really
> > won't have much of a problem here.
> > 
> > But when the only choice for other schedulers is to go out-of-tree,
> > then only 1% of the people will try it out and those people are
> > guaranteed to be the ones who saw scheduling problems in mainline.
> > So the alternative won't end up getting any testing on many of the
> > workloads that work fine in mainstream so their feedback won't tell
> > you very much at all.
> 
> Yeah I concede that perhaps it is the only way to get things going
> any further. But how do we decide if and when the current scheduler
> should be demoted from default, and which should replace it?

Step one is ship both in -mm. If that doesn't give us enough
confidence, ship both in mainline. If that doesn't give us enough
confidence, wait until vendors ship both. Eventually a clear picture
should emerge. If it doesn't, either the change is not significant or
no one cares.

But it really is important to be able to do controlled experiments on
this stuff with little effort. That's the recipe for getting lots of
valid feedback.

-- 
Mathematics is the supreme nostalgia of our time.
