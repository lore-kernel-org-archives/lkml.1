Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbZLHNbm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbZLHNbm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 08:31:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZLHNbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 08:31:42 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46735 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754822AbZLHNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 08:31:41 -0500
X-Authority-Analysis: v=1.0 c=1 a=kd4J5hv4N5wA:10 a=u8Wft6Q5H0WCc344sdEA:9 a=R-Q5XAHlOOdCOcxMdbNYVDgEgpcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 00/13] tracing: various cleanups and small fixes
 (updated)
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20091208122255.GB5016@nowhere>
References: <4B1DC476.3030700@cn.fujitsu.com>
	 <20091208122255.GB5016@nowhere>
Content-Type: text/plain
Date: Tue, 08 Dec 2009 08:29:40 -0500
Message-Id: <1260278980.2165.21.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 13:23 +0100, Frederic Weisbecker wrote:
> On Tue, Dec 08, 2009 at 11:13:58AM +0800, Li Zefan wrote:
> > Updates:
> > 
> > - took a further step to save more spaces (01/13)
> > - fixed a mistake in (03/13)
> > - collected some ACKs
> > 
> > 
> > Here are some patches that I've collected. All are cleanups and
> > small fixes, no change in functionality.
> > 
> > As a result, 24K bytes are saved, and 87 lines of code are
> > reduced:
> > 
> >    text    data     bss     dec     hex filename
> > 5355293 1961928 7103260 14420481         dc0a01 vmlinux.o.old
> > 5331208 1961864 7103260 14396332         dbabac vmlinux.o
> > 
> > ---
> >  include/linux/ftrace_event.h       |    4 +-
> >  include/linux/syscalls.h           |    6 +-
> >  include/trace/ftrace.h             |   56 ++-----------
> >  kernel/trace/ftrace.c              |   30 ++++---
> >  kernel/trace/power-traces.c        |    2 -
> >  kernel/trace/trace.c               |  166 +++++++++++++-----------------------
> >  kernel/trace/trace.h               |   23 +++---
> >  kernel/trace/trace_event_profile.c |    6 +-
> >  kernel/trace/trace_events.c        |   38 +++++++--
> >  kernel/trace/trace_export.c        |    4 -
> >  kernel/trace/trace_kprobe.c        |    9 --
> >  kernel/trace/trace_ksym.c          |   13 ++--
> >  kernel/trace/trace_syscalls.c      |   18 +----
> >  13 files changed, 144 insertions(+), 231 deletions(-)
> 
> 
> I'm queuing these patches.

I don't mind you queing them, but I still want to have a deeper look.
Could you hold on a bit. I'll look at them today, and give an ack, or
comments later on.

Thanks,

-- Steve


