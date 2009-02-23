Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbZBWAX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbZBWAX3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 19:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbZBWAXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 19:23:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56247 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZBWAXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 19:23:20 -0500
Date: Sun, 22 Feb 2009 19:23:17 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Ingo Molnar <mingo@elte.hu>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       zippel@linux-m68k.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
In-Reply-To: <1235302980.4632.8.camel@laptop>
Message-ID: <alpine.DEB.2.00.0902221922360.18221@gandalf.stny.rr.com>
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>  <499EE162.4050008@oracle.com>  <20090220172241.GF24538@elte.hu> <1235302980.4632.8.camel@laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Feb 2009, Peter Zijlstra wrote:

> On Fri, 2009-02-20 at 18:22 +0100, Ingo Molnar wrote:
> > Eventually we should eliminate markers, their uses can either be 
> > converted to new-style tracepoints, or to ftrace_printk().
> 
> I would like to never merge an ftrace_printk() user... just as I'd like
> to get rid of every marker.
> 
> Then again, some people appear happy to commit their printk debug spree
> too :/

/me looks at arch/powerpc/kernel/ftrace.c and realizes that he's guilty as 
charged :-p

-- Steve

