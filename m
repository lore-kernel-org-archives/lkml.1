Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbZJLKSt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbZJLKSt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:18:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755427AbZJLKSs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:18:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56036 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZJLKSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:18:47 -0400
Date: Mon, 12 Oct 2009 12:17:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: rostedt@goodmis.org, Jason Baron <jbaron@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: system gets stuck in a lock during boot
Message-ID: <20091012101746.GC15777@elte.hu>
References: <1254880921.1696.112.camel@gandalf.stny.rr.com> <4ACC001D.4050105@gmail.com> <1254920429.1696.127.camel@gandalf.stny.rr.com> <4ACCAB54.4010408@gmail.com> <1254928298.1696.166.camel@gandalf.stny.rr.com> <4ACCB934.7070805@gmail.com> <1254931582.1696.171.camel@gandalf.stny.rr.com> <4ACCE1BA.5000307@gmail.com> <1254941730.1696.177.camel@gandalf.stny.rr.com> <4ACCE72B.3010906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ACCE72B.3010906@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0002]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Justin P. Mattock <justinmattock@gmail.com> wrote:

> Steven Rostedt wrote:
>> On Wed, 2009-10-07 at 11:45 -0700, Justin P. Mattock wrote:
>>
>>    
>>>>
>>>>        
>>> yep like I said I owe you guys an apology, for
>>> my mistake(thanks for taking the time).
>>>      
>>
>> Well, thank you for reporting it. If nobody reports any problems, we
>> just assume everything is OK, and as people curse us out and look for
>> alternatives, we will be sipping our mai-tais in ignorant bliss.
>>
>> -- Steve
>>
>>    
>
> agree, my main concern when reporting is to make sure that it's a real 
> issue, and not a mistake like this one.

Well, it can be really hard to filter out whether a problem is somehow 
self-inflicted or caused by the kernel proper - thus we generally prefer 
over-reporting over under-reporting.

Even if it's self-inflicted it's useful on a meta level: if many people 
report it then we might end up adding more safety guards to disable a 
particular common pattern of shoot-foot-self incidents.

	Ingo
