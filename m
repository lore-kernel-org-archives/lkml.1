Return-Path: <linux-kernel-owner+w=401wt.eu-S1756477AbZCWFfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477AbZCWFfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 01:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753700AbZCWFfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 01:35:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZCWFfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 01:35:37 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
X-Fcc: ~/Mail/utrace
X-Fcc: ~/Mail/linus
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
In-Reply-To: Ingo Molnar's message of  Sunday, 22 March 2009 11:25:34 +0100 <20090322102534.GC19826@elte.hu>
References: <20090321041954.72b99e69.akpm@linux-foundation.org>
	<20090321115141.GA3566@redhat.com>
	<20090321050422.d1d99eec.akpm@linux-foundation.org>
	<20090321154501.GA2707@elte.hu>
	<20090321143413.75ead1aa.akpm@linux-foundation.org>
	<20090321215145.GB5262@redhat.com>
	<alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
	<20090321222030.GA5157@redhat.com>
	<20090321223759.GA22770@x200.localdomain>
	<20090321233839.GB5157@redhat.com>
	<20090322102534.GC19826@elte.hu>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20090323053323.2F28DFC3AB@magilla.sf.frob.com>
Date: Sun, 22 Mar 2009 22:33:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And i think the ptrace-via-utrace engine is actually fully ready, 
> just perhaps it was not submitted out of caution to keep the 
> logistics simple.

That's not so.  There is a clumsy prototype version.  Much of the work to
do it properly is really just plain ptrace clean-up and not specifically
about using utrace.  Oleg and I are ready to work on it as soon as our time
is not monopolized by trying to get the core utrace code to be accepted.

This ptrace work really buys nothing with immediate pay-off at all.  It's a
real shame if its lack keeps people from actually looking at utrace itself.
(This has been a long conversation so far with zero discussion of the code.)
A collaboration with focus on what new things can be built, rather than on
reasons not to let the foundations be poured, would be a lovely thing.


Thanks,
Roland
