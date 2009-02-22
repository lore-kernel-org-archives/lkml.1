Return-Path: <linux-kernel-owner+w=401wt.eu-S1755904AbZBVMZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbZBVMZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 07:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754064AbZBVMYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 07:24:54 -0500
Received: from mx2.redhat.com ([66.187.237.31]:50270 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbZBVMYy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 07:24:54 -0500
Date: Sun, 22 Feb 2009 07:24:25 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
Message-ID: <20090222122424.GA9951@redhat.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com> <499EE162.4050008@oracle.com> <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop> <y0mocwuptbc.fsf@ton.toronto.redhat.com> <1235304876.4632.10.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235304876.4632.10.camel@laptop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sun, Feb 22, 2009 at 01:14:36PM +0100, Peter Zijlstra wrote:
> > > I would like to never merge an ftrace_printk() user... just as I'd like
> > > to get rid of every marker.
> > 
> > But why?  They solve a problem well enough that Ingo had in effect
> > reinvented them on Friday.
> 
> Because after a printk() debug spree, I don't commit them, I toss them
> out and keep the fix.

Markers solve a problem closer to tracepoints than to debugging
printk's.

In this context, the main difference between tracepoints is that
markers need almost no hand-written glue code of the sort that make up
ftrace engines that just trace simple values.  Simpler & smaller code
for the same output seems like a win.

- FChE
