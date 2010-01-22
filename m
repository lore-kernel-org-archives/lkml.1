Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842Ab0AVCYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0AVCYZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:24:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630Ab0AVCYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:24:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19199 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755560Ab0AVCYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:24:23 -0500
Date: Thu, 21 Jan 2010 21:22:55 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100122022255.GF22003@redhat.com>
References: <20100120062834.GB12165@elte.hu> <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <20100122012516.GE22003@redhat.com> <alpine.LFD.2.00.1001211729080.13231@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001211729080.13231@localhost.localdomain>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Thu, Jan 21, 2010 at 05:32:47PM -0800, Linus Torvalds wrote:
> [...]
> > To the extent the discussion is colored by the new features enabled
> > from this refactoring, well, there is Oleg's list which may or may not
> > have mentioned enabling systemtap's user-space probing.
> 
> Let's face it, system tap isn't going to be merged, so why even bring it 
> up?

It was certainly not meant to derail the discussion about the merits
of utrace as a useful cleanup API in its own right, but rather to be
an example of what kinds of things become straightforward in its
presence.  You may be aware of nascent efforts to bring the same
uprobes infrastructure to perf.

> Every kernel developer I have _ever_ seen agrees that all the new
> tracing is a million times superior. [...]

And that is fine.  We believe there is plenty of space in the problem
domain for different approaches.

> ... considering how little the system tap people ever did for the kernel.

Less passionate analysis would identify a long history of contribution
by the the greater affiliated team, including via merged code and by
and passing on requirements and experiences.  We have been trying to
share as much as you have been willing to take.  While systemtap's
current codebase may not (and need not) have a future inside the
kernel, chances are good that improvements in common infrastructure
will allow systemtap to shrink and change enough that the question
becomes moot.


- FChE
