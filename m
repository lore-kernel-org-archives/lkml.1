Return-Path: <linux-kernel-owner+w=401wt.eu-S1760947AbXH2WXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947AbXH2WXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 18:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbXH2WXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 18:23:45 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36702 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755732AbXH2WXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 18:23:44 -0400
Date: Thu, 30 Aug 2007 00:23:44 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Natalie Protasevich <protasnb@gmail.com>
Cc: David Rees <drees76@gmail.com>, Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: Who wants to maintain KR list for stable releases? (was Re:
	nmi_watchdog=2 regression in 2.6.21)
Message-ID: <20070829222344.GV26410@stusta.de>
References: <46CDE94A.7000600@googlemail.com> <1187904169.2435.83.camel@dhcp193.mvista.com> <46D21E8E.4000003@googlemail.com> <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com> <1188227585.2435.192.camel@dhcp193.mvista.com> <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com> <1188229197.2435.207.camel@dhcp193.mvista.com> <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com> <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2007 at 12:42:02AM -0700, Natalie Protasevich wrote:
>...
> Then I think bugzilla needs:
>      adding more categories such as security,

"security" would be a flag like "regression", not a category.

> system calls (lots of
> implementation suggestions for posix and non-posix ones),
>...

Bugzilla is for tracking bugs, not for discussing possible
kernel features.

Tracking feature or implementation suggestions wouldn't make sense. 
Consider e.g. that there are several people on linux-kernel who often 
write what they think the kernel should do but who never write a single 
line of code themselves. There's no value in tracking such stuff.

>      improved searches - for sure, for example in addition to
> pre-cooked queries make possible using "raw" queries directly on sql,
> which will address misplaced bugs and will make categories more
> dynamic;

What do you have in mind?

I've always been able to do any search I wanted using the "Advanced Search"
of Bugzilla. Well, just checking, it seems the search for the new
"regression" flag could be made easier, but that's not a general problem.

But what could be improved in the database would be to fix the 
charset problems for getting the RSS feeds working (#8774).  ;-)

>     recipe database, for standard debugging requests and procedures
> (serial console, getting sysreq traces, bisecting etc. - things to cut
> and paste)

Documentation makes sense, but it belongs into some place like the 
kernelnewbies wiki, not the Bugzilla itself.

>     user modifiable personal environment ("my bugzilla"), more of
> morph type interface around the database.

Preferences settings plus saved searches already work.

What is missing?

> ... not mentioning all flaws and problems with current one (cannot get
> back to home page,

There's a "Home" link that does exactly this among the actions offered 
at the bottom of all pages.

> clear previous search,

There's a "Search" link that gives you a new search among the actions 
offered at the bottom of all pages.

> do certain updates in one step
>...

The only thing that comes into my mind is that you cannot reassign a bug 
and change it's status in one step. But "flaws and problems" would IMHO 
be too hard an expression since it works fine with two updates.

> Regressions need to be tracked in effective manner, and I also noticed
> counter intuitive question that we have now (the infamous "last
> release when it _didn't_ happen") is clearly not the way to go, rather
>  adding simple boxes "Was working in XX" and "Not working in XX" or
> similar straightforward question.

Sounds like a good solution for the one question so many submitters get 
wrong.  :-)

> In my opinion bugzilla is far from being a convenient tool. I suspect
> that hating bugzilla comes down to having to deal with no
> sophisticated interface that is inadequate - when so many nice and
> slick tools and sites are around that we all used to.  I am also
> investigating and checking out other bugzillas looking for good ideas.

Bugzilla isn't that bad and it has the advantage of being the most 
popular bug tracking system for open source projects, which means that 
most likely every kernel developer and many submitters have already used
a Bugzilla at some other project.

>From past discussions my impression was that several kernel developers 
have an email based workflow and are reluctant to integrate web based 
actions into their workflow.

I'd say the success of any bigger Bugzilla change or switch to a 
different or writing of a new bug tracking system could be measured
by answering the following question:
  Will Linus Torvalds and David Miller use it?

> Thanks,
> --Natalie

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

