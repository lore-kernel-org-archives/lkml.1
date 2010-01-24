Return-Path: <linux-kernel-owner+w=401wt.eu-S1753831Ab0AXNVA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab0AXNVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 08:21:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753587Ab0AXNU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 08:20:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab0AXNU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 08:20:58 -0500
Date: Sun, 24 Jan 2010 08:20:09 -0500
From: "Frank Ch. Eigler" <fche@redhat.com>
To: tytso@mit.edu, Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle Moffett <kyle@moffetthome.net>, Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <20100124132009.GB4263@redhat.com>
References: <alpine.LFD.2.00.1001211724500.13231@localhost.localdomain> <20100122182827.GA13185@redhat.com> <20100122200129.GG22003@redhat.com> <alpine.LFD.2.00.1001221355250.13231@localhost.localdomain> <20100122221348.GA4263@redhat.com> <alpine.LFD.2.00.1001221604190.13231@localhost.localdomain> <alpine.LFD.2.00.1001221614520.13231@localhost.localdomain> <f73f7ab81001222220jfaf2edfwca3fa4c22b0b4d72@mail.gmail.com> <alpine.LFD.2.00.1001232051510.3574@localhost.localdomain> <20100124102513.GB4382@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100124102513.GB4382@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Sun, Jan 24, 2010 at 05:25:13AM -0500, tytso@mit.edu wrote:
> [...]
> > > The killer app for this will be the ability to delete thousands of
> > > lines of code from GDB, strace, and all the various other tools that
> > > have to painfully work around the major interface gotchas of ptrace(),
> > > while at the same time making their handling of complex processes much
> > > more robust.
> > 
> > No. There is absolutely _no_ reason to believe that gdb et al would ever 
> > delete the ptrace interfaces anyway. 
> 
> More to the point, gdb *couldn't* use utrace, because utrace only
> exports a kernel API; not a syscall interface.

Yes, this might explain why Kyle wrote:

> > > [...] I believe that "utrace" is the kernel side of that
> > > API. [...]

> And if the Red Hat Toolchain folks are thinking about encouraging
> gdb to start creating out-of-tree kernel modules [...]  the Red Hat
> Toolchain group needs to be smacked upside the head...

Those keeping up will note that an ordinary in-tree, non-modular,
non-root-only, already-works-with-standard-gdb,
potentially-better-than-ptrace debugger interface has already been
prototyped & posted on lkml as an RFC.


- FChE
