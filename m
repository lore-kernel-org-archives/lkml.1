Return-Path: <linux-kernel-owner+w=401wt.eu-S1752062AbXAXUwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752062AbXAXUwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jan 2007 15:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752066AbXAXUwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jan 2007 15:52:50 -0500
Received: from homer.mvista.com ([63.81.120.158]:49595 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbXAXUwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jan 2007 15:52:50 -0500
Subject: Re: [patch 00/46] High resolution timer / dynamic tick update
From: Daniel Walker <dwalker@mvista.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Roman Zippel <zippel@linux-m68k.org>
In-Reply-To: <1169668653.6905.49.camel@localhost.localdomain>
References: <20070123211159.178138000@localhost.localdomain>
	 <1169604991.19471.95.camel@imap.mvista.com>
	 <20070124070701.GA17654@elte.hu>
	 <1169631016.19471.175.camel@imap.mvista.com>
	 <1169668653.6905.49.camel@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 24 Jan 2007 12:51:30 -0800
Message-Id: <1169671890.19471.309.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-01-24 at 11:57 -0800, john stultz wrote:
> On Wed, 2007-01-24 at 01:30 -0800, Daniel Walker wrote:
> > 
> > My patch set has been stable for months, and reviewed and tested by
> > John and I constantly (With you and Thomas on the CC list each
> > release).. It's a completely safe bet, IMO . 
> 
> Oh, I really wanted to stay out of this, but just a small clarification:
> I've reviewed your patches on a number of occasions, but I can't recall
> actually having the time to run them.

I know sucky huh? I was assuming you had done some testing.. It's
unfortunate that you haven't (I know your busy tho)

> Ok, so my take: While I've looked over both patch sets, and have noticed
> (and mentioned to tglx) the similarity in some of the changes, I don't
> see any big conflict in intent. They're both cleanups that make the
> clocksource code more flexible for uses other them just system
> timekeeping.

Only in so much as the high res changes parallel my own. That includes
from my set the update_callback removal and the rating sorted list.
thats about where the similarity stops, even those changes don't appear
to have the breath of mine.

My patch set is more extensive. The changes Thomas made exist only to
allow the verify functionality .

> Thomas' changes are more obviously purpose driven, and Daniel's appear
> more like just cleanups. So given that, if it were me, I'd put Thomas
> changes in first, and re-diff Daniel's non-redundant changes on top.

Seems backwards , clean ups should always go first. If Thomas had
started off my patch set his changes would have been smaller and
hopefully stronger. (I even remember you tell me that you wanted the
kernel/time/timekeeping.c change first in my series cause clean ups
should go first..)

If the HRT changes went in I would have to re-make my cleanups, then do
more cleanup to change the stuff Thomas is introducing. Looking at his
code, to do a clean up I would want to just outright revert it.

> Although, to be fair, I do know that Daniel has future sched_clock
> related patches that need his cleanups (so the cleanups are not just
> shuffling code). However, I'm not as psyched about those changes as I am
> about HRT, so again I'd rank HRT higher on the priority list.

The release of HRT is a dead duck anyway. It's way to late in the 2.6.20
release cycle to be introducing that extensive of a rewrite. I'm not in
control of that tho.

> So I'm bummed this has collided like it has. I do like a number of
> Daniel's cleanups, and Thomas (and myself as well, really) could have
> communicated better. So the duplicate code is unfortunate, but its not
> really a stop-everything deal breaker, is it?

Do you remember Thomas was CC'd on all my releases, and all of your
comments got CC'd to him (as far as I remember). So it's hard to imagine
that any of the code collision is on your hands.

Given the circumstances I don't see how we can do anything less than
resolve the conflicts .. My cleanups first, then his code and condense
and update his set. I'll gladly volunteer to do that.

Daniel

