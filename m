Return-Path: <linux-kernel-owner+w=401wt.eu-S1767159AbXCIKy3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767159AbXCIKy3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:54:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767165AbXCIKy3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:54:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41327 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767159AbXCIKy2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:54:28 -0500
Date: Fri, 9 Mar 2007 11:53:43 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org,
       sparclinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 4/4]: [SPARC64]: Add clocksource/clockevents support.
Message-ID: <20070309105343.GA10687@elte.hu>
References: <20070305.213759.35469392.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305.213759.35469392.davem@davemloft.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> >From 1171ef62b18d7eef093ecf961dd09b11339d53d9 Mon Sep 17 00:00:00 2001
> From: David S. Miller <davem@sunset.davemloft.net>
> Date: Mon, 5 Mar 2007 15:28:37 -0800
> Subject: [PATCH] [SPARC64]: Add clocksource/clockevents support.
> 
> I'd like to thank John Stul and others for helping me along the way.
> 
> A lot of cleanups fell out of this.  For example, the get_compare() 
> tick_op was totally unused, so was deleted.  And the most often used 
> tick_op members were grouped together for cache-friendlyness.

cool stuff! It's really gratifying to see that you were able to two new 
major features on Sparc64 (CONFIG_NO_HZ and CONFIG_HIGH_RES_TIMERS) via:

>  7 files changed, 25 insertions(+), 172 deletions(-)
>  4 files changed, 238 insertions(+), 230 deletions(-)

so it's in fact a net removal of code! I think this really demonstrates 
the power of unified frameworks.

	Ingo
