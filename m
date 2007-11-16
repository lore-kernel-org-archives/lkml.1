Return-Path: <linux-kernel-owner+w=401wt.eu-S1762337AbXKPV02@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762337AbXKPV02 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 16:26:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbXKPV0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 16:26:19 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:32883 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752502AbXKPV0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 16:26:18 -0500
Message-ID: <473E0AE1.2050904@chelsio.com>
Date: Fri, 16 Nov 2007 13:25:53 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: jeff@garzik.org
CC: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com, wenxiong@us.ibm.com
Subject: Re: [PATCH 2/9] cxgb3 - Use wild card for PCI vendor ID match
References: <20071116192144.31042.69591.stgit@speedy5>
In-Reply-To: <20071116192144.31042.69591.stgit@speedy5>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Nov 2007 21:24:28.0625 (UTC) FILETIME=[11F12C10:01C82897]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Divy Le Ray wrote:
> From: Divy Le Ray <divy@chelsio.com>
>
> Vendor ID is not necessarily set to 1. 
>   
This patch modifies the sub-device id, not the vendor id ...

> Use Vendor Id wild card for PCI device matching
>
> Signed-off-by: Divy Le Ray <divy@chelsio.com>
> ---
>
>  drivers/net/cxgb3/cxgb3_main.c |   24 ++++++++++++------------
>  1 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/net/cxgb3/cxgb3_main.c b/drivers/net/cxgb3/cxgb3_main.c
> index bb0d1c8..d92da8f 100644
> --- a/drivers/net/cxgb3/cxgb3_main.c
> +++ b/drivers/net/cxgb3/cxgb3_main.c
> @@ -76,20 +76,20 @@ enum {
>  
>  #define EEPROM_MAGIC 0x38E2F10C
>  
> -#define CH_DEVICE(devid, ssid, idx) \
> -	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, ssid, 0, 0, idx }
> +#define CH_DEVICE(devid, idx) \
> +	{ PCI_VENDOR_ID_CHELSIO, devid, PCI_ANY_ID, PCI_ANY_ID, 0, 0, idx }
>  
>  static const struct pci_device_id cxgb3_pci_tbl[] = {
> -	CH_DEVICE(0x20, 1, 0),	/* PE9000 */
> -	CH_DEVICE(0x21, 1, 1),	/* T302E */
> -	CH_DEVICE(0x22, 1, 2),	/* T310E */
> -	CH_DEVICE(0x23, 1, 3),	/* T320X */
> -	CH_DEVICE(0x24, 1, 1),	/* T302X */
> -	CH_DEVICE(0x25, 1, 3),	/* T320E */
> -	CH_DEVICE(0x26, 1, 2),	/* T310X */
> -	CH_DEVICE(0x30, 1, 2),	/* T3B10 */
> -	CH_DEVICE(0x31, 1, 3),	/* T3B20 */
> -	CH_DEVICE(0x32, 1, 1),	/* T3B02 */
> +	CH_DEVICE(0x20, 0),	/* PE9000 */
> +	CH_DEVICE(0x21, 1),	/* T302E */
> +	CH_DEVICE(0x22, 2),	/* T310E */
> +	CH_DEVICE(0x23, 3),	/* T320X */
> +	CH_DEVICE(0x24, 1),	/* T302X */
> +	CH_DEVICE(0x25, 3),	/* T320E */
> +	CH_DEVICE(0x26, 2),	/* T310X */
> +	CH_DEVICE(0x30, 2),	/* T3B10 */
> +	CH_DEVICE(0x31, 3),	/* T3B20 */
> +	CH_DEVICE(0x32, 1),	/* T3B02 */
>  	{0,}
>  };
>  
> -
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

