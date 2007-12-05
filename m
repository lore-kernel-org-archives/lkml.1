Return-Path: <linux-kernel-owner+w=401wt.eu-S1753609AbXLEUyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609AbXLEUyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:54:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbXLEUyD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:54:03 -0500
Received: from ccs17.jlab.org ([129.57.35.82]:46374 "EHLO ccs17.jlab.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751499AbXLEUyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:54:03 -0500
Message-ID: <47570FE7.6030407@jlab.org>
Date: Wed, 05 Dec 2007 15:53:59 -0500
From: Jie Chen <chen@jlab.org>
Organization: Jefferson Lab
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Simon Holm Th??gersen <odie@cs.aau.dk>
Subject: Re: Possible bug from kernel 2.6.22 and above
References: <4744966C.900@jlab.org> <1196887002.6353.19.camel@lappy>
In-Reply-To: <1196887002.6353.19.camel@lappy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2007-11-21 at 15:34 -0500, Jie Chen wrote:
> 
>> It is clearly that the synchronization overhead increases as the number 
>> of threads increases in the kernel 2.6.21. But the synchronization 
>> overhead actually decreases as the number of threads increases in the 
>> kernel 2.6.23.8 (We observed the same behavior on kernel 2.6.22 as 
>> well). This certainly is not a correct behavior. The kernels are 
>> configured with CONFIG_SMP, CONFIG_NUMA, CONFIG_SCHED_MC, 
>> CONFIG_PREEMPT_NONE, CONFIG_DISCONTIGMEM set. The complete kernel 
>> configuration file is in the attachment of this e-mail.
>>
>>  From what we have read, there was a new scheduler (CFS) appeared from 
>> 2.6.22. We are not sure whether the above behavior is caused by the new 
>> scheduler.
> 
> If I read this correctly, you say that: .22 is the first bad one right?
> 
> The new scheduler (CFS) was introduced in .23, so it seems another
> change would be responsible for this.
> 
> 
> 
Hi, Peter:

Yes. We did observe this in 2.6.22. Thank you.

-- 
###############################################
Jie Chen
Scientific Computing Group
Thomas Jefferson National Accelerator Facility
12000, Jefferson Ave.
Newport News, VA 23606

(757)269-5046 (office) (757)269-6248 (fax)
chen@jlab.org
###############################################

