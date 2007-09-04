Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbXIFMGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbXIFMGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 08:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751077AbXIFMF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 08:05:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:59734 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbXIFMF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 08:05:56 -0400
Subject: Re: [Linux-fbdev-devel] [PATCH 1/4] radeonfb: add PCI Id for
	RS482/Radeon Xpress 200M
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070904105831.GE7320@devil>
References: <20070904105831.GE7320@devil>
Content-Type: text/plain
Date: Tue, 04 Sep 2007 15:45:12 +0200
Message-Id: <1188913512.5972.147.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-04 at 12:58 +0200, aherrman@arcor.de wrote:
> .. which can be found in Acer Aspire 5100.
> 
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> ---
>  drivers/video/aty/ati_ids.h     |    1 +
>  drivers/video/aty/radeon_base.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/video/aty/ati_ids.h b/drivers/video/aty/ati_ids.h
> index 685a754..648da1e 100644
> --- a/drivers/video/aty/ati_ids.h
> +++ b/drivers/video/aty/ati_ids.h
> @@ -211,3 +211,4 @@
>  #define PCI_CHIP_RS350_7834             0x7834
>  #define PCI_CHIP_RS350_7835             0x7835
>  #define PCI_CHIP_RS480_5955             0x5955
> +#define PCI_CHIP_RS482_5975             0x5975
> diff --git a/drivers/video/aty/radeon_base.c b/drivers/video/aty/radeon_base.c
> index 47ca62f..90a3957 100644
> --- a/drivers/video/aty/radeon_base.c
> +++ b/drivers/video/aty/radeon_base.c
> @@ -102,6 +102,7 @@
>  static struct pci_device_id radeonfb_pci_table[] = {
>          /* Radeon Xpress 200m */
>  	CHIP_DEF(PCI_CHIP_RS480_5955,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
> +	CHIP_DEF(PCI_CHIP_RS482_5975,   RS480,  CHIP_HAS_CRTC2 | CHIP_IS_IGP | CHIP_IS_MOBILITY),
>  	/* Mobility M6 */
>  	CHIP_DEF(PCI_CHIP_RADEON_LY, 	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),
>  	CHIP_DEF(PCI_CHIP_RADEON_LZ,	RV100,	CHIP_HAS_CRTC2 | CHIP_IS_MOBILITY),

