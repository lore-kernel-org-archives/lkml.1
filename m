Return-Path: <linux-kernel-owner+w=401wt.eu-S1754450AbYHHHXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450AbYHHHXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 03:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752123AbYHHHXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 03:23:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37318 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbYHHHXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 03:23:43 -0400
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Roland McGrath <roland@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org>
	 <489B6511.7000208@goop.org>
	 <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com>
	 <20080807222642.761AF15429D@magilla.localdomain>
	 <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 09:22:50 +0200
Message-Id: <1218180170.8625.62.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-08-07 at 21:21 -0400, Steven Rostedt wrote:

> Which would people prefer?  I little longer full build and do the 
> modification on every object, or have a shorter full build, but every 
> build will take that extra minute to do?

I have a very strong preference to do it per obj rather than at the end,
that way it can be distributed and make these fancy smp boxen useful.

Bonus points if you can make distcc dig it.

The vmlinux link path is the thing that is killing build performance,
anything to shorten that is golden, anything increasing it needs _very_
good justification.

