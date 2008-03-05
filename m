Return-Path: <linux-kernel-owner+w=401wt.eu-S1764780AbYCEL3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764780AbYCEL3g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754133AbYCEL3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:29:14 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:48346 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754030AbYCEL3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:29:12 -0500
Message-ID: <47CE8405.9000704@garzik.org>
Date: Wed, 05 Mar 2008 06:29:09 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
Subject: Re: [PATCH] ehea: Fix missing Kconfig dependency
References: <200803031352.06322.osstklei@de.ibm.com>
In-Reply-To: <200803031352.06322.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Fixed Kconfig: ehea driver requires sparse mem
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
> diff -Nurp linux-2.6.25-rc3.org/drivers/net/Kconfig linux-2.6.25-rc3/drivers/net/Kconfig
> --- linux-2.6.25-rc3.org/drivers/net/Kconfig	2008-02-24 22:25:54.000000000 +0100
> +++ linux-2.6.25-rc3/drivers/net/Kconfig	2008-03-03 13:36:48.000000000 +0100
> @@ -2513,7 +2513,7 @@ config CHELSIO_T3
>  
>  config EHEA
>  	tristate "eHEA Ethernet support"
> -	depends on IBMEBUS && INET
> +	depends on IBMEBUS && INET && SPARSEMEM
>  	select INET_LRO
>  	---help---

applied


