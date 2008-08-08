Return-Path: <linux-kernel-owner+w=401wt.eu-S1757403AbYHHLbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbYHHLbU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbYHHLbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:31:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754282AbYHHLbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:31:09 -0400
Date: Fri, 8 Aug 2008 07:31:06 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Peter Zijlstra <peterz@infradead.org>
cc: Roland McGrath <roland@redhat.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
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
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
In-Reply-To: <1218180170.8625.62.camel@twins>
Message-ID: <alpine.DEB.1.10.0808080729480.19865@gandalf.stny.rr.com>
References: <20080807182013.984175558@goodmis.org>  <489B6511.7000208@goop.org>  <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com>  <20080807222642.761AF15429D@magilla.localdomain>  <alpine.DEB.1.10.0808072113290.18565@gandalf.stny.rr.com>
 <1218180170.8625.62.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 8 Aug 2008, Peter Zijlstra wrote:

> On Thu, 2008-08-07 at 21:21 -0400, Steven Rostedt wrote:
> 
> > Which would people prefer?  I little longer full build and do the 
> > modification on every object, or have a shorter full build, but every 
> > build will take that extra minute to do?
> 
> I have a very strong preference to do it per obj rather than at the end,
> that way it can be distributed and make these fancy smp boxen useful.
> 
> Bonus points if you can make distcc dig it.

Yes, the CC used in the script does indeed use distcc (if you are using 
it).

;-)

-- Steve

> 
> The vmlinux link path is the thing that is killing build performance,
> anything to shorten that is golden, anything increasing it needs _very_
> good justification.
> 
> 
