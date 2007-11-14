Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbXKNQAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbXKNQAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:00:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbXKNQAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:00:38 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41746 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054AbXKNQAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:00:37 -0500
Date: Wed, 14 Nov 2007 16:59:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Grant Wilson <grant.wilson@zen.co.uk>,
       Peter Zijlstra <peterz@infradead.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>, linux-kernel@vger.kernel.org,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: Re: 2.6.24-rc1-gb4f5550 oops
Message-ID: <20071114155923.GB18037@elte.hu>
References: <20071114151708.GA12355@tv-sign.ru> <20071114152930.GA1690@elte.hu> <20071114155031.GA12398@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114155031.GA12398@tv-sign.ru>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Oleg Nesterov <oleg@tv-sign.ru> wrote:

> > > I suspect I see the bug in that area, but I am not sure it can 
> > > explain this trace completely.
> > 
> > there's a fix pending from Dmitry - please see below. It took days 
> > for Grant to trigger the crash so it needs some time to be confirmed 
> > but it could explain the crash in theory.
> 
> Yes I agree, it can explain the crash.
> 
> However, this patch can't fix the bug I was talking about (of course, 
> unless I missed something). It is still possible that the 
> "fair_sched_class" task can have ->se.cfs_rq/parent pointing to the 
> freed memory, no?

yeah, agreed. I've queued up your fix for merging - thanks!

	Ingo
