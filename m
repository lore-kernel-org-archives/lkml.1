Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbXGKRQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbXGKRQH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751490AbXGKRPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:15:55 -0400
Received: from main.gmane.org ([80.91.229.2]:56210 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbXGKRPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:15:54 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: SATA exceptions
Date: Wed, 11 Jul 2007 13:20:15 -0400
Message-ID: <4695114F.1010206@tmr.com>
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <fa.NhBdOmH9+RkW+QO72+TjPRwEKj0@ifi.uio.no> <468FD5ED.5060401@shaw.ca> <200707080035.05718.caglar@pardus.org.tr> <46928066.7000705@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
X-Complaints-To: usenet@sea.gmane.org
Cc: caglar@pardus.org.tr, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
X-Gmane-NNTP-Posting-Host: pool-70-109-119-137.alb.east.verizon.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
In-Reply-To: <46928066.7000705@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> S.Çağlar Onur wrote:
>> 07 Tem 2007 Cts tarihinde, Robert Hancock şunları yazmıştı: 
>>> It's not the free space on the drive that matters, it's the number of
>>> free sectors in the spare sector pool on the drive, which is invisible
>>> to software.
>>>
>>> Your SMART log shows 309 reallocated sectors. That seems somewhat high..
>> Ah sorry to misinterpret the content:), its a quiet new piece of hardware (at 
>> most ~1.5 month old) and  "Reallocated_Event_Count" constantly increases 
>> (currently its increased to 313) and although i'm not 100 percent sure these 
>> errors only occured with kernels > 2.6.18 (or 2.6.18 didn't report these 
>> cause according to kern.log these only visible with 2.6.22+) 
> 
> OS and driver can't really do much about the reallocation event.  Some
> number of reallocations is okay but if you it going up constantly, you
> probably have a dying disk.
> 
Or, as I learned the hard way, if you have the problem on all drives 
sharing a power supply, a power issue.

>> We bought 3 HP Pavillon dv2385ea and one of them only runs with 2.6.18 and its 
>> smartctl output follows as a reference;
>>
>>   5 Reallocated_Sector_Ct   0x0033   253   253   010    Pre-fail  
>> 196 Reallocated_Event_Count 0x0032   253   253   000    Old_age   
> 
> Hmm... This is pretty high too.  Do the counts increase on this machine too?
> 


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot

