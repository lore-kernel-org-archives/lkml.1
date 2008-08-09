Return-Path: <linux-kernel-owner+w=401wt.eu-S1753910AbYHIOZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910AbYHIOZe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 10:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751946AbYHIOZ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 10:25:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:41473 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbYHIOZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 10:25:25 -0400
Date: Sat, 9 Aug 2008 10:25:22 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Bodo Eggert <7eggert@gmx.de>
cc: Andi Kleen <andi@firstfloor.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <alpine.DEB.1.10.0808090902100.24140@gandalf.stny.rr.com>
Message-ID: <alpine.DEB.1.10.0808091024110.25265@gandalf.stny.rr.com>
References: <aYipy-5FM-9@gated-at.bofh.it> <aYiIP-6bN-11@gated-at.bofh.it> <aYkAT-15Q-1@gated-at.bofh.it> <aYDX5-fa-31@gated-at.bofh.it> <aYE6H-tg-21@gated-at.bofh.it> <aYEgj-Fc-17@gated-at.bofh.it> <aYEJq-1xB-23@gated-at.bofh.it> <aYET8-1L7-17@gated-at.bofh.it>
 <aYFcq-2f2-11@gated-at.bofh.it> <aYFvP-2Vc-25@gated-at.bofh.it> <aYJIZ-15G-7@gated-at.bofh.it> <aYKvs-2gQ-7@gated-at.bofh.it> <aYKF1-2qs-7@gated-at.bofh.it> <E1KRmxa-0001S5-E0@be1.7eggert.dyndns.org>
 <alpine.DEB.1.10.0808090902100.24140@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 9 Aug 2008, Steven Rostedt wrote:
> > 
> > Did you try short jumps? (0xeb 0x03 0x?? 0x?? 0x??)
> 
> What would those last three bytes be?

Ah, I see, you jump 3 bytes forward.

I'm pretty sure that it is still more expensive than a nop, on some archs.
But I'm not 100% sure on that.

-- Steve

