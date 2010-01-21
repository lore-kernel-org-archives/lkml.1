Return-Path: <linux-kernel-owner+w=401wt.eu-S1753756Ab0AUBXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab0AUBXg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 20:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751669Ab0AUBXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 20:23:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab0AUBXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 20:23:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
X-Fcc: ~/Mail/utrace
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-next@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, utrace-devel@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: linux-next: add utrace tree
In-Reply-To: Stephen Rothwell's message of  Thursday, 21 January 2010 01:38:22 +1100 <20100121013822.28781960.sfr@canb.auug.org.au>
References: <20100119211646.GF16096@redhat.com>
	<20100120111220.e7fb4e2c.sfr@canb.auug.org.au>
	<20100120054950.GB27108@elte.hu>
	<20100120061551.GB6588@in.ibm.com>
	<20100120062834.GB12165@elte.hu>
	<20100120072925.GA11395@elte.hu>
	<20100121013822.28781960.sfr@canb.auug.org.au>
X-Windows: warn your friends about it.
Message-Id: <20100121012238.4172F1566@magilla.sf.frob.com>
Date: Wed, 20 Jan 2010 17:22:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Frank, please be clear as to which branch you want included (master or
> utrace-ptrace).  Also note that neither of those branches matches what
> was posted in the sense that they both have lots of history and merges
> not represented in the patches.  (I assume that they do produce the same
> final source tree, though).

Yes, the trees do match.  I certainly never expected our ancient git
history to get merged in directly upstream.  I've made a new branch on:
	git://git.kernel.org/pub/scm/linux/kernel/git/frob/linux-2.6-utrace.git
called:
	next/master
(Actually it's on master.kernel.org and the public mirror is being a little
slow as I write this.)

This starts from v2.6.33-rc4 and then has commits for the 7 patches that
Oleg posted in December.  Beyond that, we've added one follow-on patch to
fix a bug Oleg just tracked down (Oleg will post that patch soon).  And
I've added one more commit with a MAINTAINERS update, shown below.

You can also find the same stuff from the series file and patch files in:
	http://people.redhat.com/utrace/2.6-next/

If it makes things easier for linux-next to have this git branch either
rebased or merged from a different fork point, please let me know.


Thanks,
Roland

---
[PATCH] MAINTAINERS: add utrace

This updates the ptrace entry to cover utrace too.
They are part of the same maintenance effort.
Also add the utrace mailing list.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 MAINTAINERS |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..8da2a0a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4375,15 +4375,18 @@ M:	Jim Paris <jim@jtan.com>
 L:	cbe-oss-dev@ozlabs.org
 S:	Maintained
 
-PTRACE SUPPORT
+PTRACE AND UTRACE SUPPORT
 M:	Roland McGrath <roland@redhat.com>
 M:	Oleg Nesterov <oleg@redhat.com>
+L:	utrace-devel@redhat.com
 S:	Maintained
 F:	include/asm-generic/syscall.h
 F:	include/linux/ptrace.h
 F:	include/linux/regset.h
 F:	include/linux/tracehook.h
-F:	kernel/ptrace.c
+F:	include/linux/utrace.h
+F:	kernel/ptrace*
+F:	kernel/utrace*
 
 PVRUSB2 VIDEO4LINUX DRIVER
 M:	Mike Isely <isely@pobox.com>
