Return-Path: <linux-kernel-owner+w=401wt.eu-S1765191AbXEWVEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765191AbXEWVEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 17:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755509AbXEWVE1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 17:04:27 -0400
Received: from cb2.northrockquote.com ([64.251.14.146]:1365 "EHLO
	dejavu.debianpt.org" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbXEWVE0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 17:04:26 -0400
Message-ID: <4654AC3E.906@debianpt.org>
Date: Wed, 23 May 2007 22:03:58 +0100
From: Miguel Figueiredo <elmig@debianpt.org>
Organization: DebianPT.org
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>
CC: Linux Kernel M/L <linux-kernel@vger.kernel.org>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
References: <464F57DD.2000309@tmr.com> <4650774F.9040208@debianpt.org> <2c0942db0705200944r19a37bd8pd7c220903084e4d3@mail.gmail.com> <46507E1D.6030002@debianpt.org> <46532E8A.4030900@tmr.com> <46534C31.1060306@debianpt.org> <46538AB8.8030009@tmr.com> <46543D3A.9030805@tmr.com> <46548806.4010601@debianpt.org> <4654A7F8.1040505@tmr.com>
In-Reply-To: <4654A7F8.1040505@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Davidsen wrote:
> Miguel Figueiredo wrote:
>> Bill Davidsen wrote:
>>> I was unable to reproduce the numbers Miguel generated, comments 
>>> below. The -ck2 patch seems to run nicely, although the memory 
>>> repopulation from swap would be most useful on system which have a 
>>> lot of memory pressure.
>>>
>>> I spent a few hours running the -ck2 patch, and I didn't see any 
>>> numbers like yours. What I did see is going up with my previous 
>>> results as http://www.tmr.com/~davidsen/sched_smooth_04.html. While 
>>> there were still some minor pauses in glxgears with my test, 
>>> performance was very similar to the sd-0.48 results. And I did try 
>>> watching video with high load, without problems. Only when I run a 
>>> lot of other screen-changing processes can I see pauses in the display.
>>>> Your subjective impressions would be helpful, and you may find that 
>>>> the package in the www.tmr.com/~public/source is slightly easier to 
>>>> use and gives more stable results. The documentation suggests the 
>>>> way to take samples (the way I did it) but if you feel more or 
>>>> longer samples would help it is tunable.
>>>>
>>>> I added Con to the cc list, he may have comments or suggestions 
>>>> (against the current versions, please). Or he may feel that video 
>>>> combined with other heavy screen updating is unrealistic or not his 
>>>> chosen load. I'm told the load is similar to games which use threads 
>>>> and do lots of independent action, if that's a reference.
>>>>
>>> I'll include the -ck2 patch in my testing on other hardware.
>>>
>>
>> Hi Bill,
>>
>>  the numbers i posted before are repeatable on that machine.
>>
> The numbers you posted in <46534C31.1060306@debianpt.org> are not the 
> same... From my inbox I grab some very non-matching values:
> =====
> Here's the funny part...
> 
> Lets call:
> 
> a) to "random number of processes run while glxgears is running", 
> gl_fairloops file
> 
> b) to "generated frames while running a burst of processes" aka "massive 
> and uknown amount of operations in one process", gl_gears file
> 
> kernel    2.6.21-cfs-v13    2.6.21-ck2
> a)    194464        254669       b)    54159        124
> =====
> 
> The numbers in your glitch1.html file show a close correlation for cfs 
> and -ck2, well within what I would expect. The stddev for the loops is 
> larger for -cf2, but not out of line with what I see, and nothing like 
> the numbers you originally sent me (which may have been testing 
> something else, or from an old version before I made improvements, or 
> ???). In any case thanks for testing.
> 
>>
>> I did run, again, glitch1 on my laptop (T2500 CoreDuo, also Nvidia) 
>> please check: http://www.debianpt.org/~elmig/pool/kernel/20070523/
>>
>>
> Thanks, those data seem as expected.
> 

These numbers are from a different machine (this has 2 cores).
The other machine it's Debian Unstable and this Debian stable.


-- 

Com os melhores cumprimentos/Best regards,

Miguel Figueiredo
http://www.DebianPT.org
