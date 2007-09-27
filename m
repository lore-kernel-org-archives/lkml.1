Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541AbXI0IU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541AbXI0IU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 04:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXI0IUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 04:20:13 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:50383 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbXI0IUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 04:20:11 -0400
Message-ID: <46FB67A3.8070508@linux.vnet.ibm.com>
Date: Thu, 27 Sep 2007 13:49:47 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andreas Schwab <schwab@suse.de>, Maxim Uvarov <muvarov@ru.mvista.com>,
       LKML <linux-kernel@vger.kernel.org>, balbir@in.ibm.com,
       jlan@engr.sgi.com
Subject: Re: [PATCH] Since we have counters in __u64 format we have to print
 them with %llu macros.
References: <20070926143918.6749.53939.stgit@localhost.localdomain> <je641x64rw.fsf@sykes.suse.de> <46FA46F6.6000707@linux.vnet.ibm.com> <46FAA373.9010607@zytor.com>
In-Reply-To: <46FAA373.9010607@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Balbir Singh wrote:
>> Andreas Schwab wrote:
>>> Maxim Uvarov <muvarov@ru.mvista.com> writes:
>>>
>>>> diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
>>>> index cbee3a2..73924df 100644
>>>> --- a/Documentation/accounting/getdelays.c
>>>> +++ b/Documentation/accounting/getdelays.c
>>>> @@ -208,7 +208,7 @@ void print_delayacct(struct taskstats *t)
>>>>  void task_context_switch_counts(struct taskstats *t)
>>>>  {
>>>>  	printf("\n\nTask   %15s%15s\n"
>>>> -	       "       %15lu%15lu\n",
>>>> +	       "       %15llu%15llu\n",
>>>>  	       "voluntary", "nonvoluntary",
>>>>  	       t->nvcsw, t->nivcsw);
>>> __u64 is not always long long.
>> What is the maximum size of long long across all architectures?
>> How does one format __u64 for printing?
>>
> 
> In user space, use the macro PRIu64 (or PRIx64 etc) from <inttypes.h>.
> 
> 	-hpa

Thanks, I'll look into it

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
