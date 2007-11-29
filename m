Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbXK2FB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbXK2FB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 00:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750711AbXK2FBt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 00:01:49 -0500
Received: from gepetto.dc.ltu.se ([130.240.42.40]:42742 "EHLO
	gepetto.dc.ltu.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbXK2FBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 00:01:48 -0500
Message-ID: <474E44C5.4020107@student.ltu.se>
Date: Thu, 29 Nov 2007 05:49:09 +0100
From: Richard Knutsson <ricknu-0@student.ltu.se>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC] kmemcheck: trap uses of uninitialized memory (v2)
References: <474C34CC.6060509@gmail.com> <474D100E.1000101@student.ltu.se> <19f34abd0711281031r3d9ac97bw800aaeec87e86816@mail.gmail.com>
In-Reply-To: <19f34abd0711281031r3d9ac97bw800aaeec87e86816@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
> Hi,
>
> On Nov 28, 2007 7:51 AM, Richard Knutsson <ricknu-0@student.ltu.se> wrote:
>   
>> Vegard Nossum wrote:
>>     
>>> +static int
>>>       
>> Not 'static bool'?
>>     
>>> +page_is_tracked(struct page *page)
>>>       
>> Why not returning 'false' and 'true'?
>>     
>
> Sorry, I am not used to using bool in C :-) I will change this if bool
> is preferred in kernel code.
>
>   
Well, why not use them since we have them (C99 standard and over a year 
in the kernel). ;)
What is "preferred" in a group of a few thousands, is hard to say, but I 
believe it is the way to go. The only "resistance" to it I know, is "it 
is not a C idiom". A quite illogical statement, at best. However, the 
0/1 vs false/true is just a preference. (I like false/true, since I also 
say "true AND false = false" for example... (NOT true = false, makes 
sense to me, NOT 1 = 0 seem strange, why can't it be 2, or -1 ;) ))
>>> +static unsigned int
>>> +opcode_get_size(const uint8_t *opcode)
>>>       
>> Are we not using 'u8' in the kernel?
>>     
>
> Actually, I don't see any reason to use u8 when uint8_t is already
> standard and used in other places in the kernel.
>   
I believe I have heard they can be a problem in some situations. It also 
have the benefit of uniforming the kernel-code.

cu
Richard Knutsson

