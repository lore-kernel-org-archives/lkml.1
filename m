Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711Ab0AZXbP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711Ab0AZXbP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:31:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753369Ab0AZXbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:31:14 -0500
Received: from ey-out-2122.google.com ([74.125.78.26]:39056 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753094Ab0AZXbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:31:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MJqOMf1u3a/xx0zQWuRnYo/uCV2Z4baXf34Meq8dXO/8iBvS9qxeBFn8ifSJyCDXzv
         OkAb0KJ3V/OVsgW4HoSdXQyFKk73M1i4N09YlUTnFSxRDG8CmSY3araK83/95Lx0yJWx
         muonJKaG3bzZavRJn7mI8SHfoHI534LOicWtg=
MIME-Version: 1.0
In-Reply-To: <74fd948d1001261350n2f26c057ubbe056d11d19abf2@mail.gmail.com>
References: <74fd948d1001261121r7e6d03a4i75ce40705abed4e0@mail.gmail.com>
	 <4B5F52FE.5000201@crca.org.au> <1264539045.3536.1348.camel@calx>
	 <4B5F5794.8020302@cs.helsinki.fi>
	 <74fd948d1001261350n2f26c057ubbe056d11d19abf2@mail.gmail.com>
Date: Tue, 26 Jan 2010 23:31:11 +0000
Message-ID: <74fd948d1001261531v7a09e1e8t54a7a5a5a2df277b@mail.gmail.com>
Subject: Re: BUG at mm/slab.c:2990 with 2.6.33-rc5-tuxonice
From: Pedro Ribeiro <pedrib@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/26 Pedro Ribeiro <pedrib@gmail.com>:
> 2010/1/26 Pekka Enberg <penberg@cs.helsinki.fi>:
>> Matt Mackall wrote:
>>>
>>> On Wed, 2010-01-27 at 07:39 +1100, Nigel Cunningham wrote:
>>>>
>>>> Hi.
>>>>
>>>> Pedro Ribeiro wrote:
>>>>>
>>>>> Hi,
>>>>>
>>>>> I hit a bug at mm/slab.c:2990 with .33-rc5.
>>>>> Unfortunately nothing more is available than a screen picture with a
>>>>> crash dump, although it is a good one.
>>>>> The bug was hit almost at the end of a hibernation cycle with
>>>>> Tux-on-Ice, while saving memory contents to an encrypted swap
>>>>> partition.
>>>>>
>>>>> The image is here http://img264.imageshack.us/img264/9634/mmslab.jpg
>>>>> (150 kb)
>>>>>
>>>>> Hopefully it is of any use for you. Please let me know if you need any
>>>>> more info.
>>>>
>>>> Looks to me to be completely unrelated to TuxOnIce - at least at a first
>>>> glance.
>>>>
>>>> Ccing the slab allocator maintainers listed in MAINTAINERS.
>>>
>>> Not sure if this will do us any good, it's the second oops.
>>
>> Looks like slab corruption to me which is usually not a slab bug but caused
>> by buggy callers. Is CONFIG_DEBUG_SLAB enabled?
>>
>
> I have enabled it and compiled the kernel. As soon as I hit the bug, I
> will send a photo here.
>
> Regards,
> Pedro
>

The pic is here.
http://img43.imageshack.us/img43/3644/dsc01061ko.jpg

There was a buttload of output before that, which I tried capturing in
video, but its too crappy to post.
Do you know if/where I can get patches for KDB in .33?

Regards,
Pedro
