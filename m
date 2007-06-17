Return-Path: <linux-kernel-owner+w=401wt.eu-S1758769AbXFQRp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbXFQRp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXFQRpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:45:50 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:49724
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754710AbXFQRpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:45:50 -0400
Date: Sun, 17 Jun 2007 10:44:39 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Oleg Verych <olecom@flower.upol.cz>
cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Adrian Bunk <bunk@stusta.de>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
In-Reply-To: <20070617114709.GD16016@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0706171038290.28371@asgard.lang.hm>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
 <E1HyipW-0005wJ-0Q@flower> <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org>
 <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz>
 <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de>
 <467501D0.3090203@googlemail.com> <20070617025552.addd1c41.akpm@linux-foundation.org>
 <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com>
 <20070617114709.GD16016@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jun 2007, Oleg Verych wrote:

> On Sun, Jun 17, 2007 at 12:22:26PM +0200, Michal Piotrowski wrote:
>> On 17/06/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> On Sun, 17 Jun 2007 11:41:36 +0200 Michal Piotrowski
>>> <michal.k.k.piotrowski@gmail.com> wrote:
>>>
>>>> +If the patch introduces a new regression and this regression was not
>>> fixed
>>>> +in seven days, then the patch will be reverted.
>>>
>>> Those regressions where we know which patch caused them are the easy ones.
>>> Often we don't know which patch (or even which subsystem merge) is at
>>> fault.
>>>
>>> I think.  How many of the present 2.6.22-rc regressions which you're
>>> presently tracking have such a well-identified cause?
>>>
>>
>> Here lays the problem.
>>
>> git-bisect is a killer app, people should start using it.
>
> It's OK _only_ in case of unknown, hard to find *hardware* bugs.
>
> If you think it's "a good thing" for bad, untested by developer
> code, then something is completely wrong.
>
> And if there's no debugger in the mainline kernel, which is developer's
> tool, then why do you think testers must stick with git-bisect, as their
> debugger-like tool (bandwidth in most and time consuming in some cases)?
>
> That's wrong if developers are tending to reply only one thing --
> git-bisect.
>
> If things are going to be that bad, then better to start dealing with the
> cause, not consequences. In this situation requesting test-cases is a
> better way, as it's going to influence developer as cause of potential
> problems. If tests will show *hardware* side of problem, then, well some
> parts may be not obvious, thus bisecting is a way to continue.

most people who report bugs don't know enough about what's actually going 
wrong to be able to write a test case (those that do can probably just 
write a patch to fix it). Along similar lines a debugger wouldn't be of 
much use either.

the fact that git-bisect doesn't require any knowledge other then 
knowledge the reporter has demonstrated that they already have (the 
ability to compile and install their own kernel) puts it within the reach 
of testers.

unfortunantly, as good as it is it can take a lot of effort, especially if 
the bug takes time to show up. it's not perfect, but it's a huge help.

and developers aren't always responding with 'do a bisect', sometimes they 
respond with 'yes, we know about that' or 'that sounds like X', so it's 
still worthwhile for people to report the problem first before going to 
the ffort of doing a bisect.

David Lang
