Return-Path: <linux-kernel-owner+w=401wt.eu-S1751978AbZH0SA6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978AbZH0SA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 14:00:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbZH0SA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 14:00:57 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:47033 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbZH0SA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 14:00:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WpejP5gnREFq6vGBXDbbw8otju/BaCcLsBQSwdWu8sbzGFz49g41QIKOjTIafSbTyN
         XSeMiK0ojFRt45Oxml6gEpqwkbWIKPtGddMVIc9v7C3oh4b2quC7KMRBGXwMGPeG83aQ
         cShrdx0yer4DWXSRNjx+kLsuTDfLiUEXMokGU=
Message-ID: <4A96CA0A.90405@gmail.com>
Date: Thu, 27 Aug 2009 11:01:46 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009031304)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #14012] latest git fried my x86_64 imac
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.NXH.BtGlKB@chimera> <4A9481B9.3070607@gmail.com> <200908262306.38464.rjw@sisk.pl>
In-Reply-To: <200908262306.38464.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Wednesday 26 August 2009, Justin P. Mattock wrote:
>    
>> Rafael J. Wysocki wrote:
>>      
>>> This message has been generated automatically as a part of a report
>>> of recent regressions.
>>>
>>> The following bug entry is on the current list of known regressions
>>> from 2.6.30.  Please verify if it still should be listed and let me know
>>> (either way).
>>>
>>>
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14012
>>> Subject		: latest git fried my x86_64 imac
>>> Submitter	: Justin P. Mattock<justinmattock@gmail.com>
>>> Date		: 2009-08-13 07:20 (13 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=125014080427090&w=4
>>>
>>>
>>>
>>>
>>>        
>> if I revert this commit:
>> af6af30c0fcd77e621638e53ef8b176bca8bd3b4
>> I can get a normal bootup.
>>      
>
> Hm, that's
>
> commit af6af30c0fcd77e621638e53ef8b176bca8bd3b4
> Author: Peter Zijlstra<peterz@infradead.org>
> Date:   Wed Aug 5 20:41:04 2009 +0200
>
>      ftrace: Fix perf-tracepoint OOPS
>
> I wonder what happens if you compile out ftrace?
>
>    
>> As for this  bug, it seems I'm the only
>> hitting this. The system is a fresh LFS build
>> x86_64.
>> In regards to keeping this open
>> not sure, I don't have a problem with closing this
>> and taking the blame as something I did during my build
>> of the system, then if this becomes more frequent
>> then open a new bug.
>>      
>
> OK, I'll close it for now.
>
> Thanks,
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>    
o.k. I tried disabling all of ftrace in the kernel,
unfortunately the only one left
is HAVE_FTRACE_SYSCALLS
which seems to be selected by x86.
seems the system still sticks
without reverting perf-tracepoint oops.

Justin P. Mattock

