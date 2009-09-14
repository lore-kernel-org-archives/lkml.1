Return-Path: <linux-kernel-owner+w=401wt.eu-S1757078AbZINUxp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078AbZINUxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:53:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbZINUxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:53:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:46952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbZINUxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:53:42 -0400
Subject: Re: [PATCH v4] ftrace: document basic ftracer/ftracer graph needs
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <8bd0f97a0909141321t515648c7ue0a7d377b99f13f5@mail.gmail.com>
References: <20090614012457.GD5986@nowhere>
	 <1244948719-22216-1-git-send-email-vapier@gentoo.org>
	 <1252957702.20020.53.camel@gandalf.stny.rr.com>
	 <8bd0f97a0909141321t515648c7ue0a7d377b99f13f5@mail.gmail.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 14 Sep 2009 16:53:43 -0400
Message-Id: <1252961623.20020.56.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-14 at 16:21 -0400, Mike Frysinger wrote:
> On Mon, Sep 14, 2009 at 15:48, Steven Rostedt wrote:
> > On Sat, 2009-06-13 at 23:05 -0400, Mike Frysinger wrote:
> >> diff --git a/Documentation/trace/ftrace.txt b/Documentation/trace/ftrace.txt
> >> index fd9a3e6..95a39fb 100644
> >> --- a/Documentation/trace/ftrace.txt
> >> +++ b/Documentation/trace/ftrace.txt
> >> @@ -27,6 +27,12 @@ disabled, and more (ftrace allows for tracer plugins, which
> >>  means that the list of tracers can always grow).
> >>
> >>
> >> +Implementation Details
> >> +----------------------
> >> +
> >> +See ftrace-implementation.txt for details for arch porters and such.
> >
> > Might want to specify that this is for the function tracer.
> 
> well, all of ftrace.txt says "function tracer", so if/when someone
> cleans that up, this will get fixed in the process.

Well things do need to be clean up, the original code had the function
tracer called ftrace, which it no longer does. Why add more incorrect
documentation just to match the previous incorrect documentation?

> 
> >> --- a/kernel/trace/Kconfig
> >> +++ b/kernel/trace/Kconfig
> >> @@ -11,31 +11,41 @@ config NOP_TRACER
> >>
> >>  config HAVE_FTRACE_NMI_ENTER
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_FUNCTION_TRACER
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_FUNCTION_GRAPH_TRACER
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_FUNCTION_TRACE_MCOUNT_TEST
> >>       bool
> >>       help
> >> -      This gets selected when the arch tests the function_trace_stop
> >> -      variable at the mcount call site. Otherwise, this variable
> >> -      is tested by the called function.
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_DYNAMIC_FTRACE
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_FTRACE_MCOUNT_RECORD
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config HAVE_HW_BRANCH_TRACER
> >>       bool
> >>
> >>  config HAVE_FTRACE_SYSCALLS
> >>       bool
> >> +     help
> >> +       See Documentation/trace/ftrace-implementation.txt
> >>
> >>  config TRACER_MAX_TRACE
> >>       bool
> >
> > Other than this, it looks good.
> 
> so you want me to drop the Kconfig pieces ?  there was discussion in
> this thread about why the Kconfig pieces were here ...

I'm fine with the Kconfig, I was referencing my own comments, not the
above.

-- Steve


