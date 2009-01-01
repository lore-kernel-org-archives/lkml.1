Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbZAAV6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbZAAV6T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 16:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbZAAV6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 16:58:08 -0500
Received: from mail.gmx.net ([213.165.64.20]:38535 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750741AbZAAV6H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 16:58:07 -0500
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18LKzdKOzALfztfxmjYLI7kHtcEY+aLMpAgFAQYN9
	CEPs5hAvrXQhJ8
Date: Thu, 1 Jan 2009 22:58:07 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH] spi.h uses/needs device.h
In-Reply-To: <495AF348.9080105@oracle.com>
Message-ID: <Pine.LNX.4.64.0901012244480.8412@axis700.grange>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
 <495AF348.9080105@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Dec 2008, Randy Dunlap wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Include header files as used/needed:

This duplicates an earlier one:

http://sourceforge.net/mailarchive/forum.php?thread_name=Pine.LNX.4.64.0811251750410.6290%40axis700.grange&forum_name=spi-devel-general

Thanks
Guennadi

> 
> In file included from mmotm-2008-1230-1605/drivers/leds/leds-dac124s085.c:16:
> mmotm-2008-1230-1605/include/linux/spi/spi.h:66: error: field 'dev' has incomplete type
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'to_spi_device':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:100: warning: type defaults to 'int' in declaration of '__mptr'
> mmotm-2008-1230-1605/include/linux/spi/spi.h:100: warning: initialization from incompatible pointer type
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_dev_get':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:106: error: implicit declaration of function 'get_device'
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_dev_put':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:112: error: implicit declaration of function 'put_device'
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_set_drvdata':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:130: error: implicit declaration of function 'dev_set_drvdata'
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_get_drvdata':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:135: error: implicit declaration of function 'dev_get_drvdata'
> mmotm-2008-1230-1605/include/linux/spi/spi.h:135: warning: return makes pointer from integer without a cast
> mmotm-2008-1230-1605/include/linux/spi/spi.h: At top level:
> mmotm-2008-1230-1605/include/linux/spi/spi.h:172: error: expected declaration specifiers or '...' before 'pm_message_t'
> mmotm-2008-1230-1605/include/linux/spi/spi.h:174: error: field 'driver' has incomplete type
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'to_spi_driver':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:179: warning: type defaults to 'int' in declaration of '__mptr'
> mmotm-2008-1230-1605/include/linux/spi/spi.h:179: warning: initialization from incompatible pointer type
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_unregister_driver':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:192: error: implicit declaration of function 'driver_unregister'
> mmotm-2008-1230-1605/include/linux/spi/spi.h: At top level:
> mmotm-2008-1230-1605/include/linux/spi/spi.h:225: error: field 'dev' has incomplete type
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_master_get_devdata':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:271: warning: return makes pointer from integer without a cast
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_message_alloc':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:494: error: implicit declaration of function 'kzalloc'
> mmotm-2008-1230-1605/include/linux/spi/spi.h:496: warning: assignment makes pointer from integer without a cast
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_message_free':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:510: error: implicit declaration of function 'kfree'
> mmotm-2008-1230-1605/include/linux/spi/spi.h: In function 'spi_unregister_device':
> mmotm-2008-1230-1605/include/linux/spi/spi.h:801: error: implicit declaration of function 'device_unregister'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/linux/spi/spi.h |    2 ++
>  1 file changed, 2 insertions(+)
> 
> --- mmotm-2008-1230-1605.orig/include/linux/spi/spi.h
> +++ mmotm-2008-1230-1605/include/linux/spi/spi.h
> @@ -19,6 +19,8 @@
>  #ifndef __LINUX_SPI_H
>  #define __LINUX_SPI_H
>  
> +#include <linux/device.h>
> +
>  /*
>   * INTERFACES between SPI master-side drivers and SPI infrastructure.
>   * (There's no SPI slave support for Linux yet...)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
