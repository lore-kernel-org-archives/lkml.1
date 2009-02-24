Return-Path: <linux-kernel-owner+w=401wt.eu-S1760963AbZBXWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760963AbZBXWLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 17:11:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759072AbZBXWLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 17:11:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51193 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758801AbZBXWLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 17:11:13 -0500
Date: Tue, 24 Feb 2009 17:11:10 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, peterz@infradead.org, fweisbec@gmail.com,
       tytso@mit.edu, arjan@infradead.org, pq@iki.fi, acme@redhat.com,
       jbaron@redhat.com, mbligh@google.com, compudj@krystal.dyndns.org,
       fche@redhat.com, kosaki.motohiro@jp.fujitsu.com, jens.axboe@oracle.com,
       mhiramat@redhat.com, srostedt@redhat.com
Subject: Re: [PATCH 1/4][RFC] tracing: add event trace infrastructure
In-Reply-To: <20090224194650.GC28772@elte.hu>
Message-ID: <alpine.DEB.2.00.0902241710240.12697@gandalf.stny.rr.com>
References: <20090224193344.638329210@goodmis.org> <20090224193450.734369391@goodmis.org> <20090224114217.d30ab19a.akpm@linux-foundation.org> <20090224194650.GC28772@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 24 Feb 2009, Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Tue, 24 Feb 2009 14:33:45 -0500
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> > 
> > > +#define DECLARE_TRACE_FMT(call, proto, args, fmt, fmt_args)		\
> > > +static void ftrace_event_##call(proto)					\
> > > +{									\
> > > +	event_trace_printk(_RET_IP_, "(%s) " fmt "\n", #call, fmt_args); \
> > > +}									\
> > 
> > <anal>This macro emits a definition, not a declaration.</anal>
> 
> yes indeed :) It got modified from one that emitted a 
> declaration to also emit a definition and the name was not 
> converted.

Yes, I was just adding a modification of DECLARE_TRACE which was indeed a 
declare, but converted it to DECLARE_TRACE_FMT.

Would DEFINE_TRACE_FMT(...) be better?

-- Steve

