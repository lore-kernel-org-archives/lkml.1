Return-Path: <linux-kernel-owner+w=401wt.eu-S1753501AbXJEFCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501AbXJEFCh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:02:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750811AbXJEFC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:02:28 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61959 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbXJEFC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:02:27 -0400
Message-ID: <4705C4BF.6060308@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 13:59:43 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 2/2] implement new notifier function to panic_notifier_list
References: <4704D0CA.4080001@ah.jp.nec.com> <20071004090711.456b6338.randy.dunlap@oracle.com>
In-Reply-To: <20071004090711.456b6338.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 04 Oct 2007 20:38:50 +0900 Takenori Nagano wrote:
> 
>> This patch implements new notifier function to panic_notifier_list. We can
>> change the list of order by debugfs.
>>
>> Thanks,
>>
>> ---
>>
>> Signed-off-by: Takenori Nagano <t-nagano@ah.jp.nec.com>
>>
>> ---
>>   * Returns seconds, approximately.  We don't need nanosecond
>>   * resolution, and we don't need to waste time with a big divide when
>> @@ -193,5 +201,6 @@ __init void spawn_softlockup_task(void)
>>  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>>  	register_cpu_notifier(&cpu_nfb);
>>
>> -	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
>> +	tunable_notifier_chain_register(&panic_notifier_list, &panic_block,
>> +						"softlookup", NULL);
>>  }
> 
>                                                 "softlockup"

Hi Randy,

Thank you for reviewing. :)
I'll fix next version.
