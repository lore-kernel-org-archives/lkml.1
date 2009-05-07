Return-Path: <linux-kernel-owner+w=401wt.eu-S1759299AbZEGA4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299AbZEGA4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 20:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696AbZEGA41
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 20:56:27 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:49372 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753795AbZEGA41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 20:56:27 -0400
Message-ID: <4A0231E6.4090707@cn.fujitsu.com>
Date: Thu, 07 May 2009 08:57:10 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, fweisbec@gmail.com,
       rostedt@goodmis.org, zhaolei@cn.fujitsu.com, laijs@cn.fujitsu.com
Subject: Re: [PATCH v3] ftrace: add a tracepoint for __raise_softirq_irqoff()
References: <49FFDF9C.7040505@cn.fujitsu.com> <49FFE279.1030809@cn.fujitsu.com>
In-Reply-To: <49FFE279.1030809@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Li Zefan wrote:
>> +TRACE_EVENT(irq_softirq_raise,
> 
> I think 'softirq_raise' is better.
> 
>> +
>> +	TP_PROTO(unsigned int nr),
>> +
>> +	TP_ARGS(nr),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	unsigned int,	nr	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->nr	= nr;
>> +	),
>> +
>> +	TP_printk("softirq=%d action=%s is raised",
>> +		__entry->nr, softirq_to_name[__entry->nr])
> 
> "softirq=%d action=%s" is sufficient.
> 
> Please see TRACE_EVENT(softirq_entry) and TRACE_EVENT(softirq_exit).
> 

Thanks, I will modify it as your suggestions. ;-)

> 
>> +);
>> +


