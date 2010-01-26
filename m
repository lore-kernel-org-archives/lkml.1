Return-Path: <linux-kernel-owner+w=401wt.eu-S1753565Ab0AZN7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab0AZN7V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 08:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164Ab0AZN7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 08:59:19 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34623 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab0AZN7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 08:59:19 -0500
Date: Tue, 26 Jan 2010 14:58:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Valdis.Kletnieks@vt.edu
Cc: ananth@in.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Peter Zijlstra <peterz@infradead.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: linux-next: add utrace tree
Message-ID: <20100126135849.GC1764@ucw.cz>
References: <20100120072925.GA11395@elte.hu> <20100121013822.28781960.sfr@canb.auug.org.au> <20100122111747.3c224dfd.sfr@canb.auug.org.au> <20100121163004.8779bd69.akpm@linux-foundation.org> <20100121163145.7e958c3f.akpm@linux-foundation.org> <20100122005147.GD22003@redhat.com> <20100121170541.7425ff10.akpm@linux-foundation.org> <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122052139.GA20532@in.ibm.com> <18867.1264167798@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18867.1264167798@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-01-22 08:43:18, Valdis.Kletnieks@vt.edu wrote:
> On Fri, 22 Jan 2010 10:51:39 +0530, Ananth N Mavinakayanahalli said:
> 
> > FWIW, Oleg's implementation of ptrace over utrace is 100% compatible
> > with legacy ptrace; gdb testsuite indicates that
> > (http://lkml.org/lkml/2009/12/21/98).
> 
> No, that only proves it's compatible enough for gdb to not care. The problem
> is all those *other* packages that abuse ptrace in totally crackhead ways.
> 
> (No, I can't name them - but ptrace is the sort of interface that almost
> encourages its use for things somewhere between crackhead and mad-scientist,
> so they're almost certainly out there.. WAY out there.. :)

strace, subterfugue, ltrace, ...? Plus various homegrown sandboxing tools...
									Pavel


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
