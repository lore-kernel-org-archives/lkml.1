Return-Path: <linux-kernel-owner+w=401wt.eu-S1753420Ab0AVBGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab0AVBGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 20:06:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752816Ab0AVBGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 20:06:42 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44063 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752757Ab0AVBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 20:06:41 -0500
Date: Thu, 21 Jan 2010 17:05:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: add utrace tree
Message-Id: <20100121170541.7425ff10.akpm@linux-foundation.org>
In-Reply-To: <20100122005147.GD22003@redhat.com>
References: <20100119211646.GF16096@redhat.com>
	<20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	<20100120054950.GB27108@elte.hu>
	<20100120061551.GB6588@in.ibm.com>
	<20100120062834.GB12165@elte.hu>
	<20100120072925.GA11395@elte.hu>
	<20100121013822.28781960.sfr@canb.auug.org.au>
	<20100122111747.3c224dfd.sfr@canb.auug.org.au>
	<20100121163004.8779bd69.akpm@linux-foundation.org>
	<20100121163145.7e958c3f.akpm@linux-foundation.org>
	<20100122005147.GD22003@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jan 2010 19:51:47 -0500 "Frank Ch. Eigler" <fche@redhat.com> wrote:

> Hi -
> 
> On Thu, Jan 21, 2010 at 04:31:45PM -0800, Andrew Morton wrote:
> > [...]
> > > Someone please sell this to us.
> > Here's what Oleg said last time I asked this: [...]
> 
> I wonder if Roland/Oleg are being too modest in their current role as
> ptrace maintainers.  Considering that *they* think of utrace as a
> means toward proper refactoring of ptrace, how much further burden of
> proof should they shoulder?  To what extent are other subsystem
> maintainers required to "sell" reworkings of their areas, when there
> appear to be no drawbacks and at least arguable benefits?
> 

ptrace is a nasty, complex part of the kernel which has a long history
of problems, but it's all been pretty quiet in there for the the past few
years.  This leads one to expect that a rip-out-n-rewrite is a
high-risk prospect.  So, quite reasonably, one looks for a good reason
for taking such risk.

It's not really appropriate to generalise from other subsystem
maintainer's reworkings onto ptrace.  It's very rare that we'd make a
change this radical to a tricky part of core kernel.

