Return-Path: <linux-kernel-owner+w=401wt.eu-S1760551AbXEYHkZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760551AbXEYHkZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:40:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760343AbXEYHkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:40:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35265 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760202AbXEYHkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:40:05 -0400
Date: Fri, 25 May 2007 09:39:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525073957.GA15207@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525073158.GB8094@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > if (!f)
> > 	f = cpufreq_get(freq->cpu);
> > if (!f)
> > 	f = tsc_khz;
> > 
> > ?
> > 
> > Something's not quite right here :-)
> 
> What do you think is wrong? cpufreq_get can return 0.
> 
> Admittedly the second test could be inside a block of the first, but 
> then it would make the code more ugly and this code is not performance 
> critical.

moving it inside the block makes the code _cleaner_ in fact :-)

	Ingo
