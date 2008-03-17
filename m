Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbYCQFYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbYCQFYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 01:24:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYCQFYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 01:24:04 -0400
Received: from 1wt.eu ([62.212.114.60]:2496 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbYCQFYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 01:24:03 -0400
Date: Mon, 17 Mar 2008 06:21:34 +0100
From: Willy Tarreau <w@1wt.eu>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "LKML," <linux-kernel@vger.kernel.org>
Subject: Re: Poor PostgreSQL scaling on Linux 2.6.25-rc5 (vs 2.6.22)
Message-ID: <20080317052134.GD13012@1wt.eu>
References: <200803111749.29143.nickpiggin@yahoo.com.au> <200803121221.37234.nickpiggin@yahoo.com.au> <1205308704.8514.197.camel@twins> <200803171144.35479.nickpiggin@yahoo.com.au> <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0803162216r1892782bsc894d4188b51481b@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 16, 2008 at 10:16:36PM -0700, Ray Lee wrote:
> On Sun, Mar 16, 2008 at 5:44 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> >  I don't see how it is really helpful for interactive processes either.
> >  By definition, if they are not CPU bound, then they should be run
> >  quite soon after waking up; if they are CPU bound, then reducing
> >  efficiency by increasing context switches is effectively going to
> >  increase their latency anyway.
> 
> How? Are you saying that switching the granularity to, say, 25ms, will
> *decrease* the latency of interactive tasks?
> 
> And the efficiency we're talking about reducing here is due to the
> fact that tasks are hitting cold caches more times per second when the
> granularity is smaller, correct? Or are you concerned by another
> issue?
> 
> > Can this be changed by default, please?
> 
> Not without benchmarks of interactivity, please. There are far, far
> more linux desktops than there are servers. People expect to have to
> tune servers (I do, for the servers I maintain). People don't expect
> to have to tune a desktop to make it run well.

Oh and even on servers, when your anti-virus proxy reaches a load of 800,
you're happy no to have too large a time-slice so that you regularly get
a chance of being allowed to type in commands over SSH.

Large time-slices are needed only in HPC environments IMHO, where only
one task runs.

Willy

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
