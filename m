Return-Path: <linux-kernel-owner+w=401wt.eu-S1755268Ab0ASHjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0ASHjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 02:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753487Ab0ASHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 02:39:00 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54805 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0ASHi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 02:38:58 -0500
Message-ID: <4B556118.7020502@cn.fujitsu.com>
Date: Tue, 19 Jan 2010 15:36:56 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] perf_event: fix race in perf_swevent_get_recursion_context()
References: <4B54654A.4090601@cn.fujitsu.com> <1263822958.4283.560.camel@laptop>
In-Reply-To: <1263822958.4283.560.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
> On Mon, 2010-01-18 at 21:42 +0800, Xiao Guangrong wrote:
>> It only disable preemption in perf_swevent_get_recursion_context()
>> it can't avoid race of hard-irq and NMI
>>
>> In this patch, we use atomic operation to avoid it and reduce
>> cpu_ctx->recursion size, it also make this patch no need diable
>> preemption
> 
> Uhm why?
> 
> This patch looks terminally broken

Please see my explanation in another mail:
http://lkml.org/lkml/2010/1/18/501

Thanks,
Xiao
