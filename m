Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab0BBWHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 17:07:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34944 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399Ab0BBWHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 17:07:21 -0500
Date: Tue, 2 Feb 2010 23:07:19 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, don@syst.com.br, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] HID: use multi input quirk for eTurboTouch touchscreen
In-Reply-To: <1265141347-7541-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1002022307020.15395@pobox.suse.cz>
References: <1265141347-7541-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Feb 2010, Thadeu Lima de Souza Cascardo wrote:

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
> index adbef5d..e99485f 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -164,6 +164,9 @@
>  #define USB_VENDOR_ID_ESSENTIAL_REALITY	0x0d7f
>  #define USB_DEVICE_ID_ESSENTIAL_REALITY_P5 0x0100
>  
> +#define USB_VENDOR_ID_ETURBOTOUCH	0x22b9
> +#define USB_DEVICE_ID_ETURBOTOUCH	0x0006
> +
>  #define USB_VENDOR_ID_EZKEY 		0x0518
>  #define USB_DEVICE_ID_BTC_8193		0x0002
>  
> diff --git a/drivers/hid/usbhid/hid-quirks.c b/drivers/hid/usbhid/hid-quirks.c
> index 0d9045a..edc598d 100644
> --- a/drivers/hid/usbhid/hid-quirks.c
> +++ b/drivers/hid/usbhid/hid-quirks.c
> @@ -42,6 +42,7 @@ static const struct hid_blacklist {
>  
>  	{ USB_VENDOR_ID_AFATECH, USB_DEVICE_ID_AFATECH_AF9016, HID_QUIRK_FULLSPEED_INTERVAL },
>  
> +	{ USB_VENDOR_ID_ETURBOTOUCH, USB_DEVICE_ID_ETURBOTOUCH, HID_QUIRK_MULTI_INPUT },
>  	{ USB_VENDOR_ID_PANTHERLORD, USB_DEVICE_ID_PANTHERLORD_TWIN_USB_JOYSTICK, HID_QUIRK_MULTI_INPUT | HID_QUIRK_SKIP_OUTPUT_REPORTS },
>  	{ USB_VENDOR_ID_PLAYDOTCOM, USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII, HID_QUIRK_MULTI_INPUT },

Applied to my tree, thank you.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
