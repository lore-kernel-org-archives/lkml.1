Return-Path: <linux-kernel-owner+w=401wt.eu-S1761114AbYBOTGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761114AbYBOTGh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757245AbYBOTG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:06:28 -0500
Received: from mail.tmr.com ([64.65.253.246]:40947 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754865AbYBOTG1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:06:27 -0500
Message-ID: <47B5E2FD.9060908@tmr.com>
Date: Fri, 15 Feb 2008 14:07:41 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: Driver removals
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi>
In-Reply-To: <20080214082547.GJ12383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Wed, Feb 13, 2008 at 09:26:26PM -0500, Bill Davidsen wrote:
>> ...
>> In general, if a driver works and is being used, until it *needs*  
>> attention I see no reason to replace it. I don't agree that "it forces  
>> people to try the new driver" is a valid reason, being unmaintained is  
>> only a problem if it needs maintenance. I am not going to reopen that  
>> topic, I'm simply noting a general opposition to unfunded mandates, and  
>> requiring changes to kernel, module and/or rc.local config is just that.
> 
> Keeping a working unmaintained driver in the tree is not a big deal - we 
> have hundreds of them.
> 
> But you miss the main point that removal of an obsolete driver with a 
> new replacement driver forces people to finally report their problems 
> with the new driver, thus making the new driver better.
> 
You sure are proud of that new driver! People won't use it because the 
old one is working fine, so you think it's fine to force them to make 
changes in their system to use the new driver. Best case is it works 
after costing the user some time, worst case it doesn't and breaks their 
system, so they stop upgrading the kernel and don't get security fixes.

> After all, the people who scream loudly that the new driver doesn't work 
> for them when the old driver gets removed are the people who should have 
> reported their problems with the new driver many years ago...
> 
Is it not obvious that the problem lies with the "when the old driver 
gets removed" part, there is absolutely no effort needed to keep an old 
driver, and if it's left in until some change requires rewriting every 
module in the kernel, it's likely that either the old hardware or the 
user will die before that ever happens again.

There is no benefit to users, if the old driver didn't work they would 
have switched, there's no saving in support effort because, as you 
pointed out, there are "hundreds of them" now.

This reminds me of Microsoft and XP vs. VISTA. MSFT is stopping sales 
and support of XP to "force people to upgrade" to VISTA. You want to 
"force people to upgrade" to newer drivers. The difference is that MSFT 
at least has money as a reason, as far as I can tell the reason you want 
to force people to use new drivers is because people put all the effort 
into writing the new drivers and now most of us want to use the old one 
if it works. We don't want to change configuration and hope something 
else new works, because we know the old driver works for us and we want 
to use our system instead of helping test the new driver.

I appreciate the effort it took to write new drivers, I believe most 
users able to build their own kernels do. I use new drivers on new 
systems because install picks them and a new system has to go through 
shakedown in any case. I just wish that *you* could appreciate that a 
driver change requires user effort and chance to find bugs in a new 
driver, for each and every system, many of which are at EOL now. I wish 
you valued the user's time as much as users value developer time.

*EOL - end-of-life, if your organization doesn't use the term. the "it's 
paid for, use it but don't spend money on it" phase of ownership.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
