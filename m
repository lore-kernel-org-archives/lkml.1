Return-Path: <linux-kernel-owner+w=401wt.eu-S1753024AbZGVJyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024AbZGVJyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752754AbZGVJyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:54:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900AbZGVJyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:54:51 -0400
Date: Wed, 22 Jul 2009 11:54:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Peng Huang <shawn.p.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-usb@vger.kernel.org
Subject: Re: Add ZTE AC8710 usb modem device.
In-Reply-To: <1248234015-13353-1-git-send-email-shawn.p.huang@gmail.com>
Message-ID: <alpine.LRH.2.00.0907221153410.27150@twin.jikos.cz>
References: <1248234015-13353-1-git-send-email-shawn.p.huang@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ proper CCs added ]

On Wed, 22 Jul 2009, Peng Huang wrote:

> 
> Signed-off-by: Peng Huang <shawn.p.huang@gmail.com>
> ---
>  drivers/usb/serial/option.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
> index 98262dd..1b35c24 100644
> --- a/drivers/usb/serial/option.c
> +++ b/drivers/usb/serial/option.c
> @@ -301,6 +301,7 @@ static int  option_resume(struct usb_serial *serial);
>  #define ZTE_PRODUCT_MF628			0x0015
>  #define ZTE_PRODUCT_MF626			0x0031
>  #define ZTE_PRODUCT_CDMA_TECH			0xfffe
> +#define ZTE_PRODUCT_AC8710			0xfff1
>  
>  #define BENQ_VENDOR_ID				0x04a5
>  #define BENQ_PRODUCT_H10			0x4068
> @@ -538,6 +539,7 @@ static struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF626) },
>  	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_MF628) },
>  	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_CDMA_TECH) },
> +	{ USB_DEVICE(ZTE_VENDOR_ID, ZTE_PRODUCT_AC8710) },
>  	{ USB_DEVICE(BENQ_VENDOR_ID, BENQ_PRODUCT_H10) },
>  	{ USB_DEVICE(DLINK_VENDOR_ID, DLINK_PRODUCT_DWM_652) },
>  	{ USB_DEVICE(QISDA_VENDOR_ID, QISDA_PRODUCT_H21_4512) },
> 

-- 
Jiri Kosina
SUSE Labs

