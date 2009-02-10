Return-Path: <linux-kernel-owner+w=401wt.eu-S1754442AbZBJO0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442AbZBJO0X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 09:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754882AbZBJO0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 09:26:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:47755 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356AbZBJO0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 09:26:13 -0500
Date: Tue, 10 Feb 2009 09:26:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH 1/2] tracing/sysprof: add missing
 tracing_{start,stop}_record_cmdline()
In-Reply-To: <20090210141052.GA5836@nowhere>
Message-ID: <alpine.DEB.1.10.0902100922230.23505@gandalf.stny.rr.com>
References: <4990fdb7.0e0f660a.1d27.5399@mx.google.com> <20090210122726.GA21531@elte.hu> <20090210123145.GA1403@elte.hu> <20090210141052.GA5836@nowhere>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 10 Feb 2009, Frederic Weisbecker wrote:

Hi Frederic!

Just a quick comment about the change log. I'm still learning how to
write them too, but I'll give my 2 cents anyway ;-)

When looking a logs, I sometimes like to know the reason for the change.
So below I would have also included...

> 
> --
> >From 97113f668e9aef7ba101fbb3399e5ebb27aeec4c Mon Sep 17 00:00:00 2001
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Tue, 10 Feb 2009 15:07:22 +0100
> Subject: [PATCH] tracing/sysprof: fix a build error on sysprof tracer
> 

The sysprof tracer gets the command line data from the context switch 
tracer. We must select it otherwise we get 

>  the following build error:
> 
> kernel/built-in.o: In function `stack_trace_reset':
> trace_sysprof.c:(.text+0x3e91a): undefined reference to `tracing_stop_cmdline_record'
> kernel/built-in.o: In function `stack_trace_init':
> trace_sysprof.c:(.text+0x3e953): undefined reference to `tracing_start_cmdline_record'
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Just makes reading the logs a bit easier to see what is happening.

Thanks!

Acked-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

