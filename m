Return-Path: <linux-kernel-owner+w=401wt.eu-S1754630AbXIBTWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbXIBTWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 15:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbXIBTWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 15:22:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51118 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbXIBTWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 15:22:08 -0400
Date: Sun, 2 Sep 2007 21:21:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: Daniel Walker <dwalker@mvista.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org
Subject: Re: [ANNOUNCE/RFC] Really Fair Scheduler
Message-ID: <20070902192152.GA29757@elte.hu>
References: <Pine.LNX.4.64.0708310139280.1817@scrub.home> <1188694367.11196.42.camel@dhcp193.mvista.com> <20070902072029.GA24427@elte.hu> <Pine.LNX.4.64.0709021655340.1817@scrub.home> <20070902152900.GA23642@elte.hu> <Pine.LNX.4.64.0709021903240.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709021903240.1817@scrub.home>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -0.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-0.5 required=5.9 tests=BAYES_20 autolearn=no SpamAssassin version=3.0.3
	-0.5 BAYES_20               BODY: Bayesian spam probability is 5 to 20%
	[score: 0.1861]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roman Zippel <zippel@linux-m68k.org> wrote:

> > > > so unmodified CFS is 4.6% faster on this box than with Roman's 
> > > > patch and it's also more consistent/stable (10 times lower 
> > > > fluctuations).
> > > 
> > > Was SCHED_DEBUG enabled or disabled for these runs?
> > 
> > debugging disabled of course. (your patch has a self-validity 
> > checking function [verify_queue()] that is called on SCHED_DEBUG=y, 
> > it would have been unfair to test your patch with that included.)
> 
> I'll look into it next week.

thanks. FYI, there's plenty of time - i'll be at the KS next week so 
i'll be quite unresponsive to emails. Would be nice if you could take a 
quick look at the trivial patch i posted today though. How close is it 
to your algorithm, have i missed any important details? (not counting 
nice levels and rounding, it's just a quick & dirty prototype to show 
the first layer of the core math and nothing more.)

	Ingo
