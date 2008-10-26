Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYJZN6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYJZN6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 09:58:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbYJZN6H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 09:58:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57784 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbYJZN6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 09:58:06 -0400
Date: Sun, 26 Oct 2008 09:58:01 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v2][RFC] ftrace: function oprofiler
In-Reply-To: <1225017357.27415.5.camel@twins>
Message-ID: <alpine.DEB.1.10.0810260951500.20123@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810250130020.27727@gandalf.stny.rr.com>  <alpine.DEB.1.10.0810252049020.7650@gandalf.stny.rr.com> <1225017357.27415.5.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 26 Oct 2008, Peter Zijlstra wrote:

> On Sat, 2008-10-25 at 20:55 -0400, Steven Rostedt wrote:
> 
> > This is a function profiler to count the number of times a function is hit.
> 
> I have to ask, _why_?
> 
> It seems like a nice enough gimmick, but is this information actually
> useful?

Well, it does let you know for sure which functions are the hottest paths.
Perhaps you have a "slow path" function. This will show you how slow
that slow path is. That is, how many times it is hit compared to the
fast path.

With dynamic ftrace, you can also pick and choose which functions
are to be counted.

What is also nice about it (and something that I will use it for), is that
it will show you the functions that will be hit the most during a trace. 
If you do not care about those functions, then you can easily filter them 
out for your trace.

This patch is also a proof of concept. I'm sure others can think of more 
useful things to do by adding more stuff to this patch.

-- Steve

