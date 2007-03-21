Return-Path: <linux-kernel-owner+w=401wt.eu-S933946AbXCUXsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933946AbXCUXsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 19:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934013AbXCUXst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 19:48:49 -0400
Received: from Mail.MNSU.EDU ([134.29.1.12]:46987 "EHLO mail.mnsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933946AbXCUXst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 19:48:49 -0400
Message-ID: <4601C44B.9060705@mnsu.edu>
Date: Wed, 21 Mar 2007 18:48:27 -0500
From: Jeffrey Hundstad <jeffrey.hundstad@mnsu.edu>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Artur Skawina <art_k@o2.pl>
CC: Con Kolivas <kernel@kolivas.org>,
       linux list <linux-kernel@vger.kernel.org>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] sched: rsdl improvements
References: <200703220429.45311.kernel@kolivas.org> <4601BF45.7070708@o2.pl>
In-Reply-To: <4601BF45.7070708@o2.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Artur Skawina wrote:
> Con Kolivas wrote:
>   
>> Note no interactive boost idea here.
>>
>> Patch is for 2.6.21-rc4-mm1. I have not spent the time trying to bring other
>> bases in sync.
>>     
>
> I've tried RSDLv.31+this on 2.6.20.3 as i'm not tracking -mm.
>
>   
>> Further improve the deterministic nature of the RSDL cpu scheduler and make
>> the rr_interval tunable.
>>
>> By only giving out priority slots to tasks at the current runqueue's
>> prio_level or below we can make the cpu allocation not altered by accounting
>> issues across major_rotation periods. This makes the cpu allocation and
>> latencies more deterministic, and decreases maximum latencies substantially.
>> This change removes the possibility that tasks can get bursts of cpu activity
>> which can favour towards interactive tasks but also favour towards cpu bound
>> tasks which happen to wait on other activity (such as I/O) and is a net
>> gain.
>>     
>
> I'm not sure this is going in the right direction... I'm writing
> this while compiling a kernel w/ "nice -20 make -j2" and X is almost
>   
Did you mean "nice -20"?  If so, that should have slowed X quite a bit.  
Try "nice 19" instead.

nice(1):
       Run  COMMAND  with an adjusted niceness, which affects process 
scheduling.  With no COMMAND, print the current  niceness.   Nicenesses  
range from -20 (most favorable scheduling) to 19 (least favorable).


