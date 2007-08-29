Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbXH2X75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbXH2X75 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 19:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXH2X7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 19:59:49 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:46146 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549AbXH2X7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 19:59:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WZtZfbnLQtpQa89E5+DiYOqqmEGCY8bVULrZqDyZrBfeGJ/UzOvbwuG78lZZxkuQLzkLhX57vdRM9iI1NZvlA9+sAOy7NG8ZeDrD6Rgbe+Ow99+Fbs+g3kQ3Fs3zbM9uTrUbKZgjreSI8UjxWKVAKaWPF1wC+GeGxQEwVlhy5pA=
Message-ID: <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com>
Date: Wed, 29 Aug 2007 16:59:47 -0700
From: "Natalie Protasevich" <protasnb@gmail.com>
To: "Adrian Bunk" <bunk@kernel.org>
Subject: Re: Who wants to maintain KR list for stable releases? (was Re: nmi_watchdog=2 regression in 2.6.21)
Cc: "David Rees" <drees76@gmail.com>, "Daniel Walker" <dwalker@mvista.com>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "=?ISO-8859-1?Q?Bj=F6rn_Steinbrink?=" <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20070829222344.GV26410@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46CDE94A.7000600@googlemail.com> <46D21E8E.4000003@googlemail.com>
	 <20070827005131.b93f5935.akpm@linux-foundation.org>
	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>
	 <1188227585.2435.192.camel@dhcp193.mvista.com>
	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>
	 <1188229197.2435.207.camel@dhcp193.mvista.com>
	 <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com>
	 <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com>
	 <20070829222344.GV26410@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Bugzilla is for tracking bugs, not for discussing possible
> kernel features.

True, but some of them are categorized as bugs from the reporter's
prospective, when they say "man page says" or "according to POSIX it's
wrong". I am going to push ones that are feature suggestions,
re-design suggestions, and some way implementation related out to the
site that Rick is going to help to maintain, which is more of
suggested projects list.
>
> Tracking feature or implementation suggestions wouldn't make sense.
> Consider e.g. that there are several people on linux-kernel who often
> write what they think the kernel should do but who never write a single
> line of code themselves. There's no value in tracking such stuff.

Yes, but some suggestions seem to make sense. How about evaluating it?
and if they are real making it a possible project for someone who
would do appropriate research, etc. And we move them from bugzilla
where they don't belong to a development arena.

> >      improved searches - for sure, for example in addition to
> > pre-cooked queries make possible using "raw" queries directly on sql,
> > which will address misplaced bugs and will make categories more
> > dynamic;
>
> What do you have in mind?

I am going to look into the bugzilla software to start with, and see
if there is a way to expand it this way. we used to have such internal
tracking (unix based) at work, where we could compose pretty much
freelance queries, it is really not big deal for developers who script
and write huge regular expressions for their convenience every
day...just a vogue idea for now, trying to think how to minimize bugs
that get lost because of wrong bucket. Going manually through all of
them is not very effective.

> I've always been able to do any search I wanted using the "Advanced Search"
> of Bugzilla. Well, just checking, it seems the search for the new
> "regression" flag could be made easier, but that's not a general problem.
>

Yes but you have to assume that everything is in the right place from
start, besides putting things into categories is often impossible
before some exchange with reporter and initial diagnostics. The worst
category so fas as I found is "other" (in every place where it
exists). Most of the "other" bugs haven't been touched, and some have
huge "SATA" letters in the description written in them :)

> But what could be improved in the database would be to fix the
> charset problems for getting the RSS feeds working (#8774).  ;-)

I agree :)

> Documentation makes sense, but it belongs into some place like the
> kernelnewbies wiki, not the Bugzilla itself.

Right, so there should be convenient links to such. I know people like
Mauro maintains his own set of templates and he was the one to suggest
it, but later I found out myself that looking for serial console or
bisect instructions every time is cumbersome... I can't imagine
 making every maintainer to have to have his own, maybe some hate bug
stuff for this ("oh, not that again...")

> Preferences settings plus saved searches already work.
>
> What is missing?

I guess existing one is certainly good in many ways - just not good
enough for people to love it ;) Frankly, I see so many other bugzillas
that have better look and feel but there is no way we can change it
overnight...improving things according to feedback from maintainers
(after all the whole purpose is to give them what they need, even in
case if they don't need bugzilla at all! then it should be best
possible interface for bug maintainers ;), maybe try 3.0+ first and
see how much better we get...

> There's a "Home" link that does exactly this among the actions offered
> at the bottom of all pages.

Yea you can find many hidden buttons that you have to scroll down to
:) A little more ergonomics wouldn't hurt though..

> Bugzilla isn't that bad and it has the advantage of being the most
> popular bug tracking system for open source projects, which means that
> most likely every kernel developer and many submitters have already used
> a Bugzilla at some other project.
>
> From past discussions my impression was that several kernel developers
> have an email based workflow and are reluctant to integrate web based
> actions into their workflow.

Yes, and we should cater to them as well. I am totally agree with you
that tracking and fixing real bugs is the real goal, and interface is
only important as long as it serves the purpose, and not being a
culprit. We'll see how it will be evolving. (and I am evolving here
too - trying to find what's missing and how to make things work :)

> I'd say the success of any bigger Bugzilla change or switch to a
> different or writing of a new bug tracking system could be measured
> by answering the following question:
>   Will Linus Torvalds and David Miller use it?

Heh, yes. This should be something really awesome don't you think :)

--Natalie
