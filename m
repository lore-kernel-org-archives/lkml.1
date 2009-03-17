Return-Path: <linux-kernel-owner+w=401wt.eu-S1756084AbZCQPbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756084AbZCQPbU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756010AbZCQPar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:30:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:32931 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZCQPam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:30:42 -0400
Date: Tue, 17 Mar 2009 11:30:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Christoph Hellwig <hch@infradead.org>
cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Theodore Tso <tytso@mit.edu>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Jiaying Zhang <jiayingz@google.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 2/7] tracing: replace TP<var> with TP_<var>
In-Reply-To: <20090317075852.GA9960@infradead.org>
Message-ID: <alpine.DEB.2.00.0903171130110.10274@gandalf.stny.rr.com>
References: <20090310045710.286915983@goodmis.org> <20090310045810.833427485@goodmis.org> <20090317075852.GA9960@infradead.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 17 Mar 2009, Christoph Hellwig wrote:

> On Tue, Mar 10, 2009 at 12:57:12AM -0400, Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > Impact: clean up
> > 
> > The macros TPPROTO, TPARGS, TPFMT, TPRAWFMT, and TPCMD all look a bit
> > ugly. This patch adds an underscore to their names.
> 
> Honestly I think they still look ugly.
> 
> >  DECLARE_TRACE(subsys_eventname,
> > -	TPPROTO(int firstarg, struct task_struct *p),
> > -	TPARGS(firstarg, p));
> > +	TP_PROTO(int firstarg, struct task_struct *p),
> > +	TP_ARGS(firstarg, p));
> 
> Compare that to a
> 
> DECLARE_TRACE(subsys_eventname,
> 	trace_proto(int firstarg, struct task_struct *p),
> 	trace_args(firstarg, p));
> 
> or even when you insist on UPPERCASE:
> 
> DECLARE_TRACE(subsys_eventname,
> 	TRACE_PROTO(int firstarg, struct task_struct *p),
> 	TRACE_ARGS(firstarg, p));

I have no attachement to the name. I can switch it to TRACE_PROTO etc.

Thanks,

-- Steve

