Return-Path: <linux-kernel-owner+w=401wt.eu-S1758519AbXGIRZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758519AbXGIRZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754213AbXGIRZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:25:39 -0400
Received: from mail.tmr.com ([64.65.253.246]:34917 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754479AbXGIRZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:25:38 -0400
Message-ID: <4692701B.3030506@tmr.com>
Date: Mon, 09 Jul 2007 13:27:55 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Kok, Auke" <auke-jan.h.kok@intel.com>, jgarzik@pobox.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org, saw@saw.sw.com.sg,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [2.6 patch] the overdue eepro100 removal
References: <20070701202139.GM10869@stusta.de> <46894BD5.9080609@tmr.com> <46897212.30104@intel.com> <468D15F4.6020106@tmr.com> <20070709125208.GZ3492@stusta.de>
In-Reply-To: <20070709125208.GZ3492@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> On Thu, Jul 05, 2007 at 12:01:56PM -0400, Bill Davidsen wrote:
>   
>> Please do not make unnecessary kernel changes which require changes in our 
>> systems.
>>     

>> If you think the e100 driver fixes your problems use it and be happy. But 
>> since you don't have to test system behavior with the new driver, and you 
>> won't be called at night or on weekends if it doesn't work, do the rest of 
>> the world a favor and stop taking out things we know to work! Leaving in 
>> the eepro100 causes no work for you, and even if e100 works perfectly it 
>> needs to be validated in any sane network. it still makes work.
>>     
>
> The goal is to get e100 better, and removing eepro100 helps with 
> reaching this goal.
>
>   
That's *your* goal, it should not be a shock that users have a goal of 
using their systems without having to reconfigure them every time 
there's a kernel upgrade containing a security fix.
> Why didn't _you_ try the e100 driver when you validated your systems 
> after you upgraded them to kernel 2.6, and if you did and it didn't 
> work, where is your bug report?
>   
Is that a joke, or subtle irony? Do you generally validate drivers you 
don't use just because your hardware might be able to support them? I 
don't validate various accelerated video drivers on systems running 
mostly text console, never check sound options on systems with an audio 
application, etc. After I tried the e100 driver on the first few systems 
and found issues (which may be resolved by now) I went back to eepro100 
and used what worked. And used the driver for any new systems in other 
installs.

If there were any benefit to removing a working driver I would at least 
be able to see it as a resources issue, but as far as I can see you just 
seem to have a personal preference for the e100 driver and want to force 
others to use it because you are so much better able to decide what 
users need than the system administrators. That's one of the reasons 
people choose open source, because they have a choice, and can use 
what's best for them.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

