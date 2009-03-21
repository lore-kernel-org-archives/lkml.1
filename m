Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZCULxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZCULxl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 07:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752450AbZCULxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 07:53:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51781 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbZCULxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 07:53:30 -0400
Date: Sat, 21 Mar 2009 07:51:41 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090321115141.GA3566@redhat.com>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014244.9ADF1FC3AB@magilla.sf.frob.com> <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321041954.72b99e69.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sat, Mar 21, 2009 at 04:19:54AM -0700, Andrew Morton wrote:
> [...]
> > Utrace is very much tracing material - without the ftrace plugin the 
> > whole utrace machinery is just something that provides a _ton_ of 
> > hooks to something entirely external: SystemTap mainly.
> 
> Roland's changelogs don't mention systemtap at all afacit.
> That was, umm, major information lossage.

There have been many mixed messages from LKML on the topic - sometimes
mentioning systemtap is forbidden, other times necessary.  Sorry about
that.

There are several non-systemtap clients in existence or under
development.  You've may have heard of the ptrace cleanup, a
multi-client ptrace replacement, an on-the-fly core dumper, the ftrace
widget, user-space probes.  All of these should have somewhat
compelling non-systemtap uses, if that's an important criterion.


> Actually it seems that the whole utrace-ftrace thing is a big
> distraction and could/should just be omitted.  This is a systemtap
> feature and should be viewed as such. [...]

utrace is a better way to perform user thread management than what is
there now, and the utrace-ftrace widget shows how to *hook* thread
events such as syscalls in a lighter weight / more managed way than
the first one proposed.  (That's one reason we've been participating
in the ftrace discussions.)  Of course it can be made to use the fine
syscall pretty-printing code recently added.


- FChE
