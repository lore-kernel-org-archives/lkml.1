Return-Path: <linux-kernel-owner+w=401wt.eu-S1755845AbXIZLtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845AbXIZLtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 07:49:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbXIZLsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 07:48:55 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:55433 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXIZLsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 07:48:55 -0400
Message-ID: <46FA46F6.6000707@linux.vnet.ibm.com>
Date: Wed, 26 Sep 2007 17:18:06 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andreas Schwab <schwab@suse.de>
CC: Maxim Uvarov <muvarov@ru.mvista.com>, LKML <linux-kernel@vger.kernel.org>,
       balbir@in.ibm.com, jlan@engr.sgi.com
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print
 them with %llu macros.
References: <20070926143918.6749.53939.stgit@localhost.localdomain> <je641x64rw.fsf@sykes.suse.de>
In-Reply-To: <je641x64rw.fsf@sykes.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Schwab wrote:
> Maxim Uvarov <muvarov@ru.mvista.com> writes:
> 
>> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
>> index cbee3a2..73924df 100644
>> --- a/Documentation/accounting/getdelays.c
>> +++ b/Documentation/accounting/getdelays.c
>> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
>>  void task_context_switch_counts(struct taskstats *t)
>>  {
>>  	printf("\n\nTask   %15s%15s\n"
>> -	       "       %15lu%15lu\n",
>> +	       "       %15llu%15llu\n",
>>  	       "voluntary", "nonvoluntary",
>>  	       t->nvcsw, t->nivcsw);
> 
> __u64 is not always long long.

What is the maximum size of long long across all architectures?
How does one format __u64 for printing?

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
