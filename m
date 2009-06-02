Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbZFBFkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbZFBFkt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbZFBFkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:40:40 -0400
Received: from smtp.nokia.com ([192.100.105.134]:39613 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbZFBFkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:40:39 -0400
Message-ID: <4A24BB21.3050402@nokia.com>
Date: Tue, 02 Jun 2009 08:39:45 +0300
From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Reply-To: Artem.Bityutskiy@nokia.com
Organization: Nokia OYJ
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] hrtimer: export ktime_add_safe
References: <20090529150929.8912.33879.sendpatchset@localhost.localdomain> <20090529150938.8912.3443.sendpatchset@localhost.localdomain> <20090601195600.GF29610@elte.hu>
In-Reply-To: <20090601195600.GF29610@elte.hu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 02 Jun 2009 05:39:47.0659 (UTC) FILETIME=[8A6F21B0:01C9E344]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext Ingo Molnar wrote:
> * Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:
> 
>> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> Subject: [PATCH 1/2] hrtimer: export ktime_add_safe
>>
>> We want to use hrtimers in UBIFS (for write-buffer write-back timer).
>> We need the 'hrtimer_set_expires_range_ns()', which is an in-line
>> function which uses 'ktime_add_safe()'.
>>
>> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
>> ---
>>  kernel/hrtimer.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
>> index cb8a15c..18f6906 100644
>> --- a/kernel/hrtimer.c
>> +++ b/kernel/hrtimer.c
>> @@ -332,6 +332,8 @@ ktime_t ktime_add_safe(const ktime_t lhs, const ktime_t rhs)
>>  	return res;
>>  }
>>  
>> +EXPORT_SYMBOL_GPL(ktime_add_safe);
>> +
> 
> Feel free to queue this up in your tree - it's trivial enough.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

OK, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
