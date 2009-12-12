Return-Path: <linux-kernel-owner+w=401wt.eu-S1761870AbZLLKme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761870AbZLLKme (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761590AbZLLKmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:42:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33629 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761525AbZLLKmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:42:31 -0500
Date: Sat, 12 Dec 2009 11:42:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PATCH] TTY patches for 2.6.33-git
Message-ID: <20091212104219.GA22212@elte.hu>
References: <20091211232805.GA10652@kroah.com>
 <20091212084611.GA28266@elte.hu>
 <20091212104205.6a13b5e5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091212104205.6a13b5e5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> On Sat, 12 Dec 2009 09:46:11 +0100
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Greg KH <gregkh@suse.de> wrote:
> > 
> > > Here's the big TTY patchset for your .33-git tree.
> > 
> > FYI, one of the changes in this tree is causing lockups on x86.
> > 
> > Config attached.
> > 
> > Possible suspects would one of these:
> > 
> >  36ba782: tty: split the lock up a bit further
> >  5ec93d1: tty: Move the leader test in disassociate
> >  38c70b2: tty: Push the bkl down a bit in the hangup code
> >  f18f949: tty: Push the lock down further into the ldisc code
> >  eeb89d9: tty: push the BKL down into the handlers a bit
> > 
> > as they deal with locking details and are fresher than two weeks.
> 
> Any diagnostics with the lockup or just a system hang ?

None that i've captured (the hang is silent) but Andrew posted some.

	Ingo
