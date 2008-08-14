Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbYHNI3c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbYHNI3c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:29:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755685AbYHNI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:29:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41420 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756076AbYHNI3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:29:06 -0400
Message-ID: <48A3ECCB.4070500@garzik.org>
Date: Thu, 14 Aug 2008 04:28:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Jeff Garzik <jgarzik@redhat.com>, Julia Lawall <julia@diku.dk>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] au1000_eth: use 'unsigned long' for irqflags
References: <20080810134252.GA19751@localhost.localdomain>
In-Reply-To: <20080810134252.GA19751@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vegard Nossum wrote:
>>From a0d915d5e99e752389093b3e1d6cae5ab5438392 Mon Sep 17 00:00:00 2001
> From: Vegard Nossum <vegard.nossum@gmail.com>
> Date: Wed, 6 Aug 2008 14:12:11 +0200
> Subject: [PATCH] au1000_eth: use 'unsigned long' for irqflags
> 
> The patch was generated using the Coccinelle semantic patch framework.
> 
> Cc: Julia Lawall <julia@diku.dk>
> Cc: Alexey Dobriyan <adobriyan@gmail.com>
> Cc: Jeff Garzik <jgarzik@redhat.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
> ---
>  drivers/net/au1000_eth.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/au1000_eth.c b/drivers/net/au1000_eth.c
> index cb8be49..5ee1b05 100644
> --- a/drivers/net/au1000_eth.c
> +++ b/drivers/net/au1000_eth.c
> @@ -807,7 +807,7 @@ err_out:
>  static int au1000_init(struct net_device *dev)
>  {
>  	struct au1000_private *aup = (struct au1000_private *) dev->priv;
> -	u32 flags;
> +	unsigned long flags;
>  	int i;
>  	u32 control;

applied


