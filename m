Return-Path: <linux-kernel-owner+w=401wt.eu-S932536AbYCGUor@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932536AbYCGUor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:44:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763557AbYCGUoa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:44:30 -0500
Received: from senator.holtmann.net ([87.106.208.187]:33944 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762826AbYCGUo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:44:28 -0500
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Message-Id: <68E3DB35-04A3-475E-8C3F-B2F48E778487@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Karsten Keil <kkeil@suse.de>
In-Reply-To: <20080307201034.GA671@pingi.kke.suse.de>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH] [BLUETOOTH] Add another Broadcom device
Date: Fri, 7 Mar 2008 21:43:54 +0100
References: <20080307201034.GA671@pingi.kke.suse.de>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Karsten,

> This patch adds another Broadcom BCM2045 based device to the
> blacklist, with these settings the micro dongle works on my system.
>
> Signed-off-by: Karsten Keil <kkeil@suse.de>
> ---
> drivers/bluetooth/hci_usb.c |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/bluetooth/hci_usb.c b/drivers/bluetooth/hci_usb.c
> index 372c7ef..f16c94c 100644
> --- a/drivers/bluetooth/hci_usb.c
> +++ b/drivers/bluetooth/hci_usb.c
> @@ -116,6 +116,7 @@ static struct usb_device_id blacklist_ids[] = {
> 	{ USB_DEVICE(0x0a5c, 0x2009), .driver_info = HCI_BCM92035 },
>
> 	/* Broadcom BCM2045 */
> +	{ USB_DEVICE(0x0a5c, 0x2039), .driver_info = HCI_RESET |  
> HCI_WRONG_SCO_MTU },
> 	{ USB_DEVICE(0x0a5c, 0x2101), .driver_info = HCI_RESET |  
> HCI_WRONG_SCO_MTU },

before I sign off on this one, can you include the part from /proc/bus/ 
usb/devices for this dongle.

Regards

Marcel

