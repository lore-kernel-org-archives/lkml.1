Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZJLSRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZJLSRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 14:17:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757472AbZJLSRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 14:17:10 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:40676 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255AbZJLSRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 14:17:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=NTn2hNw0UVCU1KL8KJhyc2cMKKUis8YpIT4UHz2OQ8iIFUQmF1gSHGejUFRTWTxBoP
         R2WEzo6ysbfDZP4Wd4JIJhrB5aq2Fkc5dZf0SCffWeqPAFgtUuVghXN0dkhoD726X+PO
         HkuUFqas4aITWf6kQz4Xd6KfSC4gAt+CxNTTQ=
Message-ID: <4AD37285.6060904@gmail.com>
Date: Mon, 12 Oct 2009 11:16:37 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Spicebird/0.7.1 (X11; 2009022519)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
References: <1254880921.1696.112.camel@gandalf.stny.rr.com> <4ACC001D.4050105@gmail.com> <1254920429.1696.127.camel@gandalf.stny.rr.com> <4ACCAB54.4010408@gmail.com> <1254928298.1696.166.camel@gandalf.stny.rr.com> <4ACCB934.7070805@gmail.com> <1254931582.1696.171.camel@gandalf.stny.rr.com> <4ACCE1BA.5000307@gmail.com> <1254941730.1696.177.camel@gandalf.stny.rr.com> <4ACCE72B.3010906@gmail.com> <20091012101746.GC15777@elte.hu>
In-Reply-To: <20091012101746.GC15777@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>    
>> Steven Rostedt wrote:
>>      
>>> On Wed, 2009-10-07 at 11:45 -0700, Justin P. Mattock wrote:
>>>
>>>
>>>        
>>>>>
>>>>>            
>>>> yep like I said I owe you guys an apology, for
>>>> my mistake(thanks for taking the time).
>>>>
>>>>          
>>> Well, thank you for reporting it. If nobody reports any problems, we
>>> just assume everything is OK, and as people curse us out and look for
>>> alternatives, we will be sipping our mai-tais in ignorant bliss.
>>>
>>> -- Steve
>>>
>>>
>>>        
>> agree, my main concern when reporting is to make sure that it's a real
>> issue, and not a mistake like this one.
>>      
>
> Well, it can be really hard to filter out whether a problem is somehow
> self-inflicted or caused by the kernel proper - thus we generally prefer
> over-reporting over under-reporting.
>
> Even if it's self-inflicted it's useful on a meta level: if many people
> report it then we might end up adding more safety guards to disable a
> particular common pattern of shoot-foot-self incidents.
>
> 	Ingo
>
>    
CONFIG_INGO=y

Thanks man, yeah I agree the more over reporting the better.
but in this case  I did shoot myself in the foot(not by choice though).
In any case I really appreciate all of you guys
taking the time to look at this. I will try and be more careful the
next time in reporting.

Justin P. Mattock

