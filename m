Return-Path: <linux-kernel-owner+w=401wt.eu-S1755625AbYFYWVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625AbYFYWVx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 18:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbYFYWVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 18:21:46 -0400
Received: from gw.goop.org ([64.81.55.164]:52995 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388AbYFYWVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 18:21:45 -0400
Message-ID: <4862C4DA.9060004@goop.org>
Date: Wed, 25 Jun 2008 15:21:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove end_pfn in 64bit
References: <200806242213.15310.yhlu.kernel@gmail.com>	 <200806242214.09503.yhlu.kernel@gmail.com>	 <20080625154138.GC18796@elte.hu> <4862B915.3010001@goop.org> <86802c440806251457y134de928rb496da66becbe5cd@mail.gmail.com>
In-Reply-To: <86802c440806251457y134de928rb496da66becbe5cd@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jun 25, 2008 at 2:31 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>>
>>>
>>>       
>>>> and use max_pfn directly.
>>>>
>>>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>>>
>>>>         
>>> applied to tip/x86/setup-memory - thanks Yinghai. I have picked up these
>>> patches:
>>>
>>> Ingo Molnar (1):
>>>      Merge branch 'x86/setup-memory'
>>>
>>> Yinghai Lu (6):
>>>      x86: fix e820_update_range size when overlapping
>>>      x86: get max_pfn_mapped in init_memory_mapping
>>>      x86: add table_top check for alloc_low_page in 64 bit
>>>      x86: change size if e820_update/remove_range
>>>      x86: numa 32 using apicid_2_node to get node for logical_apicid
>>>      x86: remove end_pfn in 64bit
>>>
>>>       
>> Did you CC: this to me to indicate that "x86_64: replace end_pfn with
>> num_physpages" conflicts massively with this patch?  Fortunately I don't
>> depend on it, so I don't mind much.
>>
>> How does "max_pfn" differ from "num_physpages"?  Should one of them go as
>> well?
>>     
>
> 64bit setup_arch assign num_physpages with end_pfn...
>   

I posted a patch to remove end_pfn and replace it with num_physpages 
everywhere, which obviously clashed badly with your patch ;)

> and max_pfn is defined in linux/bootmem.h
> num_physpages  is defined in linux/mm.h

Do they contain separate values?  Do they mean different things?

    J
