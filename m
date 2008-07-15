Return-Path: <linux-kernel-owner+w=401wt.eu-S1759036AbYGOUax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759036AbYGOUax (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762911AbYGOUaZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:30:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762207AbYGOUaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:30:24 -0400
Date: Tue, 15 Jul 2008 13:29:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulmck@us.ibm.com,
       a.p.zijlstra@chello.nl, Vegard Nossum <vegard.nossum@gmail.com>
Subject: Re: [git pull] RCU updates for v2.6.27
In-Reply-To: <20080715131515.ebdc53d8.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807151319360.2867@woody.linux-foundation.org>
References: <20080714152045.GA29159@elte.hu> <alpine.LFD.1.10.0807151037060.3017@woody.linux-foundation.org> <20080715131515.ebdc53d8.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jul 2008, Andrew Morton wrote:

> On Tue, 15 Jul 2008 10:38:27 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > Hmm. I really wanted to wait with kmemcheck, which is huge and I'm not 
> > entirely convinced yet.
> 
> Any particular concerns?

It's big, complex and looks fragile. And it reports lots of false 
positives, with big warnings to people to generally not use or make 
reports about itit unless they are already experts. So it looks like 
something pretty specific.

I also want to feel like it actually has been helpful.

But the _real_ issue is that I'm simply merging about 20+ trees per day, 
and I want to know what I merge, and I want to feel comfy about it as I 
merge it.

And kmemcheck didn't make me do that, adn I didn't feel like I had the 
time to really look at it any closer. So while I might merge it before the 
merge window is open, there's simply no way I'll merge it today (and 
almost certainly not this week, considering that I'll be on the coast for 
a long weekend).

IOW, I'm quite busy enough merging _other_ things, and handling the 
fallout from those other merges (mostly the firmware discussion ;). So I'm 
simply not interested in kmemcheck right now - I have enough to keep me 
busy.

So kmemcheck in no way made me go: "ok, we _need_ to merge this", and at 
the same time it's biggish and scary and complex enough that I felt I 
needed to take the time to think about it - which I don't feel I have 
right now.

The RCU thing, on the other hand, looked like a no-brainer from a merge 
standpoint. However, since it had merged kmemcheck, it didn't get merged 
either. I'll take a look at Ingo's second version that didn't tie the two 
together.

This is why tying things together doesn't necessarily work, and why I told 
Ingo that I'm not pulling the RCU thing just because I wasn't ready to 
pull kmemcheck.

		Linus
