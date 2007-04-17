Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXDQGPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXDQGPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXDQGPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:15:00 -0400
Received: from holomorphy.com ([66.93.40.71]:46752 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240AbXDQGPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:15:00 -0400
Date: Mon, 16 Apr 2007 23:14:24 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Nick Piggin <npiggin@suse.de>,
       "Michael K. Edwards" <medwards.linux@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Mackall <mpm@selenic.com>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070417061424.GK2986@holomorphy.com>
References: <4622CC30.6030707@bigpond.net.au> <20070416030405.GI8915@holomorphy.com> <4623050B.8020602@bigpond.net.au> <20070416110439.GH2986@holomorphy.com> <46237239.1070903@bigpond.net.au> <f2b55d220704161610l71c72bc6k364bd9396cd59300@mail.gmail.com> <20070417035528.GE25513@wotan.suse.de> <46244C43.8000607@bigpond.net.au> <20070417043456.GH25513@wotan.suse.de> <4624633D.4080005@bigpond.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4624633D.4080005@bigpond.net.au>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 17, 2007 at 04:03:41PM +1000, Peter Williams wrote:
> There's a lot of ugly code in the load balancer that is only there to 
> overcome the side effects of SMT and dual core.  A lot of it was put 
> there by Intel employees trying to make load balancing more friendly to 
> their systems.  What I'm suggesting is that an N CPUs per runqueue is a 
> better way of achieving that end.  I may (of course) be wrong but I 
> think that the idea deserves more consideration than you're willing to 
> give it.

This may be a good one to ask Ingo about, as he did significant
performance work on per-core runqueues for SMT. While I did write
per-node runqueue code for NUMA at some point in the past, I did no
tuning or other performance work on it, only functionality.

I've actually dealt with kernels using elder versions of Ingo's code
for per-core runqueues on SMT, but was never called upon to examine
that particular code for either performance or stability, so I'm
largely ignorant of what the perceived outcome of it was.


-- wli
