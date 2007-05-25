Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXEYIRf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXEYIRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:17:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbXEYIRY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:17:24 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36063 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXEYIRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:17:22 -0400
Date: Fri, 25 May 2007 10:16:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525081653.GA24308@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <1180080906.7348.35.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180080906.7348.35.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2007-05-25 at 09:54 +0200, Ingo Molnar wrote:
> > Subject: [patch] x86_64: fix sched_clock()
> > From: Ingo Molnar <mingo@elte.hu>
> > 
> > sched_clock() is totally broken on x86_64, because it is not defined by 
> > the architecture at all! It fell the victim to the opaqueness of 
> > __attribute__((weak)) and to non-testing.
> > 
> > the i386 version was supposed to be used. This patch fixes that. Booted 
> > and tested on x86_64 and i386.
> > 
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> This does indeed solve my issue.

great! Btw., this is also accidental proof that CFS works well even with 
a jiffies granularity sched_clock() ;-)

	Ingo
