Return-Path: <linux-kernel-owner+w=401wt.eu-S935157AbZJORBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935157AbZJORBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 13:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935096AbZJORBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 13:01:51 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:54051 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933058AbZJORBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 13:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=HHygkxTP6GIa4LILC5896mSOgseogmPbZu8K4pNi2wrYqa2yD2Fu0/J1JgtSiccZ/A
         hhbB4zFO6fhT0EchL53dqJNidsZiiEW34q6q/nURtj2xBL8PN43rcBc8MaQZShOzIqeT
         YAkY9rWl+kpCPDnueBrWi0u7RLd/y5h2Qjpuc=
MIME-Version: 1.0
In-Reply-To: <200910151251.57306.toralf.foerster@gmx.de>
References: <200910151251.57306.toralf.foerster@gmx.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 15 Oct 2009 13:00:54 -0400
Message-ID: <8bd0f97a0910151000ta7db2cau46f2f8ad065e70a6@mail.gmail.com>
Subject: Re: build issue #29 for v2.6.32-rc4-149-ga3ccf63 :gpio.h:171: error: 
	implicit declaration of function 'gpio_get_value'
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: David Woodhouse <dwmw2@infradead.org>, Bryan Wu <cooloney@kernel.org>,
       linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/10/15 Toralf Förster <toralf.foerster@gmx.de>:
> Hello,
>
> the build (.config attached) failed, make ends with :
> ...
>  CC      drivers/mtd/maps/gpio-addr-flash.o
> In file included from /home/tfoerste/devel/linux-2.6/arch/x86/include/asm/gpio.h:19,
>                 from drivers/mtd/maps/gpio-addr-flash.c:26:
> include/asm-generic/gpio.h: In function 'gpio_get_value_cansleep':
> include/asm-generic/gpio.h:171: error: implicit declaration of function 'gpio_get_value'
> include/asm-generic/gpio.h: In function 'gpio_set_value_cansleep':
> include/asm-generic/gpio.h:177: error: implicit declaration of function 'gpio_set_value'
> drivers/mtd/maps/gpio-addr-flash.c: In function 'gpio_flash_probe':
> drivers/mtd/maps/gpio-addr-flash.c:232: error: implicit declaration of function 'gpio_request'
> drivers/mtd/maps/gpio-addr-flash.c:236: error: implicit declaration of function 'gpio_free'
> drivers/mtd/maps/gpio-addr-flash.c:240: error: implicit declaration of function 'gpio_direction_output'
> make[3]: *** [drivers/mtd/maps/gpio-addr-flash.o] Error 1
> make[2]: *** [drivers/mtd/maps] Error 2
> make[1]: *** [drivers/mtd] Error 2
> make: *** [drivers] Error 2
>
> The build was made with :
> $>make randconfig; make clean; make
>
> Here's the config:

patches for this have been posted already, but no one has merged them.
 search recent lkml please.
-mike
