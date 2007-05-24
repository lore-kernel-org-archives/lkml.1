Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbXEXRDp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbXEXRDp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:03:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750701AbXEXRDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:03:37 -0400
Received: from coyote.holtmann.net ([217.160.111.169]:37292 "EHLO
	mail.holtmann.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbXEXRDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:03:36 -0400
Subject: Re: [PATCH 3/6] HCIUSB: Initialize the Broadcom USB Bluetooth
	device in Dell laptops.
From: Marcel Holtmann <marcel@holtmann.org>
To: Ben Collins <bcollins@ubuntu.com>
Cc: linux-kernel@vger.kernel.org, Maxim Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <cc9d2edaa0e2f0806a002fd04a930957780651b3.1179964369.git.bcollins@ubuntu.com>
References: <98cd38b5.git.bcollins@ubuntu.com>
	 <cc9d2edaa0e2f0806a002fd04a930957780651b3.1179964369.git.bcollins@ubuntu.com>
Content-Type: text/plain
Date: Thu, 24 May 2007 19:02:31 +0200
Message-Id: <1180026151.21432.17.camel@aeonflux.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> CC: Marcel Holtmann <marcel@holtmann.org>
> CC: Maxim Krasnyansky <maxk@qualcomm.com>
> Signed-off-by: Tim Gardner <tim.gardner@ubuntu.com>
> Signed-off-by: Phillip lougher <phillip@ubuntu.com>
> Signed-off-by: Ben Collins <bcollins@ubuntu.com>
> ---
>  drivers/bluetooth/hci_usb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
> index b0238b4..d636142 100644
> --- a/drivers/bluetooth/hci_usb.c
> +++ b/drivers/bluetooth/hci_usb.c
> @@ -131,7 +131,7 @@ static struct usb_device_id blacklist_ids[] = {
>  	{ USB_DEVICE(0x03f0, 0x171d), .driver_info = HCI_WRONG_SCO_MTU },
>  
>  	/* Dell laptop with Broadcom chip */
> -	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU },
> +	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_WRONG_SCO_MTU|HCI_RESET },
>  
>  	/* Microsoft Wireless Transceiver for Bluetooth 2.0 */
>  	{ USB_DEVICE(0x045e, 0x009c), .driver_info = HCI_RESET },

it is already in my tree.

Regards

Marcel


