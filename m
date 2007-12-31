Return-Path: <linux-kernel-owner+w=401wt.eu-S1752113AbXLaRK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752113AbXLaRK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 12:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbXLaRKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 12:10:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41365 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750935AbXLaRKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 12:10:49 -0500
Message-ID: <47792295.8070001@sgi.com>
Date: Mon, 31 Dec 2007 09:10:45 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       tglx@linutronix.de, mingo@redhat.com, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 05/10] x86_64: Use generic percpu
References: <20071228001046.854702000@sgi.com> <20071228001047.556634000@sgi.com> <200712281354.52453.ak@suse.de> <47757311.5050503@sgi.com> <20071230141829.GA28415@elte.hu> <477916ED.8010602@sgi.com>
In-Reply-To: <477916ED.8010602@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Ingo Molnar wrote:
>> * Mike Travis <travis@sgi.com> wrote:
>>
>>>> Also for such changes .text size comparisons before/after are a good 
>>>> idea.
>>> x86_64-defconfig:
>>>
>>> pre-percpu                          post-percpu
>>>       159373 .init.text                       +3 .init.text
>>>      1411137 .rodata                          +8 .rodata
>>>      3629056 .text                           +48 .text
>>>      7057383 Total                           +59 Total
>> ok, that looks like really minimal impact, so i'm in favor of merging 
>> this into arch/x86 - and the unification it does later on is nice too.
>>
>> to get more test feedback: what would be the best way to get this tested 
>> in x86.git in a standalone way? Can i just pick up these 10 patches and 
>> remove all the non-x86 arch changes, and expect it to work - or are the 
>> other percpu preparatory/cleanup patches in -mm needed too?
>>
>> 	Ingo
> 
> I've tested some x86_64 configs but the UP model is currently broken so I
> haven't been able to test that. (the "fs/nfs/super.c" build problem with
> TASK_NORMAL and TASK_UNINTERRUPTIBLE undefined.)
> 
> Thanks,
> Mike

Sorry, I guess I didn't exactly answer the question.  Yes, these changes
are standalone. 

Thanks,
Mike
