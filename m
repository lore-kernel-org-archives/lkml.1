Return-Path: <linux-kernel-owner+w=401wt.eu-S1755131AbZICLy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131AbZICLy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 07:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755082AbZICLy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 07:54:26 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:63313 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZICLy0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 07:54:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BAPkUlUP4KwJov/t3KVwCzToOFuR5WXPVuFJcHRP+PbkQqkDYfqqbdW77wakSqDkA4
         YRoDUn7POT1canu/volYs68gmo0kSUD7Kp90pAQPi22LU1hBXWpJB2aXaxpFcBDnEtJy
         +Tp8DXsQ6Viztg1dVRJ6+Ih59tY462NE7hhYc=
MIME-Version: 1.0
In-Reply-To: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
References: <1251978140-4992-1-git-send-email-amit.kucheria@canonical.com>
Date: Thu, 3 Sep 2009 13:54:27 +0200
Message-ID: <a32f33a40909030454y51905525g15a65cc8364b8eb5@mail.gmail.com>
Subject: Re: [PATCH] rt2x00: Get rid of duplicate usb id from rt2500usb
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> USB_DEVICE(0x148f, 0x2573) is served by the rt73usb driver where it is already
> defined. Remove it from rt2500usb.
>
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>

NACK

Users have reported that this is a valid rt2500usb ID. You can thank the
manufacturer of the dongle to produce dongles with the same USB ID but
with different chipsets.

Ivo

> ---
>  drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
> index ce75426..2e9fac7 100644
> --- a/drivers/net/wireless/rt2x00/rt2500usb.c
> +++ b/drivers/net/wireless/rt2x00/rt2500usb.c
> @@ -2020,7 +2020,6 @@ static struct usb_device_id rt2500usb_device_table[] = {
>        /* Ralink */
>        { USB_DEVICE(0x148f, 0x1706), USB_DEVICE_DATA(&rt2500usb_ops) },
>        { USB_DEVICE(0x148f, 0x2570), USB_DEVICE_DATA(&rt2500usb_ops) },
> -       { USB_DEVICE(0x148f, 0x2573), USB_DEVICE_DATA(&rt2500usb_ops) },
>        { USB_DEVICE(0x148f, 0x9020), USB_DEVICE_DATA(&rt2500usb_ops) },
>        /* Sagem */
>        { USB_DEVICE(0x079b, 0x004b), USB_DEVICE_DATA(&rt2500usb_ops) },
> --
> 1.6.3.3
>
>
