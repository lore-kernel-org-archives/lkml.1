Return-Path: <linux-kernel-owner+w=401wt.eu-S1759017AbZEKSD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759017AbZEKSD2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755325AbZEKSDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:03:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35910 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751772AbZEKSDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:03:16 -0400
Date: Mon, 11 May 2009 10:57:48 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Parag Warudkar <parag.lkml@gmail.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
cc: LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
In-Reply-To: <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>  <1241165805.13562.2.camel@johannes.local> <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 1 May 2009, Parag Warudkar wrote:

> On 5/1/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> 
> > I'm not sure what makes you think that it even _should_ be reverted.
> >  Just to make that clear: it should _not_ be reverted. How did you check
> >  that it isn't reverted in compat-wireless anyway? Must have been by code
> >  inspection since if you had made an attempt to verify that the code in
> >  there works, you would have found that indeed there's no reason to
> >  revert this commit since the fix for it went in, and is literally a
> >  single line.
> 
> Well I have the 04-29 compat-wireless tree and it does not work - just
> like mainline I get timeouts. I have not been able to download later
> versions - clicking on the URL does nothing for some reason. (Besides
> I do not normally track compat-wireless.)

Ok, it's -rc5, and apparently nothing has happened about this problem. 
Johannes has just been stone-walling and ignoring the reports, and 
claiming it's fixed when it clearly wasn't. 

I just verified on one of my older machines (running current fedora-11, 
with a 4965AGN rev=0x4) that the problem is real, and that reverting that 
commit does indeed seem to fix it.

So here goes: I'm going to revert that commit today or tomorrow, unless 
somebody sends me a fix that I can verify. I don't want any more excuses, 
I don't want to hear developers dismissing bug-reports, and I _can_ verify 
this problem myself. 

We do not fix bugs by introducing new regressions and then ignoring the 
reports. Especially since the bug that the commit in question fixes seems 
to be _way_ less important than the bug it then introduces.

		Linus
