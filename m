Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab0CHPLa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:11:30 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37412 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414Ab0CHPL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:11:28 -0500
X-Authority-Analysis: v=1.0 c=1 a=PW-0km1n5IAA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=jNzPz81SZkJaT6viOjoA:9 a=YXZX4Q3x259_dOmFCKQA:7 a=4r9HjNDOcwqJghN7BxDRcer5OFEA:4 a=PUjeQqilurYA:10 a=x8gzFH9gYPwA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/4] tracing: function graph output for
 preempt/irqs-off tracers
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jiri Olsa <jolsa@redhat.com>
Cc: mingo@elte.hu, fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100308070732.GA2057@jolsa.lab.eng.brq.redhat.com>
References: <1266843422-18288-1-git-send-email-jolsa@redhat.com>
	 <20100308070732.GA2057@jolsa.lab.eng.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Mon, 08 Mar 2010 10:11:26 -0500
Message-ID: <1268061086.10871.1808.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-08 at 08:07 +0100, Jiri Olsa wrote:
> hi,
> any feedback?

Ah, I forgot about this patch set. I'll take a look at it today.

Thanks,

-- Steve

> 
> thanks,
> jirka
> 
> On Mon, Feb 22, 2010 at 01:56:58PM +0100, Jiri Olsa wrote:
> > hi,
> > 
> > I'm sending reworked version of the graph output support for
> > preemptirqsoff/preemptoff/irqsoff tracers.
> > 
> > I made the graph output as an output event, so it could be shared
> > within tracers - patch 1/4.
> > 
> > I also added raw trace output for graph tracer. I have this one around
> > for long time and it was quite handy for investigating graph tracer issues.
> > (patch 4/4)
> > 
> > 
> > attached patches:
> > - 1/4 adding ftrace events for graph tracer
> > - 2/4 graph output support for irqsoff tracer
> > - 3/4 graph output support for preemptirqsoff/preemptoff tracers
> > - 4/4 raw output for graph tracer
> > 
> > wbr,
> > jirka
> > ---
> >  kernel/trace/trace.c                 |    2 +-
> >  kernel/trace/trace.h                 |   11 ++-
> >  kernel/trace/trace_functions_graph.c |  117 +++++++++++++++++++----
> >  kernel/trace/trace_irqsoff.c         |  174 ++++++++++++++++++++++++++++++++--
> >  4 files changed, 277 insertions(+), 27 deletions(-)
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


