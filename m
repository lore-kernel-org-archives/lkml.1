Return-Path: <linux-kernel-owner+w=401wt.eu-S1759152AbXH3Iv0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152AbXH3Iv0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 04:51:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755941AbXH3IvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 04:51:19 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43448 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930AbXH3IvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 04:51:18 -0400
Date: Thu, 30 Aug 2007 10:51:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: David Rees <drees76@gmail.com>, Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
Message-ID: <20070830085118.GB9260@stusta.de>
References: <46D21E8E.4000003@googlemail.com> <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com> <1188227585.2435.192.camel@dhcp193.mvista.com> <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com> <1188229197.2435.207.camel@dhcp193.mvista.com> <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com> <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com> <20070829222344.GV26410@stusta.de> <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 04:59:47PM -0700, Natalie Protasevich wrote:
> > Bugzilla is for tracking bugs, not for discussing possible
> > kernel features.
> 
> True, but some of them are categorized as bugs from the reporter's
> prospective, when they say "man page says" or "according to POSIX it's
> wrong".

If code behaves differently from how it should that is a bug. [1]

> I am going to push ones that are feature suggestions,
> re-design suggestions, and some way implementation related out to the
> site that Rick is going to help to maintain, which is more of
> suggested projects list.
> 
> > Tracking feature or implementation suggestions wouldn't make sense.
> > Consider e.g. that there are several people on linux-kernel who often
> > write what they think the kernel should do but who never write a single
> > line of code themselves. There's no value in tracking such stuff.
> 
> Yes, but some suggestions seem to make sense. How about evaluating it?
> and if they are real making it a possible project for someone who
> would do appropriate research, etc. And we move them from bugzilla
> where they don't belong to a development arena.

Fine with me, my point was simply that they don't belong into a
_bug_ tracker.

> > >      improved searches - for sure, for example in addition to
> > > pre-cooked queries make possible using "raw" queries directly on sql,
> > > which will address misplaced bugs and will make categories more
> > > dynamic;
> >
> > What do you have in mind?
> 
> I am going to look into the bugzilla software to start with, and see
> if there is a way to expand it this way. we used to have such internal
> tracking (unix based) at work, where we could compose pretty much
> freelance queries, it is really not big deal for developers who script
> and write huge regular expressions for their convenience every
> day...just a vogue idea for now, trying to think how to minimize bugs
> that get lost because of wrong bucket. Going manually through all of
> them is not very effective.

Is there any reasonable query that would be possible through SQL but 
isn't already possible through the web interface?

> > I've always been able to do any search I wanted using the "Advanced Search"
> > of Bugzilla. Well, just checking, it seems the search for the new
> > "regression" flag could be made easier, but that's not a general problem.
> 
> Yes but you have to assume that everything is in the right place from
> start, besides putting things into categories is often impossible
> before some exchange with reporter and initial diagnostics. The worst
> category so fas as I found is "other" (in every place where it
> exists). Most of the "other" bugs haven't been touched, and some have
> huge "SATA" letters in the description written in them :)
>...

You need some kind of first level support that does some initial 
debugging and assigns the bug into the right category, and that will 
always be a manual task done by going through all new bugs.

> --Natalie

cu
Adrian

[1] there are special cases where the kernel might deliberately not
    some specification

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

