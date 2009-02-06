Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZBFBtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZBFBtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 20:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752103AbZBFBtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 20:49:01 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50538 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783AbZBFBtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 20:49:00 -0500
Date: Thu, 5 Feb 2009 23:48:40 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH tip 1/2] ring_buffer: remove unused flags parameter
Message-ID: <20090206014840.GE9846@ghostprotocols.net>
References: <20090205181256.GH17653@ghostprotocols.net> <20090205221701.GA23999@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090205221701.GA23999@nowhere>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 05, 2009 at 11:17:02PM +0100, Frederic Weisbecker escreveu:
> On Thu, Feb 05, 2009 at 04:12:56PM -0200, Arnaldo Carvalho de Melo wrote:
> > Impact: API change, cleanup
> > 
> > From ring_buffer_{lock_reserve,unlock_commit}.
> > 
> > Cc: Ingo Molnar <mingo@elte.hu>
> > Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> > Cc: Jens Axboe <jens.axboe@oracle.com>
> > Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> > ---
> >  block/blktrace.c                 |    8 +++---
> >  include/linux/ring_buffer.h      |    9 ++----
> >  kernel/trace/kmemtrace.c         |   12 +++-----
> >  kernel/trace/ring_buffer.c       |    9 +-----
> >  kernel/trace/trace.c             |   56 +++++++++++++------------------------
> >  kernel/trace/trace_boot.c        |   12 +++-----
> >  kernel/trace/trace_branch.c      |    7 ++---
> >  kernel/trace/trace_hw_branches.c |    6 ++--
> >  kernel/trace/trace_mmiotrace.c   |   12 +++-----
> >  kernel/trace/trace_power.c       |   12 +++-----
> >  10 files changed, 51 insertions(+), 92 deletions(-)
> > 
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

My marketing dept is not so good, but since you liked it, I guess its
appropriate to point you to this, that is the only documentation
available about it and some of its friends, like pahole:

https://ols2006.108.redhat.com/2007/Reprints/melo-Reprint.pdf

Now back to the Rostedts extended TODO list.

- Arnaldo
