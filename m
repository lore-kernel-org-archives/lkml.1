Return-Path: <linux-kernel-owner+w=401wt.eu-S1752900AbYKKW5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752900AbYKKW5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYKKW5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:57:33 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750938AbYKKW5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:57:32 -0500
Date: Tue, 11 Nov 2008 14:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: timg@tpi.com (Tim Gardner)
Cc: marcel@holtmann.org, linux-bluetooth@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Dell Wireless 365 requires reset quirk
Message-Id: <20081111145706.9bfb4627.akpm@linux-foundation.org>
In-Reply-To: <20081104162448.A338EF8A65@sepang.rtg.net>
References: <20081104162448.A338EF8A65@sepang.rtg.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Nov 2008 09:24:48 -0700 (MST)
timg@tpi.com (Tim Gardner) wrote:

> >From 931ccb629d739aa563347a4e866bc26107e6b545 Mon Sep 17 00:00:00 2001
> From: Tim Gardner <tim.gardner@canonical.com>
> Date: Tue, 4 Nov 2008 09:18:06 -0700
> Subject: [PATCH] Dell Wireless 365 needs BTUSB_RESET quirk.
>  OriginalAuthor: Mario Limonciello <mario_limonciello@dell.com>
> 
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> Cc: stable@kernel.org
> ---
>  drivers/bluetooth/btusb.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index af472e0..051b758 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -125,6 +125,9 @@ static struct usb_device_id blacklist_table[] = {
>  	/* Dell laptop with Broadcom chip */
>  	{ USB_DEVICE(0x413c, 0x8126), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
>  
> +	/* Dell Wireless 365 */
> +	{ USB_DEVICE(0x413c, 0x8160), .driver_info = BTUSB_RESET },
> +
>  	/* Dell Wireless 370 */
>  	{ USB_DEVICE(0x413c, 0x8156), .driver_info = BTUSB_RESET | BTUSB_WRONG_SCO_MTU },
>  

I shall assume that this patch was authored by Mario.  This should have
been communicated by adding his From: line right at the top of the
changelog.  Mario's signed-off-by: is absent, but that is tolerable
because we have yours.

The (absent) changelog fails to explain what effect this patch has. 
_why_ does this driver need this quirk?

As it stands, there is insufficient information here for making
2.6.28-vs-2.6.29 decisions, let alone 2.6.27.x, 2.6.26.x, etc.

