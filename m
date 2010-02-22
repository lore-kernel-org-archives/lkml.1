Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab0BVTDL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 14:03:11 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:38607 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0BVTDH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 14:03:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=SCJ08qWv9aiLhbTroRDJAA2ZNhVbH0WdnXWzFHew3PUBPYKh/QsLUYi0PQPuqXRshZ
         jljvCu0WdOYn/Xhc4Jbr2f72H7eGQDovkfdaCn7JbmCBmV7POPLkNsylWZR9Axbms329
         /DEnqJ6NvU3ZQEUJKalMvOGPJwqoZFjmY/9FE=
MIME-Version: 1.0
In-Reply-To: <4B82B28F.10104@oracle.com>
References: <20100204185736.6628ab9a.sfr@canb.auug.org.au>
	 <4B6B29DD.7060502@oracle.com> <4B7AC2A9.4070203@oracle.com>
	 <20100216173326.091c1c77@hyperion.delvare>
	 <4B7AC999.3060103@oracle.com> <4B82B28F.10104@oracle.com>
Date: Mon, 22 Feb 2010 20:03:05 +0100
X-Google-Sender-Auth: 2a2774399db77a88
Message-ID: <10f740e81002221103h7408d52ajf5a67da39d6ae8dd@mail.gmail.com>
Subject: Re: [PATCH -next] i2c: fix xiic build error
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: ben-linux@fluff.org, Jean Delvare <khali@linux-fr.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 22, 2010 at 17:36, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 02/16/10 08:36, Randy Dunlap wrote:
>> On 02/16/10 08:33, Jean Delvare wrote:
>>> On Tue, 16 Feb 2010 08:07:05 -0800, Randy Dunlap wrote:
>>>> On 02/04/10 12:11, Randy Dunlap wrote:
>>>>
>>>> This patch is still needed in linux-next-20100216.
>>>
>>> Nothing I can do about it, as the i2c-xiic driver is neither upstream
>>> nor in my tree.
>>
>> Thanks, Jean.
>>
>> Next/merge.log tells me:
>> Merge remote branch 'bjdooks-i2c/next-i2c'
>>
>> Ben??
>>
>
> ping Ben.

Yes, please. Thx!

> Here's the patch again.
>
> ---
> From: Randy Dunlap <randy.dunlap@oracle.com>
>
> Add header file to fix build error:
>
> drivers/i2c/busses/i2c-xiic.c:493: error: implicit declaration of function 'mdelay'
>
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> Cc: linux-i2c@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-xiic.c |    1 +
>  1 file changed, 1 insertion(+)
>
> --- linux-next-20100204.orig/drivers/i2c/busses/i2c-xiic.c
> +++ linux-next-20100204/drivers/i2c/busses/i2c-xiic.c
> @@ -31,6 +31,7 @@
>  #include <linux/module.h>
>  #include <linux/init.h>
>  #include <linux/errno.h>
> +#include <linux/delay.h>
>  #include <linux/platform_device.h>
>  #include <linux/i2c.h>
>  #include <linux/interrupt.h>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
