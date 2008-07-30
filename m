Return-Path: <linux-kernel-owner+w=401wt.eu-S1754112AbYG3TTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112AbYG3TTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 15:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbYG3TTr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 15:19:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbYG3TTq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 15:19:46 -0400
Date: Wed, 30 Jul 2008 21:19:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] x86: use arch/x86/include
Message-ID: <20080730191907.GD26389@elte.hu>
References: <20080730124952.GA23413@uranus.ravnborg.org> <20080730180411.GA7896@elte.hu> <20080730184700.GA29710@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080730184700.GA29710@uranus.ravnborg.org>
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

> > hm, we have a _ton_ of changes to include files queued up already, 
> > so this is rather inconvenient.
>
> git should cope with this if changes come in via git. I do not know 
> about "git am" applied patches.

the pending commits are ordinary commits and there's little difference 
between a leaf commit that came via git and one that came via emails.

(the difference between Git and email is for more complex ops like 
renames, merges - i.e. more abstract and multi-commit operations.)

But such more complex scenarios are not what i'm talking about. We've 
got this many leaf commits in include/asm-x86/ at the moment:

   308 files changed, 3025 insertions(+), 2025 deletions(-)

... and pulling your rename generates almost 50 conflicts. (Also, i've 
got to hunt down all scripts that somehow rely on the location on 
include/asm-x86.)

> > I missed the discussion on this, what's the point of renaming all 
> > these files?
> 
> It has been discussed many times to keep arch and arch include files
> under arch/.
> Lately Linus outlined this:
> 
>     http://kerneltrap.org/mailarchive/linux-kernel/2008/5/21/1903924
> 
> I took the ball and did the kbuild side of this so we could do this 
> gradually.
>
> sparc are already converted. sh has it ready to be pulled and others
> are playing with it.
> 
> How we do it in the best way for such a fragile codebase as x86 is I 
> am not sure. [...]

huh, fragile codebase? Is that a flamebait? :-) What do you mean 
exactly?

The timing problems come from the fact that 90% of Linux development and 
95% of Linux testing happens on x86. So we've already got a ton of stuff 
queued up for the next merge window. (and some cleanups for this cycle 
as well)

But fortunately you've scripted all this, so i guess we can do it at any 
stage. Could you send the script we should run?

	Ingo
