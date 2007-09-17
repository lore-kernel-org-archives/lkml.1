Return-Path: <linux-kernel-owner+w=401wt.eu-S1758796AbXIQUgX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796AbXIQUgX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 16:36:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755635AbXIQUgP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 16:36:15 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44125 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbXIQUgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 16:36:14 -0400
Date: Mon, 17 Sep 2007 22:36:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Rob Hussey <robjhussey@gmail.com>
Cc: linux-kernel@vger.kernel.org, ck@vds.kolivas.org
Subject: Re: Scheduler benchmarks - a follow-up
Message-ID: <20070917203607.GA20564@elte.hu>
References: <6b8cef970709170221s4301e896x2ee123a149c05c3a@mail.gmail.com> <20070917130524.GA10707@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070917130524.GA10707@elte.hu>
User-Agent: Mutt/1.5.14 (2007-02-12)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> i've meanwhile tested hackbench 90 and the performance difference 
> between -ck and -cfs-devel seems to be mostly down to the more precise 
> (but slower) sched_clock() introduced in v2.6.23 and to the startup 
> penalty of freshly created tasks.

Rob, another thing i just noticed in your .configs: you have 
CONFIG_PREEMPT=y enabled. Would it be possible to get a testrun with 
that disabled? That gives the best throughput and context-switch latency 
numbers. (CONFIG_PREEMPT might also have preemption artifacts - there's 
one report of it having _worse_ desktop latencies on certain hardware 
than !CONFIG_PREEMPT.)

	Ingo
