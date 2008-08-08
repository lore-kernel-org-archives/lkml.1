Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYHHEz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYHHEz0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 00:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbYHHEzR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 00:55:17 -0400
Received: from smtpout3.tre.se ([80.251.192.228]:20624 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751180AbYHHEzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 00:55:16 -0400
Date: Fri, 8 Aug 2008 06:54:19 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Roland McGrath <roland@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 0/5] ftrace: to kill a daemon
Message-ID: <20080808045419.GA2820@uranus.ravnborg.org>
References: <20080807182013.984175558@goodmis.org> <489B6511.7000208@goop.org> <alpine.DEB.1.10.0808071721200.10092@gandalf.stny.rr.com> <20080807222642.761AF15429D@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080807222642.761AF15429D@magilla.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 07, 2008 at 03:26:42PM -0700, Roland McGrath wrote:
> > This doesn't seem any less complex than what I did. With this, I would 
> > have to come up with another way to handle modules. This will make
> > things a lot more complex.
> 
> The scheme you've implemented can apply fine to a .ko file after it's made.
> They are just .o's really.  It is presumably faster to do one step per
> final .ko rather than many tiny ones (per source file).  
> 
> That might be a benefit to doing it all at the end for vmlinux too.  I
> think the best way would be to have a vmlinux.o that we actually use in the
> link, rather than just analyzing and discarding.  Then you can just do your
> existing hack on vmlinux.o before it's linked into vmlinux.
I have patches to actually use vmlinux.o as part of the link process,
but as I hit some subtle issues with um and sparc they are not
yet ready. I plan to dust them off again and fix up the sparc and
um issues but that is not this month.

	Sam
