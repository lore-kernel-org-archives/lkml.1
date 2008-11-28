Return-Path: <linux-kernel-owner+w=401wt.eu-S1754453AbYK1G4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbYK1G4U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 01:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753063AbYK1Gzr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 01:55:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50117 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbYK1Gzr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 01:55:47 -0500
Date: Fri, 28 Nov 2008 01:55:43 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: walimis <walimisdev@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ftrace: improve document
In-Reply-To: <1227846079-9197-1-git-send-email-walimisdev@gmail.com>
Message-ID: <alpine.DEB.1.10.0811280155140.7113@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0811272251180.7113@gandalf.stny.rr.com> <1227846079-9197-1-git-send-email-walimisdev@gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 28 Nov 2008, walimis wrote:
> 
> Signed-off-by: walimis <walimisdev@gmail.com>
> Reviewed-by: Ingo Molnar <mingo@elte.hu>
> Reviewed-by: Steven Rostedt <srostedt@redhat.com>

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

> ---
>  Documentation/ftrace.txt |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/ftrace.txt b/Documentation/ftrace.txt
> index de05042..803b131 100644
> --- a/Documentation/ftrace.txt
> +++ b/Documentation/ftrace.txt
> @@ -1251,7 +1251,11 @@ These are the only wild cards which are supported.
>  
>    <match>*<match> will not work.
>  
> - # echo hrtimer_* > /debug/tracing/set_ftrace_filter
> +Note: It is better to use quotes to enclose the wild cards, otherwise
> +  the shell may expand the parameters into names of files in the local
> +  directory.
> +
> + # echo 'hrtimer_*' > /debug/tracing/set_ftrace_filter
>  
>  Produces:
>  
> @@ -1306,7 +1310,7 @@ Again, now we want to append.
>   # echo sys_nanosleep > /debug/tracing/set_ftrace_filter
>   # cat /debug/tracing/set_ftrace_filter
>  sys_nanosleep
> - # echo hrtimer_* >> /debug/tracing/set_ftrace_filter
> + # echo 'hrtimer_*' >> /debug/tracing/set_ftrace_filter
>   # cat /debug/tracing/set_ftrace_filter
>  hrtimer_run_queues
>  hrtimer_run_pending
> -- 
> 1.6.0.3
> 
> 
> 
