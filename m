Return-Path: <linux-kernel-owner+w=401wt.eu-S1752396AbZIWLnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbZIWLnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 07:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbZIWLnH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 07:43:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56969 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbZIWLnH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 07:43:07 -0400
Date: Wed, 23 Sep 2009 13:42:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Malley <mail@chrismalley.co.uk>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf sched record hangs machine
Message-ID: <20090923114258.GA4132@elte.hu>
References: <20090923073253.GA18022@elte.hu> <20090923074028.GA3078@elte.hu> <aa79d98a0909230044q3548cf0bjda62e05e0400edd6@mail.gmail.com> <aa79d98a0909230148j47232382oe28c6d88eef181c4@mail.gmail.com> <7863dc4c0909230215u2fed3edciec84f93f24d3ae1@mail.gmail.com> <20090923092024.GA29323@elte.hu> <aa79d98a0909230248j22f05047n34e0ee97382f573f@mail.gmail.com> <7863dc4c0909230306x3bc60775rc503919df83087ed@mail.gmail.com> <20090923104244.GB23941@elte.hu> <7863dc4c0909230441p49b7440bu9de9f786fee9c4bd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7863dc4c0909230441p49b7440bu9de9f786fee9c4bd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Malley <mail@chrismalley.co.uk> wrote:

> 2009/9/23 Ingo Molnar <mingo@elte.hu>:
> >
> > * Chris Malley <mail@chrismalley.co.uk> wrote:
> >
> >> Applied Peter's patch, doesn't seem to have fixed the problem:
> >>
> >> [ ?246.408893] BUG: unable to handle kernel paging request at ffffb300
> >> [ ?246.408939] IP: [<c011b0bd>] default_send_IPI_self+0x1d/0x50
> >
> > could you please send the full bootlog, up to the crash?
> >
> > Thanks,
> >
> > ? ? ? ?Ingo
> >
> 
> Sure, but I'm just rebuilding from clean first in case the change
> wasn't picked up for some reason, because I don't see how it can get
> to default_send_IPI_self() in my configuration...

yeah - i have that thinking too - according to your earlier boot 
messages x86_pmu.apic must be 0 and that codepath shouldnt trigger.

	Ingo
