Return-Path: <linux-kernel-owner+w=401wt.eu-S1762105AbXEYIlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762105AbXEYIlj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 04:41:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbXEYIlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 04:41:31 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39600 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758658AbXEYIla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 04:41:30 -0400
Date: Fri, 25 May 2007 10:41:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: William Lee Irwin III <wli@holomorphy.com>
Cc: Andi Kleen <andi@firstfloor.org>, Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [patch] i386, numaq: enable TSCs again
Message-ID: <20070525084115.GA29077@elte.hu>
References: <a781481a0705250022t3dec8f13u7c75d0ade40b0010@mail.gmail.com> <20070525073158.GB8094@one.firstfloor.org> <20070525073957.GA15207@elte.hu> <20070525074316.GA16821@elte.hu> <20070525074915.GA18400@elte.hu> <20070525075446.GA20140@elte.hu> <20070525080827.GA22399@elte.hu> <20070525081944.GZ31925@holomorphy.com> <20070525083153.GA27236@elte.hu> <20070525083813.GA19966@holomorphy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070525083813.GA19966@holomorphy.com>
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


* William Lee Irwin III <wli@holomorphy.com> wrote:

> > yes, that's what i meant under 'slightly async'. Some AMD CPUs are 
> > like that too and sched_clock() now handles that fine. So we should 
> > try my patch.
> 
> Sorry, then. I took slight to mean something else. In any event I was 
> only quantifying things. I've no opinion whatsoever on the impact of 
> the code on NUMA-Q, only some recall of its operating characteristics.

there's no need to apologize at all! Thanks for reminding us about the 
time-scale and nature of the TSC drift on NUMAQ. I was worried that 
maybe the TSC was totally unusable for some reason - but that's 
fortunately not the case. So we now have one quirk less, hopefully :-)

	Ingo
