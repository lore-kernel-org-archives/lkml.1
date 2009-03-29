Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbZC2BVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbZC2BVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 21:21:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZC2BVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 21:21:25 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39021 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880AbZC2BVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 21:21:24 -0400
Date: Sun, 29 Mar 2009 03:19:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [git pull] x86 updates for v2.6.30, final bits
Message-ID: <20090329011953.GA15450@elte.hu>
References: <20090328220307.GA16314@elte.hu> <alpine.LFD.2.00.0903281708180.3994@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0903281708180.3994@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Sat, 28 Mar 2009, Ingo Molnar wrote:
> > 
> > [ The sched.c bit is an odd one out: due to previous cpumask changes 
> >   it developed a dependency/conflict on the cpumask tree which 
> >   depended on the x86 tree. Should i have started a separate branch 
> >   for it? I didnt want to merge the x86 tree into the scheduler 
> >   tree. We had really excessive dependencies and cross-merges in
> >   this cycle around the x86 tree and i very much hope this is an
> >   exception
> 
> The problem is that you've been hoping for this "exception" for 
> the last three kernel releases.
> 
> The details differ, but you do seem to mix things up too much. I'm 
> not at all happy. I think quality control is slipping, because 
> there's this absolutely _humongous_ amount of crap that gets in 
> through you. You seem to have a hard time saying "no".
> 
> And yes, you boot-test things pretty well, but I really wish you 
> had more focus. This "everything under the sun" thing is very 
> annoying, and I think you are too damn eager to merge the random 
> new feature of the day.
> 
> So instead of "hoping", how about you look at making sure it 
> really _does_ become an exception. And that really fundamentally 
> means that it can't happen every release.
> 
> How about trying one release to just say "no" if you start seeing 
> all these kinds of things. We don't allow non-x86 architectures to 
> just tie things together this way. The fact that you have the same 
> tree seems to just encourage badness by making it "easier" to just 
> mix things up.

Yes, will do that - sorry about this. We'll also take more care and 
will try to cook up more scripting to make sure such crappy-looking 
circular criss-cross merges and compound trees dont happen again.

The remaining trees we have for this merge window are all 
single-purpose. We sent five of them in the last couple of hours and 
they have the kind of structure that we intend to use in the future 
too. If you still see _any_ problems with them, please let me know 
so i can fix the workflow ASAP.

	Ingo
