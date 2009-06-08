Return-Path: <linux-kernel-owner+w=401wt.eu-S1754877AbZFHCfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbZFHCfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:35:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbZFHCez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:34:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63751 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbZFHCez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:34:55 -0400
Message-ID: <4A2C7927.30709@cn.fujitsu.com>
Date: Mon, 08 Jun 2009 10:36:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
CC: paulmck@linux.vnet.ibm.com, Gautham R Shenoy <ego@in.ibm.com>,
       Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, dipankar@in.ibm.com
Subject: Re: [PATCH] cpuhotplug: introduce try_get_online_cpus() take 2
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090530015342.GA21502@linux.vnet.ibm.com> <20090530043739.GA12157@in.ibm.com> <4A27708C.6030703@cn.fujitsu.com> <20090605153714.GB6778@linux.vnet.ibm.com>
In-Reply-To: <20090605153714.GB6778@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
>> Add CC to Peter Zijlstra <peterz@infradead.org>
>>
>> (This patch is against mainline but not for inclusion, it will adapted
>> against -mm when request)
>>
>> Requst For Comments and Reviewing Hungeringly.
>>
>> - Lockless for get_online_cpus()'s fast path
>> - Introduce try_get_online_cpus()
> 
> One question for Gautham Shenoy -- are non-atomic CPU-hotplug notifiers
> always invoked from the task that did the cpu_hotplug_begin()?
> 
> If so, well and good.  If not, then it would not be possible to
> expedite RCU grace periods from within CPU-hotplug notifiers.
> 
> 							Thanx, Paul
> 


I have no proper machine for several days to test the next version
of this patch, so it is still being delayed a while.

Lai.



