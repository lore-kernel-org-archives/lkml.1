Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807Ab0AFKOl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807Ab0AFKOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:14:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755713Ab0AFKOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:14:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51600 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755646Ab0AFKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:14:39 -0500
Date: Wed, 6 Jan 2010 11:14:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Christian Schuerer <csw@xray.at>
Cc: Jiri Slaby <jirislaby@gmail.com>, linux-input@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] linux-2.6.33-rc2 - Re: Device IDs for new Apple Wireless
 Keyboard
In-Reply-To: <201001060216.47958.csw@xray.at>
Message-ID: <alpine.LNX.2.00.1001061113060.2277@pobox.suse.cz>
References: <4B38AFDE.8000203@gmail.com> <alpine.LNX.2.00.1001041155560.2277@pobox.suse.cz> <201001060216.47958.csw@xray.at>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Christian Schuerer wrote:

> here is the patch for linux-2.6.33-rc2:

Thanks. Unfortunately, it's wordwrapped, so it can't be easily applied. 
Could you please fix up your e-mail client so that it doesn't mangle long 
lines, or eventually send is as an attachment?

> Added device IDs for the new model of the Apple Wireless Keyboard (November 
> 2009).
> 
> Signed-off-by: Christian Schuerer-Waldheim <csw@xray.at>
> 
> diff -uprN -X linux-2.6.33-rc2-vanilla/Documentation/dontdiff linux-2.6.33-
> rc2-vanilla/drivers/hid/hid-apple.c linux-2.6.33-rc2-apple/drivers/hid/hid-
> apple.c
> --- linux-2.6.33-rc2-vanilla/drivers/hid/hid-apple.c	2009-12-24 
> 22:09:41.000000000 +0100
> +++ linux-2.6.33-rc2-apple/drivers/hid/hid-apple.c	2010-01-06 
> 01:39:29.000000000 +0100
> @@ -431,6 +431,13 @@ static const struct hid_device_id apple_
>  		.driver_data = APPLE_HAS_FN | APPLE_ISO_KEYBOARD },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, 
> USB_DEVICE_ID_APPLE_WELLSPRING3_JIS),
>  		.driver_data = APPLE_HAS_FN | APPLE_RDESC_JIS },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
> USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ANSI),
> +		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
> USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_ISO),
> +		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN |
> +			APPLE_ISO_KEYBOARD },
> +	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_APPLE, 
> USB_DEVICE_ID_APPLE_ALU_WIRELESS_2009_JIS),
> +		.driver_data = APPLE_NUMLOCK_EMULATION | APPLE_HAS_FN },

These are solely Bluetooth device, and there is no USB variant, right?

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
