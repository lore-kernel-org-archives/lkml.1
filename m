Return-Path: <linux-kernel-owner+w=401wt.eu-S1756208AbYGNSXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208AbYGNSXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbYGNSXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:23:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38166 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbYGNSXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:23:40 -0400
Date: Mon, 14 Jul 2008 20:23:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] core/softirq for v2.6.27
Message-ID: <20080714182326.GA15243@elte.hu>
References: <20080714144243.GA21079@elte.hu> <20080714092215.0efd7fa3.akpm@linux-foundation.org> <20080714163141.GA21068@elte.hu> <20080714094422.e7ae255a.akpm@linux-foundation.org> <20080714164838.GA28765@elte.hu> <alpine.LFD.1.10.0807141011260.3305@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807141011260.3305@woody.linux-foundation.org>
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

> On Mon, 14 Jul 2008, Ingo Molnar wrote:
> > 
> > /me suggests git-log-addendum feature to amend commit logs after the
> >     fact, without changing any of the code :-)
> 
> It's called "git commit --amend".

yeah - and i use that for general development meanwhile: i just 
commit the draft code in small steps (appending it to the commit via
git commit --amend), then i test it and amend it with a final commit
log in the end.

I use that method instead of doing development via uncommitted changes 
in the git index, because that way:

 - I see the under-development change in a form close to how other
   people see it (as a commit)

 - I can switch branches during development

 - It's sure that changes are not lost

 - I can distribute my half-done commits to my testboxes (internally i
   use a hierarchy of Git repos on testboxes to automatically propagate
   changes)

Once it's pushed out publicly into a persistent branch it cannot be 
touched anymore.

	Ingo
