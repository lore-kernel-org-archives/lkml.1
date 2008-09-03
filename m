Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbYICMNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbYICMNW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 08:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752386AbYICMMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 08:12:50 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47336 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755235AbYICMMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 08:12:49 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
From: Roland McGrath <roland@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
X-Fcc: ~/Mail/linus
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] utrace
In-Reply-To: Christoph Hellwig's message of  Saturday, 30 August 2008 09:40:57 -0400 <20080830134057.GB17566@infradead.org>
References: <20080826220102.89635154233@magilla.localdomain>
	<20080826223402.GB27724@x200.localdomain>
	<y0m7ia3xqev.fsf@ton.toronto.redhat.com>
	<20080827135453.GA31240@infradead.org>
	<20080827164055.GA22236@in.ibm.com>
	<20080830134057.GB17566@infradead.org>
Emacs: because idle RAM is the Devil's playground.
Message-Id: <20080903120927.3C1FF154228@magilla.localdomain>
Date: Wed,  3 Sep 2008 05:09:27 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I hope my original mail was clear that I'm not principially against
> utrace.  I think having a generic trace even dispatcher is a good thing
> if it is a) not overly complicated (see Alexeyús mails for that) and b)
> actually has a user.  A better debugger interface as the ntrace idea
> would be the prime candidate for that.

Thanks for that clarification.  From what you've said in many of your
postings, it has been easy to get the impression that you are against
everything.

I sympathize with caution about a new API that needs users to iron out
its kinks.  Here is the difficulty I've been having.

I have spent a lot of time keeping the patch series up to date,
rebasing, etc.  This has sunk all the time that I'd like to have been
spending working on higher-level pieces such as the ntrace idea.

(This will be much better now that all the tracehook work is in 2.6.27.
I know you don't buy the rationale I've explained for that work.  But I
am confident that having this in is a substantial and immediate boon to
the ease and efficiency of getting more work done sooner in this area.)

At the same time, many of the people who have asked me about the state
of the effort say things to the effect that they would like to try
writing some features based on such an API once it's been merged in.

It was my hope that having it merged in and available as a non-default
option for those who select CONFIG_EXPERIMENTAL would encourage more
people to actually get going on experiments with new features.  Several
actual users beating on it is of course what's necessary to iron out
the API and the low-level code.

Since I finally no longer expect to spend much more time myself on arch
code or rebasing hassles given what's already merged, I look forward to
soon having time to work on some higher-level stuff that makes this all
get interesting.  Whatever I produce won't be all things to all people,
and it might not be to your taste at all.  It's certain that others who
tried could come up with some other things faster.  Having the schedule
of merging utrace contingent on having some things using it that people
consider ready to be merged won't delay me working on such a thing, but
I get the impression it might deter others.

The motivating principle of utrace is that it is the lowest level and
least overhead at which multiple disparate things can be tried, without
clobbering each other, and easily enough that many kernel hackers can
find it easier to whip up something useful than to write horrible bugs
while trying.  The idea of merging it after review and revision on its
own merits is to get more of us active in making and disagreeing about
concrete things using it and whether they merit being merged.


Thanks,
Roland
