Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab0BDXka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 18:40:30 -0500
Received: from mail.vyatta.com ([76.74.103.46]:58019 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933112Ab0BDXk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 18:40:27 -0500
Date: Thu, 4 Feb 2010 15:40:04 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: "Ha, Tristram" <Tristram.Ha@Micrel.Com>
Cc: "Dave Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2.6.33 4/4] net: Add PCI vendor and device ids for
 Micrel KSZ8841/2 PCI devices
Message-ID: <20100204154004.44e3d607@nehalam>
In-Reply-To: <14385191E87B904DBD836449AA30269D021A55@MORGANITE.micrel.com>
References: <14385191E87B904DBD836449AA30269D021A55@MORGANITE.micrel.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010 15:28:29 -0800
"Ha, Tristram" <Tristram.Ha@Micrel.Com> wrote:

> From: Tristram Ha <Tristram.Ha@micrel.com>
> 
> Add PCI vendor and device ids for Micrel KSZ8841/2 PCI devices.
> 
> Signed-off-by: Tristram Ha <Tristram.Ha@micrel.com>
> ---
> This is a resubmission of the Micrel KSZ8841/2 PCI Ethernet driver.
> 
> --- linux-2.6.33-rc5.old/include/linux/pci_ids.h	2010-01-21 15:31:35.000000000 -0800
> +++ linux-2.6.33-rc5.new/include/linux/pci_ids.h	2010-01-29 10:38:53.000000000 -0800
> @@ -2199,6 +2199,12 @@
>  #define PCI_VENDOR_ID_NETCELL		0x169c
>  #define PCI_DEVICE_ID_REVOLUTION	0x0044
>  
> +#define PCI_VENDOR_ID_MICREL_KS		0x16c6
> +#define PCI_DEVICE_ID_MICREL_KS8692	0x8692
> +#define PCI_DEVICE_ID_MICREL_KS8695	0x8695
> +#define PCI_DEVICE_ID_MICREL_KS8841	0x8841
> +#define PCI_DEVICE_ID_MICREL_KS8842	0x8842
> +
>  #define PCI_VENDOR_ID_CENATEK		0x16CA
>  #define PCI_DEVICE_ID_CENATEK_IDE	0x0001
>  

Current practice is to NOT update this file and instead
keep constants in the individual driver.
