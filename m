Return-Path: <linux-kernel-owner+w=401wt.eu-S1754130Ab0AXQh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab0AXQh7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 11:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754114Ab0AXQh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 11:37:57 -0500
Received: from www.tglx.de ([62.245.132.106]:59675 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111Ab0AXQh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 11:37:56 -0500
Date: Sun, 24 Jan 2010 17:36:21 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Tom Zanussi <tzanussi@gmail.com>,
       systemtap@sources.redhat.com, dle-develop@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com
Subject: Re: linux-next: add utrace tree
In-Reply-To: <20100123120301.GD7828@redhat.com>
Message-ID: <alpine.LFD.2.00.1001241731270.2906@localhost.localdomain>
References: <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org>
 <20100122012516.GE22003@redhat.com> <alpine.LFD.2.00.1001211729080.13231@localhost.localdomain> <20100122022255.GF22003@redhat.com> <alpine.LFD.2.00.1001211826060.13231@localhost.localdomain> <20100123060401.GB19399@elte.hu>
 <20100123120301.GD7828@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Jan 2010, Frank Ch. Eigler wrote:
> On Sat, Jan 23, 2010 at 07:04:01AM +0100, Ingo Molnar wrote:
> 
> > [...]  Also, if any systemtap person is interested in helping us
> > create a more generic filter engine out of the current ftrace filter
> > engine (which is really a precursor of a safe, sandboxed in-kernel
> > script engine), that would be excellent as well. [...]
> 
> Thank you for the invitation.
> 
> > More could be done - a simple C-like set of function perhaps - some minimal 
> > per probe local variable state, etc. (perhaps even looping as well, with a 
> > limit on number of predicament executions per filter invocation.)
> 
> Yes, at some point when such bytecode intepreter gets rich enough, one
> may not need the translated-to-C means of running scripts.
> 
> 
> > ( _Such_ a facility, could then perhaps be used to allow applications access 
> >   to safe syscall sandboxing techniques: i.e. a programmable seccomp concept 
> >   in essence, controlled via ASCII space filter expressions [...]
> >   IMHO that would be a superior concept for security modules too [...]
> >
> > [...]  specific functionality with an immediately visible upside,
> > with no need for opaque hooks.
> 
> This OTOH seem like rather a stretch.  If one claims that "opaque
> hooks" are bad, so instead have hooks that jump not to auditable C
> code but an bytecode interpreter?  And have the bytecodes be uploaded
> from userspace?  How is this supposed to produce "transparency" from
> the kernel/hook point of view?

Simply because the kernel controls which byte code is executed and has
control over the functionality behind it. That makes the hooks well
defined and transparent.

Thanks,

	tglx
