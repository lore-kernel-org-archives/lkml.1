Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbZEKShZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbZEKShZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 14:37:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756719AbZEKShJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 14:37:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757381AbZEKShI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 14:37:08 -0400
Date: Mon, 11 May 2009 11:33:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Johannes Berg <johannes@sipsolutions.net>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, niel.lambrechts@gmail.com
Subject: Re: Probe Timeouts with 47afbaf5af9454a7a1a64591e20cbfcc27ca67a8
In-Reply-To: <1242066170.3873.43.camel@johannes.local>
Message-ID: <alpine.LFD.2.01.0905111126320.3586@localhost.localdomain>
References: <f7848160904301838q4883106fq8d31e2e7c0b10a14@mail.gmail.com>  <1241165805.13562.2.camel@johannes.local>  <f7848160905010619n74372488n45a7b7abccfe5ea7@mail.gmail.com>  <alpine.LFD.2.01.0905111046310.3586@localhost.localdomain>
 <1242066170.3873.43.camel@johannes.local>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 11 May 2009, Johannes Berg wrote:
>
> I always only said it was fixed in wireless-testing and that the fix was
> on the way upstream. I have no influence over more.

Well, since I can't seem to reproduce the problems I had, and since it's 
possible that it wasn't the revert as much as just the reboot itself that 
cleared things up for me, right now I can no longer check one way or the 
other. 

Earlier, it looked like just reverting that commit ended up fixing things, 
which made me very unhappy, since:

> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=c428c89201a57a0ce24c37ed79e540d1f4101cf3
> 
> What does "older" mean here, and what kernel were you using?

"older" means a few years old. It's a compaq/hp 2510p that I've bug out in 
preparation for late-rc 2.6.30 testing to see that everything works fine.

And the kernel I'm using is top-of-git, so that fix was there.

Which was obviously exactly why I was so unhappy about this, since the 
revert seemed to fix problems for me _despite_ the fix.

But now that I can't re-create it, I must assume that it was some other 
random thing unrelated to the revert.

			Linus
