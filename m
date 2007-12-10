Return-Path: <linux-kernel-owner+w=401wt.eu-S1755774AbXLJN5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755774AbXLJN5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 08:57:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbXLJN5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 08:57:00 -0500
Received: from brick.kernel.dk ([87.55.233.238]:9078 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbXLJN47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:56:59 -0500
Date: Mon, 10 Dec 2007 14:53:52 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Daniel Phillips <phillips@phunq.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC] [PATCH] A clean aEvgeniy pproach to writeout throttling
Message-ID: <20071210135352.GL5008@kernel.dk>
References: <200712051603.02183.phillips@phunq.net> <200712100526.49319.phillips@phunq.net> <20071210133050.GJ5008@kernel.dk> <200712100543.45204.phillips@phunq.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712100543.45204.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10 2007, Daniel Phillips wrote:
> On Monday 10 December 2007 05:30, Jens Axboe wrote:
> > On Mon, Dec 10 2007, Daniel Phillips wrote:
> > "Let me close with perhaps the most relevant remarks: the attached
> > code has been in heavy testing and in production for months now. 
> > Thus there is nothing theoretical when I say it works, and the patch
> > speaks for itself in terms of obvious correctness."
> 
> That is quite correct, even without the redirect the code passed all our 
> tests.  Remember, we were testing for deadlock, not every possible 
> block IO configuration.

And round we go.

> > We must have differing opinions on what obvious correctness is.
> 
> Yes we do.  You appear to have missed the plot entirely.  I suppose I 
> should remind you: this is about deadlock in _your_ subsystem that has 
> been creating bug reports for years.  Block writeout deadlock.  Caused 
> by a deficiency in _your_ subsystem.

And I may remind you that I have participated in this discussion before
and made my points clear there. I suppose I should remind you how the
development process works? Just because I happen to maintain some piece
of code does not mean I'm under some sort of contractual obligation to
fix and write new code for users. I'll happily review patches and
integrate stuff I agree with, as I have been doing for years. This bug
may seem really important to you - guess what, that's the normal nature
of a bug to a user that runs into them.

> Got a plan?  Or does endless, pointless flaming feel more like progress 
> to you?

Please, I'm not flaming you. I reviewed your code and pointed out
errors, which was followed by lots of hand waving on your side instead
of just sitting down and reading/fixing the bug.

-- 
Jens Axboe

