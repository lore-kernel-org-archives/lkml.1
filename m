Return-Path: <linux-kernel-owner+w=401wt.eu-S1752037AbZIWKxH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbZIWKxH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 06:53:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751816AbZIWKxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 06:53:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49449 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620AbZIWKxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 06:53:04 -0400
Date: Wed, 23 Sep 2009 12:52:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing/kprobes: Kprobes core/tracing/profiling
	updates
Message-ID: <20090923105252.GA32176@elte.hu>
References: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253648302-5771-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Ingo,
> 
> Kprobes has been nicely improved lately. The x86 instruction decoder 
> has been fixed to support cross builds and mmx instruction set, 
> besides of a lot of various kprobes core fixes.
> 
> The tracing part has evolved too, we can define human names for 
> arguments and custom subsystem names for dynamic tracepoints.
> 
> And also kprobes profiling and raw dynamic tracepoint samples are now 
> supported through perf. Looks like most of the kernel parts are now in 
> place for a perf support. Things are going to be focused on a perf 
> kprobes tool to exploit that.

Nice progress. What's the expected timeline of exhaustive tools/perf/ 
support?

> Concerning this git tree, based on tip:/tracing/kprobes, I had to 
> merge tracing/core inside few weeks ago because it needed build fixes 
> that were in tracing/core (the merge commit provides the details). The 
> tree is self contained but it's already async with recent upstream 
> tracing updates. It means that merging upstream tree or tracing/core 
> inside may result in non-trivial conflicts. I can handle them, or 
> rebase the whole, as you prefer.
> 
> The tree can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
> 	tracing/kprobes

Would be nice to merge latest -git into this tree and resolve the 
conflicts:

 kernel/trace/Makefile
 kernel/trace/trace.h
 kernel/trace/trace_event_types.h
 kernel/trace/trace_export.c

Then i could pull it into tip:tracing/kprobes for more testing.

	Ingo
