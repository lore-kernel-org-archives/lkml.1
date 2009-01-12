Return-Path: <linux-kernel-owner+w=401wt.eu-S1754357AbZALOqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754357AbZALOqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 09:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbZALOqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 09:46:03 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34403 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbZALOqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 09:46:01 -0500
Date: Mon, 12 Jan 2009 15:45:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
Message-ID: <20090112144548.GA14016@elte.hu>
References: <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu> <493E8246.1090309@novell.com> <20081212113415.GH32640@elte.hu> <20081212114952.GA16976@elte.hu> <4958EEB6.5020105@novell.com> <49591331.9080403@novell.com> <20090111040121.GD28520@elte.hu> <20090111095325.GA32409@elte.hu> <496B5789.9040004@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496B5789.9040004@novell.com>
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


* Gregory Haskins <ghaskins@novell.com> wrote:

> Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> >
> >   
> >>> Hi Ingo,
> >>>   I have rebased the series against tip/cpus4096 as of today.  I
> >>> built/boot this kernel for both SMP/UP on a 4-way x86_64 box, and they
> >>> look sane.  Let me know if they still look broken to you.
> >>>       
> >
> > yes, i still get build failures:
> >
> > kernel/sched_rt.c:574: error: 'struct rq' has no member named 'cpu'
> > kernel/sched_rt.c:619: error: 'rq' undeclared (first use in this function)
> > kernel/sched_rt.c:619: error: (Each undeclared identifier is reported only once
> > kernel/sched_rt.c:619: error: for each function it appears in.)
> > kernel/sched_rt.c:667: error: 'rq' undeclared (first use in this function)
> >
> > so i've excluded tip/sched/rt from tip/master for now.
> >
> > 	Ingo
> >   
> Hey Ingo,
>   Sorry for all these problems.  I am not sure what is happening since
> it seems to build fine for me on this end.
> 
> I just pulled down tip/sched/rt (sha 
> 0a6d4e1dc9154c4376358663d74060d1e33d203e) and built for my x86_64 
> machine with both SMP and UP (configs attached).  They both completed 
> without errors.  Could you send me the config you are having trouble 
> with?

dont have it anymore - but you can look at the build error itself and 
figure out what config options it needs to trigger such problems - and 
whether the code could be simplified/streamlined to not run into such 
issues. If there's no #ifdef in a .c file there's rarely such problems.

	Ingo
