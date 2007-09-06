Return-Path: <linux-kernel-owner+w=401wt.eu-S933116AbXIFVBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116AbXIFVBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 17:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932233AbXIFVBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 17:01:11 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51472 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbXIFVBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 17:01:10 -0400
To: Adrian Bunk <bunk@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, sam@ravnborg.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] build system: section garbage collection for vmlinux
In-Reply-To: <20070906203931.GE4480@stusta.de>
References: <200709051443.21522.vda.linux@googlemail.com> <200709051946.12096.vda.linux@googlemail.com> <20070905203438.GG475@flower.upol.cz> <200709061155.46667.vda.linux@googlemail.com> <20070906114044.GM475@flower.upol.cz> <20070906122143.GM16016@stusta.de> <20070906204349.GO475@flower.upol.cz> <20070906203931.GE4480@stusta.de>
User-Agent: slrn + jed (x86_64-pc-linux-glibc-debian)
Date: Thu, 6 Sep 2007 23:16:15 +0200
Message-Id: <E1ITOhz-0001wd-Uu@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Thu, 6 Sep 2007 22:39:31 +0200

[]
>> > His patch improves the build process.
>> 
>> I would like to know timing, btw. Size, especially shown 1%, doesn't
>> matter if link time increased dramatically. `Allyes' config, when i
>> had fast and rammish machine was terrible thing (last winter). If 32
>> cores/cpus is will of author, then i'm even more suspicious.
>
> For non-developers size and speed of the kernel matter much more than 
> compile time.

I'm talking about benefits for the process (developers, testers) and
the result (end users, dogs eating own food :).

> When you go towards embedded systems with limited resources a 1% size 
> decrease would often be worth it even if it would (hypothetically) 
> increase the compile time by a factor of 10.

   text    data     bss     dec     hex filename
   5159478 1005139  406784 6571401  644589 linux-2.6.23-rc4.org/vmlinux
   5131822  996090  401439 6529351  63a147 linux-2.6.23-rc4.gc/vmlinux

Are this numbers show embedded target? I think no. Also time factor of
*10* can be spent more productively reviewing actual code of parts, that
are going to be embedded, no?

[]
>> > There's nothing that requires treatment.
>> 
>> [Help for] The developers/contributors of those drivers, no?
>>...
>
> They did everything right.
>
> You should better try to understand the problem first before behaving as 
> if you knew everything better than everyone else...

OK, thank you very much. Now, describe what problem you are talking
about, please. I see non.
____
