Return-Path: <linux-kernel-owner+w=401wt.eu-S1760564AbZLJHYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760564AbZLJHYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 02:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760462AbZLJHX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 02:23:59 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:60996 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760457AbZLJHX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 02:23:58 -0500
Date: Thu, 10 Dec 2009 08:23:51 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH] perf sched: Add max delay time snapshot
Message-ID: <20091210072351.GF16874@elte.hu>
References: <1260391208-6808-1-git-send-regression-fweisbec@gmail.com>
 <4B206A18.2030607@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B206A18.2030607@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Frederic Weisbecker wrote:
>
> > When we have a maximum latency reported for a task, we need a 
> > convenient way to find the matching location to the raw traces or to 
> > perf sched map that shows where the task has been eventually 
> > scheduled in. This gives a pointer to retrieve the events that 
> > occured during this max latency.
> 
> Then, we can cooperate with ftrace's data to know what the cpu is 
> doing at that time.

What do you mean by mixing it with ftrace data? These events ought to be 
a full replacement for the sched and wakeup tracers. In the long run we 
want a single stream of events and phase out most of the pretty-printing 
ftrace plugins.

	Ingo
