Return-Path: <linux-kernel-owner+w=401wt.eu-S1753714AbYJWXC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbYJWXC2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756734AbYJWXCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:02:11 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:43901 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbYJWXCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:02:09 -0400
Date: Thu, 23 Oct 2008 19:02:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ftrace: ftrace dump on oops control
In-Reply-To: <20081023155440.3b90e129.randy.dunlap@oracle.com>
Message-ID: <alpine.DEB.1.10.0810231900500.9459@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231514140.8986@gandalf.stny.rr.com> <20081023155440.3b90e129.randy.dunlap@oracle.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 23 Oct 2008, Randy Dunlap wrote:

> On Thu, 23 Oct 2008 15:15:27 -0400 (EDT) Steven Rostedt wrote:
> 
> > +/**
> > + * ftrace_dump_on_oops - variable to dump ftrace buffer on oops
> > + *
> > + * If there is an oops (or kernel panic) and the ftrace_dump_on_oops
> > + * is set, then ftrace_dump is called. This will output the contents
> > + * of the ftrace buffers to the console.  This is very useful for
> > + * capturing traces that lead to crashes and outputing it to a
> > + * serial console.
> > + *
> > + * It is default off, but you can enable it with either specifying
> > + * "ftrace_dump_on_oops" in the kernel command line, or setting
> > + * /proc/sys/kernel/ftrace_dump_on_oops to true.
> > + */
> > +int ftrace_dump_on_oops;
> 
> Hi Steven,
> 
> Please lose the /** (just use /*).  The documentation is a good thing,
> but we don't do kernel-doc for simple variables.
> That might be a good thing to add one day....

OK, will do. Yeah, this variable is kind of special, and I wanted it to
be documented well. Oh well, I'll have to wait for kernel-doc to do
variables ;-)

I'll send a new patch that does the update.

-- Steve

