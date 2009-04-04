Return-Path: <linux-kernel-owner+w=401wt.eu-S937273AbZDDBVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937273AbZDDBVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763636AbZDDBVQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:21:16 -0400
Received: from mail.lang.hm ([64.81.33.126]:43625 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763471AbZDDBVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:21:15 -0400
Date: Fri, 3 Apr 2009 18:19:08 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Felix Blyakher <felixb@sgi.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lachlan McIlroy <lachlan@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Subject: Re: [GIT PULL] XFS update for 2.6.30
In-Reply-To: <8A177E56-84E9-487E-930E-9C6805E17184@sgi.com>
Message-ID: <alpine.DEB.1.10.0904031818270.28893@asgard.lang.hm>
References: <20090331053013.7642414167108@attica.americas.sgi.com> <BD6F95C9-2F2D-49A3-979C-25018E62E416@sgi.com> <alpine.LFD.2.00.0904030952220.4130@localhost.localdomain> <alpine.LFD.2.00.0904030954030.4130@localhost.localdomain>
 <8A177E56-84E9-487E-930E-9C6805E17184@sgi.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Apr 2009, Felix Blyakher wrote:

> On Apr 3, 2009, at 12:02 PM, Linus Torvalds wrote:
>
>> On Fri, 3 Apr 2009, Linus Torvalds wrote:
>> 
>>> On Thu, 2 Apr 2009, Felix Blyakher wrote:
>>>> 
>>>> Were there any problems pulling from the xfs repository?
>>> 
>>> Sorry, no - just too much email, too many trees to look at, too many
>>> people to argue with.
>>> 
>>> Pulled.
>> 
>> Side note - I almost unpulled afterwards.
>
> That was my concern, i.e. it's not pulled without explicit
> NAK. I knew about your possible concerns.
>
>> You've done several apparently totally useless pulls from my tree at
>> random points.
>
> Yes, I noticed that, and agree with all your points even
> before you brought them up.
> I already started talking to people to improve my process.
> The reason the intermediate pulls from your tree were done
> is to make sure that new xfs patches would not conflict
> with some other changes already in the mainline. That was
> part of the maintainer cheat sheet given to me, and I
> didn't realize the side effects of it.
> I probably can verify the possible conflicts without pushing
> the merges into the repository and reset the working tree to
> pre pull state.

create a temporary branch and do the merge in that. then throw away the 
test branch and there is no harm to the main tree.

David Lang

> At any rate, I'll find some way to manage that without
> cluttering the history with the merges.
> Any suggestions are welcome.
>
> Thanks,
> Felix
>
>> 
>> 
>> Daily "keep up-to-date with Linus' tree" pulls are _strongly_ discouraged
>> (read: if this continues, I'll just stop pulling from you), because it
>> makes the history totally unreadable after-the-fact. It has some direct
>> technical downsides (it makes it much harder to run "git bisect" and see
>> what is going on), but apart from those direct downsides it just makes it
>> much harder for me - or anybody else who wants to get an overview of what
>> happened - to visualize things when history is messy.
>> 
>> Instead of having a clear nice line of development that says "this is what
>> happened to XFS", those merges have basically mixed up all your changes
>> with all the random _other_ changes in the tree.
>> 
>> In other words, having those extra merges makes the graphical tools almost
>> useless for getting some kind of "what happened" overview.
>> 
>> I realize that an occasional back-merge may be required to resolve big
>> conflicts early, but they really have to be pretty big and immediate for
>> it to be a win.
>>
>> 			Linus
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
