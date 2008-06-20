Return-Path: <linux-kernel-owner+w=401wt.eu-S1754934AbYFTJGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbYFTJGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 05:06:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754657AbYFTJGf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 05:06:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58269 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbYFTJGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 05:06:34 -0400
Date: Fri, 20 Jun 2008 11:06:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Daniel K." <dk@uw.no>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10] sched: rt: dont stop the period timer when there
	are tasks wanting to run
Message-ID: <20080620090620.GB31502@elte.hu>
References: <20080619122218.971447669@chello.nl> <20080619123314.398446193@chello.nl> <485ABD3A.9090704@uw.no> <1213906578.3223.113.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213906578.3223.113.camel@lappy.programming.kicks-ass.net>
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

> On Thu, 2008-06-19 at 20:10 +0000, Daniel K. wrote:
> > Peter Zijlstra wrote:
> > > When a runnable group failed to get any runtime within a period it would be
> > > found idle and the period timer would be stopped.
> > > 
> > > So if the group ever gets throttled, it will never wake up again.
> > > 
> > > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > > Reported-by: "Daniel K." <dk@uw.no>
> > Tested-by: Daniel K. <dk@uw.no>
> > 
> > I think this should go into .26 as well, due to the non-intuitiveness
> > of the knobs that cause this if they are fiddled with in the wrong way.
> 
> Sounds reasonable, Ingo?

agreed - i've put it into tip/sched/urgent as well.

	Ingo
