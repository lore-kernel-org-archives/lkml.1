Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbZCWFXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbZCWFXJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751687AbZCWFWy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:22:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbZCWFWx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:22:53 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: "Frank Ch. Eigler" <fche@redhat.com>
X-Fcc: ~/Mail/linus
X-Fcc: ~/Mail/utrace
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: Frank Ch. Eigler's message of  Saturday, 21 March 2009 19:38:39 -0400 <20090321233839.GB5157@redhat.com>
References: <20090321091235.GA29678@elte.hu>
	<20090321041954.72b99e69.akpm@linux-foundation.org>
	<20090321115141.GA3566@redhat.com>
	<20090321050422.d1d99eec.akpm@linux-foundation.org>
	<20090321154501.GA2707@elte.hu>
	<20090321143413.75ead1aa.akpm@linux-foundation.org>
	<20090321215145.GB5262@redhat.com>
	<alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
	<20090321222030.GA5157@redhat.com>
	<20090321223759.GA22770@x200.localdomain>
	<20090321233839.GB5157@redhat.com>
X-Windows: all the problems and twice the bugs.
Message-Id: <20090323052050.D3F61FC3AB@magilla.sf.frob.com>
Date: Sun, 22 Mar 2009 22:20:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes, I believe that is Roland's intent.  I believe it was separated
> from the current suite of patches for staging purposes, to merge the
> most solid code up first.  The code is available from the utrace git
> tree in the utrace-ptrace branch.

More than just "staging".  The utrace-ptrace code there today is really not
very nice to look at, and it's not ready for prime time.  As has been
mentioned, it is a "pure clean-up exercise".  As such, it's not the top
priority.  It also didn't seem to me like much of an argument for merging
utrace: "Look, more code and now it still does the same thing!"

Instead, I figured we should merge utrace in a way that lets everybody beat
on it for new features and hash out details, without immediate risk of
regressions in ptrace (which are severely annoying to everyone when they
happen).  The proper clean-ups for ptrace can proceed in parallel with work
using utrace for things that are actually new and interesting, and at least
the first half of that clean-up work is orthogonal to utrace.

This seems like the normal way that new optional CONFIG_FOOBAR features
(marked EXPERIMENTAL, even) are handled.  We don't jump over ourselves to
make existing crucial code paths subject to a new subsystem that is getting
its first rounds of shake-out.


Thanks,
Roland
