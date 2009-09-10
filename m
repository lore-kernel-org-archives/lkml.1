Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbZIJUGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbZIJUGq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 16:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbZIJUGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 16:06:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:36779 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671AbZIJUGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 16:06:45 -0400
Date: Thu, 10 Sep 2009 22:06:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Martin Steigerwald <Martin@lichtvoll.de>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nikos Chantziaras <realnc@arcor.de>, Mike Galbraith <efault@gmx.de>,
       Jens Axboe <jens.axboe@oracle.com>, Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090910200636.GA13104@elte.hu>
References: <20090906205952.GA6516@elte.hu> <4AA76FD2.1050103@arcor.de> <1252487869.7746.181.camel@twins> <200909102145.53332.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909102145.53332.Martin@lichtvoll.de>
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


* Martin Steigerwald <Martin@lichtvoll.de> wrote:

> Am Mittwoch 09 September 2009 schrieb Peter Zijlstra:
> > On Wed, 2009-09-09 at 12:05 +0300, Nikos Chantziaras wrote:
> > > Thank you for mentioning min_granularity.  After:
> > >
> > >    echo 10000000 > /proc/sys/kernel/sched_latency_ns
> > >    echo 2000000 > /proc/sys/kernel/sched_min_granularity_ns
> > 
> > You might also want to do:
> > 
> >      echo 2000000 > /proc/sys/kernel/sched_wakeup_granularity_ns
> > 
> > That affects when a newly woken task will preempt an already running
> > task.
> 
> Heh that scheduler thing again... and unfortunately Col appearing 
> to feel hurt while I am think that Ingo is honest on his offer on 
> collaboration...
> 
> While it makes fun playing with that numbers and indeed 
> experiencing subjectively a more fluid deskopt how about just a
> 
> echo "This is a f* desktop!" > /proc/sys/kernel/sched_workload

No need to do that, that's supposed to be the default :-) The knobs 
are really just there to help us make it even more so - i.e. you 
dont need to tune them. But it really relies on people helping us 
out and tell us which combinations work best ...

> Or to say it in other words: The Linux kernel should not require 
> me to fine-tune three or more values to have the scheduler act in 
> a way that matches my workload.
> 
> I am willing to test stuff on my work thinkpad and my Amarok 
> thinkpad in order to help improving with that.

It would be great if you could check latest -tip:

  http://people.redhat.com/mingo/tip.git/README

and compare it to vanilla .31?

Also, could you outline the interactivity problems/complaints you 
have?

	Ingo
