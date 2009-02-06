Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbZBFAFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbZBFAFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 19:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753208AbZBFAFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 19:05:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069AbZBFAFD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 19:05:03 -0500
Date: Fri, 6 Feb 2009 01:04:55 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Steven Rostedt <rostedt@goodmis.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090206000455.GE16040@elte.hu>
References: <20090205181256.GH17653@ghostprotocols.net> <20090205221701.GA23999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205221701.GA23999@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > $ codiff /tmp/vmlinux.before /tmp/vmlinux.after
> > linux-2.6-tip/kernel/trace/trace.c:
> >   trace_vprintk              |  -14
> >   trace_graph_return         |  -14
> >   trace_graph_entry          |  -10
> >   trace_function             |   -8
> >   __ftrace_trace_stack       |   -8
> >   ftrace_trace_userstack     |   -8
> >   tracing_sched_switch_trace |   -8
> >   ftrace_trace_special       |  -12
> >   tracing_sched_wakeup_trace |   -8
> >  9 functions changed, 90 bytes removed, diff: -90
> > 
> > linux-2.6-tip/block/blktrace.c:
> >   __blk_add_trace |   -1
> >  1 function changed, 1 bytes removed, diff: -1
> > 
> > /tmp/vmlinux.after:
> >  10 functions changed, 91 bytes removed, diff: -91
> 
> 
> codiff... I didn't know this great tool! :-)

yes, very nice!

I've moved all the codiff output from the (discarded) diffstat
section into the commit log, they are very much worth preserving.

	Ingo
