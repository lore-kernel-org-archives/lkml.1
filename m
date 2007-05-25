Return-Path: <linux-kernel-owner+w=401wt.eu-S1759963AbXEYH06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759963AbXEYH06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 03:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbXEYH0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 03:26:52 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44941 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751469AbXEYH0v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 03:26:51 -0400
Date: Fri, 25 May 2007 09:26:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] sched_clock(): cleanups
Message-ID: <20070525072641.GA13025@elte.hu>
References: <20070525071005.GA6431@elte.hu> <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525072512.GA12683@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525072512.GA12683@elte.hu>
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


> > if (!f)
> > 	f = cpufreq_get(freq->cpu);
> > if (!f)
> > 	f = tsc_khz;
> > 
> > ?
> > 
> > Something's not quite right here :-)

ah, that's fine. It does this: 'try to give f a value', and then: 'if 
still no value then give it tsc_khz as a last resort)

call_r_s_f() still needs an urgent rerenaming though =B-)

	Ingo
