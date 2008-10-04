Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYJDRSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYJDRSX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 13:18:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYJDRSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 13:18:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38330 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbYJDRSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 13:18:15 -0400
Date: Sat, 4 Oct 2008 13:18:14 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 0/3] ring-buffer: less locking and only disable
 preemption
In-Reply-To: <20081004163348.GA23593@Krystal>
Message-ID: <alpine.DEB.1.10.0810041315440.6571@gandalf.stny.rr.com>
References: <20081004060057.660306328@goodmis.org> <20081004084002.GE27624@elte.hu> <alpine.DEB.1.10.0810041015330.4551@gandalf.stny.rr.com> <20081004163348.GA23593@Krystal>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 4 Oct 2008, Mathieu Desnoyers wrote:
> 
> Or use this code, based on a temporary breakpoint, to do the code
> patching (part of the -lttng tree). It does not require stop_machine at
> all and is nmi safe.
> 

When this is supported for all archs, and can be done at all functions 
then I could use it.

I may just have the arch specific code use it, but we'll see.

Also, how good is it at patching 20,000 call sites?

-- Steve

