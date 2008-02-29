Return-Path: <linux-kernel-owner+w=401wt.eu-S934254AbYB2Wma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254AbYB2Wma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 17:42:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932273AbYB2WmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 17:42:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:53427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbYB2WmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 17:42:19 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64 ia32 syscall restart fix
In-Reply-To: Linus Torvalds's message of  Friday, 29 February 2008 08:26:14 -0800 <alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <20080229035707.EAE862700FD@magilla.localdomain>
	<20080229155207.GC27248@elte.hu>
	<alpine.LFD.1.00.0802290814320.17889@woody.linux-foundation.org>
Emacs: if SIGINT doesn't work, try a tranquilizer.
Message-Id: <20080229224212.24A532700FE@magilla.localdomain>
Date: Fri, 29 Feb 2008 14:42:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And here I thought I was so good for using coherent English sentences
with proper punctuation and capitalization, not to mention actually
explaining the issues of the change.  I must admit I've been a little
bewildered in the past when Ingo has changed my log entries to be
ungrammatical, eschew standard punctuation, and with an apparent
vendetta on the shift key, not to mention sometimes removed half the
relevant technical detail to boot.

I suppose I shouldn't be surprised at being harangued for making my log
entries too informative.  People love to remove clauses out of the
middle of my code comments too--so they can match the norm of run-on
sentences, I guess.

Most log entries I see are short.  But they really don't explain the
problem being fixed so I know enough about it without digging out some
long mailing list threads.  If that's your preference, then I guess we'll
just have to keep having Ingo remove the text I write.  At least it will
be in the archives from my posting.  (Reading it is the only way I'll
remember myself what details mattered, after a week has gone by.)

If what you want is formulaic log text that always puts blank lines in
between bug description, change description, and change justification, I
can do that.  If there is any place that documents the conventions you
want in log entries, I've overlooked it.

As Ingo alluded to, most of the time my number one focus is to record all
the important facts and decisions before I go back to something else or
knock off for the night.  I hate nothing more than looking at an old
change of mine and not being able to figure out what some of the logic
behind it was.  If there's one thing I can rely on, it's that I'll forget
what I knew the first time until I spend hours the second time
recapitulating the same debugging to find out that I may have had some
sense after all six months back.

Anyway, if the worst push-back on my submissions is a handful
of foreigners telling me how to write English, then I guess
things are ... as they should be. ;-)


As to the question of tagging for backports, I am not really clear on
what the intended criteria are.  Take this bug for example.  It is a
consistent behavior that has existed since the dawn of time (I've only
actually checked back to 2.6.9).  It's wrong, but can't be a surprise
on any system based on a stable release.  It's a regression of the
64-bit kernel vs the native 32-bit kernel, but not a version-to-version
regression.  The fix is straightforward to backport and has very low
risk.  How does all that translate into whether a given stable version
wants a backport or not?


Thanks,
Roland
