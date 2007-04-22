Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbXDVE66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbXDVE66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 00:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932231AbXDVE66
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 00:58:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:59129 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754056AbXDVE65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 00:58:57 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18soW46+rcsTaTZl6CUPr1jxQ1o3saTUsosjgpBbw
	dWUbuh9EFReFwq
Subject: Re: [REPORT] cfs-v4 vs sd-0.44
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Denis Vlasenko <vda.linux@googlemail.com>, Ingo Molnar <mingo@elte.hu>,
       Willy Tarreau <w@1wt.eu>, William Lee Irwin III <wli@holomorphy.com>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Gene Heskett <gene.heskett@gmail.com>
In-Reply-To: <200704221008.50367.kernel@kolivas.org>
References: <20070420140457.GA14017@elte.hu>
	 <20070421160008.GA28783@elte.hu>
	 <200704220054.58639.vda.linux@googlemail.com>
	 <200704221008.50367.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 22 Apr 2007 06:58:53 +0200
Message-Id: <1177217933.5802.11.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-22 at 10:08 +1000, Con Kolivas wrote:
> On Sunday 22 April 2007 08:54, Denis Vlasenko wrote:
> > On Saturday 21 April 2007 18:00, Ingo Molnar wrote:
> > > correct. Note that Willy reniced X back to 0 so it had no relevance on
> > > his test. Also note that i pointed this change out in the -v4 CFS
> > >
> > > announcement:
> > > || Changes since -v3:
> > > ||
> > > ||  - usability fix: automatic renicing of kernel threads such as
> > > ||    keventd, OOM tasks and tasks doing privileged hardware access
> > > ||    (such as Xorg).
> > >
> > > i've attached it below in a standalone form, feel free to put it into
> > > SD! :)
> >
> > But X problems have nothing to do with "privileged hardware access".
> > X problems are related to priority inversions between server and client
> > processes, and "one server process - many client processes" case.
> 
> It's not a privileged hardware access reason that this code is there. This is 
> obfuscation/advertising to make it look like there is a valid reason for X 
> getting negative nice levels somehow in the kernel to make interactive 
> testing of CFS better by default.

That's not a very nice thing to say, and it has no benefit unless you
specifically want to run multiple heavy X hitting clients.

I boot with that feature disabled specifically to be able to measure
fairness in a pure environment, and it's still _much_ smoother and
snappier than any RSDL/SD kernel I ever tried.

	-Mike

