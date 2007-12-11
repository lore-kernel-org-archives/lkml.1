Return-Path: <linux-kernel-owner+w=401wt.eu-S1755902AbXLKUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902AbXLKUCU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 15:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbXLKUB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 15:01:57 -0500
Received: from brick.kernel.dk ([87.55.233.238]:10449 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756492AbXLKUB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 15:01:56 -0500
Date: Tue, 11 Dec 2007 21:01:50 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071211200149.GA1927@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100617.24157.phillips@phunq.net> <20071211131514.GB25437@kernel.dk> <200712111138.58197.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712111138.58197.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 11 2007, Daniel Phillips wrote:
> On Tuesday 11 December 2007 05:15, Jens Axboe wrote:
> > On Mon, Dec 10 2007, Daniel Phillips wrote:
> > > Now about that block writeout deadlock... it doesn't just affect my
> > > code, it basically breaks Linux as a storage platform, among other
> > > things.
> >
> > As written in other similar threads in the past in which you also
> > participated, I still of the opinion that this is a vm issue and
> > should be solved as such.
> 
> The problem is solved.  The main cornerstone of the solution is
> bio throttling, simply because the resources in question are consumed by 
> bio transactions.

... because too much is pushed out. This isn't a mathematica problem,
there's more than one solution to this problem. Throttling the bio count
is one.

> > As to the patch in question "fixing" it in the block layer, it's a
> > fairly simple work around and I'm not totally against it. If you get
> > rid of the ->bi_throttle stuff and just do sanity checks on the
> > count, then we could look at getting some testing done.
> 
> Testing is already progressing fine without you, thankyou.  If you do 
> want to participate, welcome, otherwise it is not a problem.  Thanks 
> for picking up that bug yesterday.

Here we go again, thanks for picking up your jerky attitude again. I'm
trying to suggest a way to get the patch in a state to be included, but
apparently you are not interested. With 3 bugs so far exposed in your
really short patch, seems you should take all the testing help you can
get.

For what it's worth, your behind the doors testing is worth basically
nothing. It's already been shown that your test coverage wasn't very
wide, if this patch/idea is to have any hope of proceeding further you
need user testing. Period.

Stop cc'ing or replying, what little interest I had is totally gone.

-- 
Jens Axboe

