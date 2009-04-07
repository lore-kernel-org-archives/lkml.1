Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbZDGBrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbZDGBrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 21:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752666AbZDGBrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 21:47:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33649 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbZDGBrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 21:47:07 -0400
Subject: Re: [PATCH] Update old Mini-HOWTO for ftrace
From: Steven Rostedt <srostedt@redhat.com>
To: GeunSik Lim <leemgs1@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, rt-users <linux-rt-users@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Nikanth Karthikensan <knikanth@suse.de>
In-Reply-To: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
References: <49b7c2350904060702j3f725a45ub5e7d3ee3af883c1@mail.gmail.com>
Content-Type: text/plain
Organization: Red Hat
Date: Mon, 06 Apr 2009 21:46:52 -0400
Message-Id: <1239068812.4753.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-04-06 at 23:02 +0900, GeunSik Lim wrote:
> Dear Steven,
> 
>    The author of ftrace(Internal kernel Function Tracer) feature
> renamed the ftrace tracer
>     to function to avoid further confusion between the ftrace
> infrastructure and the
>     function tracer on Oct-20, 2008.
> 
>     But, Update of Mini-HOWTO document are still not working
>     .
>     Most of the developers often utilize "/debug/tracing/README" file
> as Mini-HOWTO.
>     They will confuse definition and usage about ftrace  between
> README(ftrace) file
>     and available_tracers(function) file after linux-2.6.27 like me.
>     And, I want you to append "chrt -f 5 sleep 1" command as simple
> example for latency.
> 
>     Signed-off-by: GeunSik Lim <leemgs1@gmail.com>
>     Signed-off-by: Steven Rostedt <srostedt@redhat.com>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/trace/trace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index a0174a4..15f0eec 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2358,7 +2358,7 @@ static const char readme_msg[] =
>         "# mkdir /debug\n"
>         "# mount -t debugfs nodev /debug\n\n"
>         "# cat /debug/tracing/available_tracers\n"
> -       "wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
> +       "wakeup preemptirqsoff preemptoff irqsoff function
> sched_switch none\n\n"
>         "# cat /debug/tracing/current_tracer\n"
>         "none\n"
>         "# echo sched_switch > /debug/tracing/current_tracer\n"
> @@ -2368,6 +2368,7 @@ static const char readme_msg[] =
>         "noprint-parent nosym-offset nosym-addr noverbose\n"
>         "# echo print-parent > /debug/tracing/trace_options\n"
>         "# echo 1 > /debug/tracing/tracing_enabled\n"
> +       "# chrt -f 5 sleep 1\n"
>         "# cat /debug/tracing/trace > /tmp/trace.txt\n"
>         "echo 0 > /debug/tracing/tracing_enabled\n"
>  ;
> 

Actually Nikanth sent a similar patch a month ago, but somehow it
slipped under the radar. I'll be picking that one up instead.

http://lkml.org/lkml/2009/3/23/24

But thanks anyway.

-- Steve


