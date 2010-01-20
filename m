Return-Path: <linux-kernel-owner+w=401wt.eu-S1756352Ab0ATHaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab0ATHaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 02:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990Ab0ATHaJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 02:30:09 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34364 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0ATHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 02:30:08 -0500
Date: Wed, 20 Jan 2010 08:29:25 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100120072925.GA11395@elte.hu>
References: <20100119211646.GF16096@redhat.com>
 <20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
 <20100120054950.GB27108@elte.hu>
 <20100120061551.GB6588@in.ibm.com>
 <20100120062834.GB12165@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120062834.GB12165@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:
> 
> > On Wed, Jan 20, 2010 at 06:49:50AM +0100, Ingo Molnar wrote:
> > 
> > Ingo,
> > 
> > > Note, i'm not yet convinced that this (and the rest: uprobes and systemtap, 
> > > etc.) can go uptream in its present form.
> > 
> > Agreed, uprobes is still not upstream ready -- it was an RFC. We are
> > working through the comments there to get it ready for merger.
> > 
> > > IMHO the far more important thing to address beyond formalities and workflow 
> > > cleanliness are the (many) technical observations and objections offered by 
> > > Peter Zijstra on lkml. Not just the git history but also the abstractions and 
> > > concepts are messy and should be reworked IMO, and also good and working perf 
> > > events integration should be achieved, etc.
> > 
> > I think Oleg addressed most of Peter's concerns on utrace when the 
> > ptrace/utrace patchset was reposted.
> 
> Peter is Cc:-ed and he might want to chime in.
> 
> > Perf integration with uprobes will be done and discussions have started with 
> > Masami and Frederic. There are a couple of fundamental technical aspects 
> > (XOL vma vs. emulation; breakpoint insertion through CoW and not through 
> > quiesce) that need resolution.
> > 
> > > The fact that there's a well established upstream workflow for instrumentation 
> > > patches, which is being routed around by the utrace/uprobes/systemtap code 
> > > here is not a good sign in terms of reaching a good upstream solution. Lets 
> > > hope it works out well though.
> > 
> > Agreed.
> > 
> > On the other hand, having ptrace/utrace in the -next tree will give it a
> > lot more testing, while any outstanding technical issues are being addressed.
> 
> Including experimental code that is RFC and which is not certain to go 
> upstream is certainly not the purpose of linux-next though.
> 
> It will cause conflicts with various other trees and increases the overhead 
> all around. It also causes us to trust linux-next bugreports less - as it's 
> not the 'next Linux' anymore. Also, there's virtually no high-level 
> technical review done in linux-next: the trees are implicitly trusted 
> (because they are pushed by maintainers), bugs and conflicts are reported 
> but otherwise it's a neutral tree that includes pretty much any commit 
> indiscriminately.
> 
> If you need review and testing there's a number of trees you can get 
> inclusion into.

Btw., the utrace code has lived in -mm for quite some time - that's an 
excellent route as Andrew does thorough review and testing.

If Andrew agrees with this particular tree as-is and wants these bits to live 
in linux-next and have it in -mm that way then that's a fair approach 
obviously and i have no objections ...

The point is to have at least one relevant maintainer request and track it and 
then supervise the completion of it (which includes the resolution of all 
outstanding objections) and then push it to Linus.

	Ingo
