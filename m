Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbXIJMup@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbXIJMup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 08:50:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757351AbXIJMuh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 08:50:37 -0400
Received: from il.qumranet.com ([82.166.9.18]:57017 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753137AbXIJMuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 08:50:37 -0400
Message-ID: <46E53D96.4050409@qumranet.com>
Date: Mon, 10 Sep 2007 15:50:30 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND][PATCH 0/4] Virtual Machine Time Accounting
References: <46E5325D.1020902@bull.net> <20070910120758.GA26835@elte.hu>
In-Reply-To: <20070910120758.GA26835@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Laurent Vivier <Laurent.Vivier@bull.net> wrote:
>
>   
>> Ingo, please, could you have a look to these patches ?
>>
>> The aim of these four patches is to introduce Virtual Machine time 
>> accounting.
>>
>> [PATCH 1/4] as recent CPUs introduce a third running state, after 
>> "user" and "system", we need a new field, "guest", in cpustat to store 
>> the time used by the CPU to run virtual CPU. Modify /proc/stat to 
>> display this new field.
>>     
>
> the concept certainly looks sane to me.
>
> The heavy-handed use of #ifdefs uglifies the code to a large degree, but 
> this is not a fundamental problem: since basically all distros have KVM 
> enabled (and lguest benefits from this too), could you just make all 
> this new code unconditional?
>   

I imagine the embedded people will complain... perhaps move all the code 
to a #ifdef section above with a full implementation and a stub 
implementation.

-- 
error compiling committee.c: too many arguments to function

