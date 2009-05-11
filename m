Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZEKIi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZEKIi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754137AbZEKIiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:38:19 -0400
Received: from mail-ew0-f224.google.com ([209.85.219.224]:46811 "EHLO
	mail-ew0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726AbZEKIiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SOMh6/0TIFDk3L/NV8S+i4tvmPMhHBPa7OwvbBZqZp+lT8HfolD0xhq/HjympQEQMx
         7KIC9FOXz8lPcR7mIMzaqpiGiSUZ8yok27jJ21ZFFUdoCyu5ORXPeZ7ODiYyeh/lyne6
         Oxuo2EvvIGGpSVbWzC4jYfEv5Aij7YGUMEmAI=
MIME-Version: 1.0
In-Reply-To: <4A07C905.8010805@gmail.com>
References: <c6b1100b0905101239n564e4379v5460c281260950bc@mail.gmail.com>
	 <4A074682.6010403@gmail.com>
	 <c6b1100b0905101529tfafe11p3ddcbf4b604ddd29@mail.gmail.com>
	 <4A07C905.8010805@gmail.com>
Date: Mon, 11 May 2009 08:38:17 +0000
Message-ID: <c6b1100b0905110138r804136aqce6111b17cabc5fb@mail.gmail.com>
Subject: Re: Oops in wireless from today's git
From: Chris Clayton <chris2553@googlemail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/11 Jiri Slaby <jirislaby@gmail.com>:
> On 05/11/2009 12:29 AM, Chris Clayton wrote:
>> 2009/5/10 Jiri Slaby <jirislaby@gmail.com>:
>>> On 05/10/2009 09:39 PM, Chris Clayton wrote:
>>>> I've just done a git pull and built, installed and booted the kernel.
>>>> Unfortunately I got the oops below.
>>> What's your HEAD? Looks like the issue solved by
>>> 0cc113d866fa87c1455cbaff8d1f7ac054090bd5.
>>>
>>
>> Sorry, I'm a real novice git user, but if by HEAD you mean the latest
>> commit, its a4d7749be5de4a7261bcbe3c7d96c748792ec455. The file
>> .git/FETCH_HEAD contains:
>>
>> a4d7749be5de4a7261bcbe3c7d96c748792ec455                branch
>> 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6
>
> Ah, I though you're on wireless-testing git. Could you try to apply this
> patch?
> http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=commitdiff_plain;h=0cc113d866fa87c1455cbaff8d1f7ac054090bd5
>

Thanks Jiri. That patch applies (with offsets) and prevents the oops.
I think the patch that caused this oops was sent to stable, so  I
guess this needs pushing to Linus quite quickly so that it can go to
stable too.

Tested-by: Chris Clayton <chris2553@googlemail.com>

Thanks again.

-- 
No, Sir; there is nothing which has yet been contrived by man, by which
so much happiness is produced as by a good tavern or inn - Doctor Samuel
Johnson
