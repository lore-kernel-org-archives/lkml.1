Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYDDFqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYDDFqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 01:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYDDFqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 01:46:04 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59864 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783AbYDDFqD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 01:46:03 -0400
Message-ID: <47F5C097.9010801@pobox.com>
Date: Fri, 04 Apr 2008 01:45:59 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] net/tokenring/olympic.c section fixes
References: <20080330224004.GC28445@cs181133002.pp.htv.fi>
In-Reply-To: <20080330224004.GC28445@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> My previous section fix only turned one section problem into another 
> section problem.
> 
> This patch fixes it for real.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
>  drivers/net/tokenring/olympic.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> 59aa404d6b07f60a839e06f3dc772c9de63f5eea diff --git a/drivers/net/tokenring/olympic.c b/drivers/net/tokenring/olympic.c
> index 433c994..df2bbd7 100644
> --- a/drivers/net/tokenring/olympic.c
> +++ b/drivers/net/tokenring/olympic.c
> @@ -117,7 +117,7 @@
>   * Official releases will only have an a.b.c version number format. 
>   */
>  
> -static char version[] __devinitdata = 
> +static char version[] = 
>  "Olympic.c v1.0.5 6/04/02 - Peter De Schrijver & Mike Phillips" ; 
>  
>  static char *open_maj_error[]  = {"No error", "Lobe Media Test", "Physical Insertion",
> @@ -290,7 +290,7 @@ op_disable_dev:
>  	return i;
>  }
>  
> -static int __devinit olympic_init(struct net_device *dev)
> +static int olympic_init(struct net_device *dev)
>  {
>      	struct olympic_private *olympic_priv;
>  	u8 __iomem *olympic_mmio, *init_srb,*adapter_addr;
> @@ -434,7 +434,7 @@ static int __devinit olympic_init(struct net_device *dev)
>  
>  }
>  
> -static int __devinit olympic_open(struct net_device *dev) 
> +static int olympic_open(struct net_device *dev) 
>  {
>  	struct olympic_private *olympic_priv=netdev_priv(dev);
>  	u8 __iomem *olympic_mmio=olympic_priv->olympic_mmio,*init_srb;

applied


