Return-Path: <linux-kernel-owner+w=401wt.eu-S932951AbZJIDwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951AbZJIDwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932818AbZJIDwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:52:20 -0400
Received: from mail-gx0-f212.google.com ([209.85.217.212]:47983 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932751AbZJIDwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:52:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=rHG7YZoRhnwfg/P9Qm3Ven4MlE659WmrpU8HT6ZbZARHRHSa1w1Wi8KHvyoSH0ad5y
         w/KUnjsMiQEA/GkAkb72KiCpy+X6sJpGh69EtXh2q6wBabXjBuhYeTi1xl/k3Blex/sB
         sNOIMxMBGq6uXeX8rggLwM45mneGS3kG7TMLM=
Subject: Re: [PATCH] CS5535: Remove the X86 platform dependence of
 SND_CS5535AUDIO
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-mips <linux-mips@linux-mips.org>,
       Andres Salomon <dilinger@debian.org>,
       Jaya Kumar <jayakumar.lkml@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
       loongson-dev@googlegroups.com
In-Reply-To: <1255059842-12160-1-git-send-email-wuzhangjin@gmail.com>
References: <1255059842-12160-1-git-send-email-wuzhangjin@gmail.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 09 Oct 2009 11:51:27 +0800
Message-Id: <1255060287.16819.1.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-09 at 11:44 +0800, Wu Zhangjin wrote:
> There is no platform dependence of SND_CS5535AUDIO before 2.6.31, Not
> sure who have touched this part, but SND_CS5535AUDIO is at least
> available on Loongson family machines, so, Remove the platform
> dependence directly.
> 
> Reported-by: rixed@happyleptic.org
> Signed-off-by: Wu Zhangjin <wuzhangjin@gmail.com>
> ---
>  sound/pci/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
> index fb5ee3c..75c602b 100644
> --- a/sound/pci/Kconfig
> +++ b/sound/pci/Kconfig
> @@ -259,7 +259,6 @@ config SND_CS5530
>  
>  config SND_CS5535AUDIO
>  	tristate "CS5535/CS5536 Audio"
> -	depends on X86 && !X86_64

or use this?

	depends on (X86 && !X86_64) || MIPS

Regards,
	Wu Zhangjin

