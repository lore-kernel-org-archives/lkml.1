Return-Path: <linux-kernel-owner+w=401wt.eu-S1761702AbYDZTNN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761702AbYDZTNN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 15:13:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759498AbYDZTM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 15:12:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759276AbYDZTM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 15:12:57 -0400
Date: Sat, 26 Apr 2008 12:12:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Yinghai Lu <yinghai.lu@sun.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       jbarnes@virtuousgeek.org
Subject: Re: [RFC git pull] "big box" x86 changes
In-Reply-To: <20080426185516.GA32364@elte.hu>
Message-ID: <alpine.LFD.1.10.0804261205490.2813@woody.linux-foundation.org>
References: <20080426185516.GA32364@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Apr 2008, Ingo Molnar wrote:
> 
> So we need a bit of help wrt. how mergable this is, and what else is 
> needed to make it mergable. These changes have been booted all across 
> the x86 spectrum, small and large boxes alike, so i'd be seriously 
> surprised if they caused any widespread breakage.

I'd like to see this sent as perhaps four independent pulls (where 
"independent" doesn't necessarily mean that they don't depend on each 
other and have some ordering, but is more of a "this is the bootup 
changes" vs "these are bootmem-related" etc, if at all possible. 

Quite frankly, from a review standpoint, very few people should need to 
(or want to) review individual commits when there are 50 of them (they 
might only care about the changes that 3 or 4 of them make, but they get 
lost in the noise), but at the same time, if you have a single diffstat 
like this:

	45 files changed, 2071 insertions(+), 362 deletions(-)

then you're also going to have people not able to give good feedback.

In contrast, if you send out an email like this one, but that has the 
combined diff of say 10 commits in one area, and the diff is a couple of 
hundred lines of changes rather than almost 2,500 lines, then you'll 
definitely get people who are able and willing to look at four chunks like 
that.

IOW, they'd be big enough that people hopefully don't start nitpicking 
about some *totally* uninteresting small detail, but small enough that 
people can read it through without losing concentration about a quarter of 
the way in.

			Linus
