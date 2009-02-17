Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbZBQRj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbZBQRj0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 12:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752533AbZBQRjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 12:39:18 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:46348 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377AbZBQRjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 12:39:18 -0500
Date: Tue, 17 Feb 2009 12:39:16 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Wenji Huang <wenji.huang@oracle.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [RE-SEND PATCH 1/3] tracing: use the more proper parameter.
In-Reply-To: <1234850848-3525-1-git-send-email-wenji.huang@oracle.com>
Message-ID: <alpine.DEB.1.10.0902171238340.910@gandalf.stny.rr.com>
References: <1234850848-3525-1-git-send-email-wenji.huang@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, I've applied all three patches.

Just a small nit pick. Please do not include a period in the subject line.

Thanks,

-- Steve


On Tue, 17 Feb 2009, Wenji Huang wrote:

> Pass tsk to tracing_record_cmdline instead of current.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 95f99a7..dc61e82 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -336,7 +336,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
>  	data->rt_priority = tsk->rt_priority;
>  
>  	/* record this tasks comm */
> -	tracing_record_cmdline(current);
> +	tracing_record_cmdline(tsk);
>  }
>  
>  static void
> -- 
> 1.5.6
> 
> 
> 
