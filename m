Return-Path: <linux-kernel-owner+w=401wt.eu-S1758447AbYKWKwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758447AbYKWKwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 05:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756794AbYKWKwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 05:52:01 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53046 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756669AbYKWKwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 05:52:00 -0500
Date: Sun, 23 Nov 2008 11:51:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Fleming <mjf@gentoo.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Sam Ravnborg <sam@ravnborg.org>, Jim Radford <radford@galvanix.net>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 0/5] ftrace: recordmcount for sh and arm, plus
	permanent disable API
Message-ID: <20081123105104.GB30453@elte.hu>
References: <20081121202932.281682721@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081121202932.281682721@goodmis.org>
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



> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel

thanks Steve - i've picked up you latest tip/devel lineup, with the 
following topic mappings - comment lines show places where i had to 
touch the commit:

 ab687e9: trace: fix compiler warning in branch profiler
   => tip/tracing/branch-tracer
    # fixed typo in commit log

 43f6f85: ftrace: add ftrace_off_permanent
   => tip/tracing/ftrace
    # tweaked the impact line

 fe40c4d: ring-buffer: add tracing_off_permanent
   => tip/tracing/ring-buffer

 5143dac: ftrace: mcountrecord.pl for arm
   => tip/tracing/ftrace
    # fixed subject line
    # added impact-line

 5bb2800: ftrace: Specify $alignment for sh architecture
   => tip/tracing/ftrace
    # fixed subject line capitalization
    # added impact-line

 cf4b087: trace: profile all if conditionals
   => tip/tracing/branch-tracer

 3d89c08: trace: branch profiling should not print percent without data
   => tip/tracing/branch-tracer

 f174c21: trace: consolidate unlikely and likely profiler
   => tip/tracing/branch-tracer

 61980a9: trace: remove extra assign in branch check
   => tip/tracing/branch-tracer

 48a4227: ftrace: create default variables for archs in recordmcount.pl
   => tip/tracing/ftrace

 1d18d90: ftrace: add support for powerpc to recordmcount.pl script
   => tip/tracing/ftrace

 cf68a8f: sh: dynamic ftrace support.
   => tip/tracing/ftrace

the final commit IDs are:

 0429149: trace: fix compiler warning in branch profiler
 69bb54e: ftrace: add ftrace_off_permanent
 033601a: ring-buffer: add tracing_off_permanent
 e58918a: ftrace: scripts/recordmcount.pl support for ARM
 3a3d04a: ftrace: specify $alignment for sh architecture
 2bcd521: trace: profile all if conditionals
 bac28bf: trace: branch profiling should not print percent without data
 45b7974: trace: consolidate unlikely and likely profiler
 42f565e: trace: remove extra assign in branch check
 c204f72: ftrace: create default variables for archs in recordmcount.pl
 42e007d: ftrace: add support for powerpc to recordmcount.pl script
 0da85c0: sh: dynamic ftrace support.

Thanks,

	Ingo
