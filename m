Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963Ab0AMP64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963Ab0AMP64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:58:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755327Ab0AMP6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:58:55 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:50403 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309Ab0AMP6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:58:54 -0500
Date: Wed, 13 Jan 2010 07:58:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Nicholas Miell <nmiell@comcast.net>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       josh@joshtriplett.org, tglx@linutronix.de, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, laijs@cn.fujitsu.com, dipankar@in.ibm.com
Subject: Re: [RFC PATCH] introduce sys_membarrier(): process-wide memory
	barrier (v5)
Message-ID: <20100113155845.GA6803@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100113013757.GA29314@Krystal> <1263358823.3874.10.camel@entropy> <20100113053126.GC6781@linux.vnet.ibm.com> <1263361196.3874.12.camel@entropy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263361196.3874.12.camel@entropy>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 12, 2010 at 09:39:56PM -0800, Nicholas Miell wrote:
> On Tue, 2010-01-12 at 21:31 -0800, Paul E. McKenney wrote:
> > Why is it OK to ignore the developer's request for an expedited
> > membarrer()?  The guy who expected the syscall to complete in a few
> > microseconds might not be so happy to have it take many milliseconds.
> > By the same token, the guy who specified non-expedited so as to minimally
> > disturb other threads in the system might not be so happy to see them
> > all be IPIed for no good reason.  ;-)
> > 
> > 							Thanx, Paul
> 
> Because the behavior is still correct, even if it is slower than you'd
> expect. It doesn't really matter where the expedited flag goes, though,
> because every future kernel will understand it.

In a real-time application, no shortage of which run on Linux, "going
slower than you expect" is a bug, right?

							Thanx, Paul
