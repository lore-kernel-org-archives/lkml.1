Return-Path: <linux-kernel-owner+w=401wt.eu-S1754434AbYFWVCM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434AbYFWVCM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 17:02:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754345AbYFWVB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 17:01:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53610 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753885AbYFWVB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 17:01:56 -0400
Date: Mon, 23 Jun 2008 23:01:29 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-mm@kvack.org,
       sugita <yumiko.sugita.yf@hitachi.com>,
       Satoshi OSHIMA <satoshi.oshima.fk@hitachi.com>
Subject: Re: [BUG][PATCH -mm] avoid BUG() in __stop_machine_run()
Message-ID: <20080623210129.GB16579@elte.hu>
References: <20080611225945.4da7bb7f.akpm@linux-foundation.org> <485A806A.2090602@goop.org> <20080620132110.GB19740@elte.hu> <200806231355.39329.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806231355.39329.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Friday 20 June 2008 23:21:10 Ingo Molnar wrote:
> > * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
[...]
> > > (With the appropriate transformation of sched_setscheduler -> __)
> > >
> > > Better than scattering stray true/falses around the code.
> >
> > agreed - it would also be less intrusive on the API change side.
> 
> Yes, here's the patch.  I've put it in my tree for testing, too.
> 
> sched_setscheduler_nocheck: add a flag to control access checks

applied to tip/sched/new-API-sched_setscheduler, thanks Rusty. Also 
added it to auto-sched-next so that it shows up in linux-next.

btw., had to merge this bit manually:

> +/**
> + * sched_setscheduler_nocheck - change the scheduling policy and/or RT priority of a thread 
> from kernelspace.
> + * @p: the task in question.

as it suffered from line-warp damage.

	Ingo
