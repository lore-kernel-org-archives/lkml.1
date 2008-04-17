Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYDQImB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYDQImB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755931AbYDQIlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:41:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755721AbYDQIlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:41:51 -0400
Date: Thu, 17 Apr 2008 01:40:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417014054.ea788f1f.akpm@linux-foundation.org>
In-Reply-To: <20080417083000.GA4935@elte.hu>
References: <20080416202338.GA6007@elte.hu>
	<20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 10:30:00 +0200 Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Wed, 16 Apr 2008 22:23:38 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> > How much of this has not been in linux-next?
> 
> none.

That's a relief.  Please keep it this way - I plan on basing -mm on
linux-next after 2.6.26-rc1 and that should prevent reoccurrences.

> but we do much more testing than just getting code into other trees. We 
> cross-build 96 different configurations on other non-x86 architectures:
> 
>   http://www.tglx.de/autoqa-cgi/index?run=81&tree=1
> 
> last night's run was: 96 out of 96 configs built successfully.
> 
> This covers: alpha, arm, mips, powerpc, sparc64, x86, m32r, powerpc, 
> xtensa, mips, sh, sparc, parisc, powerpc. We test the various branches 
> (amongst them for-akpm) and combination trees as well.
> 
> and the backbone of arch/x86 QA we do are the build, boot and stress 
> tests we do on x86: we ran and booted thousands of x86 randconfigs in 
> the past few days alone. x86/latest boots and works from the smallest 
> boxes up to a 64-way testbox. On the 64-way box i did a 1 week burn-in 
> stress-test last week as well, for any longer-term effects.

That's nowhere as useful as it could be.

By keeping all this code out of -mm you haven't solved any of the
merge/integration problems which we had in 2.6.24-rcX.  They're all still
there.  All you did was to push them out of the two-month
integrate-and-test period and put them into the 2.6.25 merge window
instead.

> > >  - ftrace plugin for sysprof
> > 
> > sysprof is crap.
> 
> you mean the original hack? Sure, that had a number of problems and we 
> are not offering that for a merge.

whew.

> But have you seen the latest code we are offering for merge?

No.  Was it ever sent out for review?

> Check out 
> sched-devel/latest and kernel/trace/trace_sysprof.c. Nicely generalized 
> on top of stacktrace.h, put into the ftrace framework, userspace has 
> been ported to that too. No more special sysprof-only API hack.

Would prefer to not have to go fishing in git trees to find code to review.


