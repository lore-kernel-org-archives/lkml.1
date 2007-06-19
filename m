Return-Path: <linux-kernel-owner+w=401wt.eu-S1763977AbXFSAnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763977AbXFSAnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXFSAm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:42:58 -0400
Received: from dvhart.com ([64.146.134.43]:45931 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758774AbXFSAm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:42:57 -0400
Message-ID: <4677268F.9070202@mbligh.org>
Date: Mon, 18 Jun 2007 17:42:55 -0700
From: Martin Bligh <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>	 <200706172349.08813.bzolnier@gmail.com>	 <4675C083.6080409@s5r6.in-berlin.de>	 <20070617220927.99ebc1ee.akpm@linux-foundation.org>	 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca>	 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com>	 <46770A22.4020007@mbligh.org>	 <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>	 <46771C5D.10809@mbligh.org>	 <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org> <32209efe0706181724k26e0ee57laf9610b1834d4154@mail.gmail.com>
In-Reply-To: <32209efe0706181724k26e0ee57laf9610b1834d4154@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, simplicity is a key - but most of reporters on bugs are pretty
> professional folks (or very well rounded amateurs :) We can try still
> why not? the worst that can happen will be empty fields.

mmm. added complexity and interface clutter for little or no benefit
is what I'm trying to avoid - they did that in the IBM bugzilla and
it turned into a big ugly unusable monster. You can call me either
"experienced" or "bitter" depending what mood you're in ;-)

Not sure I'd agree that most of the bug submitters are all that
professional, it's a very mixed bag.

> Maybe searching free text fields can then be implemented.  Then every
> message exchange in bugzilla can be used for extracting such info -
> questions about HW specifics are asked a lot, almost in every one.
> It's a shame we cant' use this information. I was once searching for
> "VIA" and got "zero bugs found", but in reality there are hundreds!
> Probably something that makes sense to bring up with bugzilla project?

That should work now ... seems to for me.

http://bugzilla.kernel.org/buglist.cgi?query_format=advanced&short_desc_type=allwordssubstr&short_desc=&long_desc_type=substring&long_desc=VIA&kernel_version_type=allwordssubstr&kernel_version=&bug_status=NEW&bug_status=REOPENED&bug_status=ASSIGNED&bug_status=RESOLVED&bug_status=VERIFIED&bug_status=REJECTED&bug_status=DEFERRED&bug_status=NEEDINFO&bug_status=CLOSED&emailassigned_to1=1&emailtype1=substring&email1=&emailassigned_to2=1&emailreporter2=1&emailcc2=1&emailtype2=substring&email2=&bugidtype=include&bug_id=&chfieldfrom=&chfieldto=Now&chfieldvalue=&regression=both&cmdtype=doit&order=Bug+Number&field0-0-0=noop&type0-0-0=noop&value0-0-0=

Produces a metric-buttload of results. Go to the advanced search option
and do "A Comment" contains the string "VIA". By default "Status" is
only set to do open bugs, which you might want to change to all types.

> However, I've been working with other bugzillas (have to admit they
> were mostly company/corporate), where this was a required field that
> didn't seem to cause difficulties. I am planning to do some more
> research and get some more ideas from other bugzillas. I suppose we
> can have them discussed and revised sometime.

Would be good, thanks. I tend to favour keeping things as simple as
possible though, we have very little control over our users, and they're
a very broad base. Making the barrier to entry for use as low as
possible is the design we've been pursuing.

M.
