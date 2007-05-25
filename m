Return-Path: <linux-kernel-owner+w=401wt.eu-S1760390AbXEYIzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390AbXEYIzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXEYIzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:55:36 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34929 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbXEYIzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:55:35 -0400
Date: Fri, 25 May 2007 10:55:21 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@osdl.org
Subject: Re: [patch] x86_64: fix sched_clock()
Message-ID: <20070525085521.GA32044@elte.hu>
References: <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080209.GE8094@one.firstfloor.org> <20070525080415.GB21446@elte.hu> <20070525082018.GF8094@one.firstfloor.org> <20070525083430.GB27236@elte.hu> <20070525084109.GI8094@one.firstfloor.org> <20070525084426.GA29973@elte.hu> <20070525084547.GJ8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525084547.GJ8094@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > must be an -mm fix. I used -mm as a basis of my work. Please apply 
> > my patch.
> 
> I would prefer to find out why the mm patch was added and then 
> hopefully remove it.  IMNSHO it should not be needed.

it comes in via:

  fix-x86_64-mm-sched-clock-share.patch

 From: Rusty Russell <rusty@rustcorp.com.au>

 If you set tsc_disable (eg "notsc" on cmdline), sched-clock.c gives a
 divide by zero on boot.

so IMNSHO it is very much needed ;-)

	Ingo
