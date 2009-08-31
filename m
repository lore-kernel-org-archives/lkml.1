Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbZHaSJH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbZHaSJH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 14:09:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbZHaSJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 14:09:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:60501 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310AbZHaSJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 14:09:04 -0400
Date: Mon, 31 Aug 2009 14:09:04 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       David Miller <davem@davemloft.net>, Neil Horman <nhorman@tuxdriver.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wei Yongjun <yjwei@cn.fujitsu.com>, Netdev <netdev@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] tracing/events: convert NAPI's tracepoint via
 TRACE_EVENT
In-Reply-To: <20090831084922.GB25811@elte.hu>
Message-ID: <alpine.DEB.2.00.0908311407060.13931@gandalf.stny.rr.com>
References: <4A9B6AA7.5020508@cn.fujitsu.com> <20090831084922.GB25811@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 31 Aug 2009, Ingo Molnar wrote:

> 
> * Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
> > - Convert NAPI's tracepoint via TRACE_EVENT macro, the output information
> >   like below:
> 
> I think as long as it does not touch tracing infrastructure (which 
> your patches dont do in their current form) this should be 
> done/merged via the networking tree.

I agree, all changes that are in include/trace/events/ and trace point 
usage can stay within the subsystem tree.

> 
> [ There might be some small collisions in define_trace.h (because
>   these tracepoints move from legacy to new-style TRACE_EVENT() 
>   form) but that's OK. ]

But changes to anything in include/trace or kernel/trace needs to go 
throught the tracing subsystem. This includes a changes to define_trace.h.

Thanks,

-- Steve

