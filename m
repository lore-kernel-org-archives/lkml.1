Return-Path: <linux-kernel-owner+w=401wt.eu-S1754669AbYJUND6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbYJUND6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 09:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbYJUNDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 09:03:39 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63313 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338AbYJUNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 09:03:38 -0400
Date: Tue, 21 Oct 2008 09:03:35 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Lockup in tracepoint unregister in sched switch ftrace plugin
In-Reply-To: <20081021120813.GA9672@elte.hu>
Message-ID: <alpine.DEB.1.10.0810210901560.23042@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810202336560.25193@gandalf.stny.rr.com> <alpine.DEB.1.10.0810210012440.25193@gandalf.stny.rr.com> <20081021120813.GA9672@elte.hu>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 21 Oct 2008, Ingo Molnar wrote:
> > 
> > Note, I just booted this kernel with CONFIG_NOHZ=n and it booted fine. 
> > This looks like a bug somewhere in tracepoints/RCU/dynamic-ticks
> 
> does it work with fb02fbc14 reverted? (see the reverter patch below or 
> try tip/master)

Yes! With this revert (I applied your patch) it now boots with 
CONFIG_NO_HZ=y.

(now I go look to see why preemptoff failed its selftest)

-- Steve

