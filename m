Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZCVMi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZCVMi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 08:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753946AbZCVMiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 08:38:19 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799AbZCVMiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 08:38:18 -0400
Date: Sun, 22 Mar 2009 13:37:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 3/3] utrace-based ftrace "process" engine, v2
Message-ID: <20090322123749.GF19826@elte.hu>
References: <20090321074301.GA19384@elte.hu> <20090321013912.ed6039c9.akpm@linux-foundation.org> <20090321091235.GA29678@elte.hu> <20090321041954.72b99e69.akpm@linux-foundation.org> <20090321115141.GA3566@redhat.com> <20090321050422.d1d99eec.akpm@linux-foundation.org> <20090321154501.GA2707@elte.hu> <20090321143413.75ead1aa.akpm@linux-foundation.org> <20090321215145.GB5262@redhat.com> <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903211501060.3030@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 21 Mar 2009, Frank Ch. Eigler wrote:
> > 
> > > If testing utrace against its main application requires installation
> > > of a complete enterprise distro from a distro [...]
> > 
> > This has *never* been a requirement.
> 
> You guys are getting off a tangent.
> 
> Let's go back to the post that started this all.
> 
> > The thing is, utrace crashes in Fedora have dominated kerneloops.org 
> > for many months, so i'm not sure what to make of the idea of posting 
> > a 4000+ lines of core kernel code patchset on the last day of the 
> > development cycle, a posting that has carefully avoided the Cc:-ing 
> > of affected maintainers ;-)
> 
> .. and dammit, I agree 100%. If utrace really shows up in _any_ 
> way on kerneloops.org, then I think THE ENTIRE DISCUSSION in this 
> thread is moot.
> 
> I'm not going to take known-bad crap. It's that simple. Don't 
> bother posting it, don't bother discussing it, don't bother making 
> excuses for it.

The kerneloops stats on utrace crashes are way down currently,
after that peak last fall. So i didnt want to suggest that it's 
known-broken now - i only wanted to point out that it's a 
known-risky area and that the submission of it should involve
the affected maintainers/developers.

Regarding current stability, Roland, Frank, is the utrace patch in 
latest (today's) Fedora rawhide:

 -rw-r--r-- 1 root root 176555 2009-01-08 05:42 linux-2.6-utrace.patch

a bug fixed equivalent of the utrace bits that crashed in the 
2.6.26.3 kernel? In that case it is certainly known-good.

Or is it a slimmed-down version?

The ptrace bits and signoffs from Oleg and Alexey would certainly 
help (me) in trusting it. (I've Cc:-ed Oleg and Alexey)

The ftrace bits could certainly be staged to go in via the tracing 
tree (in .31 or so) after the utrace-core+ptrace bits went upstream.

	Ingo
