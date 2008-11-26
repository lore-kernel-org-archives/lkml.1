Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYKZOyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYKZOyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 09:54:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbYKZOyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 09:54:09 -0500
Received: from styx.suse.cz ([82.119.242.94]:38698 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753818AbYKZOyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 09:54:07 -0500
Date: Wed, 26 Nov 2008 15:54:06 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Scholz <Scholz@fias.uni-frankfurt.de>
cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] HID: Apple alu wireless keyboards are bluetooth
 devices
In-Reply-To: <1227710025-23592-2-git-send-email-Scholz@fias.uni-frankfurt.de>
Message-ID: <alpine.LNX.1.10.0811261553010.19853@jikos.suse.cz>
References: <1227710025-23592-1-git-send-email-Scholz@fias.uni-frankfurt.de> <1227710025-23592-2-git-send-email-Scholz@fias.uni-frankfurt.de>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Jan Scholz wrote:

> Changed HID_USB_DEVICE to HID_BLUETOOTH_DEVICE for the apple alu
> wireless keyboards
> Signed-off-by: Jan Scholz <Scholz@fias.uni-frankfurt.de>
> ---
>  drivers/hid/hid-apple.c |    6 +++---
>  drivers/hid/hid-core.c  |    6 +++---
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
> index 9b97795..aa28aed 100644
> --- a/drivers/hid/hid-apple.c
> +++ b/drivers/hid/hid-apple.c
> @@ -400,12 +400,12 @@ static const struct hid_device_id apple_devices[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_GEYSER4_HF_JIS),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>  			APPLE_RDESC_JIS },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ANSI),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_ISO),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
>  			APPLE_ISO_KEYBOARD },
> -	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_ALU_WIRELESS_JIS),
>  		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_WELLSPRING_ANSI),
>  		.driver_data = APPLE_HAS_FN },

Hi Jan,

shouldn't we rather have both USB and Bluetooth variants?

Thanks,

-- 
Jiri Kosina
SUSE Labs
