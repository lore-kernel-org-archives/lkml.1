Return-Path: <linux-kernel-owner+w=401wt.eu-S1765030AbYEOVnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765030AbYEOVnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122AbYEOVnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:43:22 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:38220 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857AbYEOVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:43:21 -0400
Date: Thu, 15 May 2008 14:43:13 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: "Christophe Jaillet" <christophe.jaillet@wanadoo.fr>
Cc: "cj" <christophe.jaillet@wanadoo.fr>,
       "linux" <linux-kernel@vger.kernel.org>,
       <florian.fainelli@telecomint.eu>, <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] /drivers/net/r6040.c: bad use of round_jiffies()
 ???
Message-ID: <20080515144313.524d199d@infradead.org>
In-Reply-To: <20080515212624.D56371C00093@mwinf2723.orange.fr>
References: <20080515212624.D56371C00093@mwinf2723.orange.fr>
Organization: Intel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008 23:26:22 +0200
"Christophe Jaillet" <christophe.jaillet@wanadoo.fr> wrote:

> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/net/r6040.c.
> 
> Compared to other places in the kernel, I think that this driver
> misuses the function round_jiffies.
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> ---
> 
> --- linux 2.6.25/drivers/net/r6040.c	2008-05-15
> 23:21:28.000000000 +0200 +++ linux
> 2.6.25/drivers/net/r6040.c.cj	2008-05-15 22:16:44.000000000
> +0200 @@ -733,7 +733,7 @@ static void r6040_timer(unsigned long da }
>  
>  	/* Timer active again */
> -	mod_timer(&lp->timer, jiffies + round_jiffies(HZ));
> +	mod_timer(&lp->timer, round_jiffies(jiffies + HZ));
>  }
>  

good catch!
Acked-by: Arjan van de Ven <arjan@linux.intel.com>
