Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbZHZV5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbZHZV5O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 17:57:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZHZV5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 17:57:12 -0400
Received: from mail-px0-f174.google.com ([209.85.216.174]:52179 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968AbZHZV5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 17:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=pApxjhuYojMUQysw+mcVysnRzQuXsJzTEFo1SwLt7yjITWVDRMMDp++oTMxz7Z9JMt
         tcDOm/hW6WDxUa/Pu1DXMK0rNQ5F88U192NZxBw8nEzL8rW9WMjcH8Dw6BLVdlvaVlyJ
         Fna/qbqptEX94Qx+6Xn/8K0A1eUPFGQuqy/tQ=
Message-ID: <4A95AFEB.10809@gmail.com>
Date: Wed, 26 Aug 2009 14:58:03 -0700
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
Ill give that a try and see.

Justin P. Mattock
