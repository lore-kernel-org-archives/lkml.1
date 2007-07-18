Return-Path: <linux-kernel-owner+w=401wt.eu-S1764332AbXGRNtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764332AbXGRNtl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 09:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755848AbXGRNtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 09:49:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:53488 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289AbXGRNta (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 09:49:30 -0400
Date: Wed, 18 Jul 2007 15:48:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
Message-ID: <20070718134811.GA9227@elte.hu>
References: <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu> <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu> <Pine.LNX.4.64.0707161331570.1817@scrub.home> <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org> <1184754430.20032.130.camel@twins> <Pine.LNX.4.64.0707181442340.1817@scrub.home> <1184763148.20032.135.camel@twins> <Pine.LNX.4.64.0707181506460.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707181506460.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > By breaking the UNIX model of nice levels. Not an option in my book.
> 
> Breaking user expectations of nice levels is?

_changing_ it is an option within reason, and we've done it a couple of 
times already in the past, and even within CFS (as Peter correctly 
observed) we've been through a couple of iterations already. And as i 
mentioned it before, the outer edge of nice levels (+19, by far the most 
commonly used nice level) was inconsistent to begin with: 3%, 5%, 9% of 
nice-0, depending on HZ. So changing that to a consistent (and 
user-requested) 1.5% is a much smaller change than you seem to make it 
out to be. CFS itself is a far larger "change of expectations" than this 
tweak to nice levels. So by your standard we could never change the 
scheduler. (which your ultimate argument might be after all =B-)

	Ingo
