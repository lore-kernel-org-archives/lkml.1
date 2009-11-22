Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZKVLvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZKVLvh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 06:51:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752382AbZKVLvg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 06:51:36 -0500
Received: from gateway-1237.mvista.com ([206.112.117.35]:35714 "HELO
	imap.sh.mvista.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751659AbZKVLvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 06:51:36 -0500
Message-ID: <4B0925BD.6070507@ru.mvista.com>
Date: Sun, 22 Nov 2009 14:51:25 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] MIPS: Add a high resolution sched_clock() via cnt32_to_63().
References: <dae45f23b5d34f64fc60a445015e7dfe05aa0d07.1258875717.git.wuzhangjin@gmail.com> <20091122081328.GB24558@elte.hu>
In-Reply-To: <20091122081328.GB24558@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Ingo Molnar wrote:

>> +config HR_SCHED_CLOCK
>> +	bool "High Resolution sched_clock()"
>> +	depends on CSRC_R4K
>> +	default n
>> +	help
>> +	  This option enables the MIPS c0 count based high resolution
>> +	  sched_clock().
>> +
>> +	  If you need a ns precision timestamp, You are recommended to enable
>> +	  this option. For example, If you are using the Ftrace subsystem to do
>>     

   s/If/if/

>> diff --git a/arch/mips/kernel/csrc-r4k.c b/arch/mips/kernel/csrc-r4k.c
>> index e95a3cd..4e52cca 100644
>> --- a/arch/mips/kernel/csrc-r4k.c
>> +++ b/arch/mips/kernel/csrc-r4k.c
>> @@ -6,10 +6,64 @@
>>   * Copyright (C) 2007 by Ralf Baechle
>>   */
>>  #include <linux/clocksource.h>
>> +#include <linux/cnt32_to_63.h>
>> +#include <linux/timer.h>
>>  #include <linux/init.h>
>>  
>>  #include <asm/time.h>
>>  
>> +/*
>> + * MIPS' sched_clock implementation.
>>     
>
> s/MIPS'/MIPS's
>   

   MIPS's is not really a proper English. :-)

WBR, Sergei


