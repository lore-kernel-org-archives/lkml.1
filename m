Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab0CENZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 08:25:39 -0500
Received: from hera.kernel.org ([140.211.167.34]:35021 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719Ab0CENZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 08:25:36 -0500
Message-ID: <4B910649.1000506@kernel.org>
Date: Fri, 05 Mar 2010 22:25:29 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Sachin Sant <sachinp@in.ibm.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: -next March 3: Boot failure on x86 (Oops)
References: <20100303174603.5be197ba.sfr@canb.auug.org.au> <4B8E83D4.6090507@in.ibm.com> <4B8F0CD0.1040507@kernel.org> <4B8F43DD.10002@in.ibm.com> <4B909FC5.8020800@kernel.org> <4B90A031.8090306@kernel.org> <4B90A214.70301@kernel.org> <4B90B723.3000100@in.ibm.com>
In-Reply-To: <4B90B723.3000100@in.ibm.com>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Mar 2010 13:25:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2010 04:47 PM, Sachin Sant wrote:
>> diff --git a/mm/percpu.c b/mm/percpu.c
>> index 768419d..f1ed9ea 100644
>> --- a/mm/percpu.c
>> +++ b/mm/percpu.c
>> @@ -373,11 +373,11 @@ static int pcpu_need_to_extend(struct pcpu_chunk
>> *chunk)
>>  {
>>      int new_alloc;
>>
>> -    if (chunk->map_alloc >= chunk->map_used + 2)
>> +    if (chunk->map_alloc >= chunk->map_used + 3)
>>          return 0;
>>
>>      new_alloc = PCPU_DFL_MAP_ALLOC;
>> -    while (new_alloc < chunk->map_used + 2)
>> +    while (new_alloc < chunk->map_used + 3)
>>          new_alloc *= 2;
>>
>>      return new_alloc;

This was a red herring.  +2 is correct.

Thanks.

-- 
tejun
