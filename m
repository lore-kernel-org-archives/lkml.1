Return-Path: <linux-kernel-owner+w=401wt.eu-S1757297AbZF2BDs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757297AbZF2BDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 21:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbZF2BDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 21:03:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53650 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbZF2BDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 21:03:39 -0400
Message-ID: <4A4812F7.1010305@cn.fujitsu.com>
Date: Mon, 29 Jun 2009 09:03:51 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Steven Rostedt <rostedt@goodmis.org>, Zhaolei <zhaolei@cn.fujitsu.com>,
       kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] ftrace: add tracepoint for timer
References: <4A38B9C7.3080802@cn.fujitsu.com> <20090625050908.GB6071@nowhere>
In-Reply-To: <20090625050908.GB6071@nowhere>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Frederic Weisbecker wrote:
> On Wed, Jun 17, 2009 at 05:39:19PM +0800, Xiao Guangrong wrote:
>> This patch is modify from Mathieu's patch base on Ingo's suggestion, the
>> original patch can be found here:
>> 	http://marc.info/?l=linux-kernel&m=123791201816247&w=2
>>
>> Great thanks to Thomas for giving me so many valuable advices.
>>
>> Those tracepoints are wanted and useful:
>> 1: We can detect a timer's delay
>> 2: We can monitor the lifecycle and behaviors of a timer
>>
>> Thus they help in analysing and debuging.
>>
>> Example ftrace output:
>>    insmod-3743  [001] 217105.738770: timer_init: timer=e0b3e4c8
>>    insmod-3743  [001] 217105.738868: timer_start: timer=e0b3e4c8 func=timer_fun expires=442863 timeout=50
>>    <idle>-0     [001] 217105.935436: timer_expire: timer=e0b3e4c8 func=timer_fun jiffies=442863
>>    <idle>-0     [001] 217105.935440: timer_cancel: timer=e0b3e4c8 func=timer_fun
>>
>> We expect the timer expires at 442863, after 50 jiffies, actually the timer
>> expires at 442863, so it is delayed by 0 jiffies.
>>
>> Changelog v1->v2:
>> 1: Add jiffies info into timer
>> 2: Combine debugobjects and trace as Thomas's suggestion
>>  
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> 
> 
> Thomas, are you fine with these patches?
> If so, I can prepare a pull request to Ingo, unless he prefers to
> apply them himself.
> 

Hi Thomas,

What is your opinion on this patch?
Can I get your acked-by if you think this patch is useful for us?

Thanks,
Xiao

> Thanks,
> Frederic.
> 
> 
