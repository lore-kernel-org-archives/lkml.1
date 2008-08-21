Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbYHULRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbYHULRg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 07:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbYHULR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 07:17:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45472 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753244AbYHULR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 07:17:29 -0400
Date: Thu, 21 Aug 2008 13:17:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Gregory Haskins <ghaskins@novell.com>, vatsa <vatsa@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: properly account IRQ and RT load in SCHED_OTHER
	load balancing
Message-ID: <20080821111713.GA15680@elte.hu>
References: <1219310330.8651.93.camel@twins> <20080821104718.GA28331@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821104718.GA28331@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > This patch tries to solve this issue by accounting the time spend on 
> > both Real-Time tasks and IRQ handling, and using that to 
> > proportionally inflate the SCHED_OTHER load.
> 
> applied it to tip/sched/devel for more testing.

-tip testing found that it wouldnt build on UP in sched_debug.c - made 
that bit dependent on CONFIG_SMP. sched_scale_load() does not seem to be 
too meaningful on UP.

	Ingo
