Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbZKJHvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbZKJHvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 02:51:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbZKJHvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 02:51:00 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:59454 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbZKJHvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 02:51:00 -0500
Date: Tue, 10 Nov 2009 16:51:02 +0900 (JST)
Message-Id: <20091110.165102.386189748263321818.mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style
 formatting
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
In-Reply-To: <20091110035812.GB29454@elte.hu>
References: <1257808802-9420-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	<20091110035812.GB29454@elte.hu>
X-Mailer: Mew version 5.2 on Emacs 22.2 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v2 0/4] perf bench: Common option for specifying style formatting
Date: Tue, 10 Nov 2009 04:58:12 +0100

> > bench subcommand of perf.
> > 
> > Users of perf bench will be able to specify
> > style formatting with this option in common way.
> > 
> > Hitoshi Mitake (4):
> >   perf bench: Add stuffs to bench.h for unified output formatting
> >   perf bench: Modify builtin-bench.c for processing common options
> >   perf bench: Modified bench/bench-messaging.c to adopt unified output
> >     formatting
> >   perf bench: Modify builtin-pipe.c for processing common options
> > 
> >  tools/perf/bench/bench.h           |    9 ++++
> >  tools/perf/bench/sched-messaging.c |   18 +++++---
> >  tools/perf/bench/sched-pipe.c      |   22 ++++++----
> >  tools/perf/builtin-bench.c         |   79 +++++++++++++++++++++++++++++------
> >  4 files changed, 99 insertions(+), 29 deletions(-)
> 
> Very nice, applied to tip:perf/bench, thanks!
> 
> A (very) small detail about initializers in bench.h:
> 
>  - No need to break the line for function prototypes, they are more
>    readable in a single line. (even if checkpatch complains about it)
> 
>  - We try to align definitions / structure fields vertically, to make it 
>    all a bit more readable.
> 
> Something like the (untested) cleanup patch below. (Just put it into 
> your next batch of commits.)
> 
> Thanks,
> 
> 	Ingo
> 
> ---
>  tools/perf/bench/bench.h |   16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 
> Index: tip/tools/perf/bench/bench.h
> ===================================================================
> --- tip.orig/tools/perf/bench/bench.h
> +++ tip/tools/perf/bench/bench.h
> @@ -1,17 +1,15 @@
>  #ifndef BENCH_H
>  #define BENCH_H
>  
> -extern int bench_sched_messaging(int argc, const char **argv,
> -				 const char *prefix);
> -extern int bench_sched_pipe(int argc, const char **argv,
> -			    const char *prefix);
> +extern int bench_sched_messaging(int argc, const char **argv, const char *prefix);
> +extern int bench_sched_pipe(int argc, const char **argv, const char *prefix);
>  
> -#define BENCH_FORMAT_DEFAULT_STR "default"
> -#define BENCH_FORMAT_DEFAULT 0
> -#define BENCH_FORMAT_SIMPLE_STR "simple"
> -#define BENCH_FORMAT_SIMPLE 1
> +#define BENCH_FORMAT_DEFAULT_STR	"default"
> +#define BENCH_FORMAT_DEFAULT		0
> +#define BENCH_FORMAT_SIMPLE_STR		"simple"
> +#define BENCH_FORMAT_SIMPLE		1
>  
> -#define BENCH_FORMAT_UNKNOWN -1
> +#define BENCH_FORMAT_UNKNOWN		-1
>  
>  extern int bench_format;
>  
> 

Thanks for your merge!

I tested your cleaning patch, and this has no problem.
So I'll queue this with next patch series post.

And I have a question.
In tools/perf/command-list.txt, there is the word "mainporcelain".
What does this mean?

Of course I searched this word on my dictionary, but cannot got an answer.
I'm preparing the initial document for perf-bench.
Can I add perf-bench with mainporcelain to command-list.txt?

