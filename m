Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbZLRK5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbZLRK5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 05:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752893AbZLRK5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 05:57:43 -0500
Received: from fom01.emnet.dk ([89.249.14.84]:61570 "EHLO fom01.emnet.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZLRK5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 05:57:42 -0500
X-AuditID: 59f90e54-b7bd7ae000001243-e9-4b2b60240f88
Subject: Re: x264 benchmarks BFS vs CFS
From: Kasper Sandberg <lkml@metanurb.dk>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jason Garrett-Glaser <darkshikari@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML Mailinglist <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1261121405.30469.8.camel@marge.simson.net>
References: <1261042383.14314.0.camel@localhost>
	 <28f2fcbc0912170242r6d93dfb1j337558a829e21a75@mail.gmail.com>
	 <20091217105316.GB26010@elte.hu> <1261047618.14314.6.camel@localhost>
	 <28f2fcbc0912171718x271520b4k5da3376b5182d88a@mail.gmail.com>
	 <20091218052344.GD417@elte.hu>  <1261121405.30469.8.camel@marge.simson.net>
Content-Type: text/plain
Date: Fri, 18 Dec 2009 11:57:36 +0100
Message-Id: <1261133856.14314.39.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAxIa7B4SGuw4EhrsOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-18 at 08:30 +0100, Mike Galbraith wrote:
> On Fri, 2009-12-18 at 06:23 +0100, Ingo Molnar wrote:
> 
> > Having said that, we generally try to make things perform well without apps 
> > having to switch themselves to SCHED_BATCH. Mike, do you think we can make 
> > x264 perform as well (or nearly as well) under SCHED_OTHER as under 
> > SCHED_BATCH?
> 
> It's not bad as is, except for ultrafast mode.  START_DEBIT is the
> biggest problem there.  I don't think SCHED_OTHER will ever match
> SCHED_BATCH for this load, though I must say I haven't full-spectrum
> tested.  This load really wants RR scheduling, and wakeup preemption
> necessarily perturbs run order.
> 
> I'll probably piddle with it some more, it's an interesting load.
Yes, i must say, very interresting, its very complicated and... oh wait,
its just encoding a movie!
> 
> 	-Mike
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

