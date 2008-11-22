Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYKVB1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYKVB1F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 20:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753854AbYKVB0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 20:26:54 -0500
Received: from rv-out-0506.google.com ([209.85.198.226]:41089 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYKVB0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 20:26:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wnzTToVvOW7HCnyYW6PpJx0BXk0DKTNF57msaNKOjQZnqBECukqtQJpGeavGB4//vr
         A/smda2WdNEFF0y2Qwwsh0gTtRhQqqJJCoDOXIhcmVCeETOKsMbJW3RUd8cjkzwJA1qV
         WW2wpA82i+m4V3Ic9Yi5L/IdpEfRmOSxlpGJk=
Message-ID: <19f34abd0811211726h143c83f6obdfcb97e71fa595f@mail.gmail.com>
Date: Sat, 22 Nov 2008 02:26:52 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Brian Phelps" <lm317t@gmail.com>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>
Subject: Re: kernel BUG at mm/slab.c:601
Cc: linux-kernel@vger.kernel.org, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Mikael Pettersson" <mikpe@it.uu.se>,
       "Alexander Shaduri" <ashaduri@gmail.com>,
       "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <19f34abd0811211725s169dc42ao195c61b6dac3e975@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ea3b75ed0811181524y7cdad2afl85e0281e293922cc@mail.gmail.com>
	 <19f34abd0811191419x3f6981ady7de5bf40f9ae2983@mail.gmail.com>
	 <ea3b75ed0811200901p1bd9e746q5b3757dd6114f3bd@mail.gmail.com>
	 <19f34abd0811211710q65d6200bt3a145971cd1bc911@mail.gmail.com>
	 <19f34abd0811211725s169dc42ao195c61b6dac3e975@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Resend with (I hope) working e-mail address for Mauro]

On Sat, Nov 22, 2008 at 2:25 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Sat, Nov 22, 2008 at 2:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>>> [  527.562373]  ffffffff8043b157 0000000000200200 ffffffffa02810d4
>>> ffff88001e13c600
>>
>> LIST_POISON2 on the stack:
>>
>> include/linux/poison.h:#define LIST_POISON2  ((void *) 0x00200200)
>
> So looking at bttv source code, I wonder what the codes like these are
> trying to do:
>
>                        if (set->top->vb.queue.next)
>                                list_del(&set->top->vb.queue);
>
> Code is ancient, I'll ask Mauro.
>
>
> Vegard
>
> --
> "The animistic metaphor of the bug that maliciously sneaked in while
> the programmer was not looking is intellectually dishonest as it
> disguises that the error is the programmer's own creation."
>        -- E. W. Dijkstra, EWD1036
>
