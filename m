Return-Path: <linux-kernel-owner+w=401wt.eu-S1031365AbXDZRXK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031365AbXDZRXK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 13:23:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031362AbXDZRXK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 13:23:10 -0400
Received: from mail.tmr.com ([64.65.253.246]:47868 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031369AbXDZRXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 13:23:07 -0400
Message-ID: <4630E00B.3090502@tmr.com>
Date: Thu, 26 Apr 2007 13:23:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de>
In-Reply-To: <20070426040806.GJ3468@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Apr 25, 2007 at 08:29:28PM -0700, Linus Torvalds wrote:
>> ...
>> So it's been over two and a half months, and while it's certainly not the 
>> longest release cycle ever, it still dragged out a bit longer than I'd 
>> have hoped for and it should have. As usual, I'd like to thank Adrian (and 
>> the people who jumped on the entries Adrian had) for keeping everybody on 
>> their toes with the regression list - there's a few entries there still, 
>> but it got to the point where we didn't even know if they were real 
>> regressions, and delaying things further just wasn't going to help.
>> ...
> 
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release:
> 14
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release that were first reported in March or earlier:
> 8
> 
> Number of different known regressions compared to 2.6.20 at the time
> of the 2.6.21 release with patches available at the time of the 2.6.21 
> release [1]:
> 3
> 
> What I will NOT do:
> Waste my time with tracking 2.6.22-rc regressions.
> 
> 
> We have an astonishing amount of -rc testers, but obviously not the 
> developer manpower for handling them.
> 
> If we would take "no regressions" seriously, it might take 4 or 5 months 
> between releases due to the lack of developer manpower for handling 
> regressions. But that should be considered OK if avoiding regressions 
> was considered more important than getting as quick as possible to the 
> next two week regression-merge window.
> 
> But releasing with so many known regressions is insulting for the many 
> people who spent their time testing -rc kernels.
> 
Without someone holding Linus feet to the fire the next release may be a 
real POS. I think you have done the perfect job, identifying the show 
stoppers, quantifying the obscure and minor regressions, and serving to 
give testing targets as purported fixes are applied.

I don't think you should judge your work by leaving some targets for 
-stable and 2.6.22, but rather from the number of problems you detected, 
documented, and caused to be addressed.

If it were my week to be God, I would insist that the rcN to final step 
was regressions-only, and that all regressions be classified as (a) 
acceptable results of changes to fix other problems, (b) must be fixed 
before release, or (c) obscure enough to tolerate for a short time, must 
be fixed in stable and mainline before N+1 release.

Measuring releases or your own value against perfection is thankless!

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
