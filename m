Return-Path: <linux-kernel-owner+w=401wt.eu-S1758748AbXIYUr5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbXIYUr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 16:47:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753729AbXIYUru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 16:47:50 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:55993 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753456AbXIYUrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 16:47:49 -0400
In-Reply-To: <200709252116.22541.ioe-lkml@rameria.de>
References: <20070925144443.GA17858@elte.hu> <20070925162502.GA3231@linux.vnet.ibm.com> <20070925162807.GB3231@linux.vnet.ibm.com> <200709252116.22541.ioe-lkml@rameria.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <5E8967F2-474C-4019-AA9D-9C3601376DBD@mac.com>
Cc: vatsa@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, randy.dunlap@oracle.com
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: [PATCH 1/3] Fix coding style
Date: Tue, 25 Sep 2007 16:47:19 -0400
To: Ingo Oeser <ioe-lkml@rameria.de>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 25, 2007, at 15:16:20, Ingo Oeser wrote:
> On Tuesday 25 September 2007, Srivatsa Vaddagiri wrote:
>> @@ -297,7 +293,7 @@ static int __init init_sched_debug_procf
>>  	pe->proc_fops = &sched_debug_fops;
>>
>>  #ifdef CONFIG_FAIR_USER_SCHED
>> -	pe = create_proc_entry("root_user_share", 0644, NULL);
>> +	pe = create_proc_entry("root_user_cpu_share", 0644, NULL);
>>  	if (!pe)
>>  		return -ENOMEM;
>
> What about moving this debug stuff under debugfs?  Please consider  
> using the functions in <linux/debugfs.h>.  They compile into  
> nothing, if DEBUGFS is not compiled in and have already useful  
> functions for reading/writing integers and booleans.

Umm, that's not a debugging thing.  It appears to be a tunable  
allowing you to configure what percentage of the total CPU that UID 0  
gets which is likely to be useful to configure on production systems;  
at least until better group-scheduling tools are produced.

Cheers,
Kyle Moffett

