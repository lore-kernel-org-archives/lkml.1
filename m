Return-Path: <linux-kernel-owner+w=401wt.eu-S1757069AbYGOWGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757069AbYGOWGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 18:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753942AbYGOWGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 18:06:05 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37606 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753638AbYGOWGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 18:06:03 -0400
Date: Wed, 16 Jul 2008 00:05:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT pull] x86 updates
Message-ID: <20080715220547.GA11448@elte.hu>
References: <alpine.LFD.1.10.0807152249270.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151417440.2867@woody.linux-foundation.org> <alpine.LFD.1.10.0807152341240.3283@apollo.tec.linutronix.de> <alpine.LFD.1.10.0807151456490.2867@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807151456490.2867@woody.linux-foundation.org>
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

> On Tue, 15 Jul 2008, Thomas Gleixner wrote:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=x86/urgent
> > 
> > has a commit on top of your tree. 
> > 
> > commit	     431ceb83f703a343bdd14350480a2224fa4bfedf
> > tree	     2f4644aec0d326e23327ed2297a4a4f52b1d830e
> > parent	     b9d2252c1e44fa83a4e65fdc9eb93db6297c55af
> >
> > I waited with the pull request until it showed up there.
> 
> I'd say it's a mirroring issue, but:
> 
> [torvalds@woody linux]$ git ls-remote ssh://master.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git | grep x86/urgent
> b9d2252c1e44fa83a4e65fdc9eb93db6297c55af	refs/heads/x86/urgent
> b9d2252c1e44fa83a4e65fdc9eb93db6297c55af	refs/heads/x86/urgent-undo-ioapic
> 41b7aafd3ea22fcd6cbb062da39d5c757d6c09ca	refs/remotes/origin/x86/urgent
> 
> ie it looks like even master has b9d2252c1 as tip (which is the one 
> you say is the parent).
> 
> I wonder if Ingo overwrote it. You both push to the same tree, don't 
> you? And maybe somebody used "-f" to force an over-push?

sorry, my fault - i have reset it back to -git because i wanted to get 
rid of the local merge commit that we created over 
include/asm-x86/dwarf2.h. That coincided with Thomas pushing an urgent 
fix out. We rarely push out via -f but this was an exception.

Thomas, could you please push it again?

	Ingo
