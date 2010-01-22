Return-Path: <linux-kernel-owner+w=401wt.eu-S1754868Ab0AVWAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab0AVWAA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 17:00:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664Ab0AVV77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 16:59:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52217 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932123Ab0AVV76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 16:59:58 -0500
Date: Fri, 22 Jan 2010 13:59:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Frank Ch. Eigler" <fche@redhat.com>
cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
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
In-Reply-To: <20100122200129.GG22003@redhat.com>
Message-ID: <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain>
References: <20100120062834.GB12165@elte.hu> <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org>
 <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 22 Jan 2010, Frank Ch. Eigler wrote:
> 
> Finally, I don't know how to address the logic of "if a feature
> requires utrace, that's a bad argument for utrace" and at the same
> time "you need to show a killer app for utrace".  What could possibly
> satisfy both of those constraints?  Please advise.

The point is, the feature needs to be a killer feature. And I have yet to 
hear _any_ such killer feature, especially from a kernel maintenance 
standpoint.

The "better ptrace than ptrace" is irrelevant. Sure, we all know ptrace 
isn't a wonderful feature. But it's there, and a debugger is going to have 
support for it anyway, so what's the _advantage_ of a "better ptrace 
interface"? There is absolutely _zero_ advantage, there's just "yet 
another interface". We can't get rid of the old one _anyway_.

And the seccomp replacement just sounds horrible. Using some tracing 
interface to implement security models sounds like the worst idea ever.

And like it or not, over the last almost-decade, _not_ having to have to 
work with system tap has been a feature, not a problem, for the kernel 
community.

So what's the killer feature?

			Linus
