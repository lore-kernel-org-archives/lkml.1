Return-Path: <linux-kernel-owner+w=401wt.eu-S1760512AbYD0NPl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760512AbYD0NPl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 09:15:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753770AbYD0NPe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 09:15:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32860 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751728AbYD0NPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 09:15:34 -0400
Date: Sun, 27 Apr 2008 15:15:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [patch] ftrace, v15
Message-ID: <20080427131516.GA8850@elte.hu>
References: <20080427063019.GA23295@elte.hu> <2f11576a0804270414t3ef16998me2ff2afd21eedbe7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2f11576a0804270414t3ef16998me2ff2afd21eedbe7@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Hi Ingo,
> 
> >  the current/latest ftrace tree can be pulled from:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched-devel.git
> >
> >  the full diffs are too large to be included here, but the shortlog and
> >  the diffstat is below. Not much changed in the fundamentals since the
> >  last lkml posting - but many small details were refined.
> 
> I hope ftrace people discussio LTTng people more. AFAIK nobody explain 
> pros. and cons. ftrace against marker approach. (of cource, LTTng 
> people doen't explain it too)

check the tree :-) It has these commits too:

    Markers use imv jump
    Linux Kernel Markers - Use Immediate Values
    Markers - define non optimized marker
    Markers - remove extra format argument

    LTTng instrumentation net
    LTTng instrumentation mm
    LTTng instrumentation kernel
    LTTng instrumentation ipc
    LTTng instrumentation fs

[ the latter ones are only there for testing - Mathieu is working on a
  different approach for syscall instrumentation. ]

Enjoy,

	Ingo
