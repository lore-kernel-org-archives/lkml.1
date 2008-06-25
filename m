Return-Path: <linux-kernel-owner+w=401wt.eu-S1756527AbYFYRjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527AbYFYRjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbYFYRiv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:38:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:58336 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753041AbYFYRiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:38:50 -0400
Message-ID: <486282A8.5020306@sgi.com>
Date: Wed, 25 Jun 2008 10:38:48 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Merge setup_32/64.c into setup.c
References: <200806242213.15310.yhlu.kernel@gmail.com>	 <200806242214.09503.yhlu.kernel@gmail.com>	 <200806250114.09858.yhlu.kernel@gmail.com>	 <20080625153614.GB18796@elte.hu>	 <86802c440806250844s51b50311va1c8e9c9fc1da510@mail.gmail.com>	 <20080625164300.GC6040@elte.hu> <86802c440806251028sb9a98e3ncbae3b3130c02fa6@mail.gmail.com>
In-Reply-To: <86802c440806251028sb9a98e3ncbae3b3130c02fa6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Wed, Jun 25, 2008 at 9:43 AM, Ingo Molnar <mingo@elte.hu> wrote:
>> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>>
>>>>>  include/asm-x86/setup.h    |    2
>>>>>  5 files changed, 670 insertions(+), 934 deletions(-)
>>>> very nice!
>>>>
>>>> could we please split this up into several, gradual steps that bring
>>>> setup_32.c and setup_64.c to exactly the same content - where the final
>>>> patch just renames arch/x86/kernel/setup_32.c to arch/x86/kernel/setup.c
>>>> and deletes arch/x86/kernel/setup_64.c ?
>>> OK, someone (Mike Triavis) already stole setup.c for X86_NUMA.
>>>
>>> You need to change that setup.c to other name. or split it away...
>> hm, that change was supposed to be the seed of a unification. So if it
>> actually hinders you, feel free to move it to a different file.
>> Obviously it is setup_32.c and setup_64.c that should be unified into
>> setup.c.
> 
> ok, I will change that setup_percpu.c
> 
> YH

One thing I was trying to do was to merge more stuff from setup_32/64 into
setup.c.  Unfortunately, there was some test failures on i386 that I did not
have time to debug.  But the file existed before my time. ;-)

Why does the current setup.c need to be renamed and not simply add the merged
changes into it?  

Thanks,
Mike
