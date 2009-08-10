Return-Path: <linux-kernel-owner+w=401wt.eu-S1752398AbZHJHjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbZHJHjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 03:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZHJHjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 03:39:44 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35197 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZHJHjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 03:39:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=weJE8uOw/Wh9TJfLfnJ0BQS0UKMY+NKg4C2iclJzHicZpFL9QlWdXRSnMSJK9jX0nn
         GAxCYxIscd1hjqClZnrDwByneSqEWgBvm7Co0534+4iWgd+XSQmvXNgOkk+1MLNOUchX
         QkZvlmHQ8YKs1pqYFuJjElbYfREmkYedmcTDk=
From: Florian Fainelli <florian@openwrt.org>
To: Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: [PATCH] MIPS: AR7: fix wrong including path of rt7.h in ar7_wdt.c
Date: Mon, 10 Aug 2009 09:39:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-mips@linux-mips.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Nicolas Thill <nico@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>,
       Enrik Berkhan <Enrik.Berkhan@akk.org>
References: <1249888074-20784-1-git-send-email-wuzhangjin@gmail.com>
In-Reply-To: <1249888074-20784-1-git-send-email-wuzhangjin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908100939.40963.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wu,

Le Monday 10 August 2009 09:07:54 Wu Zhangjin, vous avez écrit :
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>

Thanks, but that was sent a while ago to Wim Van Sebroeck who is the watchdog 
subsystem maintainer.

> ---
>  drivers/watchdog/ar7_wdt.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/watchdog/ar7_wdt.c b/drivers/watchdog/ar7_wdt.c
> index 3fe9742..ec48e12 100644
> --- a/drivers/watchdog/ar7_wdt.c
> +++ b/drivers/watchdog/ar7_wdt.c
> @@ -37,7 +37,7 @@
>  #include <linux/uaccess.h>
>
>  #include <asm/addrspace.h>
> -#include <asm/ar7/ar7.h>
> +#include <ar7.h>
>
>  #define DRVNAME "ar7_wdt"
>  #define LONGNAME "TI AR7 Watchdog Timer"



-- 
Best regards, Florian Fainelli
Email: florian@openwrt.org
Web: http://openwrt.org
IRC: [florian] on irc.freenode.net
-------------------------------
