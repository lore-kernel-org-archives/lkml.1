Return-Path: <linux-kernel-owner+w=401wt.eu-S1754673AbYFYVbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673AbYFYVbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYFYVbP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:31:15 -0400
Received: from gw.goop.org ([64.81.55.164]:47722 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479AbYFYVbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:31:14 -0400
Message-ID: <4862B915.3010001@goop.org>
Date: Wed, 25 Jun 2008 14:31:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yhlu.kernel@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: remove end_pfn in 64bit
References: <200806242213.15310.yhlu.kernel@gmail.com> <200806242214.09503.yhlu.kernel@gmail.com> <20080625154138.GC18796@elte.hu>
In-Reply-To: <20080625154138.GC18796@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>   
>> and use max_pfn directly.
>>
>> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>>     
>
> applied to tip/x86/setup-memory - thanks Yinghai. I have picked up these 
> patches:
>
> Ingo Molnar (1):
>       Merge branch 'x86/setup-memory'
>
> Yinghai Lu (6):
>       x86: fix e820_update_range size when overlapping
>       x86: get max_pfn_mapped in init_memory_mapping
>       x86: add table_top check for alloc_low_page in 64 bit
>       x86: change size if e820_update/remove_range
>       x86: numa 32 using apicid_2_node to get node for logical_apicid
>       x86: remove end_pfn in 64bit
>   

Did you CC: this to me to indicate that "x86_64: replace end_pfn with 
num_physpages" conflicts massively with this patch?  Fortunately I don't 
depend on it, so I don't mind much.

How does "max_pfn" differ from "num_physpages"?  Should one of them go 
as well?

    J
