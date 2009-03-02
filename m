Return-Path: <linux-kernel-owner+w=401wt.eu-S1759099AbZCBHaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759099AbZCBHaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 02:30:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZCBH3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 02:29:55 -0500
Received: from rv-out-0506.google.com ([209.85.198.229]:30375 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZCBH3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 02:29:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kcuMA7vqWAOytOpPMJdKfuZ5TBw0D7A4b4Or7tbDywzM6d+P0J9+6vpC9eMFQHUcpO
         2vL3WKWDOszZrdcmd/bvAWveQYhGDGrjE/N5u/XmQZVUeVkKI2ZOL4Kv1kfBaLGHUQKd
         b81lANlZqWUUHNbgB4RrIgu7gY+IFcdze8qP8=
Subject: Re: [PATCH 2/4] zedtrace generic kernel filtering
From: Tom Zanussi <tzanussi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090228092657.GA2869@elte.hu>
References: <1235725256.8512.88.camel@charm-linux>
	 <20090228092657.GA2869@elte.hu>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 01:29:49 -0600
Message-Id: <1235978989.7581.46.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2009-02-28 at 10:26 +0100, Ingo Molnar wrote:
> * Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > Add generic kernel filtering.
> > 
> > Signed-off-by: Tom Zanussi <tzanussi@gmail.com>
> > 
> > ---
> >  kernel/trace/trace_binary/Makefile     |    2 +-
> >  kernel/trace/trace_binary/zed.c        |  103 +++++++++--
> >  kernel/trace/trace_binary/zed.h        |   15 ++
> >  kernel/trace/trace_binary/zed_filter.c |  301 ++++++++++++++++++++++++++++++++
> >  kernel/trace/trace_binary/zed_filter.h |   45 +++++
> >  kernel/trace/trace_binary/zed_sched.c  |    4 +
> >  6 files changed, 451 insertions(+), 19 deletions(-)
> >  create mode 100644 kernel/trace/trace_binary/zed_filter.c
> >  create mode 100644 kernel/trace/trace_binary/zed_filter.h
> 
> Nice!
> 

Thanks!

> This fits really nicely into the ftrace principles and i'd love 
> to see this feature merged into ftrace - would you be interested 
> in working on that? If so then you can find the latest tracing 

Sure, but I'm not too familiar with the ftrace code and wouldn't have
big blocks of time to devote to it, so if it's something that's needed
"right away", I'll probably have to defer to letting someone else adapt
the code if they wanted to.

> tree at:
> 
>     http://people.redhat.com/mingo/tip.git/README
> 
> Note that Steve added explicit field enumeration and 'raw' C 
> syntax tracepoints to the event tracer earlier today (partly 
> based on your ideas here), so that would be a good basis to 
> extend/enhance/fix, if you are interested.
> 

Yeah, I took a quick look and saw some nice improvements.  Anyway, the
filtering I did for this was basically a side-effect of the event
description stuff, which made the filtering relatively easy to do (and
the event description files give the user a way to list the available
fields).  What I'm wondering is if you're interested in the filtering
part alone or in the event description part as well, which I hadn't
thought of as separable (I guess I need to look at the current ftrace
code to see what's already there).

Thanks,

Tom

> Thanks,
> 
> 	Ingo

