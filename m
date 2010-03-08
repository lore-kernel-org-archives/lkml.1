Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab0CHHHt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 02:07:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab0CHHHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 02:07:44 -0500
Date: Mon, 8 Mar 2010 08:07:32 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] tracing: function graph output for preempt/irqs-off
 tracers
Message-ID: <20100308070732.GA2057@jolsa.lab.eng.brq.redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,
any feedback?

thanks,
jirka

On Mon, Feb 22, 2010 at 01:56:58PM +0100, Jiri Olsa wrote:
> hi,
> 
> I'm sending reworked version of the graph output support for
> preemptirqsoff/preemptoff/irqsoff tracers.
> 
> I made the graph output as an output event, so it could be shared
> within tracers - patch 1/4.
> 
> I also added raw trace output for graph tracer. I have this one around
> for long time and it was quite handy for investigating graph tracer issues.
> (patch 4/4)
> 
> 
> attached patches:
> - 1/4 adding ftrace events for graph tracer
> - 2/4 graph output support for irqsoff tracer
> - 3/4 graph output support for preemptirqsoff/preemptoff tracers
> - 4/4 raw output for graph tracer
> 
> wbr,
> jirka
> ---
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace.h                 |   11 ++-
>  kernel/trace/trace_functions_graph.c |  117 +++++++++++++++++++----
>  kernel/trace/trace_irqsoff.c         |  174 ++++++++++++++++++++++++++++++++--
>  4 files changed, 277 insertions(+), 27 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
