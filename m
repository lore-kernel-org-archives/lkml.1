Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZDQEhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZDQEhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 00:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbZDQEgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 00:36:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:48416 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZDQEgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 00:36:53 -0400
Date: Fri, 17 Apr 2009 00:36:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 2/2] tracing/events/lockdep: move tracepoints within
 recursive protection
In-Reply-To: <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.2.00.0904170034590.20429@gandalf.stny.rr.com>
References: <20090416161543.199331330@goodmis.org>  <20090416161746.831882528@goodmis.org> <1239900469.23397.3128.camel@laptop>  <alpine.DEB.2.00.0904161343110.20429@gandalf.stny.rr.com> <1239904428.23397.3278.camel@laptop> <alpine.DEB.2.00.0904162254270.20429@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0904170002030.20429@gandalf.stny.rr.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Apr 2009, Steven Rostedt wrote:
> 
> Note, for some reason we hit int3 ??
> 
> Tracepoints do not use int3 does it?
> 
> I have kprobes defined but not any kprobe self tests on.
> 

Interesting, I disabled kprobes and all lockdep issues go away. I no 
longer get the lockdep error message, and the lockdep tracing seems to be 
working fine (without the modification of the original post).

I'll let it run the rest of the night and see how it is doing tomorrow 
morning.

Night,

-- Steve

