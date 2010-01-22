Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909Ab0AVWOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0AVWOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613Ab0AVWOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 17:14:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753169Ab0AVWOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 17:14:22 -0500
Date: Fri, 22 Jan 2010 17:13:48 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100122221348.GA4263@redhat.com>
References: <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Fri, Jan 22, 2010 at 01:59:11PM -0800, Linus Torvalds wrote:
> [...]
> > Finally, I don't know how to address the logic of "if a feature
> > requires utrace, that's a bad argument for utrace" and at the same
> > time "you need to show a killer app for utrace".  What could possibly
> > satisfy both of those constraints?  Please advise.
> 
> The point is, the feature needs to be a killer feature. And I have yet to 
> hear _any_ such killer feature, especially from a kernel maintenance 
> standpoint.


> The "better ptrace than ptrace" is irrelevant. Sure, we all know ptrace 
> isn't a wonderful feature. But it's there, and a debugger is going to have 
> support for it anyway, so what's the _advantage_ of a "better ptrace 
> interface"? There is absolutely _zero_ advantage, there's just "yet 
> another interface". We can't get rid of the old one _anyway_.

The point is that the intermediate api will allow (and, as the part
you clipped out about utrace-gdbstub said, *already has allowed*)
alternative plausible interfaces that coexist just fine.


> And the seccomp replacement just sounds horrible. Using some tracing 
> interface to implement security models sounds like the worst idea ever.

So all this is about *naming* utrace?  It was never built "for
tracing", but for (efficient/multiplexed) *control*.  That wasn't even
its original name -- one of your lieutenants asked roland to change it
to utrace.


> And like it or not, over the last almost-decade, _not_ having to
> have to work with system tap has been a feature, not a problem, for
> the kernel community.

I don't have a problem with that.  We have apprx. never imposed
anything on developers who didn't want to use it.  There are plenty
who have and will.


- FChE
