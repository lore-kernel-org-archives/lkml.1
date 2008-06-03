Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbYFCWnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbYFCWnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 18:43:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYFCWne
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 18:43:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33523 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbYFCWnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 18:43:33 -0400
Message-ID: <4845C8D1.4080808@garzik.org>
Date: Tue, 03 Jun 2008 18:42:25 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Nathan Lynch <ntl@pobox.com>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Hannes Hering <hannes.hering@linux.vnet.ibm.com>, tklein@de.ibm.com,
       themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/2] ehea: remove dependency on MEMORY_HOTPLUG
References: <200805071443.20192.hannes.hering@linux.vnet.ibm.com> <20080528164405.GA4836@localdomain> <200806031007.40162.hannes.hering@linux.vnet.ibm.com> <20080603204908.GB7475@localdomain> <1212527335.23656.2.camel@badari-desktop> <4845B382.20205@garzik.org> <20080603223128.GD7475@localdomain>
In-Reply-To: <20080603223128.GD7475@localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nathan Lynch wrote:
> Now that walk_memory_resource() is available regardless of
> MEMORY_HOTPLUG's setting, this dependency is not needed.
> 
> Signed-off-by: Nathan Lynch <ntl@pobox.com>
> ---
>  drivers/net/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index dd0ec9e..f4182cf 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -2426,7 +2426,7 @@ config CHELSIO_T3
>  
>  config EHEA
>  	tristate "eHEA Ethernet support"
> -	depends on IBMEBUS && INET && SPARSEMEM && MEMORY_HOTPLUG
> +	depends on IBMEBUS && INET && SPARSEMEM
>  	select INET_LRO

ACK, please send via appropriate target for memory hotplug stuff


