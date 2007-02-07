Return-Path: <linux-kernel-owner+w=401wt.eu-S965677AbXBGQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965677AbXBGQ42 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 11:56:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161369AbXBGQ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 11:56:28 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:16164 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965677AbXBGQ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 11:56:27 -0500
Message-ID: <45CA0373.5080508@oracle.com>
Date: Wed, 07 Feb 2007 08:50:59 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Esben Nielsen <nielsen.esben@googlemail.com>
CC: Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, linux-net@vger.kernel.org
Subject: Re: [PATCH] Broken ArcNet com20020 pcmcia driver in 2.6.20
References: <Pine.LNX.4.64.0702071418440.31566@frodo.shire>
In-Reply-To: <Pine.LNX.4.64.0702071418440.31566@frodo.shire>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Esben Nielsen wrote:
> Hi,
>  I can not get my com20020 pcmcia driver to work as a module under 2.6.20.
> There is the build problem:

Please send me your .config file.  I can't seem to reproduce this.

> MODPOST 30 modules
> WARNING: "com20020_found" [drivers/net/pcmcia/com20020_cs.ko] undefined!
> WARNING: "com20020_check" [drivers/net/pcmcia/com20020_cs.ko] undefined!
> 
> The solution:
> Always export com20020_found and com20020_check.
> 
> Esben
> 
>  drivers/net/arcnet/com20020.c |    3 ---
>  1 file changed, 3 deletions(-)
> 
> Index: linux-2.6.20/drivers/net/arcnet/com20020.c
> ===================================================================
> --- linux-2.6.20.orig/drivers/net/arcnet/com20020.c
> +++ linux-2.6.20/drivers/net/arcnet/com20020.c
> @@ -337,11 +337,8 @@ static void com20020_set_mc_list(struct
>      }
>  }
> 
> -#if defined(CONFIG_ARCNET_COM20020_PCI_MODULE) || \
> -    defined(CONFIG_ARCNET_COM20020_ISA_MODULE)
>  EXPORT_SYMBOL(com20020_check);
>  EXPORT_SYMBOL(com20020_found);
> -#endif
> 
>  MODULE_LICENSE("GPL");

-- 
~Randy
