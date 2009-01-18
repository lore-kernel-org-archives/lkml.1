Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZARF7p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZARF7p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 00:59:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752257AbZARF7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 00:59:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:59897 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024AbZARF7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 00:59:35 -0500
Message-ID: <4972C53C.5050509@kernel.org>
Date: Sun, 18 Jan 2009 14:59:24 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/17] x86-64: Move cpu number from PDA to per-cpu and
 	consolidate with 32-bit.
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com>	 <1232115396-26367-1-git-send-email-brgerst@gmail.com>	 <1232115396-26367-2-git-send-email-brgerst@gmail.com>	 <1232115396-26367-3-git-send-email-brgerst@gmail.com>	 <1232115396-26367-4-git-send-email-brgerst@gmail.com>	 <1232115396-26367-5-git-send-email-brgerst@gmail.com>	 <4972B8AB.8040001@kernel.org> <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
In-Reply-To: <73c1f2160901172157j6cd731e5s187e98a069a3ab96@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 05:59:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> On Sun, Jan 18, 2009 at 12:05 AM, Tejun Heo <tj@kernel.org> wrote:
>> Hello,
>>
>>> --- a/arch/x86/kernel/setup_percpu.c
>>> +++ b/arch/x86/kernel/setup_percpu.c
>>> @@ -147,6 +147,9 @@ unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
>>>  #endif
>>>  EXPORT_SYMBOL(__per_cpu_offset);
>>>
>>> +DEFINE_PER_CPU(int, cpu_number);
>>> +EXPORT_PER_CPU_SYMBOL(cpu_number);
>> This is inside CONFIG_HAVE_SETUP_PER_CPU_AREA.  I think voyage would
>> be unhappy with this change.
> 
> Is there any specific reason Voyager doesn't use the x86
> setup_per_cpu_areas() function?  I don't see anything on a quick
> glance that would not work.  The x86 code is pretty much a superset of
> the default code in init/main.c.

I have no idea at all.  Given that not many people can test it, I
figured just leaving it alone would be the best course but if it can
be merged, all the better.

Thanks.

-- 
tejun
