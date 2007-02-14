Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXBNNz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXBNNz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 08:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932286AbXBNNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 08:55:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:27917 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290AbXBNNz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 08:55:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=NsKIcJ2kiDtoGCK56I9yOnGx613zRGuzhz2Aps7h6vMsUah6AMock6q/KeO+tzBuNJ9By5vPeBx3G6dy/zN6DLxhsFDVVCxIzAFEs+jrKT16P70xsCEVZp0Xlf0GLUNknR5ChXN22u8X9qJhxRFWnBnum18Cr1myfB7z6GP5xqU=
Date: Wed, 14 Feb 2007 14:55:15 +0100 (CET)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Andrew Burgess <aab@cichlid.com>
cc: mingo@elte.hu, rncbc@rncbc.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.20-rt5 Oops on boot
In-Reply-To: <200702101551.l1AFpKUf019229@cichlid.com>
Message-ID: <Pine.LNX.4.64.0702141451540.7817@frodo.shire>
References: <200702101551.l1AFpKUf019229@cichlid.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Andrew Burgess wrote:

>> I have terrible news: 2.6.20-rt5 does not boot at all on a couple
>> machines I was brave enough to try -- a P4@3.3Ghz SMP/HT desktop, and a
>> Core2 Duo T7200@2.0Ghz laptop.
>
> Ditto for me on an ASUS AMD64 x2, just hangs, I have no
> serial console. 2.6.20-rc5-rt7 booted ok (the last one I
> tried). Both using SMP.
>

2.6.20-rt5 doesn't boot on my hyperthreaded Pentium 4 2.80GHz either. I 
don't have serial console but I can see that it stops at exit.c:877.

Esben

> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
