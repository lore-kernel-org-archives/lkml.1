Return-Path: <linux-kernel-owner+w=401wt.eu-S1758787AbZCUMOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787AbZCUMOA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 08:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757312AbZCUMNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 08:13:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41699 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754367AbZCUMNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 08:13:49 -0400
Date: Sat, 21 Mar 2009 05:04:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-Id: <20090321050422.d1d99eec.akpm@linux-foundation.org>
In-Reply-To: <20090321115141.GA3566@redhat.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com>
	<20090321014244.9ADF1FC3AB@magilla.sf.frob.com>
	<20090321074301.GA19384@elte.hu>
	<20090321013912.ed6039c9.akpm@linux-foundation.org>
	<20090321091235.GA29678@elte.hu>
	<20090321041954.72b99e69.akpm@linux-foundation.org>
	<20090321115141.GA3566@redhat.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Mar 2009 07:51:41 -0400 "Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> On Sat, Mar 21, 2009 at 04:19:54AM -0700, Andrew Morton wrote:
> > [...]
> > > Utrace is very much tracing material - without the ftrace plugin the 
> > > whole utrace machinery is just something that provides a _ton_ of 
> > > hooks to something entirely external: SystemTap mainly.
> > 
> > Roland's changelogs don't mention systemtap at all afacit.
> > That was, umm, major information lossage.
> 
> There have been many mixed messages from LKML on the topic - sometimes
> mentioning systemtap is forbidden, other times necessary.  Sorry about
> that.

heh.  We all love systemtap and want it to get better.

> There are several non-systemtap clients in existence or under
> development.  You've may have heard of the ptrace cleanup, a
> multi-client ptrace replacement, an on-the-fly core dumper, the ftrace
> widget, user-space probes.  All of these should have somewhat
> compelling non-systemtap uses, if that's an important criterion.

Well I dunno.  You guys are closer to this than I am, but I'd have thought
that systemtap is the main game here, and most/all of the above is just
fluff.

IOW, "this helps systemtap" is sufficient reason for merging a kernel
change.  For sufficiently large values of "help", and sufficiently small
values of "eww", of course.



I have strong memories of being traumatised by reading the uprobes code. 
What's the story on all of that nowadays?


> 
> > Actually it seems that the whole utrace-ftrace thing is a big
> > distraction and could/should just be omitted.  This is a systemtap
> > feature and should be viewed as such. [...]
> 
> utrace is a better way to perform user thread management than what is
> there now, and the utrace-ftrace widget shows how to *hook* thread
> events such as syscalls in a lighter weight / more managed way than
> the first one proposed.  (That's one reason we've been participating
> in the ftrace discussions.)  Of course it can be made to use the fine
> syscall pretty-printing code recently added.

eh.  Boring.  Let's fix systemtap?
