Return-Path: <linux-kernel-owner+w=401wt.eu-S937210AbZDDBzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937210AbZDDBzZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 21:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761233AbZDDBzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 21:55:10 -0400
Received: from relay2.sgi.com ([192.48.179.30]:48096 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758686AbZDDBzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 21:55:09 -0400
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lachlan McIlroy <lachlan@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>
Message-Id: <60503DAA-7DA4-467C-A21E-B02D61FA9390@sgi.com>
From: Felix Blyakher <felixb@sgi.com>
To: david@lang.hm
In-Reply-To: <alpine.DEB.1.10.0904031818270.28893@asgard.lang.hm>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [GIT PULL] XFS update for 2.6.30
Date: Fri, 3 Apr 2009 20:54:55 -0500
References: <20090331053013.7642414167108@attica.americas.sgi.com> <BD6F95C9-2F2D-49A3-979C-25018E62E416@sgi.com> <alpine.LFD.2.00.0904030952220.4130@localhost.localdomain> <alpine.LFD.2.00.0904030954030.4130@localhost.localdomain> <8A177E56-84E9-487E-930E-9C6805E17184@sgi.com> <alpine.DEB.1.10.0904031818270.28893@asgard.lang.hm>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Apr 3, 2009, at 8:19 PM, david@lang.hm wrote:

> On Fri, 3 Apr 2009, Felix Blyakher wrote:
>
>> On Apr 3, 2009, at 12:02 PM, Linus Torvalds wrote:
>>
>>> On Fri, 3 Apr 2009, Linus Torvalds wrote:
>>>> On Thu, 2 Apr 2009, Felix Blyakher wrote:
>>>>> Were there any problems pulling from the xfs repository?
>>>> Sorry, no - just too much email, too many trees to look at, too  
>>>> many
>>>> people to argue with.
>>>> Pulled.
>>> Side note - I almost unpulled afterwards.
>>
>> That was my concern, i.e. it's not pulled without explicit
>> NAK. I knew about your possible concerns.
>>
>>> You've done several apparently totally useless pulls from my tree at
>>> random points.
>>
>> Yes, I noticed that, and agree with all your points even
>> before you brought them up.
>> I already started talking to people to improve my process.
>> The reason the intermediate pulls from your tree were done
>> is to make sure that new xfs patches would not conflict
>> with some other changes already in the mainline. That was
>> part of the maintainer cheat sheet given to me, and I
>> didn't realize the side effects of it.
>> I probably can verify the possible conflicts without pushing
>> the merges into the repository and reset the working tree to
>> pre pull state.
>
> create a temporary branch and do the merge in that. then throw away  
> the test branch and there is no harm to the main tree.

That was suggested among other things by Ingo Molnar as well.
I'm planing to follow this approach.

Thanks,
Felix

>
>
> David Lang
>
>> At any rate, I'll find some way to manage that without
>> cluttering the history with the merges.
>> Any suggestions are welcome.
>>
>> Thanks,
>> Felix
>>
>>> Daily "keep up-to-date with Linus' tree" pulls are _strongly_  
>>> discouraged
>>> (read: if this continues, I'll just stop pulling from you),  
>>> because it
>>> makes the history totally unreadable after-the-fact. It has some  
>>> direct
>>> technical downsides (it makes it much harder to run "git bisect"  
>>> and see
>>> what is going on), but apart from those direct downsides it just  
>>> makes it
>>> much harder for me - or anybody else who wants to get an overview  
>>> of what
>>> happened - to visualize things when history is messy.
>>> Instead of having a clear nice line of development that says "this  
>>> is what
>>> happened to XFS", those merges have basically mixed up all your  
>>> changes
>>> with all the random _other_ changes in the tree.
>>> In other words, having those extra merges makes the graphical  
>>> tools almost
>>> useless for getting some kind of "what happened" overview.
>>> I realize that an occasional back-merge may be required to resolve  
>>> big
>>> conflicts early, but they really have to be pretty big and  
>>> immediate for
>>> it to be a win.
>>>
>>> 			Linus
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux- 
>> kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

