Return-Path: <linux-kernel-owner+w=401wt.eu-S1756057AbZDOOfF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbZDOOfF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 10:35:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbZDOOex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 10:34:53 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:62429 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZDOOew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 10:34:52 -0400
Message-id: <49E5F07E.40704@acm.org>
Date: Wed, 15 Apr 2009 09:34:38 -0500
From: Corey Minyard <minyard@acm.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-version: 1.0
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       openipmi-developer@lists.sourceforge.net
Subject: Re: [PATCH 4/5] IPMI: Add console oops catcher
References: <20090303152123.GD7777@minyard.local>
 <20090303132046.a8975963.akpm@linux-foundation.org>
 <49ADC559.7040705@ct.jp.nec.com>
 <20090402141445.3a7a6504.akpm@linux-foundation.org>
 <49E58168.3090409@ct.jp.nec.com>
In-reply-to: <49E58168.3090409@ct.jp.nec.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Shimamoto wrote:
> Andrew Morton wrote:
>> On Tue, 03 Mar 2009 16:03:37 -0800
>> Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com> wrote:
>>
>>> ...
>>>> This reader is unable to determine what the mystery preempt_disable()
>>>> is here for.  It needs a comment, please.
>>> I cannot recall why it's here. So a comment is really needed.
>>> This preempt_disable() may not be needed.
>>>
>>>> What happens if two CPUs oops at the same time (which is fairly 
>>>> common)?
>>> ...
>>>
>>> OK. I'll look at this.
>>>
>>>> It would be prudent to have a timeout in this loop.  The machine has
>>>> crashed and subsystems and hardware and memory are in an unknown and
>>>> possibly bad state.
>>> Right.
>>>
>>> ...
>>>
>>>> This looks like we're abusing the "unblank" method.
>>>>
>>>> If you think that the console subsystem is missing some capability
>>>> which this driver needs then please do prefer to fix the console
>>>> subsystem, rather than awkwardly making things fit.
>>> OK. Will take a look about this point.
>>>
>>
>> None of this happened.
>>
>> It makes me reluctant to merge that patches as they stand, because then
>> it all gets forgotten about, whereas holding the patches back will
>> remind us that updates are needed.
>
> Sorry for late reply.
> I couldn't have time for this patch.
> I'll look at this again and will resend updates.
Andrew, can we drop this for now and at get the other patches in?  At 
least the first one ("Fix platform return check"), since it's an obvious 
bug fix.

Thanks,

-corey

>
> Thanks,
> Hiroshi
>

