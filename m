Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbYJVRZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbYJVRZr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 13:25:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbYJVRZg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 13:25:36 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:19171 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbYJVRZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 13:25:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gOgC0iwN4VB5Sqaj3SJbl+rHd/HNQ4SPTxWi7LnwgiiHZM4Zq+d1nyMTwB2IZ9p4jv
         RmIiZfkLV9mXd25AaS9ykW7SMI0AGUZohFMeaWpyzwK3KslggrL4yJGvX8v8758c3fe8
         dcWWz+LT51vx2l10c/IPfAqJ4XrJyHrcQnYYM=
Message-ID: <48FF620A.9040506@gmail.com>
Date: Wed, 22 Oct 2008 20:25:30 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, sandmann@daimi.au.dk,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 4/4] Implement semaphore latency tracer
References: <1223817124-27239-1-git-send-email-edwintorok@gmail.com>	 <1223817124-27239-6-git-send-email-edwintorok@gmail.com>	 <1223838786.8634.8.camel@lappy.programming.kicks-ass.net>	 <48F259A7.2030800@gmail.com> <20081022152842.GI23060@elte.hu>	 <48FF49BD.8000608@gmail.com>  <20081022154851.GL23060@elte.hu> <1224696137.20069.6.camel@twins>
In-Reply-To: <1224696137.20069.6.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-10-22 20:22, Peter Zijlstra wrote:
> On Wed, 2008-10-22 at 17:48 +0200, Ingo Molnar wrote:
>   
>> * Török Edwin <edwintorok@gmail.com> wrote:
>>
>>     
>>> On 2008-10-22 18:28, Ingo Molnar wrote:
>>>       
>>>> hm, but the most common synchronization primitive are mutexes - and 
>>>> those are not covered by your patchset.
>>>>   
>>>>         
>>> Indeed. I've seen a patch from Jason Baron to introduce tracepoints 
>>> for mutexes, but the conclusion was that the tracepoints should be in 
>>> lockstat instead.
>>>
>>> And if lockstat is enabled Peter Zijlstra's 'contend with points' 
>>> patch seems to do exactly what I want to.
>>>
>>> However I think it would be useful to have (a tracepoints based?) 
>>> latency tracker, which can be enabled/disabled at runtime, and which 
>>> doesn't add any data to the mutex/semaphore structures. My patchset 
>>> was a first attempt towards that, but it seems that such use of 
>>> tracepoints is not welcome at this time?
>>>
>>> Please tell me if I should continue working on this, or if I my 
>>> patches are designed totally on the wrong way.
>>>       
>> i think if you hook into Peter's lockstat APIs that should give us a 
>> pretty good tracer, with no ugliness introduced. That would be rather 
>> interesting. Peter, do you concur?
>>     
>
> Yes, I've already suggested this. Use the exact same hooks that
> lockdep/lockstat use.

Ok, I'll work on this when I get some time :)
[hopefully this weekend test the 'contend with points patch', next
weekend write the new tracepoints]

Best regards,
--Edwin
