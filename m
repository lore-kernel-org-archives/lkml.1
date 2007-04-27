Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbXD0UXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbXD0UXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 16:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757199AbXD0UXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 16:23:18 -0400
Received: from smtpout09-04.prod.mesa1.secureserver.net ([64.202.165.17]:53610
	"HELO smtpout09.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1757198AbXD0UXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 16:23:17 -0400
Message-ID: <46325BB1.2090904@seclark.us>
Date: Fri, 27 Apr 2007 16:23:13 -0400
From: Stephen Clark <Stephen.Clark@seclark.us>
Reply-To: Stephen.Clark@seclark.us
User-Agent: Mozilla/5.0 (X11; U; Linux 2.2.16-22smp i686; en-US; m18) Gecko/20010110 Netscape6/6.5
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <20070426165950.GO3468@stusta.de> <20070426215015.003f6196@the-village.bc.nu> <20070427145805.GT3468@stusta.de> <20070427163143.GG24852@thunk.org> <20070427194605.GV3468@stusta.de>
In-Reply-To: <20070427194605.GV3468@stusta.de>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:

>On Fri, Apr 27, 2007 at 12:31:43PM -0400, Theodore Tso wrote:
>  
>
>>On Fri, Apr 27, 2007 at 04:58:05PM +0200, Adrian Bunk wrote:
>>    
>>
>>>"no regressions" is definitely not feasible.
>>>
>>>14 known regressions, some of them not yet debugged at all, are 
>>>different from your "some small regression".
>>>      
>>>
>>Yes, but when were some of these regressions reported?  Past a certain
>>point, I think it's reasonable to look at the regression, decide how
>>many people would be affected by it, and why it hadn't been noticed
>>earlier, and in some cases, decide that it's better to get this
>>debugged and fixed in the stable and development trees in parallel.
>>    
>>
>
>8 of them have been reported in March or earlier. [1]
>
>Patches for 2 of these 8 were available at the time of the release. [2]
>While the question whether to merge one of them into 2.6.21 was 
>controversial, the other one was not controversial.
>
>For one of the bugs, it became obvious when someone looked at it after 
>the release of 2.6.21 that between the bug report on March 31th and the 
>release of 2.6.21 on April 21th, noone started debugging this bug. [3] [4]
>
>  
>
>>>And look e.g. at the many (and non-trivial) changes between -rc7 and 
>>>-final, resulting in more than one report from people who were running 
>>>-rc7 without problems - and 2.6.21 doesn't work for them.
>>>      
>>>
>>I agree that's unfortunate.
>>
>>    
>>
>>>It's not a choice between "regressions don't matter" and "no regressions",
>>>it's about the place in the area between these two extremes. I have my 
>>>opinions on what I want to expect from a stable Linux kernel, and other 
>>>people have different opinins.
>>>      
>>>
>>Everyone is going to disagree to some extent; and their own comfort
>>zone.  So a certain amount compromise is always going to be necessary.
>>Of course, it's up to you decide whether this has gone beyond the zone
>>where you aren't comfortable working with other people's development
>>style.
>>
>>Regards,
>>
>>					- Ted
>>    
>>
>
>cu
>Adrian
>
>[1] http://lkml.org/lkml/2007/4/26/2
>[2] http://lkml.org/lkml/2007/4/25/496
>[3] http://lkml.org/lkml/2007/4/26/496
>[4] and although it turned out this specific regression was already 
>    fixed in 2.6.21, I hope you get my point
>
>  
>
What Adrian was doing, or anybody in the future, is not going to be 
productive unless
Linus holds the people who are responsible for the bug to get it fixed 
or report why they
can't.

My $.02
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)



