Return-Path: <linux-kernel-owner+w=401wt.eu-S1754598AbXLHVjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754598AbXLHVjU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 16:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbXLHVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 16:39:09 -0500
Received: from ns1.primeinteractive.net ([195.95.205.253]:49889 "EHLO
	mail.primeinteractive.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbXLHVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 16:39:07 -0500
X-Quarantine-ID: <B-KiX8EXTqHc>
Message-ID: <475B0EED.60708@primeinteractive.net>
Date: Sat, 08 Dec 2007 22:38:53 +0100
From: Pavol Cvengros <pavol.cvengros@primeinteractive.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: ICH9 & Core2 Duo - kernel crash
References: <200712041331.24678.pavol.cvengros@primeinteractive.net> <47585879.7010305@tmr.com> <200712070701.55283.pavol.cvengros@primeinteractive.net> <47598E1B.7010907@tmr.com> <47599734.1030505@primeinteractive.net> <475AC72B.1070508@tmr.com>
In-Reply-To: <475AC72B.1070508@tmr.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Pavol Cvengros wrote:
>> Bill Davidsen wrote:
>>> Pavol Cvengros wrote:
>>>> On Thursday 06 December 2007 21:15:53 Bill Davidsen wrote:
>>>>  
>>>>> Pavol Cvengros wrote:
>>>>>  
>>>>>> Hello,
>>>>>>
>>>>>> I am trying LKML to get some help on one linux kernel related 
>>>>>> problem.
>>>>>> Lately we got a machine with new HW from Intel. CPU is Intel 
>>>>>> Core2 Duo
>>>>>> E6850 3GHz with 2GB of RAM. Motherboard is Intel DG33BU with G33 
>>>>>> chipset.
>>>>>>
>>>>>> After long fight with kernel crashes on different things, we 
>>>>>> figured out
>>>>>> that if the multicore is disabled in bios, everything is ok and 
>>>>>> machine
>>>>>> is running good. No kernel crashes no problems, but with one core 
>>>>>> only.
>>>>>>
>>>>>> This small table will maybe explain:
>>>>>>
>>>>>> Cores   -     kernel   -   state
>>>>>>    2  -   nonsmp or smp  - crash
>>>>>>    1  -  smp or nonsmp  - ok
>>>>>>
>>>>>> All crashes have been different (swaper, rcu, irq, init.....) or 
>>>>>> we just
>>>>>> got internal gcc compiler error while compiling kernel/glibc/.... 
>>>>>> and the
>>>>>> machine was frozen.
>>>>>>
>>>>>> Please can somebody advise what to do to identify that problem more
>>>>>> precisely. (debug kernel options?)
>>>>>>
>>>>>> Our immpresion - ICH9 & ICH9R support in kernel is bad... sorry 
>>>>>> to say..
>>>>>>       
>>>>> I have seen unusual memory behavior under heavy load, in the cases 
>>>>> I saw
>>>>> it was heavy DMA load from multiple SCSI controllers, and one case 
>>>>> with
>>>>> FFT on the CPU and heavy network load with gigE. Have you run 
>>>>> memtest on
>>>>> this hardware? Just a thought, but I see people running Linux on that
>>>>> chipset, if not that particular board.
>>>>>
>>>>> A cheap test even if it shows nothing. Of course it could be a CPU 
>>>>> cache
>>>>> issue in that one CPU, although that's unlikely.
>>>>>     
>>>>
>>>> yes, memtest was running all his tests without problems. The wierd 
>>>> thing is that all kernel crashes we have seen were different (as 
>>>> stated in original mail)....
>>>>
>>>>   
>>> The problem with memtest, unless I underestimate it, is that it 
>>> doesn't use all core and siblings, so it doesn't quite load the 
>>> memory system the way regular usage would. Needless to say, if this 
>>> does turn out to be a memory loading issue I don't know of any tools 
>>> to really test it. I fall back on part swapping, but that only helps 
>>> if it's the memory DIMM itself.
>>>
>>
>> right now that machine has 2 x 1GB DDR2 - 800MHz.... do you think I 
>> should test the machine with only one DDR? (I hope to put there 4GB 
>> all together)
>>
> Well, odd memory problems are rare, did you look for a BIOS update? It 
> could be that the chipset isn't being set properly, and would explain 
> why it might work differently with another BIOS. But if there's 
> nothing else to try, it won't hurt to see if it works differently with 
> only one DDR.
>
original BIOS and the latest BIOS tested, doesn't work.... I will try 
latest kernels and just one DDR

