Return-Path: <linux-kernel-owner+w=401wt.eu-S1751011AbXCEX1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751011AbXCEX1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:27:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932086AbXCEX1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:27:05 -0500
Received: from rrcs-24-153-217-226.sw.biz.rr.com ([24.153.217.226]:42338 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734AbXCEX1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:27:03 -0500
Subject: Re: [PATCH]: CXGB3 infiniband build fix
From: Steve Wise <swise@opengridcomputing.com>
To: David Miller <davem@davemloft.net>
Cc: rolandd@cisco.com, linux-kernel@vger.kernel.org
In-Reply-To: <20070305.152129.112853008.davem@davemloft.net>
References: <20070305.152129.112853008.davem@davemloft.net>
Content-Type: text/plain
Date: Mon, 05 Mar 2007 17:27:00 -0600
Message-Id: <1173137220.14159.92.camel@stevo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: Steve Wise <swise@opengridcomputing.com>


On Mon, 2007-03-05 at 15:21 -0800, David Miller wrote:
> Uses dma_alloc_coherent() et al. thus needs linux/dma-mapping.h
> include in order to build reliably.
> 
> Noticed on sparc64.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> diff --git a/drivers/infiniband/hw/cxgb3/cxio_hal.c b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> index d737c73..818cf1a 100644
> --- a/drivers/infiniband/hw/cxgb3/cxio_hal.c
> +++ b/drivers/infiniband/hw/cxgb3/cxio_hal.c
> @@ -36,6 +36,7 @@
>  #include <linux/sched.h>
>  #include <linux/spinlock.h>
>  #include <linux/pci.h>
> +#include <linux/dma-mapping.h>
>  
>  #include "cxio_resource.h"
>  #include "cxio_hal.h"

