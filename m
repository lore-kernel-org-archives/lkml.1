Return-Path: <linux-kernel-owner+w=401wt.eu-S1764971AbYD3Tm4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764971AbYD3Tm4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 15:42:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761287AbYD3Tmr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 15:42:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761130AbYD3Tmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 15:42:46 -0400
Date: Wed, 30 Apr 2008 12:42:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Newall <davidn@davidnewall.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <4818C6E3.1030701@davidnewall.com>
Message-ID: <alpine.LFD.1.10.0804301225590.2980@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <4817EF91.4080800@davidnewall.com> <20080429.211835.130816277.davem@davemloft.net> <48186E57.5070805@davidnewall.com> <alpine.LFD.1.10.0804300739350.2997@woody.linux-foundation.org>
 <4818B8A7.4000902@davidnewall.com> <alpine.LFD.1.10.0804301127020.2980@woody.linux-foundation.org> <4818C336.5000800@nortel.com> <alpine.LFD.1.10.0804301211510.2980@woody.linux-foundation.org> <4818C6E3.1030701@davidnewall.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, David Newall wrote:
>
> You're taking this far too personally.

Umm. If you didn't want a personal opinion, why did you Cc me in the first 
place then, and ask for my input?

I gave my input to you. I think your arguments are ludicrous, to the point 
of being totally idiotic. You complain how I don't release kernels that 
are stable, but without any suggestions on what the issue might be, apart 
from apparently me merging too much and making too many releases.

But do you really expect me to stop merging, or hold up releases that fix 
hundreds of issues, just because there are other issues pending? Do you 
really think development can be stopped? Trust me, we've tried. Every 
time, it just leads to worse problems when the floodgates are then opened.

And yes, there is a solution: don't develop so much. Don't allow thousands 
of developers to be involved. Do a small core group, and make development 
so hard or inconvenient that you only have a few tens of people who write 
code, and vet them and force them to jump through hoops when adding new 
features (or fixing old ones, for that matter).

And yes, that *does* result in a "stable" system. Never mind that it's 
stable for all the wrong reasons, and generally doesn't actually work well 
across a dynamic environment (whether the hardware base below or user 
space above).

See? This is why I think your arguments are so silly and misguided. 

But if you actually have real constructive ideas on things to actually 
*do*, please do mention them. We've changed our models over time, several 
times, exactly because we've searched for better ways to do thigns. But do 
realize that

 (a) we can't just stop, or even really slow down. We can onyl try to 
     regulate and to some degree direct the flood, not hold it up for any 
     particular issue.

 (b) We do have process in place, and it may not be perfect, but I doubt 
     anything is, and what we do have actually has evolved over the years. 

     And that's not just my process (ie "two-week merge window, followed 
     by about 6-8 weeks of fixups"), but the whole process both before and 
     after it (Andrew and now linux-next in front of it, and stable kernel 
     tree and the vendors after it).

 (c) the "big picture" discussion is separate from individual issues. If 
     you want your suspend-to-disk issue resolved, or a memory leak 
     solved, you don't solve those by trying to complain about other parts 
     of the system, that are totally separate.

     The global flow of patches and releases is not something that we can 
     hold up for _any_ of your individual problems. I do end up delaying 
     releases for really core things, so individual problems do obviously 
     affect (for example) the release timing. But the solution to them is 
     not in complaining about slowing down development, it is about 
     actually trying to engage the developers of *that* feature in *that* 
     particular bug.

And finally, trust me, if you want to have people care about your 
problems, the last thing you want to do is say "I might switch to BSD". 
Because quite frankly, I really don't care. People who think that threats 
like that work in any productive way can go screw themselves. I'll flame 
idiots like that, and my likelihood of helping people because they think 
they hold a gun to my head is almost zero.

		Linus
