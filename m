Return-Path: <linux-kernel-owner+w=401wt.eu-S1751240AbXDKIbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbXDKIbN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 04:31:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751260AbXDKIbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 04:31:12 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:3448 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXDKIbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 04:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type;
        b=EXIpcXKu4rv5KeYW29m5h5vUaQssvJJ6b7J5aBWHEOGJpp3u4Llvr6uNcS/BhGQGEjxhFH0i9XyeZdiRVO+4lv8wlF13hhzvdJKLVh+XoIR1wr2M+MMM1Wlv4IxrxUcHWGI4PDwaesiaO0kR7fvNHueLqshc7bJ4RA9UbhWg1Ec=
Date: Wed, 11 Apr 2007 10:30:56 +0200 (CEST)
From: Esben Nielsen <nielsen.esben@googlemail.com>
X-X-Sender: simlo@frodo.shire
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 20/30] Use menuconfig objects - ARCNET
In-Reply-To: <Pine.LNX.4.61.0704102329540.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704111014330.13800@frodo.shire>
References: <Pine.LNX.4.61.0704102046520.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.61.0704102329540.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Jan Engelhardt wrote:

>
> (Wow, not a single MODULE_AUTHOR line in drivers/net/arcnet/ ...)


ArcNet is old. Almost nobody is using it anymore. I used it at my former 
job, since we used it as control network. A lot of companies still does 
quitely, but not in combination with Linux.

>
> Use menuconfigs instead of menus, so the whole menu can be disabled at
> once instead of going through all options.
>
> Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
>
> Index: linux-2.6.21-rc5/drivers/net/arcnet/Kconfig
> ===================================================================
> --- linux-2.6.21-rc5.orig/drivers/net/arcnet/Kconfig
> +++ linux-2.6.21-rc5/drivers/net/arcnet/Kconfig
> @@ -2,10 +2,8 @@
> # Arcnet configuration
> #
>
> -menu "ARCnet devices"
> +menuconfig ARCNET
> 	depends on NETDEVICES && (ISA || PCI)

Why does it depend on ISA || PCI ? People tend to forget the PCMCIA 
driver. And in principle you could enable the ArcNet framework without 
using any of the drivers in the kernel tree.


Esben

