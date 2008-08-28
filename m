Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYH1L33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYH1L33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 07:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752146AbYH1L3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 07:29:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbYH1L3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 07:29:18 -0400
Date: Thu, 28 Aug 2008 13:28:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>,
       Dario Faggioli <raistlin@linux.it>, Max Krasnyansky <maxk@qualcomm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/6] sched: disabled rt-bandwidth by default
Message-ID: <20080828112857.GA27534@elte.hu>
References: <20080819103301.787700742@chello.nl> <alpine.LFD.1.10.0808262228030.3243@apollo.tec.linutronix.de> <874p57s873.fsf@basil.nowhere.org> <200808272008.16106.nickpiggin@yahoo.com.au> <20080828105408.GA4488@elte.hu> <20080828110923.GL26610@one.firstfloor.org> <1219922353.6443.14.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1219922353.6443.14.camel@twins>
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

> On Thu, 2008-08-28 at 13:09 +0200, Andi Kleen wrote:
> > > Even if the system has multiple CPUs, and even if just a single CPU is 
> > > fully utilized by an RT task, without the rt-limit the system will still 
> > > lock up in practice due to various other factors: workqueues and tasks 
> > > being 'stuck' on CPUs that host an RT hog. 
> > 
> > The load balancer will not notice that a particular CPU is busy
> > with real time tasks?
> 
> Not currently, working on that though.

yeah, that's nice - i tried the earlier iteration of your patch already. 
It doesnt solve the UP case obviously, nor the case where all CPUs are 
hogged by RT tasks, nor any other (or future) per CPU aspect of Linux 
that we have in place currently.

	Ingo
