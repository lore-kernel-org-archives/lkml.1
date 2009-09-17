Return-Path: <linux-kernel-owner+w=401wt.eu-S1757684AbZIQBYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757684AbZIQBYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 21:24:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754552AbZIQBYN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 21:24:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50047 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751931AbZIQBYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 21:24:13 -0400
Message-ID: <4AB18F8C.1060104@cn.fujitsu.com>
Date: Thu, 17 Sep 2009 09:23:24 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stop_machine: disable preempt in stop machine path
References: <4AB0933E.8020901@cn.fujitsu.com> <20090916160358.7faadb5f.akpm@linux-foundation.org>
In-Reply-To: <20090916160358.7faadb5f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Andrew Morton wrote:
> On Wed, 16 Sep 2009 15:26:54 +0800
> Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:
> 
>> We can disable preempt in stop_cpu(), It can reduce the cpu's waiting time
>> and make stop_machine path faster.
>>
> 
> "it can"?  But does it?  Are there any measurements or observations to
> back this up?
> 
> The kstop threads are already created with create_rt_workqueue() (which
> has super-secret undocumented semantics which I have cleverly
> discovered mean "use SCHED_FIFO").
> 

Ah, indeed, please ignore this mail, sorry for bother you all.

Thanks,
Xiao

> So we won't be getting preempted here anyway?
> 
> 
