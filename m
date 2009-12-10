Return-Path: <linux-kernel-owner+w=401wt.eu-S932827AbZLJF0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827AbZLJF0G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 00:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932780AbZLJF0F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 00:26:05 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62253 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932779AbZLJF0E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 00:26:04 -0500
Message-ID: <4B20860B.6070301@cn.fujitsu.com>
Date: Thu, 10 Dec 2009 13:24:27 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf_event: fix perf_swevent_hrtimer()
References: <4B2075B0.10805@cn.fujitsu.com> <1260422135.4165.3.camel@twins>
In-Reply-To: <1260422135.4165.3.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Peter Zijlstra wrote:
> On Thu, 2009-12-10 at 12:14 +0800, Xiao Guangrong wrote:
>> fix:
>>  [<c0477471>] ? printk+0x1d/0x24
>>  [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
>>  [<c0149231>] warn_slowpath_common+0x71/0xd0
>>  [<c01c98f9>] ? perf_prepare_sample+0x269/0x280
>>  [<c01492aa>] warn_slowpath_null+0x1a/0x20
>>  [<c01c98f9>] perf_prepare_sample+0x269/0x280
>>  [<c016e9f3>] ? cpu_clock+0x53/0x90
>>  [<c01cc368>] __perf_event_overflow+0x2a8/0x300
>>  [<c01ccc3b>] perf_event_overflow+0x1b/0x30
>>  [<c01ccccf>] perf_swevent_hrtimer+0x7f/0x120
>>
>> This is because 'data' variable not initialize.
> 
> Nope, please just initialize the missing variable. 

Ah, my mistake, I'll resend it.

Thanks,
Xiao

