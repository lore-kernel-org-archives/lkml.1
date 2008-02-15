Return-Path: <linux-kernel-owner+w=401wt.eu-S1761355AbYBOW3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761355AbYBOW3L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:29:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760318AbYBOW2w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:28:52 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:46990 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760305AbYBOW2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:28:51 -0500
Date: Sat, 16 Feb 2008 00:28:30 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Driver removals
Message-ID: <20080215222830.GA9962@cs181133002.pp.htv.fi>
References: <fp08q7$jv0$1@ger.gmane.org> <20080214082547.GJ12383@cs181133002.pp.htv.fi> <47B5E2FD.9060908@tmr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <47B5E2FD.9060908@tmr.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 02:07:41PM -0500, Bill Davidsen wrote:
> Adrian Bunk wrote:
>> On Wed, Feb 13, 2008 at 09:26:26PM -0500, Bill Davidsen wrote:
>>> ...
>>> In general, if a driver works and is being used, until it *needs*   
>>> attention I see no reason to replace it. I don't agree that "it 
>>> forces  people to try the new driver" is a valid reason, being 
>>> unmaintained is  only a problem if it needs maintenance. I am not 
>>> going to reopen that  topic, I'm simply noting a general opposition 
>>> to unfunded mandates, and  requiring changes to kernel, module and/or 
>>> rc.local config is just that.
>>
>> Keeping a working unmaintained driver in the tree is not a big deal - 
>> we have hundreds of them.
>>
>> But you miss the main point that removal of an obsolete driver with a  
>> new replacement driver forces people to finally report their problems  
>> with the new driver, thus making the new driver better.
>>
> You sure are proud of that new driver! People won't use it because the  
> old one is working fine, so you think it's fine to force them to make  
> changes in their system to use the new driver.

Sometimes what is best in the global picture is not what everyone
subjectively considers to be the best thing for him.

Well, our whole society is based on this principle...

> Best case is it works  
> after costing the user some time, worst case it doesn't and breaks their  
> system, so they stop upgrading the kernel and don't get security fixes.
>...

Instead of sending a bug report?

When removing an obsolete driver adult people suddenly start whining
"the new driver didn't work for me when I tried it one year ago".

And when asking where they reported the bug in the new driver the answer 
is that they didn't report it.

Driver development heavily relies on getting bug reports when something 
doesn't work.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

