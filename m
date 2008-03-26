Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbYCZDUh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbYCZDUh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 23:20:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYCZDUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 23:20:24 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43412 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752253AbYCZDUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 23:20:23 -0400
Message-ID: <47E9C0F2.20403@garzik.org>
Date: Tue, 25 Mar 2008 23:20:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Thomas Klein <osstklei@de.ibm.com>
CC: Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Hannes Hering <hering2@de.ibm.com>
Subject: Re: [PATCH] ehea: Fix IPv6 support
References: <200803191355.44266.osstklei@de.ibm.com>
In-Reply-To: <200803191355.44266.osstklei@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Klein wrote:
> Indicate that HEA calculates IPv4 checksums only
> 
> Signed-off-by: Thomas Klein <tklein@de.ibm.com>
> 
> ---
> diff -Nurp -X dontdiff linux-2.6.25-rc6/drivers/net/ehea/ehea.h patched_kernel/drivers/net/ehea/ehea.h
> --- linux-2.6.25-rc6/drivers/net/ehea/ehea.h	2008-03-17 00:32:14.000000000 +0100
> +++ patched_kernel/drivers/net/ehea/ehea.h	2008-03-19 08:58:07.000000000 +0100
> @@ -40,7 +40,7 @@
>  #include <asm/io.h>
>  
>  #define DRV_NAME	"ehea"
> -#define DRV_VERSION	"EHEA_0087"
> +#define DRV_VERSION	"EHEA_0089"
>  
>  /* eHEA capability flags */
>  #define DLPAR_PORT_ADD_REM 1
> diff -Nurp -X dontdiff linux-2.6.25-rc6/drivers/net/ehea/ehea_main.c patched_kernel/drivers/net/ehea/ehea_main.c
> --- linux-2.6.25-rc6/drivers/net/ehea/ehea_main.c	2008-03-17 00:32:14.000000000 +0100
> +++ patched_kernel/drivers/net/ehea/ehea_main.c	2008-03-19 08:58:07.000000000 +0100
> @@ -3108,7 +3108,7 @@ struct ehea_port *ehea_setup_single_port
>  	dev->vlan_rx_add_vid = ehea_vlan_rx_add_vid;
>  	dev->vlan_rx_kill_vid = ehea_vlan_rx_kill_vid;
>  	dev->features = NETIF_F_SG | NETIF_F_FRAGLIST | NETIF_F_TSO
> -		      | NETIF_F_HIGHDMA | NETIF_F_HW_CSUM | NETIF_F_HW_VLAN_TX
> +		      | NETIF_F_HIGHDMA | NETIF_F_IP_CSUM | NETIF_F_HW_VLAN_TX
>  		      | NETIF_F_HW_VLAN_RX | NETIF_F_HW_VLAN_FILTER

applied


