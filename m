Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933032Ab0BDVxa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 16:53:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab0BDVx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 16:53:28 -0500
Subject: Re: [PATCH -next] libertas/if_spi: needs linux/semaphore.h
From: Dan Williams <dcbw@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       Andrey Yurovsky <andrey@cozybit.com>, Colin McCabe <colin@cozybit.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20100203153107.28184ef0.randy.dunlap@oracle.com>
References: <20100203172625.c9340392.sfr@canb.auug.org.au>
	 <20100203153107.28184ef0.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Feb 2010 13:52:57 -0800
Message-ID: <1265320377.4290.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 15:31 -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> libertas/if_spi.c needs to #include linux/semaphore.h to fix build errors:
> 
> drivers/net/wireless/libertas/if_spi.c:59: error: field 'spi_ready' has incomplete type
> drivers/net/wireless/libertas/if_spi.c:60: error: field 'spi_thread_terminated' has incomplete type
> drivers/net/wireless/libertas/if_spi.c:785: error: implicit declaration of function 'down_interruptible'
> drivers/net/wireless/libertas/if_spi.c:787: error: implicit declaration of function 'up'
> drivers/net/wireless/libertas/if_spi.c:834: error: implicit declaration of function 'down'
> drivers/net/wireless/libertas/if_spi.c:943: error: implicit declaration of function 'sema_init'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/if_spi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20100203.orig/drivers/net/wireless/libertas/if_spi.c
> +++ linux-next-20100203/drivers/net/wireless/libertas/if_spi.c
> @@ -23,6 +23,7 @@
>  #include <linux/kthread.h>
>  #include <linux/list.h>
>  #include <linux/netdevice.h>
> +#include <linux/semaphore.h>
>  #include <linux/spi/libertas_spi.h>
>  #include <linux/spi/spi.h>
>  


