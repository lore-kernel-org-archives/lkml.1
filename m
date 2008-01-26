Return-Path: <linux-kernel-owner+w=401wt.eu-S1756106AbYAZOZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756106AbYAZOZq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2008 09:25:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbYAZOZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jan 2008 09:25:37 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51568 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751410AbYAZOZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2008 09:25:36 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479B42C4.7020507@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 15:25:08 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Giacomo A. Catenazzi" <cate@cateee.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: using LKML for subsystem development
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net> <479A75D4.6070607@s5r6.in-berlin.de> <479A8203.40804@s5r6.in-berlin.de> <20080126112820.GA10563@elte.hu>
In-Reply-To: <20080126112820.GA10563@elte.hu>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> [...] How will subscribers of LKML decide which discussion threads in 
>> the huge amount of traffic are worth to glance at?  Each of us has 
>> only a limited amount of time for LKML consumption.
> 
> uhm. How do you decide which of the 10000 git commits per upstream 
> kernel release (more than 100 a day) you'll look at?
> 
> easy: you download the full git tree from Linus, to have all the 
> information in one place, but you then you use filters, because you are 
> not interested in the whole 9 million lines of kernel code.

A better analogy to subsystem development discussions is -mm rather than
Linus' tree.

> You use filters such as:
> 
>    git-log drivers/net/
[...]
> and by logical extension, the public development "metadata" of that 
> unified source tree should be ... just as easily accessible. Such as ... 
> a single forum of discussion - an email list for example.
> 
> People who dont want to follow the whole, will ... filter.
> 
> For example they will only open the threads they are interested in.
> 
> Or you dont even have to read all the subjects: you can filter on "net" 
> subjects for example,
[...]
> Or filter on _people_. The "domain experts" you are interested in. 
> Filter on all mails from David S. Miller if you are interested in 
> networking topics. You'll have a really good grasp of what's going on in 
> that area, without having to invest too much time.
> 
> Or subscribe to lwn.net who do weekly updates with links to lkml. If you 
> dont have the time, you might have the money to pay people who have the 
> time to do work for you.

I would like this variant the most.  All firewire bugs would be closed
by now.  :-)

> (or if that's still too much, follow the 
> time-deferred lkml updates of lwn.net)
> 
> Realize it: it's _far_ easier to filter down a too verbose source of 
> information, than to put scattered, inaccessible pieces of information 
> back together. It's far easier to get a cup of water from the open 
> firehose than it is to gather the drops once they spilled on the ground.

Correct.

> Sure, it all seems easier if you get everything presented on a nice 
> little mailing list, with just the right people subscribed - but that 
> isolation is the same kind of "closed source" thinking that causes so 
> many problems in computing today.

Wrong.  The topic mailinglists are not about closed circles.  At least
not those which do not require subscription and which have proper list
archives.  These mailinglists are...

> lkml is about using this whole "open development" idea and pushing it to 
> its logical conclusion. "Domain experts" hiding away in caves is just a 
> fancy excuse for something much different

...not an excuse for anything.  They lower the barrier for people to
participate.  Notably people

  - who are afraid of subscribing to a high-volume mailinglist (even if
    they have the technical means at their disposal to manage that
    volume),
  - who have low bandwidth internet service,
  - whose mail service provider doesn't server-side, user-configurable
    filtering,
  - who don't want to come up with sophisticated mail filters,
  - who don't want to reconfigure filters or temporarily unsubscribe
    when they go on a trip to locations without cheap connectivity,

but most importantly,

  - who are interested a lot in how gadget xyz works (and can contribute
    a lot due to their knowledge in that field) but don't know much
    about and/or aren't interested a lot in the Linux kernel (yet).

The linux1394-devel mailinglist for example is by far not only dedicated
to Linux IEEE 1394 kernel driver development.  It is also about
development and maintenance of Linux IEEE 1394 userspace libraries and
application programs.  Should we separate these topics out into a
different mailinglist?  No, we shouldn't, because these discussions are
often closely related.  Actually we have a similar problem like you are
pointing out about LKML vs. kernel subsystem lists:  We regularly have
discussions jumping around linux1394-devel, linux1394-user,
libdc1394-devel, coriander-devel, coriander-user, kino-dev, and even
linux-scsi.

So, there is traffic which is on-topic at linux1394-devel but would be
very off-topic on linux-kernel.

BTW, you misplaced the quotation marks in >>"Domain experts" hiding away
in caves<<.  These experts exist, but the "caves" generally don't, if we
ignore non-subscriber lists and lists without usable archives for a
moment.  I as IEEE 1394 kernel subsystem maintainer would be hopelessly
incapable to get anything done if there weren't the sort of people
helping me who don't know much about the kernel but a lot about IEEE
1394; along with the very very few people who know and are interested in
both.  That latter sort of people had been 0 (read: zero) at times.

> and it can be really harmful 
> to the end result (the kernel's quality). Most of the subsystems already 
> do their development on lkml, but it could be further improved upon.

Granted.

But we can't fully replace lists like linux1394-devel by LKML.

(linux1394-devel is not an ideal example in this discussion though
because what we break, breaks only the IEEE 1394 subsystems but nothing
else.  ---  Correction:  We did break suspend/resume at two occasions or
so on systems which have one of our low-level drivers loaded.  Hard to
tell whether channeling all of linux1394-devel's discussions over LKML
would have had an effect on this.)

Back to the -mm analogy:

What about a meta list which is subscribed to the lot of subsystem lists?

People who are interested in the Linux kernel as a whole could subscribe
to that aggregated meta list.  Of course this would only fully work with
the subsystem development lists which don't require subscription to post.
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
