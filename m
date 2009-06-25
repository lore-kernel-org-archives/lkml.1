Return-Path: <linux-kernel-owner+w=401wt.eu-S1755128AbZFYMei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128AbZFYMei (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 08:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752133AbZFYMeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 08:34:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53726 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbZFYMea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 08:34:30 -0400
Date: Thu, 25 Jun 2009 08:34:30 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, lizf@cn.fujitsu.com, tglx@linutronix.de,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/urgent] ftrace: Remove duplicate newline
In-Reply-To: <tip-00e54d087afb3867b0b461aef6c1ff433d0df564@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0906250833410.12035@gandalf.stny.rr.com>
References: <4A4313A7.7030105@cn.fujitsu.com> <tip-00e54d087afb3867b0b461aef6c1ff433d0df564@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Jun 2009, tip-bot for Li Zefan wrote:

> Commit-ID:  00e54d087afb3867b0b461aef6c1ff433d0df564
> Gitweb:     http://git.kernel.org/tip/00e54d087afb3867b0b461aef6c1ff433d0df564
> Author:     Li Zefan <lizf@cn.fujitsu.com>
> AuthorDate: Thu, 25 Jun 2009 14:05:27 +0800
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 25 Jun 2009 10:28:36 +0200
> 
> ftrace: Remove duplicate newline
> 
> Before:
>   # echo 'sys_open:traceon:' > set_ftrace_filter
>   # echo 'sys_close:traceoff:5' > set_ftrace_filter
>   # cat set_ftrace_filter
>   #### all functions enabled ####
>   sys_open:traceon:unlimited
> 
>   sys_close:traceoff:count=0
> 
> After:
>   # cat set_ftrace_filter
>   #### all functions enabled ####
>   sys_open:traceon:unlimited
>   sys_close:traceoff:count=0
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Thanks!

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> LKML-Reference: <4A4313A7.7030105@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/trace_functions.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions.c b/kernel/trace/trace_functions.c
> index 90f1347..7402144 100644
> --- a/kernel/trace/trace_functions.c
> +++ b/kernel/trace/trace_functions.c
> @@ -302,8 +302,7 @@ ftrace_trace_onoff_print(struct seq_file *m, unsigned long ip,
>  	if (count == -1)
>  		seq_printf(m, ":unlimited\n");
>  	else
> -		seq_printf(m, ":count=%ld", count);
> -	seq_putc(m, '\n');
> +		seq_printf(m, ":count=%ld\n", count);
>  
>  	return 0;
>  }
> 
