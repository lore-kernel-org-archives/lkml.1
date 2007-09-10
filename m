Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXIJPjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXIJPjy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 11:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbXIJPjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 11:39:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:52676 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759229AbXIJPjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 11:39:46 -0400
Date: Mon, 10 Sep 2007 17:39:53 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
Message-ID: <20070910153953.GG3563@stusta.de>
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de> <46E5558D.3030402@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <46E5558D.3030402@tmr.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 10:32:45AM -0400, Bill Davidsen wrote:
> Adrian Bunk wrote:
>> On Sat, Sep 08, 2007 at 01:44:20PM -0400, Bill Davidsen wrote:
>>   
>>> ...
>>> That was with 2.6.22.5 (or so), dropped back to an old kernel with 
>>> sk98lin, previously had uptimes in three digit days. Up for a week or so 
>>> now.
>>>     
>>
>> There is a real long-term advantage of removing drivers like sk98lin 
>> because it forces people to report bugs if the new driver doesn't work  
>> instead of giving them the workaround of using the obsolete driver. 
>
> The issue is that sk98lin is only obsolete because you say so!

No, it is obsolete because we have more than one driver for this 
hardware, and the people responsible for network drivers in the kernel 
decided some time ago that sk98lin is the one that is obsolete.

>...
>>    And this has the (at first sight surprising) effect that removing code  
>> results in an improvement of the kernel.
>>
>>   
>>> Haven't tried later kernels, don't intend to, while no network is really 
>>> secure, it not really useful.
>>>     
>>
>> You are a regular reader of linux-kernel, and therefore the sk98lin 
>> removal can hardly be a surprise for you. If you prefer whining over 
>> helping to improve the kernel that's your choice...
>>   
>
> I am trying to "improve the kernel" by advocating not removing reliable 
> drivers in favor of unreliable drivers. Saying a driver is better because 
> it has a clean design and good code is something I would expect from 
> someone who hadn't written or used code. If skge and sky2 were so clean you 
> wouldn't still be chasing obscure bugs after the driver had been in the 
> kernel for six+ versions, you wouldn't have me wasting time trying to get a 
> more secure kernel which is still reliable, wouldn't have Willy Tarreau 
> suggesting you should be marking sk98lin as obsolete and leaving it in, 
> wouldn't have someone maintaining sk98lin as a patch, wouldn't have Chris 
> Stromsoe getting hard lock-ups. No matter how ugly sk98lin looks, and how 
> well designed skge and sky2 may be, reliability is not a beauty contest.

A better written driver might still lack some workarounds for broken 
hardware or similar problems. Or simply contain some bugs like all 
software does.

The important word is not "reliability", it's "maintainability".
And that's something that pays off in the long term.

> The volume of complaint should give you a hint that in this case the new 
> drivers aren't usefully stable for many people, and that you are advocating 
> a removal which is at least premature. If you can't admit you're wrong on 
> this one, you can say you have reconsidered the timing of removal in light 
> of new information.

It was clear that sk98lin would go in the long term, and the only thing 
that could be discussed is the when and how of removal.

When you talk about "new information", why did this information not 
surface until after the sk98lin driver was removed?

Is there really a problem with "the timing of removal" or would we have 
faced exactly the same problems if the removal was timed a year later?

And this is really the essence when I'm saying "removing code improves 
the kernel": The goal is to get people to report if the new drivers 
aren't usefully stable for them, not to use sk98lin instead without 
sending a bug report.

Having different drivers with different sets of bugs and features is 
not a situation that should be retained for a longer time.

The underlying question is:
Is there anything better than a quick removal of the obsolete driver to 
get people to both test and report bugs with the new driver?
Keeping obsolete drivers longer only for running into exactly the same 
problem later isn't an improvement.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

