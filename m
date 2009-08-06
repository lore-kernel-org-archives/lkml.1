Return-Path: <linux-kernel-owner+w=401wt.eu-S1751366AbZHFEQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751366AbZHFEQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 00:16:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751205AbZHFEQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 00:16:18 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42093 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806AbZHFEQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 00:16:17 -0400
Subject: Re: [PATCH] pci_ids.h: add new Atheros USB vendor ID
From: Marcel Holtmann <marcel@holtmann.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mcgrof@gmail.com,
       zhifeng.cai@atheros.com, stephen.chen@atheros.com
In-Reply-To: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
References: <1249523981-26601-1-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 05 Aug 2009 21:16:10 -0700
Message-Id: <1249532170.21101.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Luiz,

> New Atheros USB devices will use 0x0cf3. The first device
> will be ar9271, for which we are adding support for.
> 
> Cc: zhifeng.cai@atheros.com
> Cc: stephen.chen@atheros.com
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> John, sending this through you as this is only
> specific to wireless, at least at the moment.
> 
>  include/linux/pci_ids.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 73b46b6..27f4e6b 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2170,6 +2170,7 @@
>  #define PCI_DEVICE_ID_BCM1250_HT	0x0002
>  
>  #define PCI_VENDOR_ID_ATHEROS		0x168c
> +#define PCI_VENDOR_ID_ATHEROS_USB	0x0cf3

this is confusing the hell out of me. What are you adding here. A USB
vendor id or a PCI one. Is the ar9271 a PCI device or a USB device?

Regards

Marcel


