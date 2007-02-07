Return-Path: <linux-kernel-owner+w=401wt.eu-S1161147AbXBGK0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161147AbXBGK0u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 05:26:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161148AbXBGK0u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 05:26:50 -0500
Received: from smtp8-g19.free.fr ([212.27.42.65]:55772 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161147AbXBGK0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 05:26:49 -0500
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Feb 2007 05:26:49 EST
Message-ID: <45C9A8FE.3090705@free.fr>
Date: Wed, 07 Feb 2007 11:25:02 +0100
From: John <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, tglx@timesys.com, mingo@elte.hu,
       johnstul@us.ibm.com, akpm@osdl.org, linux.kernel@free.fr
Subject: Re: One-shot high-resolution POSIX timer periodically late
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>	 <fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>	 <fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>	 <fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>	 <fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>	 <fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>  <45C75D2D.9010506@free.fr> <1170747081.4672.11.camel@twins>
In-Reply-To: <1170747081.4672.11.camel@twins>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:

> John wrote:
>
>> Ingo Molnar wrote:
>>
>>> John wrote:
>>>
>>>> John Stultz wrote:
>>>>
>>>>> Also do check the -rt tree as Ingo suggested. I mis-read your earlier
>>>>> email and thought you were running it.
>>>>
>>>> I've been pulling my hair over a related issue for the past two days.
>>>>
>>>> (I think I may be tickling a -hrt bug...)
>>>>
>>>> I'm working with 2.6.18.6 + patch-2.6.18-rt7
>>>
>>> 2.6.18-rt7 is pretty old, do you see the problem in 2.6.20-rc6-rt5 too?
>>
>> Ingo, Thomas,
>>
>> As far as I can tell, the -rt patch set is only updated for the latest 
>> kernel version available. Is that correct?
>>
>> http://people.redhat.com/mingo/realtime-preempt/older/?M=D
>>
>> In other words, once 2.6.20 is released, and work starts on 2.6.21, if a 
>> bug is discovered in -rt, the fix will not be back-ported to the 
>> 2.6.20.x (and 2.6.19.x, and 2.6.18.x, etc) patch set?
> 
> Correct, there is only 1 live branch.

Are there people that use the -rt patch set in real industrial applications?

It seems that, if an important bug is found in the -rt part, I will have 
to either upgrade to the latest kernel, or back port all the -rt changes 
to the kernel I chose for my application?

Regards,

John

