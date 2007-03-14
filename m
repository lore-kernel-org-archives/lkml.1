Return-Path: <linux-kernel-owner+w=401wt.eu-S965136AbXCNGKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965136AbXCNGKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 02:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030484AbXCNGKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 02:10:22 -0400
Received: from vms040pub.verizon.net ([206.46.252.40]:59060 "EHLO
	vms040pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965136AbXCNGKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 02:10:21 -0400
Date: Wed, 14 Mar 2007 02:09:57 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: New thread RDSL, post-2.6.20 kernels and amanda (tar) miss-fires
In-reply-to: <20070314050721.GP2986@holomorphy.com>
To: linux-kernel@vger.kernel.org
Cc: William Lee Irwin III <wli@holomorphy.com>
Message-id: <200703140209.58375.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200703130428.11014.gene.heskett@gmail.com>
 <200703132331.56140.gene.heskett@gmail.com>
 <20070314050721.GP2986@holomorphy.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 March 2007, William Lee Irwin III wrote:
>On Tue, Mar 13, 2007 at 11:31:53PM -0400, Gene Heskett wrote:
>> Now, can someone suggest a patch I can revert that might fix this? 
>> The total number of patches between 2.6.20 and 2.6.21-rc1 will have me
>> building kernels to bisect this till the middle of June at this rate.
>
>4 billion patches could be bisected in 34 boots. Between 2.6.20 and
>2.6.21-rc1 there are only:
>
>$ git rev-list --no-merges v2.6.20..v2.6.21-rc1  |wc -l
>3118
>
>patches, requiring 14 boots. In general ceil(log(n)/log(2))+2 boots.
>
>Of course, this is a little optimistic because it assumes no additional
>breakage occurring at the various bisection points. In any event,
>assuming (pessimistically) 10 minutes per build, this is 280 minutes or
>4 hours and 40 minutes of build time. I estimate the process should
>complete well before Friday of this week, never mind June.

Chuckle, sorry to disappoint you wli, on that 32 cpu Niagra Con was 
calling 'poor equipment', maybe.

Even using  ccache, its about 15-18 minutes per build, with another 10 to 
edit my build script and construct the kernel tree with the proper 
patches applied.  Then a reboot, probably 10 minutes by the time I get 
the nvidia driver installed for the new kernel and get startx'd, then its 
another 2 hours or a bit less for an amanda run to test it.

I've posted to the amanda lists too, so they will be aware of it.  And 
because an ls -lc returns perfectly sane values for the mtimes and sizes, 
I suspect the real problem may not necessarily be 100% kernel related.  I 
have been intermittently ranting because both the tar api stir, and the 
return from tar are such a moving target that the developers are having a 
hard time staying ahead of the changes to tar, backward compatibility it 
seems, is the furthest thing from the tar maintainers minds.  The most 
recent change that I'm aware of is that tar now returns a 1 for success! 
What the heck were those guys at gnu.org thinking?  Or smoking as the 
case may be.

I obviously have a copy of the -rc1 patch in its entirety that I could 
peruse, but I'm not sure I would recognize a change that would effect tar 
if it bit me, hence the questions here to those who are far more 
conversant than I.

As I've said on several occasions William, at my age, the best part I can 
play here is the Canary, in the coal mine scene, and something strange in 
the air of 2.6.21* just killed me.  It's now up to the coroner(s) to 
determine the cause, and he has several dozen very very able assistants 
monitoring this list in my NSH opinion.  Whatever, either tar, or this 
particular board in the kernels architecture surely needs fixed before 
2.6.21 final.  I don't even know if gnu.org has a bugzilla setup, but 
I'll look around tomorrow night as I'm tied up now till late tomorrow.  
If they do, I'll file it.

But, I'm also amazed that no one else has been bitten.  Don't any of you 
ever make a backup using tar for the pack mule?

Thanks William.

>-- wli

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Do unto others before they undo you.
