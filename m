Return-Path: <linux-kernel-owner+w=401wt.eu-S1760918AbZAOJyB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760918AbZAOJyB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 04:54:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753540AbZAOJxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 04:53:49 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:49211 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480AbZAOJxs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 04:53:48 -0500
Date: Thu, 15 Jan 2009 10:53:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Chris Mason <chris.mason@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gregory Haskins <ghaskins@novell.com>, Matthew Wilcox <matthew@wil.cx>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [GIT PULL] adaptive spinning mutexes
Message-ID: <20090115095321.GC5833@elte.hu>
References: <1231774622.4371.96.camel@laptop> <1231859742.442.128.camel@twins> <alpine.LFD.2.00.0901130812590.6528@localhost.localdomain> <1231863710.7141.3.camel@twins> <1231864854.7141.8.camel@twins> <alpine.LFD.2.00.0901130846320.6528@localhost.localdomain> <1231867314.7141.16.camel@twins> <1231952436.14825.28.camel@laptop> <20090114183319.GA18630@elte.hu> <1231958447.8269.30.camel@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1231958447.8269.30.camel@think.oraclecorp.com>
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


* Chris Mason <chris.mason@oracle.com> wrote:

> On Wed, 2009-01-14 at 19:33 +0100, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > Full series, including changelogs available at:
> > > 
> > >  http://programming.kicks-ass.net/kernel-patches/mutex-adaptive-spin/
> > > 
> > > and should shortly appear in a git tree near Ingo :-)
> > 
> > Linus,
> > 
> > Please pull the adaptive-mutexes-for-linus git tree from:
> > 
> >    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git adaptive-mutexes-for-linus
> > 
> 
> I was going to put this into the btrfs tree, but since you have a branch
> just for adaptive mutexes, is it easier to put there?
> 
> From: Chris Mason <chris.mason@oracle.com>
> 
> Btrfs: stop spinning on mutex_trylock and let the adaptive code spin for us
> 
> Mutexes now spin internally and the btrfs spin is no longer required for
> performance.
> 
> Signed-off-by: Chris Mason <chris.mason@oracle.com>

applied it to tip/core/locking, thanks Chris!

	Ingo
