Return-Path: <linux-kernel-owner+w=401wt.eu-S1752817AbYKLLxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817AbYKLLxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 06:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751746AbYKLLxb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 06:53:31 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:47746 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbYKLLxa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 06:53:30 -0500
Message-ID: <491AC39C.8060303@linux.vnet.ibm.com>
Date: Wed, 12 Nov 2008 17:23:00 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Vaidyanathan S <svaidyan@in.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Bharata B Rao <bharata@linux.vnet.ibm.com>, efault@gmx.de
Subject: Re: [PATCH][mmotm] Sched fix stale value in average load per task
References: <20081112104900.GA13896@balbir.in.ibm.com> <20081112113852.GA26884@balbir.in.ibm.com> <20081112114614.GA11352@elte.hu>
In-Reply-To: <20081112114614.GA11352@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
>> * Balbir Singh <balbir@linux.vnet.ibm.com> [2008-11-12 16:19:00]:
>>
>>> +	else
>>> +		rq->avg_load_per_task = 0;
>>>  
>>>  	return rq->avg_load_per_task;
>> On second thoughts, does this look better? (Based on Mike 
>> Galbraith's suggestion)
> 
> yes - but could you send it as a delta patch against your previous 
> patch please? We want the simpler patch for tip/sched/urgent, as a 
> v2.6.28 fix - the removal of rq->avg_load_per_task can wait until 
> v2.6.29. (Please also include Mike's Ack in the patch if he acks the 
> patch.)

Fair enough. I'll send out the delta tomorrow.

-- 
	Balbir
