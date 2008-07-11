Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbYGKP1j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbYGKP1j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:27:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758788AbYGKP11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:27:27 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:60314 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758603AbYGKP1Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:27:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=eY1rMcfOQdUZdz+umbNCQwS9YlBI0gNUmic+kGJq8e+8rckrqy/GpG8AaV8DVctipL
         qa7S/pOeekjfvsrtQCFXp1pA0ZUBg611U9uTLmMWbGb4VzQwkqe7GmCv5tCs8eCF9n7K
         R6CA11r70guBZGydNL0/kpdk+UgiDLqDkc0aQ=
Message-ID: <48777BD3.4010204@gmail.com>
Date: Fri, 11 Jul 2008 18:27:15 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Takashi Iwai <tiwai@suse.de>,
       linux-next@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: today's linux-next fails to boot
References: <4877400B.1000400@gmail.com> <s5hy747rvpr.wl%tiwai@suse.de>	 <48775C69.6050107@gmail.com> <20080711135937.GA25004@elte.hu>	 <487772B6.4090100@gmail.com>	 <19f34abd0807110754n1a095671ua9132471b6a81540@mail.gmail.com> <19f34abd0807110800o5b283f00n4be7449ed3b06e5a@mail.gmail.com>
In-Reply-To: <19f34abd0807110800o5b283f00n4be7449ed3b06e5a@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-11 18:00, Vegard Nossum wrote:
>> On Fri, Jul 11, 2008 at 4:48 PM, Török Edwin <edwintorok@gmail.com> wrote:
>>     
>>>> One really simple way of getting some more info out of this is to take
>>>> the EIP value (here c0181ca0) and run it through addr2line:
>>>>
>>>>     $ addr2line -e vmlinux -i c0181ca0
>>>>         
>>> Thanks for the hint, I rebuilt a failing kernel, and this is what
>>> addr2line says:
>>>
>>> $ addr2line -e vmlinux -i c0181ca0
>>>
>>> ??:0
>>> $ addr2line -e vmlinux -f c0181ca0
>>> kmem_cache_alloc
>>> ??:0
>>>       
>
> BTW, did the new kernel fail in exactly the same place? 

Yep, I am using ccache, same sources -> same binary.

addr2line -i now says:
/var/local/src/linux-2.6.git/linux-2.6/mm/slub.c:1648
/var/local/src/linux-2.6.git/linux-2.6/mm/slub.c:1662

Strangely the EIP is the same even after rebuilding with debug info.

Since tip/master supports the latency tracing features, I won't dig
further into the linux-next problem now
(we'll know tomorrow if the commits in tip solve the boot problem).

Best regards,
--Edwin

