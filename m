Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXJUPC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXJUPC3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2007 11:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbXJUPCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Oct 2007 11:02:22 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:24000 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbXJUPCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2007 11:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=lT7DmUNUt0EoGaEpnnxmNBeNNvtkthbxR0QRSElEUD5muuZGfU9k5ds3rafhb6RKv8c1r+wS+puOhbMy8yl4fvF6ANG+1Ls3zX/ZRZOfXUhedRZJV4ghbmbKMUA0/5IfZZjVKdjstk0jfbgqlfqNP1XS1EnutE9SOqnIhLoa3D0=
Message-ID: <efe7343f0710210802v6abc54d9k19293942477dabcc@mail.gmail.com>
Date: Sun, 21 Oct 2007 16:02:18 +0100
From: "Luis Correia" <luis.f.correia@gmail.com>
To: "Pavel Machek" <pavel@ucw.cz>
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Cc: "kernel list" <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       mwallis@serialmonkey.com
In-Reply-To: <20071020184100.GA11640@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071020184100.GA11640@elf.ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On 10/20/07, Pavel Machek <pavel@ucw.cz> wrote:
> Hi!
>
> Kohjinsha subnotebook seems to contain wifi with USB IDs 0x18e8,
> 0x6206... I hope that to be compatible with
> net/wireless/rt2x00/rt73usb.c .
>
> [Sidenote: could we add some real author info into rt73usb.c?]
>
> I did this on 2.6.23-rc8-mm1 kernel (The RT hack may not be
> neccessary), but then it oopses somewhere in softmac layer. I'll try
> to play with it some more.
>
> If you have any ideas, let me know.
>                                                                 Pavel
>
> --- clean-mm/drivers/net/wireless/rt2x00/rt73usb.c      2007-10-09 09:32:08.000000000 +0200
> +++ linux-mm/drivers/net/wireless/rt2x00/rt73usb.c      2007-10-19 22:19:45.000000000 +0200
> @@ -1580,7 +1580,6 @@
>
>         if (!rt2x00_rev(&rt2x00dev->chip, 0x25730)) {
>                 ERROR(rt2x00dev, "Invalid RT chipset detected.\n");
> -               return -ENODEV;
>         }
>
>         if (!rt2x00_rf(&rt2x00dev->chip, RF5226) &&
> @@ -1588,7 +1587,6 @@
>             !rt2x00_rf(&rt2x00dev->chip, RF5225) &&
>             !rt2x00_rf(&rt2x00dev->chip, RF2527)) {
>                 ERROR(rt2x00dev, "Invalid RF chipset detected.\n");
> -               return -ENODEV;
>         }
>
>         /*
> @@ -2080,6 +2078,7 @@
>         { USB_DEVICE(0x148f, 0x2671), USB_DEVICE_DATA(&rt73usb_ops) },
>         /* Qcom */
>         { USB_DEVICE(0x18e8, 0x6196), USB_DEVICE_DATA(&rt73usb_ops) },
> +       { USB_DEVICE(0x18e8, 0x6206), USB_DEVICE_DATA(&rt73usb_ops) },
>         { USB_DEVICE(0x18e8, 0x6229), USB_DEVICE_DATA(&rt73usb_ops) },
>         { USB_DEVICE(0x18e8, 0x6238), USB_DEVICE_DATA(&rt73usb_ops) },
>         /* Senao */
>
> --
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

This device is NOT a Ralink USB wifi adapter!

Get the windows driver in this link and see for yourself.
http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
(ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))

Case Closed.

Luis Correia
rt2x00 project administrator
