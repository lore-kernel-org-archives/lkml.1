Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYHNI3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYHNI3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 04:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754041AbYHNI2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 04:28:55 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41411 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006AbYHNI2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 04:28:54 -0400
Message-ID: <48A3ECBE.9050909@garzik.org>
Date: Thu, 14 Aug 2008 04:28:46 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: khc@pm.waw.pl, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RESEND][PATCH 2.6.27-rc3] ixp4xx_eth: fix dma_mapping_error()
 compile errors
References: <200808131908.m7DJ8EAp013777@harpo.it.uu.se>
In-Reply-To: <200808131908.m7DJ8EAp013777@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> The arm ixp4xx_eth driver doesn't compile in 2.6.27-rc1:
> 
>   CC [M]  drivers/net/arm/ixp4xx_eth.o
> drivers/net/arm/ixp4xx_eth.c: In function 'eth_poll':
> drivers/net/arm/ixp4xx_eth.c:554: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
> drivers/net/arm/ixp4xx_eth.c:554: error: too few arguments to function 'dma_mapping_error'
> drivers/net/arm/ixp4xx_eth.c: In function 'eth_xmit':
> drivers/net/arm/ixp4xx_eth.c:701: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
> drivers/net/arm/ixp4xx_eth.c:701: error: too few arguments to function 'dma_mapping_error'
> drivers/net/arm/ixp4xx_eth.c: In function 'init_queues':
> drivers/net/arm/ixp4xx_eth.c:886: warning: passing argument 1 of 'dma_mapping_error' makes pointer from integer without a cast
> drivers/net/arm/ixp4xx_eth.c:886: error: too few arguments to function 'dma_mapping_error'
> make[3]: *** [drivers/net/arm/ixp4xx_eth.o] Error 1
> make[2]: *** [drivers/net/arm] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> 
> dma_mapping_error() changed in 2.6.27-rc1 to also take a device parameter,
> but nobody bothered updating ixp4xx_eth.c. Fixed by passing the appropriate
> device value in the dma_mapping_error() calls.
> 
> Tested on an ixp425 box.
> 
> Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
> Acked-by: Krzysztof Halasa <khc@pm.waw.pl>
> ---

applied


