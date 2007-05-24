Return-Path: <linux-kernel-owner+w=401wt.eu-S1753922AbXEXVsV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922AbXEXVsV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:48:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbXEXVsJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:48:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:48384 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbXEXVsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:48:06 -0400
Message-ID: <4656080F.4080006@garzik.org>
Date: Thu, 24 May 2007 17:47:59 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Jan Altenberg <jan.altenberg@linutronix.de>
CC: kim.phillips@freescale.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] Add select PHYLIB to the UCC_GETH Kconfig option
References: <1179926613.3839.47.camel@bender>
In-Reply-To: <1179926613.3839.47.camel@bender>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Altenberg wrote:
> ucc_geth has been migrated to use the common phylib code. So lets add a
> 'select PHYLIB' to the UCC_GETH Kconfig entry.
> 
> Signed-off-by: Jan Altenberg <jan.altenberg@linutronix.de>
> 
> ---
>  drivers/net/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6/drivers/net/Kconfig
> ===================================================================
> --- linux-2.6.orig/drivers/net/Kconfig
> +++ linux-2.6/drivers/net/Kconfig
> @@ -2280,6 +2280,7 @@ config GFAR_NAPI
>  config UCC_GETH
>  	tristate "Freescale QE Gigabit Ethernet"
>  	depends on QUICC_ENGINE
> +	select PHYLIB
>  	select UCC_FAST

Please fix the Kconfig warnings first.

Also, I ask again:  WHO IS THE MAINTAINER OF THIS DRIVER?

I am tired of five independent people patching the same driver.

	Jeff



