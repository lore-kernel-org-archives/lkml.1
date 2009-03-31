Return-Path: <linux-kernel-owner+w=401wt.eu-S1754327AbZCaHGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbZCaHGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 03:06:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751268AbZCaHF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 03:05:57 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:65048 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbZCaHF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 03:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=T0SO8wuz6uuXavpa++TiVKL1G1B0DMFULdesajvk4g8Mo6XAoaDka0/Zv9Xg3n70Ko
         e7/E0UXWxY+QegExY4UV4dZ1QBed5JXeiJLZ3ofK4i4o07vsUwYVBHqPg2Xx7UF+JrOa
         iVDWiJIIMKqpS8dpw0XDrT+KRC4l0RCslftqI=
MIME-Version: 1.0
In-Reply-To: <200903302229.31846.bzolnier@gmail.com>
References: <Pine.LNX.4.64.0903292229400.23398@anakin>
	 <200903302229.31846.bzolnier@gmail.com>
Date: Tue, 31 Mar 2009 09:05:53 +0200
X-Google-Sender-Auth: 07055d817f2b1e24
Message-ID: <10f740e80903310005i57337594x175559b7c071b736@mail.gmail.com>
Subject: Re: [PATCH] de: drivers/ide/ide-atapi.c needs <linux/scatterlist.h>
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 22:29, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:
> On Sunday 29 March 2009, Geert Uytterhoeven wrote:
>> On m68k:
>> | drivers/ide/ide-atapi.c: In function 'ide_io_buffers':
>> | drivers/ide/ide-atapi.c:87: error: implicit declaration of function 'sg_page'
>> | drivers/ide/ide-atapi.c:87: warning: passing argument 1 of 'PageHighMem' makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:91: warning: passing argument 1 of 'kmap_atomic' makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:96: error: implicit declaration of function 'sg_virt'
>> | drivers/ide/ide-atapi.c:96: warning: assignment makes pointer from integer without a cast
>> | drivers/ide/ide-atapi.c:107: error: implicit declaration of function 'sg_next'
>> | drivers/ide/ide-atapi.c:107: warning: assignment makes pointer from integer without a cast
>>
>> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>
> thanks, applied
>
> [ Dmitri, sorry but m68k was faster than MIPS this time ;) ]

Thanks!

>> ---
>> No idea where it got introduced. 2.6.29 was fine.
>
> Hmm... the issue went unnoticed because it was mitigated in linux-next
> by ide_pio_bytes() conversion (resulting in ide_io_buffers() removal)...

I meant that I didn't see any removals of #include <linux/scatterlist.h> nor
additions of sg_*() users since v2.6.29.
But I did wonder why we never saw it in linux-next...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
