Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbYKVATf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbYKVATf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 19:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYKVAT2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 19:19:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40128 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbYKVAT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 19:19:27 -0500
Date: Fri, 21 Nov 2008 19:19:25 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Luis Henriques <henrix@sapo.pt>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] debugfs README file contents update
In-Reply-To: <20081122000900.GC9264@hades>
Message-ID: <alpine.DEB.1.10.0811211919100.17853@gandalf.stny.rr.com>
References: <20081122000900.GC9264@hades>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 22 Nov 2008, Luis Henriques wrote:

> This patch updates the debugfs README file contents.  Just some minor changes:
> the list of available tracers and the name of the default current_tracer.
> 
> Signed-off-by: Luis Henriques <henrix@sapo.pt>

Thanks, I'll queue this up.

-- Steve

> ---
>  kernel/trace/trace.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index d86e325..f19c4be 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2280,9 +2280,9 @@ static const char readme_msg[] =
>  	"# mkdir /debug\n"
>  	"# mount -t debugfs nodev /debug\n\n"
>  	"# cat /debug/tracing/available_tracers\n"
> -	"wakeup preemptirqsoff preemptoff irqsoff ftrace sched_switch none\n\n"
> +	"wakeup preemptirqsoff preemptoff irqsoff function sysprof sched_switch nop\n\n"
>  	"# cat /debug/tracing/current_tracer\n"
> -	"none\n"
> +	"nop\n"
>  	"# echo sched_switch > /debug/tracing/current_tracer\n"
>  	"# cat /debug/tracing/current_tracer\n"
>  	"sched_switch\n"
> -- 
> 1.6.0.4
> 
> 
> 
