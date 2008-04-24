Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbYDXCZQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbYDXCZQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 22:25:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409AbYDXCZE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 22:25:04 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbYDXCZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 22:25:03 -0400
Date: Wed, 23 Apr 2008 22:24:55 -0400 (EDT)
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: mkrufky@linuxtv.org
cc: video4linux-list@redhat.com, linux-kernel@vger.kernel.org,
       ivtv-devel@ivtvdriver.org, biercenator@gmail.com,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Fix VIDIOCGAP corruption in ivtv
In-Reply-To: <480F7A0E.2080202@linuxtv.org>
Message-ID: <Pine.LNX.4.64.0804232210550.31358@bombadil.infradead.org>
References: <480F7A0E.2080202@linuxtv.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>>
>> In this case, it should be reviewed-by.
>>
>> I should be sending this soon to Linus.
>
>
> Mauro,
>
> I think it's wrong that you alter signatures.  You did this:
>
> Reviewed-by: <mkrufky@linuxtv.org <mailto:mkrufky@linuxtv.org>>

Argh! I didn't notice that weird stuff. This should be fixed before 
forwarding the patch. Sorry for the mess.

> But I provided this:
>
> Signed-off-by: Michael Krufky <mkrufky@linuxtv.org>
>
> I sign the patch, because I have handled it in my -stable queue.

SOB is the proper tag for your -stable queue. However, asking me to add 
this to my tree is not what it is expected.

SOB is meant to track the patch history until it reaches the kernel. So, 
the first SOB(s) is(are) from its author(s). The author(s) will send this 
to a driver maintainer, that will send to a subsystem maintainer, etc, 
until reach mainstream.

In the case of this patch, it was sent to the ML. Hans picked it, as the 
maintainer of ivtv, and asked me to pull.

You didn't wrote the patch, not forwarded it to me, so, the tag doesn't 
apply on my tree.

After the merge at mainstream, you'll send this to stable. In this case, 
you'll take it from my tree, add your SOB, and forward it.

Unfortunately, it is a common mistake of people sending SOB's instead of 
acked-by or reviewed-by, so several maintainers warns about the improper 
usage of the tags and corrects it on their trees, or simply ignores such 
improper usage.

If you prefer, I may just drop the tag from my tree, or fix the 
"reviewed-by".

Cheers,
Mauro.
