Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbZFZHYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbZFZHYP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 03:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753805AbZFZHYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 03:24:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbZFZHX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 03:23:59 -0400
Date: Fri, 26 Jun 2009 09:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mundt <lethal@linux-sh.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090626072350.GI14078@elte.hu>
References: <20090624131104.705c828d@skybase> <20090624112929.GB2079@linux-sh.org> <20090624142828.7c6a2337@skybase> <20090624123416.GB9510@linux-sh.org> <20090624124542.GB32306@elte.hu> <20090624131440.GA9700@linux-sh.org> <20090624132447.GD6224@elte.hu> <1245999685.31755.157.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245999685.31755.157.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2009-06-24 at 15:24 +0200, Ingo Molnar wrote:
> > 
> > [ And long-term analysis ('perf stat' type of runs) dont need IRQs 
> >   anyway - perfcounters reads outs the counts and summarizes them 
> >   across the measured workload. ]
> 
> If the counter width is less than 64 bits we do need to have some 
> interrupt to read them from before they cycle so we can accumulate 
> the deltas into a proper u64.

Yeah - but even that can be driven from some housekeeping hrtimer.

> But for proper 64 bit hardware counters there is indeed no need 
> for that.

Indeed - although they are rare.

	Ingo
