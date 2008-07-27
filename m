Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYG0Tk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYG0Tk5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2008 15:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757503AbYG0Tkt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jul 2008 15:40:49 -0400
Received: from py-out-1112.google.com ([64.233.166.178]:23873 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757490AbYG0Tks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2008 15:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TbvfQqZp/+47s+qFezemoamHVzHl+f05ktsnP9Up0xl8Hxsxmf6EXfpTv3jybEhAeW
         PxPYnJZ+WjVaL+f7nMF/PRoF6bcs8E7vPDBhv8d29HzbLkBFWTB6rLLuizD1QHLCBuVG
         LBWHAf3mh9JQXGBlHA+zTjK2gKtlOW+OGud7Q=
Message-ID: <19f34abd0807271240x71fb85e3qae5d7beaad6eaba3@mail.gmail.com>
Date: Sun, 27 Jul 2008 21:40:46 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: -git: BUG: unable to handle kernel paging request at c0100248 [CPU hotplug]
Cc: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>,
       lkml <linux-kernel@vger.kernel.org>, "Thomas Meyer" <thomas@m3y3r.de>,
       "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <19f34abd0807271235q516fc2e1rc43c6736044eabfc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807270255o1ff260a8ucb9d931905aa4947@mail.gmail.com>
	 <b647ffbd0807271014j17d1a14cncd0976ff4d3ff3fd@mail.gmail.com>
	 <19f34abd0807271019i2112498ay57c267354bd63a8c@mail.gmail.com>
	 <alpine.LFD.1.10.0807272118460.574@apollo.tec.linutronix.de>
	 <19f34abd0807271235q516fc2e1rc43c6736044eabfc@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 27, 2008 at 9:35 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sun, Jul 27, 2008 at 9:23 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Sun, 27 Jul 2008, Vegard Nossum wrote:
>>> Booting processor 1/1 ip 6000
>>> Initializing CPU#1
>>> [...]
>>> Write protecting the kernel text: 5648k
>>>
>>> So it succeeds because the protection happens much later :-)
>>
>> Patch below fixes the issue. I get it to Linus ASAP.
>
> Nice :)
>
> [...]
>
>> +.section .cpuinit.data,"wa"
>> +.align 4
>> +ENTRY(initial_code)
>> +       .long i386_start_kernel
>> +
>>  .section .text
>>  /*
>>  * Real beginning of normal "text" segment
>>
>
> Hm, isn't there some kind of "section stack" that can be used to
> restore the previous section? .pushsection/.popsection directives?

Oh, never mind :-)

(Sorry for the noise.)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
