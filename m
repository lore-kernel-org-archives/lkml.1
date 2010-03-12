Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab0CLEkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 23:40:11 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:59864 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752880Ab0CLEkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 23:40:08 -0500
Message-ID: <4B99C567.6070804@st.com>
Date: Fri, 12 Mar 2010 10:09:03 +0530
From: Viresh KUMAR <viresh.kumar@st.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, rajeev-dlh.kumar@st.com,
       shiraz.hashim@st.com, armando.visconti@st.com,
       ashish.priyadarshi@st.com, linux-kernel@vger.kernel.org,
       vipin.kumar@st.com, amit.goel@st.com, deepak.sikri@st.com
Subject: Re: [PATCH 02/11] ST SPEAr: Added basic header files for SPEAr3xx
 machine family
References: <1267592861-26911-1-git-send-email-viresh.kumar@st.com> <1267592861-26911-2-git-send-email-viresh.kumar@st.com> <1267592861-26911-3-git-send-email-viresh.kumar@st.com> <20100311103321.GB16376@n2100.arm.linux.org.uk>
In-Reply-To: <20100311103321.GB16376@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/11/2010 4:03 PM, Russell King - ARM Linux wrote:
> On Wed, Mar 03, 2010 at 10:37:32AM +0530, Viresh KUMAR wrote:
>> diff --git a/arch/arm/mach-spear3xx/include/mach/dma.h b/arch/arm/mach-spear3xx/include/mach/dma.h
>> new file mode 100644
>> index 0000000..9b93bc6
>> --- /dev/null
>> +++ b/arch/arm/mach-spear3xx/include/mach/dma.h
>> @@ -0,0 +1,18 @@
>> +/*
>> + * arch/arm/mach-spear3xx/include/mach/dma.h
>> + *
>> + * Generic DMA support for SPEAr3xx machine family
>> + *
>> + * Copyright (C) 2009 ST Microelectronics
>> + * Viresh Kumar<viresh.kumar@st.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef __ASM_ARCH_DMA_H
>> +#define __ASM_ARCH_DMA_H
>> +
>> +#endif /* __ASM_ARCH_DMA_H */
>> +
> 
> You don't need to provide this file if you don't use it.
> 

It will be removed.

>> diff --git a/arch/arm/mach-spear3xx/include/mach/vmalloc.h b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
>> new file mode 100644
>> index 0000000..4f236f3
>> --- /dev/null
>> +++ b/arch/arm/mach-spear3xx/include/mach/vmalloc.h
>> @@ -0,0 +1,22 @@
>> +/*
>> + * arch/arm/mach-spear3xx/include/mach/vmalloc.h
>> + *
>> + * Defining Vmalloc area for SPEAr3xx machine family
>> + *
>> + * Copyright (C) 2009 ST Microelectronics
>> + * Viresh Kumar<viresh.kumar@st.com>
>> + *
>> + * This file is licensed under the terms of the GNU General Public
>> + * License version 2. This program is licensed "as is" without any
>> + * warranty of any kind, whether express or implied.
>> + */
>> +
>> +#ifndef __ASM_MACH_VMALLOC_H
>> +#define __ASM_MACH_VMALLOC_H
>> +
>> +#include <mach/memory.h>
>> +
>> +#define VMALLOC_SIZE		(0x30000000)
>> +#define VMALLOC_END		(PAGE_OFFSET + VMALLOC_SIZE)
> 
> Don't define it like this - define VMALLOC_END to be the maximum virtual
> address which you can permit the vmalloc area to extend to - which is
> generally the start of your peripheral mappings.
> 
> It's rather pointless defining it in terms of PAGE_OFFSET, because this
> can vary, whereas the start of your peripheral mappings tends to be
> fixed.
> 

OK. Will be changed.


regards,
viresh kumar

