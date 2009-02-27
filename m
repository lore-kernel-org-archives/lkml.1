Return-Path: <linux-kernel-owner+w=401wt.eu-S1757999AbZB0IVI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757999AbZB0IVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 03:21:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZB0IUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 03:20:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57698 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZB0IUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:20:54 -0500
Date: Fri, 27 Feb 2009 09:20:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH][RFC] vsprintf: unify the format decoding layer for its
	3 users
Message-ID: <20090227082035.GD3609@elte.hu>
References: <20090226130243.GA22460@elte.hu> <20090226170524.GB5889@nowhere> <20090226174303.GC29439@elte.hu> <20090226174547.GC5889@nowhere> <20090226175225.GA4527@elte.hu> <20090226183415.GE5889@nowhere> <20090226185208.GA6658@nowhere> <20090226185635.GA12895@elte.hu> <20090227061936.GA5318@nowhere> <20090226224656.5785de9e.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090226224656.5785de9e.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 27 Feb 2009 07:19:37 +0100 Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > An new optimization is making its way to ftrace. Its purpose 
> > is to make ftrace_printk() consuming less memory and be 
> > faster.
> > 
> > Written by Lai Jiangshan, the approach is to delay the 
> > formatting job from tracing time to output time. Currently, 
> > a call to ftrace_printk will format the whole string and 
> > insert it into the ring buffer.
> 
> It does that?  eek.

hm, did you expect something else from a printf based interface?

	Ingo
