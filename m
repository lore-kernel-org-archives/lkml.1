Return-Path: <linux-kernel-owner+w=401wt.eu-S1753983AbXJEFIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983AbXJEFIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 01:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbXJEFIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 01:08:37 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:64309 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbXJEFIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 01:08:36 -0400
Message-ID: <4705C63E.7020408@ah.jp.nec.com>
Date: Fri, 05 Oct 2007 14:06:06 +0900
From: Takenori Nagano <t-nagano@ah.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, vgoyal@in.ibm.com,
       "Eric W. Biederman" <ebiederm@xmission.com>, k-miyoshi@cb.jp.nec.com,
       kexec@lists.infradead.org, Bernhard Walle <bwalle@suse.de>,
       Keith Owens <kaos@ocs.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, kdb@oss.sgi.com
Subject: Re: [PATCH 1/2] add tunable_notifier function
References: <4704D0BA.4090507@ah.jp.nec.com> <20071004091157.c35f3513.randy.dunlap@oracle.com>
In-Reply-To: <20071004091157.c35f3513.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Thu, 04 Oct 2007 20:38:34 +0900 Takenori Nagano wrote:
>> diff -uprN linux-2.6.23-rc9.orig/kernel/sys.c linux-2.6.23-rc9/kernel/sys.c
>> --- linux-2.6.23-rc9.orig/kernel/sys.c	2007-10-02 12:24:52.000000000 +0900
>> +++ linux-2.6.23-rc9/kernel/sys.c	2007-10-03 14:48:15.160000000 +0900
>> @@ -38,6 +38,7 @@
>>  #include <linux/syscalls.h>
>>  #include <linux/kprobes.h>
>>  #include <linux/user_namespace.h>
>> +#include <linux/debugfs.h>
>>
>>  #include <asm/uaccess.h>
>>  #include <asm/io.h>
>> @@ -393,6 +394,234 @@ int blocking_notifier_call_chain(struct
> 
>> +/**
>> + *	tunable_notifier_chain_register - Add notifier to an tunable notifier chain
>> + *	@nh: Pointer to head of the tunable notifier chain
>> + *	@n: New entry in notifier chain
>> + *	@name: Pointer to the name of this notifier chain
> 
> Is @name the name of a notifier chain or of the new notifier entry?

Hi Randy,

@name: Pointer to the name of the new notifier entry.

I'll change the explanation.

Thanks,
