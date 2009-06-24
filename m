Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbZFXWMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbZFXWMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752134AbZFXWMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:12:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52823 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751861AbZFXWMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:12:09 -0400
Date: Thu, 25 Jun 2009 00:12:07 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: rubenatch <rubenatch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: Supporting rumble in another Thrustmaster gamepad
In-Reply-To: <4A4266CC.5000005@gmail.com>
Message-ID: <alpine.LNX.2.00.0906250006200.18021@wotan.suse.de>
References: <4A4266CC.5000005@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-690678799-1245881262=:18021"
Content-ID: <alpine.LNX.2.00.0906250009201.18021@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-690678799-1245881262=:18021
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0906250009202.18021@wotan.suse.de>

Hi Rubén,

thanks for the patch! Please find a few comments below.

On Wed, 24 Jun 2009, rubenatch wrote:

> From: Rubén Aós Garralda

Could you please include your e-mail address here? (the one you want to 
have in the "author" field once the patch is committed).

> ---
> 
> diff -uprN linux-source-2.6.30/drivers/hid/hid-core.c
> linux-source-test/drivers/hid/hid-core.c
> --- linux-source-2.6.30/drivers/hid/hid-core.c  2009-06-10
> 05:05:27.000000000 +0200
> +++ linux-source-test/drivers/hid/hid-core.c    2009-06-24
> 18:39:41.000000000 +0200
> @@ -1309,6 +1309,8 @@ static const struct hid_device_id hid_bl
>         { HID_USB_DEVICE(USB_VENDOR_ID_SUNPLUS,
> USB_DEVICE_ID_SUNPLUS_WDESKTOP) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb300) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304) },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323) },
> +        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
>         { HID_USB_DEVICE(USB_VENDOR_ID_TOPSEED,
> USB_DEVICE_ID_TOPSEED_CYBERLINK) },
> diff -uprN linux-source-2.6.30/drivers/hid/hid-tmff.c
> linux-source-test/drivers/hid/hid-tmff.c
> --- linux-source-2.6.30/drivers/hid/hid-tmff.c  2009-06-10
> 05:05:27.000000000 +0200
> +++ linux-source-test/drivers/hid/hid-tmff.c    2009-06-24
> 18:41:04.000000000 +0200
> @@ -238,6 +238,10 @@ static const struct hid_device_id tm_dev
>                 .driver_data = (unsigned long)ff_rumble },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb304),
>                 .driver_data = (unsigned long)ff_rumble },
> +       { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb323),   /* Dual
> Trigger 3-in-1 (PC Mode) */
> +                .driver_data = (unsigned long)ff_rumble },
> +        { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb324),   /* Dual
> Trigger 3-in-1 (PS3 Mode) */
> +                .driver_data = (unsigned long)ff_rumble },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb651),   /* FGT
> Rumble Force Wheel */
>                 .driver_data = (unsigned long)ff_rumble },
>         { HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654),   /* FGT
> Force Feedback Wheel */

The patch has been improperly wordwrapped and whitespace-damaged by your 
mail client. I see you are using Thunderbird -- please see the following 
links

	http://mbligh.org/linuxdocs/Email/Clients/Thunderbird
	http://lkml.org/lkml/2005/12/27/191

which will give you some hints about using Thunderbird for patch 
submissions.

Also, while you are at it, could you please resend the patch which will 
also update the description for CONFIG_THRUSTMASTER_FF in 
drivers/hid/Kconfig, adding the proper model names to the description?

Thanks a lot,

-- 
Jiri Kosina
SUSE Labs
--168427776-690678799-1245881262=:18021--
