Return-Path: <linux-kernel-owner+w=401wt.eu-S1752008Ab0A0ICS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab0A0ICS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 03:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164Ab0A0ICR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 03:02:17 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:48755 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab0A0ICR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 03:02:17 -0500
Message-ID: <4B5FF307.9080900@cs.helsinki.fi>
Date: Wed, 27 Jan 2010 10:02:15 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Pedro Ribeiro <pedrib@gmail.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
References: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>	 <4B5F52FE.5000201@crca.org.au> <1264539045.3536.1348.camel@calx>	 <4B5F5794.8020302@cs.helsinki.fi>	 <74fd948d1001261350n2f26c057ubbe056d11d19abf2@mail.gmail.com> <74fd948d1001261531v7a09e1e8t54a7a5a5a2df277b@mail.gmail.com>
In-Reply-To: <74fd948d1001261531v7a09e1e8t54a7a5a5a2df277b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pedro Ribeiro kirjoitti:
> 2010/1/26 Pedro Ribeiro <pedrib@gmail.com>:
>> 2010/1/26 Pekka Enberg <penberg@cs.helsinki.fi>:
>>> Matt Mackall wrote:
>>>> On Wed, 2010-01-27 at 07:39 +1100, Nigel Cunningham wrote:
>>>>> Hi.
>>>>>
>>>>> Pedro Ribeiro wrote:
>>>>>> Hi,
>>>>>>
>>>>>> I hit a bug at mm/slab.c:2990 with .33-rc5.
>>>>>> Unfortunately nothing more is available than a screen picture with a
>>>>>> crash dump, although it is a good one.
>>>>>> The bug was hit almost at the end of a hibernation cycle with
>>>>>> Tux-on-Ice, while saving memory contents to an encrypted swap
>>>>>> partition.
>>>>>>
>>>>>> The image is here http://img264.imageshack.us/img264/9634/mmslab.jpg
>>>>>> (150 kb)
>>>>>>
>>>>>> Hopefully it is of any use for you. Please let me know if you need any
>>>>>> more info.
>>>>> Looks to me to be completely unrelated to TuxOnIce - at least at a first
>>>>> glance.
>>>>>
>>>>> Ccing the slab allocator maintainers listed in MAINTAINERS.
>>>> Not sure if this will do us any good, it's the second oops.
>>> Looks like slab corruption to me which is usually not a slab bug but caused
>>> by buggy callers. Is CONFIG_DEBUG_SLAB enabled?
>>>
>> I have enabled it and compiled the kernel. As soon as I hit the bug, I
>> will send a photo here.
>>
>> Regards,
>> Pedro
>>
> 
> The pic is here.
> http://img43.imageshack.us/img43/3644/dsc01061ko.jpg
> 
> There was a buttload of output before that, which I tried capturing in
> video, but its too crappy to post.

Can you try passing "pause_on_oops=15" as kernel parameter? It should 
delay the next oops for 15 seconds so there's enough time to take a 
picture of the first one?

Also, you could try CONFIG_SLUB and passing "slub_debug" as kernel 
parameter to get nicer diagnostics of the bug.

> Do you know if/where I can get patches for KDB in .33?

Nope, sorry.

			Pekka
