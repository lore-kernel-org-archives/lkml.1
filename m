Return-Path: <linux-kernel-owner+w=401wt.eu-S1753103AbXDQJgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbXDQJgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 05:36:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753098AbXDQJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 05:36:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57200 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753091AbXDQJgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 05:36:31 -0400
Date: Tue, 17 Apr 2007 11:36:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       William Lee Irwin III <wli@holomorphy.com>,
       Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417093600.GA22626@elte.hu>
References: <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com> <20070417035528.GE25513@wotan.suse.de> <46244C43.8000607@bigpond.net.au> <20070417043456.GH25513@wotan.suse.de> <4624633D.4080005@bigpond.net.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624633D.4080005@bigpond.net.au>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Williams <pwil3058@bigpond.net.au> wrote:

> There's a lot of ugly code in the load balancer that is only there to 
> overcome the side effects of SMT and dual core.  A lot of it was put 
> there by Intel employees trying to make load balancing more friendly 
> to their systems.  What I'm suggesting is that an N CPUs per runqueue 
> is a better way of achieving that end.  I may (of course) be wrong but 
> I think that the idea deserves more consideration than you're willing 
> to give it.

i actually implemented that some time ago and i'm afraid it was ugly as 
hell and pretty fragile. Load-balancing gets simpler, but task picking 
gets alot uglier.

	Ingo
