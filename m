Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZK0GWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZK0GWF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 01:22:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752907AbZK0GWE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 01:22:04 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33762 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbZK0GWD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 01:22:03 -0500
Date: Fri, 27 Nov 2009 07:21:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4 tip/sched/core] sched: rename preempt_notifier to
 sched_notifier and always enable it
Message-ID: <20091127062147.GB22149@elte.hu>
References: <1259234619.4273.32.camel@twins>
 <20091126115605.GA15189@elte.hu>
 <1259239259.4273.82.camel@twins>
 <4B0F356B.3040206@kernel.org>
 <20091127045209.GA13914@elte.hu>
 <4B0F65DD.1090707@kernel.org>
 <20091127054621.GA25672@elte.hu>
 <4B0F6B32.4090401@kernel.org>
 <20091127061319.GA8620@elte.hu>
 <4B0F6EA9.6070105@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0F6EA9.6070105@kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> 11/27/2009 03:13 PM, Ingo Molnar wrote:
> >>> My position on this is rather clear: i want no new callbacks and no 
> >>> changes to callbacks in the scheduler until this situation is cleaned 
> >>> up. Five callback sites are _way_ too much - so if you want to add 
> >>> callbacks or change them, please clean it up and improve it first.
> >>
> >> Even changes which cause no functional differences? [...]
> > 
> > Such as enabling preempt notifiers unconditionally? That's a functional 
> > change - it turns a so-far optional callback into an essentially 
> > mandatory one.
> 
> No, I'm not gonna do that.  Just patches to reorganize code so that 
> unnecessary conflicts won't occur.  There will be NO functional 
> changes.

Not without the other changes - which you want to do too, right? Please 
send all sched.c modifications via the scheduler tree. Going via other 
trees is fine when there's agreement by the maintainers - but this is 
one of the rare cases where that's not the case.

	Ingo
