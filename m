Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbYHKDdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbYHKDdu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 23:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbYHKDdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 23:33:41 -0400
Received: from ozlabs.org ([203.10.76.45]:57448 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbYHKDdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 23:33:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Date: Mon, 11 Aug 2008 12:41:22 +1000
User-Agent: KMail/1.9.9
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Roland McGrath <roland@redhat.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>
References: <20080807182013.984175558@goodmis.org> <20080808182104.GA11376@Krystal> <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0808081432400.8922@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808111241.23686.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 August 2008 04:41:06 Steven Rostedt wrote:
> On Fri, 8 Aug 2008, Mathieu Desnoyers wrote:
> > kstop_machine does not guarantee that you won't have _any_ thread
> > preempted with IP pointing exactly in the middle of your instructions
> > _before_ the modification scheduled back in _after_ the modification and
> > thus causing an illegal instruction.
> >
> > Still buggy. :/
>
> Hmm, good point. Unless...

You can walk the task list and fix them up, if you have to.  Of course, this 
could be extremely slow with a million threads.  Maybe just walking the 
runqueues would be sufficient?

Rusty.
