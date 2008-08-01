Return-Path: <linux-kernel-owner+w=401wt.eu-S1757836AbYHAChq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757836AbYHAChq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 22:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753424AbYHAChX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 22:37:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53195 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752793AbYHAChV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 22:37:21 -0400
Message-ID: <4892765F.5020401@cn.fujitsu.com>
Date: Fri, 01 Aug 2008 10:35:11 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VolanoMark regression with 2.6.27-rc1
References: <1217474425.25608.150.camel@ymzhang>	 <1217489463.25608.157.camel@ymzhang>  <1217489949.8157.78.camel@twins>	 <1217490560.25608.168.camel@ymzhang> <1217551154.25608.169.camel@ymzhang>
In-Reply-To: <1217551154.25608.169.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2008-8-1 8:39 Zhang, Yanmin wrote:
[snip]
>> The regression I reported exists on:
>> 1) 8-core+HT(totally 16 logical processor) tulsa: 40% regression with volano, 8% with oltp;
>> 2) 8-core+HT Montvale Itanium: 9% regression with volano; 8% with oltp;
>> 3) 16-core tigerton: %70 with volano, %18 with oltp;
>> 4) 8-core stoakley: %15 with oltp, testing failed with volanoMark.
>>
>> So the issues are popular on different architectures.
> I know kernel needs the features and it might not be a good idea to reject them over and over again.
> I will collect more data on tigerton and try to optimize it.

Could you tell me the exact config options? the same with last time?

as follows:

# CONFIG_CGROUPS is not set
CONFIG_GROUP_SCHED=y
CONFIG_FAIR_GROUP_SCHED=y
# CONFIG_RT_GROUP_SCHED is not set
CONFIG_USER_SCHED=y
# CONFIG_CGROUP_SCHED is not set


> -yanmin
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 


