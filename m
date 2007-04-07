Return-Path: <linux-kernel-owner+w=401wt.eu-S966207AbXDGSYJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966207AbXDGSYJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 14:24:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXDGSYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 14:24:09 -0400
Received: from vms042pub.verizon.net ([206.46.252.42]:47067 "EHLO
	vms042pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966207AbXDGSYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 14:24:07 -0400
Date: Sat, 07 Apr 2007 14:23:47 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: Ten percent test
In-reply-to: <20070407180818.GB23861@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Con Kolivas <kernel@kolivas.org>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
Message-id: <200704071423.47790.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703290237.38777.kernel@kolivas.org>
 <200704071212.57401.gene.heskett@gmail.com> <20070407180818.GB23861@elte.hu>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 07 April 2007, Ingo Molnar wrote:
>* Gene Heskett <gene.heskett@gmail.com> wrote:
>> To be expected, there are after all, only so many cpu cycles to go
>> around.  Here I sit, running 2.6.21-rc6 ATM, and since there is not an
>> SD patch that applies cleanly to rc6, I am back to typing half or more
>> of a sentence blind while I answer a posting such as this because of x
>> starvation while kmail is sorting incoming stuff.
>
>it would be really nice to analyze this. Does the latest -rt patch boot
>on your box so that we could trace this regression? (I can send you a
>standalone tracing patch if it doesnt.) IIRC you reported that one of
>the early patches from Mike made your system behave good (but still not
>as good as SD) - it would be nice to try a later patch too.

Yes it would be Ingo, but so far, none of the recent -rt patches has 
booted on this machine, the last one I tried a few days ago failing to 
find /dev/root, whatever the heck that is.

FWIW, I gave up on the rt stuffs 6 months or more ago when the regressions 
I was reporting weren't ever acknowledged.  I don't enjoy sitting through 
all these e2fsk's during the reboot just to have things I normally run in 
the background die, like tvtime, sitting there with some news channel 
muttering along in the background.  I was even ignored when I suggested 
it might be a dma problem, which I still think it could be.

Nevertheless, the patch you sent is building as I type, intermittently 
when the screen deigns to update so I can fix the spelling etc.

>basically, the current unfairness in the scheduler should be solved, one
>way or another. Good testcases were posted and there's progress.
>
>> (who the hell runs a 'make -j 200' or 50 while(1)'s in the real world?
>
>not many - and i dont think Mike tested any of these - Mike tested
>pretty low make -j values (Mike, can you confirm?).
>
>(I personally routinely run 'make -j 200' build jobs on my box [because
> it's the central server of a build cluster and high parallelism is
> needed to overcome network latencies], but i'm pretty special in that
> regard and i didnt use that workload as a test against any of these
> schedulers.)

And I'd wager a cool one that you don't gain more than a second or so in 
compile time between a make -j8 and a make -j200 unless your network is a 
pair of tomato juice cans & some string.  Again, to me, the network thing 
is not something that's present in an everyday users environment.  My 
drives are all here and now, on pata-133 interfaces.

>	Ingo

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
If you would keep a secret from an enemy, tell it not to a friend.
