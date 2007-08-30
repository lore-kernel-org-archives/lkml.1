Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXH3PZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXH3PZO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 11:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbXH3PZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 11:25:03 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38083 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250AbXH3PZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 11:25:00 -0400
Message-ID: <46D6E135.8000203@s5r6.in-berlin.de>
Date: Thu, 30 Aug 2007 17:24:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Natalie Protasevich <protasnb@gmail.com>
CC: Adrian Bunk <bunk@kernel.org>, David Rees <drees76@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?UTF-8?B?QmrDtnJuIFN0ZWluYnJpbms=?= <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Who wants to maintain KR list for stable releases?
References: <46CDE94A.7000600@googlemail.com> <46D21E8E.4000003@googlemail.com>	 <20070827005131.b93f5935.akpm@linux-foundation.org>	 <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com>	 <1188227585.2435.192.camel@dhcp193.mvista.com>	 <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com>	 <1188229197.2435.207.camel@dhcp193.mvista.com>	 <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com>	 <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com>	 <20070829222344.GV26410@stusta.de> <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com>
In-Reply-To: <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Natalie Protasevich wrote:
[Adrian Bunk wrote:]
>> Bugzilla is for tracking bugs, not for discussing possible
>> kernel features.
> 
> True, but some of them are categorized as bugs from the reporter's
> prospective, when they say "man page says" or "according to POSIX it's
> wrong". I am going to push ones that are feature suggestions,
> re-design suggestions, and some way implementation related out to the
> site that Rick is going to help to maintain, which is more of
> suggested projects list.
>>
>> Tracking feature or implementation suggestions wouldn't make sense.
>> Consider e.g. that there are several people on linux-kernel who often
>> write what they think the kernel should do but who never write a single
>> line of code themselves. There's no value in tracking such stuff.

I agree.

But I find it sensible...

> Yes, but some suggestions seem to make sense. How about evaluating it?
> and if they are real making it a possible project for someone who
> would do appropriate research, etc. And we move them from bugzilla
> where they don't belong to a development arena.

...to track very concrete feature-related TODO items.  One Issues &
Resolutions Database which I occasionally work with indeed distinguishes
between "bug", "new feature", "improvement", "task", whatever that
means.  The type of issue is the first question one is asked when one
enters a new issue.

'My' Linux kernel subsystem has a long virtual TODO list, with bugs,
missing features, and other kinds of items in it.  Since there is almost
no personnel, the list has a tendency to contain long-lived items.  Once
or twice or so I already added entries of the missing-feature kind to
bugzilla.kernel.org.  Doing this is questionable at the moment though
--- it adds noise to the database of actual bugs, since there is no way
to visually distinguish and filter bugs vs. missing features etc.

Of course, non-bug TODO items could as well be tracked elsewhere,
independently of bug tracking.  'My' subsystem has a wiki which could be
a good place for this.  Or I could start to post a TODO list on the
subsystem mailinglist in e.g. bimonthly intervals.


Al Boldi wrote in "Designers and Builders (was: Who wants to maintain KR
list for stable releases?)":
| So, what's wrong with tapping into people's design suggestions, and
| allowing others to implement it?

Design suggestions should really come from people who also know a lot
about the how-to.  This is even true to some degree about feature
requests.  Besides, I've got a feeling that regardless of the field of
τεχνη one works in, someone can only be a truly good designer if she or
he has also been a builder.

But back to the discussion.  A tracker is not a good tool for
brainstorming sessions, except perhaps for capturing conclusions after
the brainstorm, as far as they are suitable as input for actual work.

Also, "*allowing* others to implement it" has a strange ring to me.
Where I am around, there are always far too few people who fix things
and build things.  But very, very occasionally there is someone new who
wonders if there is an interesting TODO item which is perhaps in the
reach of his abilities.  Contributing a cleanup or an actual feature is
typically much easier than fixing an open, tracked bug.  (The bugs which
end up in the bugtracker are usually the difficult ones.)  The
contributor learns something and, in a rare turn of events, may
eventually become able and willing to join the bugfixing.
-- 
Stefan Richter
-=====-=-=== =--- ====-
http://arcgraph.de/sr/
