Return-Path: <linux-kernel-owner+w=401wt.eu-S1761331AbZD1NnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761331AbZD1NnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 09:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757520AbZD1Nmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 09:42:51 -0400
Received: from senator.holtmann.net ([87.106.208.187]:42121 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757286AbZD1Nmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 09:42:50 -0400
Subject: Re: [PATCH] Quirk for BT USB device on MacbookPro to be reset
 before use
From: Marcel Holtmann <marcel@holtmann.org>
To: amit.kucheria@verdurent.com
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Amit Kucheria <amit.kucheria@canonical.com>
In-Reply-To: <1240919876-6204-1-git-send-email-amit.kucheria@verdurent.com>
References: <1240919876-6204-1-git-send-email-amit.kucheria@verdurent.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 06:42:46 -0700
Message-Id: <1240926166.997.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

> From: Amit Kucheria <amit.kucheria@canonical.com>
> 
> Reset the Bluetooth device on Macbook Pro 5.1 inorder to be able to use it
> 
> Bug: #332443
> BugLink: https://bugs.edge.launchpad.net/ubuntu/+source/linux/+bug/332443
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  drivers/bluetooth/btusb.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 7a29a2b..c017cc5 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -109,6 +109,9 @@ static struct usb_device_id blacklist_table[] = {
>  	/* Apple MacBook Pro with Broadcom chip */
>  	{ USB_DEVICE(0x05ac, 0x820f), .driver_info = BTUSB_RESET },
>  
> +	/* Apple MacBook Pro 5,1 */
> +	{ USB_DEVICE(0x05ac, 0x8213), .driver_info = BTUSB_RESET },
> +

can you guys please NOT send out blindly outdated patches from your
vendor kernel. Check if patches apply to Linus' kernel first and that
they still make sense. In this case I have changed the BTUSB_RESET logic
as default and marked the few old/broken devices as exception.

Regards

Marcel


