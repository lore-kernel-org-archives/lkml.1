Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYIJMZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYIJMZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751856AbYIJMZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:25:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37889 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbYIJMZr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:25:47 -0400
Date: Wed, 10 Sep 2008 14:25:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] 2.6.27-rc5 couldn't boot on tulsa machine randomly
Message-ID: <20080910122530.GF14757@elte.hu>
References: <1220930793.25574.20.camel@ymzhang> <1221037978.25574.22.camel@ymzhang> <1221038340.2442.70.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1221038340.2442.70.camel@twins.programming.kicks-ass.net>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Wed, 2008-09-10 at 17:12 +0800, Zhang, Yanmin wrote:
> > On Tue, 2008-09-09 at 11:26 +0800, Zhang, Yanmin wrote:
> > > On my tulsa x86-64 machine, kernel 2.6.25-rc5 couldn't boot randomly.
> > > 
> > > Basically, function __enable_runtime forgets to reset  rt_rq->rt_throttled to 0.
> > Peter,
> > 
> > Is there any issue with the patch?
> 
> No, just got lost in my inbox due to me getting distracted at the 
> wrong moment, sorry!

there's no issue with the patch, it was already queued up in 
tip/sched/urgent, for -rc7.

	Ingo
