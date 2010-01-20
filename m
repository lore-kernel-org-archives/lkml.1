Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775Ab0ATGP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0ATGP7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 01:15:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740Ab0ATGP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 01:15:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43687 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318Ab0ATGP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 01:15:56 -0500
Date: Wed, 20 Jan 2010 11:45:51 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
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
Message-ID: <20100120061551.GB6588@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20100119211646.GF16096@redhat.com> <20100120111220.e7fb4e2c.sfr@canb.auug.org.au> <20100120054950.GB27108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120054950.GB27108@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 06:49:50AM +0100, Ingo Molnar wrote:

Ingo,

> Note, i'm not yet convinced that this (and the rest: uprobes and systemtap, 
> etc.) can go uptream in its present form.

Agreed, uprobes is still not upstream ready -- it was an RFC. We are
working through the comments there to get it ready for merger.

> IMHO the far more important thing to address beyond formalities and workflow 
> cleanliness are the (many) technical observations and objections offered by 
> Peter Zijstra on lkml. Not just the git history but also the abstractions and 
> concepts are messy and should be reworked IMO, and also good and working perf 
> events integration should be achieved, etc.

I think Oleg addressed most of Peter's concerns on utrace when the
ptrace/utrace patchset was reposted.

Perf integration with uprobes will be done and discussions have started
with Masami and Frederic. There are a couple of fundamental technical
aspects (XOL vma vs. emulation; breakpoint insertion through CoW and not
through quiesce) that need resolution.

> The fact that there's a well established upstream workflow for instrumentation 
> patches, which is being routed around by the utrace/uprobes/systemtap code 
> here is not a good sign in terms of reaching a good upstream solution. Lets 
> hope it works out well though.

Agreed.

On the other hand, having ptrace/utrace in the -next tree will give it a
lot more testing, while any outstanding technical issues are being addressed.

Stephen,
To exercise ptrace/utrace, it would be very useful if you pulled in

git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git branch utrace-ptrace

instead of 'master'.

Thanks,
Ananth
