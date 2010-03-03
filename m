Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751789Ab0CCLYa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:24:30 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:13193 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab0CCLY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:24:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i1f3KjRw92HWQndf9W3Kihy4sdK4G+oWj5Sd8mgK+3sqPoRr/13j/bVwddxijvf6dN
         cKmLwvLIS8YTwfFaAegts9XlykoE8LOfrKZaelGRGDcPajjyuq8ALcaFCk2GbYGo0HSX
         SU6e0xZnExMYhk/xfssU34yp1QezecWrUAVfg=
MIME-Version: 1.0
In-Reply-To: <20100302232738.GA314@kroah.com>
References: <20100302162228.3eeda8f3@shogun.epicvoyage.org>
	 <20100302232738.GA314@kroah.com>
Date: Wed, 3 Mar 2010 05:24:26 -0600
Message-ID: <d426fb281003030324v6dc6216ch53bdb30ffc18a9be@mail.gmail.com>
Subject: Re: 2.6.33 staging rt2870 += Belkin F5D8055 Wireless-N USB Dongle
From: Chris Largret <largret@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 2, 2010 at 5:27 PM, Greg KH <greg@kroah.com> wrote:
> Next time, please cc: me with any staging patches.
>
> Can you resend this with a "Signed-off-by:" line so that I can apply it?
> The kernel file, Documentation/SubmittingPatches describes what this
> entails.

Thanks, I'll try to use checkpatch.pl next time.

Description: Adds Belkin F5D8055 Wireless-N USB support to the rt2870
staging driver.

Signed-off-by: Chris Largret <largret@gmail.com>
diff -upr linux-2.6.33-orig/drivers/staging/rt2860/usb_main_dev.c
linux-2.6.33/drivers/staging/rt2860/usb_main_dev.c
--- linux-2.6.33-orig/drivers/staging/rt2860/usb_main_dev.c	2010-02-24
12:52:17.000000000 -0600
+++ linux-2.6.33/drivers/staging/rt2860/usb_main_dev.c	2010-03-02
12:13:05.000000000 -0600
@@ -63,6 +63,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x07D1, 0x3C11)},	/* D-Link */
 	{USB_DEVICE(0x14B2, 0x3C07)},	/* AL */
 	{USB_DEVICE(0x050D, 0x8053)},	/* Belkin */
+	{USB_DEVICE(0x050D, 0x825B)},	/* Belkin */
 	{USB_DEVICE(0x14B2, 0x3C23)},	/* Airlink */
 	{USB_DEVICE(0x14B2, 0x3C27)},	/* Airlink */
 	{USB_DEVICE(0x07AA, 0x002F)},	/* Corega */



Chris
