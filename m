Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbYGUFHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbYGUFHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 01:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760329AbYGUFHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 01:07:44 -0400
Received: from senator.holtmann.net ([87.106.208.187]:43258 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760318AbYGUFHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 01:07:43 -0400
Subject: Re: [PATCH 3/7] bluetooth: Add quirks for a few hci_usb devices
From: Marcel Holtmann <marcel@holtmann.org>
To: Ben Collins <ben.collins@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <E1KKl4I-00068H-S6@swissweb.swissdisk.com>
References: <E1KKl4I-00068H-S6@swissweb.swissdisk.com>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 07:08:11 +0200
Message-Id: <1216616891.8411.114.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

> When the Dell 370 and 410 BT adapters are put into BT radio mode, they
> need to be prepared like many other Broadcom adapters.
> 
> Also, add quirk Broadcom 2046 devices with HCI_RESET.
> 
> CC: linux-bluetooth@vger.kernel.org
> Signed-off-by: Michael Frey <michael.frey@canonical.com>
> Signed-off-by: Mario Limonciello <Mario_Limonciello@Dell.com>
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Signed-off-by: Ben Collins <ben.collins@canonical.com>
> ---
>  drivers/bluetooth/hci_usb.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
> index 192522e..0254a6b 100644
> --- a/drivers/bluetooth/hci_usb.c
> +++ b/drivers/bluetooth/hci_usb.c
> @@ -134,6 +134,13 @@ static struct usb_device_id blacklist_ids[] = {
>  
>  	/* Dell laptop with Broadcom chip */
>  	{ USB_DEVICE(0x413c, 0x8126), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
> +	/* Dell Wireless 370 */
> +	{ USB_DEVICE(0x413c, 0x8156), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
> +	/* Dell Wireless 410 */
> +	{ USB_DEVICE(0x413c, 0x8152), .driver_info = HCI_RESET | HCI_WRONG_SCO_MTU },
> +        
> +        /* Broadcom 2046 */
> +        { USB_DEVICE(0x0a5c, 0x2151), .driver_info = HCI_RESET },

do me a favor and use tabs and not whitespaces here. And is this the
latest Apple machine that has a Broadcom instead of a CSR chip in it. If
so, then let the comment reflect this.

Regards

Marcel


