Return-Path: <linux-kernel-owner+w=401wt.eu-S933902AbYD3Xjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933902AbYD3Xjp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 19:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761028AbYD3XjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 19:39:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43462 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759471AbYD3XjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 19:39:18 -0400
Date: Thu, 1 May 2008 00:31:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/10] net: fix returning void-valued expression
 warnings
Message-ID: <20080501003121.6b13f561@core>
In-Reply-To: <1209593023.24729.117.camel@brick>
References: <1209593023.24729.117.camel@brick>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --- a/drivers/net/8390.c
> +++ b/drivers/net/8390.c
> @@ -34,7 +34,7 @@ struct net_device *__alloc_ei_netdev(int size)
>  
>  void NS8390_init(struct net_device *dev, int startp)
>  {
> -	return __NS8390_init(dev, startp);
> +	__NS8390_init(dev, startp);
>  }
>  
>  EXPORT_SYMBOL(ei_open);

Acked-by: Alan Cox <alan@redhat.com>

A
