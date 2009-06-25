Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZFYFvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZFYFvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751273AbZFYFux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:50:53 -0400
Received: from smtp.knology.net ([24.214.63.101]:40579 "EHLO smtp.knology.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbZFYFuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:50:52 -0400
Subject: Re: [PATCH 12/19] drivers/net: Use PCI_VDEVICE
From: David Dillow <dave@thedillows.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <f746d5c571120f930fb6bb50d8303766573f927d.1245906152.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
	 <f746d5c571120f930fb6bb50d8303766573f927d.1245906152.git.joe@perches.com>
Content-Type: text/plain
Date: Thu, 25 Jun 2009 01:50:54 -0400
Message-Id: <1245909054.22064.33.camel@obelisk.thedillows.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-06-24 at 22:13 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
>  drivers/net/typhoon.c             |   18 +++-----

It's not a huge leap in readability, but whaddayagonnado?

Acked-by: Dave Dillow <dave@thedillows.org>

> diff --git a/drivers/net/typhoon.c b/drivers/net/typhoon.c
> index cf25eb4..c0063c5 100644
> --- a/drivers/net/typhoon.c
> +++ b/drivers/net/typhoon.c
> @@ -215,12 +215,9 @@ static struct typhoon_card_info typhoon_card_info[] __devinitdata = {
>   * bits 12-16 indicate card type: (0) client and (1) server
>   */
>  static struct pci_device_id typhoon_pci_tbl[] = {
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0,TYPHOON_TX },
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990_TX_95,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPHOON_TX95 },
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990_TX_97,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPHOON_TX97 },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990), TYPHOON_TX },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990_TX_95), TYPHOON_TX95 },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990_TX_97), TYPHOON_TX97 },
>  	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990B,
>  	  PCI_ANY_ID, 0x1000, 0, 0, TYPHOON_TXM },
>  	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990B,
> @@ -235,12 +232,9 @@ static struct pci_device_id typhoon_pci_tbl[] = {
>  	  PCI_ANY_ID, 0x2101, 0, 0, TYPHOON_FX95SVR },
>  	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990_FX,
>  	  PCI_ANY_ID, 0x2102, 0, 0, TYPHOON_FX97SVR },
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990SVR95,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPHOON_SVR95 },
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990SVR97,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPHOON_SVR97 },
> -	{ PCI_VENDOR_ID_3COM, PCI_DEVICE_ID_3COM_3CR990SVR,
> -	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, TYPHOON_SVR },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990SVR95), TYPHOON_SVR95 },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990SVR97), TYPHOON_SVR97 },
> +	{ PCI_VDEVICE(3COM, PCI_DEVICE_ID_3COM_3CR990SVR), TYPHOON_SVR },
>  	{ 0, }
>  };
>  MODULE_DEVICE_TABLE(pci, typhoon_pci_tbl);


