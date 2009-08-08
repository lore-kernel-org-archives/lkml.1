Return-Path: <linux-kernel-owner+w=401wt.eu-S1757149AbZHHA31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757149AbZHHA31 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 20:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756335AbZHHA30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 20:29:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:51886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756154AbZHHA3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 20:29:25 -0400
Date: Sat, 8 Aug 2009 02:29:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Henning Glawe <glaweh@debian.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Ignore Philips IEEE802.15.4 RF Dongle in hid-core
In-Reply-To: <20090802201812.GA5631@ruprecht.physik.fu-berlin.de>
Message-ID: <alpine.LNX.2.00.0908080229100.25797@wotan.suse.de>
References: <20090802201812.GA5631@ruprecht.physik.fu-berlin.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Aug 2009, Henning Glawe wrote:

> This usb device claims to be of HID class, but is in fact a 802.15.4
> lowpan transceiver, therefore the generic HID driver cannot operate this
> device. A separate driver for this device will be written for this using
> the new 802.15.4 stack.
> 
>  Signed-off-by: Henning Glawe <glaweh@debian.org>
> ---
>  drivers/hid/hid-core.c |    1 +
>  drivers/hid/hid-ids.h  |    3 +++
>  2 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
> index 8551693..7755949 100644
> --- a/drivers/hid/hid-core.c
> +++ b/drivers/hid/hid-core.c
> @@ -1618,6 +1618,7 @@ static const struct hid_device_id hid_ignore_list[] = {
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0002) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0003) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_PANJIT, 0x0004) },
> +	{ HID_USB_DEVICE(USB_VENDOR_ID_PHILIPS, USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_POWERCOM, USB_DEVICE_ID_POWERCOM_UPS) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD) },
>  	{ HID_USB_DEVICE(USB_VENDOR_ID_SOUNDGRAPH, USB_DEVICE_ID_SOUNDGRAPH_IMON_LCD2) },
> diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
> index 4d5ee2b..7f59854 100644
> --- a/drivers/hid/hid-ids.h
> +++ b/drivers/hid/hid-ids.h
> @@ -359,6 +359,9 @@
>  #define USB_VENDOR_ID_PETALYNX		0x18b1
>  #define USB_DEVICE_ID_PETALYNX_MAXTER_REMOTE	0x0037
>  
> +#define USB_VENDOR_ID_PHILIPS       0x0471
> +#define USB_DEVICE_ID_PHILIPS_IEEE802154_DONGLE 0x0617
> +
>  #define USB_VENDOR_ID_PLAYDOTCOM	0x0b43
>  #define USB_DEVICE_ID_PLAYDOTCOM_EMS_USBII	0x0003

Appplied, thanks Henning.

-- 
Jiri Kosina
SUSE Labs
