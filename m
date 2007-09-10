Return-Path: <linux-kernel-owner+w=401wt.eu-S964845AbXIJObD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964845AbXIJObD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 10:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbXIJOax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 10:30:53 -0400
Received: from mail.tmr.com ([64.65.253.246]:44931 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbXIJOaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 10:30:52 -0400
Message-ID: <46E5558D.3030402@tmr.com>
Date: Mon, 10 Sep 2007 10:32:45 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: James Corey <ploversegg@yahoo.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Rob Sims <lkml-z@robsims.com>, Kyle Rose <krose@akamai.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
References: <20070905102230.10b0bdcf@oldman> <782111.42803.qm@web90413.mail.mud.yahoo.com> <46E2DF74.7040307@tmr.com> <20070908191132.GD3563@stusta.de>
In-Reply-To: <20070908191132.GD3563@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Sat, Sep 08, 2007 at 01:44:20PM -0400, Bill Davidsen wrote:
>   
>> ...
>> That was with 2.6.22.5 (or so), dropped back to an old kernel with sk98lin, 
>> previously had uptimes in three digit days. Up for a week or so now.
>>     
>
> There is a real long-term advantage of removing drivers like sk98lin 
> because it forces people to report bugs if the new driver doesn't work  
> instead of giving them the workaround of using the obsolete driver. 

The issue is that sk98lin is only obsolete because you say so! skge 
crashes the system, as Chris reports, sky2 just stops passing bits and 
behaves as if the network cable were idle, no error messages of any 
nature, ping claims it's sending packets, tcpdump claims packets are 
being sent, the switch never blinks and systems on the switch see no 
packets. Again, no error messages, no dumps, nothing which would help 
you debug it, and it happens after some undefined time.

skge and sky2 are up to eight or ten versions now, and they still don't 
work. Just because a driver works doesn't mean it's obsolete.
>    
> And this has the (at first sight surprising) effect that removing code  
> results in an improvement of the kernel.
>
>   
>> Haven't tried later kernels, don't intend to, while no network is really 
>> secure, it not really useful.
>>     
>
> You are a regular reader of linux-kernel, and therefore the sk98lin 
> removal can hardly be a surprise for you. If you prefer whining over 
> helping to improve the kernel that's your choice...
>   

I am trying to "improve the kernel" by advocating not removing reliable 
drivers in favor of unreliable drivers. Saying a driver is better 
because it has a clean design and good code is something I would expect 
from someone who hadn't written or used code. If skge and sky2 were so 
clean you wouldn't still be chasing obscure bugs after the driver had 
been in the kernel for six+ versions, you wouldn't have me wasting time 
trying to get a more secure kernel which is still reliable, wouldn't 
have Willy Tarreau suggesting you should be marking sk98lin as obsolete 
and leaving it in, wouldn't have someone maintaining sk98lin as a patch, 
wouldn't have Chris Stromsoe getting hard lock-ups. No matter how ugly 
sk98lin looks, and how well designed skge and sky2 may be, reliability 
is not a beauty contest.

The volume of complaint should give you a hint that in this case the new 
drivers aren't usefully stable for many people, and that you are 
advocating a removal which is at least premature. If you can't admit 
you're wrong on this one, you can say you have reconsidered the timing 
of removal in light of new information.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

