Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0BDRqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 12:46:32 -0500
Received: from cantor.suse.de ([195.135.220.2]:53377 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab0BDRq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 12:46:29 -0500
Date: Thu, 4 Feb 2010 18:46:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: don@syst.com.br, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: use multi input quirk for TouchPack touchscreen
In-Reply-To: <1265297785-1906-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1002041845350.15395@pobox.suse.cz>
References: <1265297785-1906-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Feb 2010, Thadeu Lima de Souza Cascardo wrote:

> This device generates ABS_Z and ABS_RX events, while it should be
> generating ABS_X and ABS_Y instead. Using the MULTI_INPUT quirk solves
> this issue.
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> Signed-off-by: Daniel Oliveira Nascimento <don@syst.com.br>
> ---
>  drivers/hid/hid-ids.h           |    3 +++
>  drivers/hid/usbhid/hid-quirks.c |    1 +
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index e99485f..ba39103 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -398,6 +398,9 @@
>  
>  #define USB_VENDOR_ID_THRUSTMASTER	0x044f
>  
> +#define USB_VENDOR_ID_TOUCHPACK		0x1bfd
> +#define USB_DEVIDE_ID_TOUCHPAK_RTS	0x1688
> +

Umm .. there are two typos in this single line. Please compile-test your 
patches before submitting them.

I have fixed it and applied, thanks.

>  #define USB_VENDOR_ID_TOPMAX		0x0663
>  #define USB_DEVICE_ID_TOPMAX_COBRAPAD	0x0103
>  
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index edc598d..b89717d 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -45,6 +45,7 @@ static const struct hid_blacklist {
>  	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
>  	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },
> +	{ USB_VENDOR_ID_TOUCHPACK, USB_DEVICE_ID_TOUCHPACK_RTS, HID_QUIRK_MULTI_INPUT },
>  
>  	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_UC100KM, HID_QUIRK_NOGET },
>  	{ USB_VENDOR_ID_ATEN, USB_DEVICE_ID_ATEN_CS124U, HID_QUIRK_NOGET },
> -- 
> 1.6.6.1
> 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
