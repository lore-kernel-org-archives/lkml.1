Return-Path: <linux-kernel-owner+w=401wt.eu-S1762932AbXGZXiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762932AbXGZXiJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 19:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757064AbXGZXh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 19:37:58 -0400
Received: from mail.tmr.com ([64.65.253.246]:49331 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbXGZXh5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 19:37:57 -0400
Message-ID: <46A9307A.5000502@tmr.com>
Date: Thu, 26 Jul 2007 19:38:34 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Kyle Rose <krose@akamai.com>, linux-kernel@vger.kernel.org
Subject: Re: sk98lin for 2.6.23-rc1
References: <46A8BAD4.8020004@akamai.com> <20070726165701.GM3572@stusta.de>
In-Reply-To: <20070726165701.GM3572@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jul 26, 2007 at 11:16:36AM -0400, Kyle Rose wrote:
>> >From http://www.krose.org/~krose/computing.html:
>>
>> Since the sky2 driver continues to suck ass (which is a technical
>> description for "it hangs all the time under load, at least on my
>> hardware" :-) ), I've fixed the sk98lin driver to compile for
>> linux-2.6.23-rc1. Those who continue to have problems with sky2 can
>> still use 2.6.23-rc1, simply by doing the following:
>> ...
>> Personally, I'd like to see sk98lin remain in the kernel proper until
>> sky2 goes at least 6 months without reported problems.  The fact that I
>> am not the only one still seeing issues is a clear indication that sky2
>> (even with the recent patches in 2.6.23-rc1) is not yet ready to replace
>> sk98lin.
>> ...
> 
> This sounds good in theory.
> 
> The practical problem with this approach is that there are always many 
> people who use the old driver when the new driver doesn't work for them 
> instead of reporting their problems with the new driver.
> 
Yes, you've grasped the reason for leaving the old driver in, so people 
can use their computers. Because when there is a new driver for 
previously unsupported hardware people will be glad to put time into 
debugging it to make the hardware useful. But when you take out a 
working driver because you (ie. the responsible developer) have a new 
idea which interests you, users don't want to use it because they have 
something which works, so you take out the working driver to make work 
for the users and create what you call a "better new driver" below.

The old driver wasn't requiring any resources to maintain, the old 
hardware wasn't changing, there was no particular benefit to users in 
breaking their configuration. This disregard for the users just gives 
Linux critics an arguing point, "the next new kernel may withdraw 
support for your hardware." Isn't that why 2.6.16 is still being 
maintained? Nobody (sane) expects new drivers to be perfect, they just 
don't expect the working drivers to be disabled.

> For these people a new driver will often suck when the old driver gets 
> removed, but after the removal of the old driver they are finally forced 
> to report their bugs resulting in a better new driver for everyone.
> 
"Better" is a very subjective thing, you see elegance of design perhaps, 
I see works or not, and when I have to use statistical methods to see 
latency or CPU overhead benefits, I frankly don't care.

Removing a working driver without a fully functional replacement forces 
people to stop upgrading their kernel, or start maintaining old drivers 
out of line. Problems of the "just occasionally goes away" type can take 
months to debug, the load can't be duplicated in most cases, and there's 
no log or oops data to help.


> The sky2 driver is since nearly 2 years in the kernel and Stephen is 
> usually quite good at handling bugs.
> 
Where does sky2 come in? Does this mean the the recent suggestion to 
"just change to skge and stop complaining" is also wrong?

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
