Return-Path: <linux-kernel-owner+w=401wt.eu-S1761608AbXGUSny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761608AbXGUSny (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 14:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXGUSnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 14:43:45 -0400
Received: from smtp107.sbc.mail.mud.yahoo.com ([68.142.198.206]:43242 "HELO
	smtp107.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753536AbXGUSno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 14:43:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=kSXrdW0JetckS/q9Nskb+1WG6LNinHcQAFBmedb3snnS3p3nJwBDxPvCeBfwJEhEYlsftodOLt3VB+u0LROj0sUvCFWlzlbIhsUTvbQFixic+4LxLQxLCCkyJ0Ua6uYqVI1QH48FlcBqpMefP7cYg2uwrK8RpcpYdkncLEg93zk=  ;
X-YMail-OSG: ms4XIJ4VM1lk1D0V37H2RPvKBBilyluvcOaKaETdSafiRfzkeYhBONWpQG9q.r_lmQWzUO0JeQ--
From: David Brownell <david-b@pacbell.net>
To: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][14/37] Clean up duplicate includes in drivers/spi/
Date: Sat, 21 Jul 2007 11:24:52 -0700
User-Agent: KMail/1.9.6
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       spi-devel-general@lists.sourceforge.net, Nicolas Pitre <nico@cam.org>,
       Aubrey Li <aubrey.li@analog.com>
References: <200707211702.56466.jesper.juhl@gmail.com>
In-Reply-To: <200707211702.56466.jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707211124.53195.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 July 2007, Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	drivers/spi/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>

ACK ... although, on general principles I suspect there are more
needless includes to remove, these are just especially obvious.  :)


> ---
> 
> diff --git a/drivers/spi/pxa2xx_spi.c b/drivers/spi/pxa2xx_spi.c
> index e51311b..16bf66b 100644
> --- a/drivers/spi/pxa2xx_spi.c
> +++ b/drivers/spi/pxa2xx_spi.c
> @@ -26,7 +26,6 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/spi/spi.h>
>  #include <linux/workqueue.h>
> -#include <linux/errno.h>
>  #include <linux/delay.h>
>  
>  #include <asm/io.h>
> diff --git a/drivers/spi/spi_bfin5xx.c b/drivers/spi/spi_bfin5xx.c
> index 48587c2..88362b4 100644
> --- a/drivers/spi/spi_bfin5xx.c
> +++ b/drivers/spi/spi_bfin5xx.c
> @@ -39,7 +39,6 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/spi/spi.h>
>  #include <linux/workqueue.h>
> -#include <linux/errno.h>
>  #include <linux/delay.h>
>  
>  #include <asm/io.h>
> 


