Return-Path: <linux-kernel-owner+w=401wt.eu-S965410AbXC0Uiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965410AbXC0Uiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 16:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965412AbXC0Uiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 16:38:54 -0400
Received: from sp604003mt.neufgp.fr ([84.96.92.56]:49910 "EHLO smTp.neuf.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965410AbXC0Uix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 16:38:53 -0400
Date: Tue, 27 Mar 2007 22:30:26 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: 2.6.21-rc5-mm1
In-reply-to: <20070327131214.656e1ad7.akpm@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Badari Pulavarty <pbadari@gmail.com>, lkml <linux-kernel@vger.kernel.org>
Message-id: <46097EE2.6010206@cosmosbay.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
 <1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com>
 <20070327084838.34dc1b84.akpm@linux-foundation.org>
 <1175018270.16728.26.camel@dyn9047017100.beaverton.ibm.com>
 <20070327131214.656e1ad7.akpm@linux-foundation.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton a écrit :
> On Tue, 27 Mar 2007 09:57:50 -0800
> Badari Pulavarty <pbadari@gmail.com> wrote:
> 
>> On Tue, 2007-03-27 at 08:48 -0800, Andrew Morton wrote:
>>> On Tue, 27 Mar 2007 09:39:33 -0800 Badari Pulavarty <pbadari@gmail.com> wrote:
>>>
>>>> On Mon, 2007-03-26 at 20:57 -0800, Andrew Morton wrote:
>>>>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/
>>>>>
>>>>
>>>>   LD      init/built-in.o
>>>>   LD      .tmp_vmlinux1
>>>> ld: section .vsyscall_1 [0000000000645400 -> 000000000064542e] overlaps
>>>> section .jiffies [0000000000645400 -> 0000000000645407]
>>>> ld: .tmp_vmlinux1: section .vsyscall_1 lma 0x645400 overlaps previous
>>>> sections
>>>> make: *** [.tmp_vmlinux1] Error 1
>>>>
>>> bah.  Please send .config.
>> #
>> # Automatically generated make config: don't edit
>> # Linux kernel version: 2.6.21-rc5-mm1
> 
> The wheel spins around, slows then settles on.... 
> time-smp-friendly-alignment-of-struct-clocksource.patch!
> 
> Presumably because the ____cacheline_aligned made vsyscall_gtod_data_t get
> too big.  Or something.
> 

Maybe yes... 1024 bytes to code vsyscall0 is tricky.

But then I remember I posted a patch some time ago to remove __jiffie from 
vsyscall page... no answer yet from Andi.

