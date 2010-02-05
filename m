Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878Ab0BEVn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:43:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757431Ab0BEVn6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:43:58 -0500
Message-ID: <4B6C90D9.5050203@zytor.com>
Date: Fri, 05 Feb 2010 13:42:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Brandon Philips <bphilips@suse.de>
CC: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: keep chip_data in create_irq_nr
References: <20100203033109.GA17985@jenkins.home.ifup.org> <4B694DEF.70301@kernel.org> <20100203174216.GB17985@jenkins.home.ifup.org> <4B6BDAC0.3090900@kernel.org> <20100205210534.GD4930@jenkins.home.ifup.org>
In-Reply-To: <20100205210534.GD4930@jenkins.home.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2010 01:05 PM, Brandon Philips wrote:
>>  
>> Index: linux-2.6/include/linux/irq.h
>> ===================================================================
>> --- linux-2.6.orig/include/linux/irq.h
>> +++ linux-2.6/include/linux/irq.h
>> @@ -400,6 +400,7 @@ static inline int irq_has_action(unsigne
>>  
>>  /* Dynamic irq helper functions */
>>  extern void dynamic_irq_init(unsigned int irq);
>> +void dynamic_irq_init_keep_chip_data(unsigned int irq);
>>  extern void dynamic_irq_cleanup(unsigned int irq);
> 
> Missing extern?
> 

Quite the opposite -- function prototypes don't need "extern", and
putting "extern" on them is generally considered bad style.

	-hpa
