Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbYBNVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbYBNVNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763267AbYBNVNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:13:08 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43444 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759969AbYBNVND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:13:03 -0500
Date: Thu, 14 Feb 2008 13:12:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: gregkh@suse.de, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       klloyd@sierrawireless.com
Subject: Re: [PATCH] usb: serial: move zte MF330 from sierra to option
Message-Id: <20080214131228.f76848bd.akpm@linux-foundation.org>
In-Reply-To: <47B0B02D.2000906@sierrawireless.com>
References: <47B0B02D.2000906@sierrawireless.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 12:29:33 -0800
Kevin Lloyd <klloyd@sierrawireless.com> wrote:

> From: Kevin Lloyd <linux@sierrawireless.com>
> 
> Moves the Onda H600/ZTE MF33 device from the sierra driver to the option driver.
> 

A changelog should describe why a change was made, not simply what the
change is.

> 
> ---
>  drivers/usb/serial/sierra.c |   1 -
>  drivers/usb/serial/option.c |   2 +
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.25-rc1/drivers/usb/serial/sierra.c.orig	2008-02-11 11:34:06.000000000 -0800
> +++ linux-2.6.25-rc1/drivers/usb/serial/sierra.c	2008-02-11 11:34:36.000000000 -0800
> @@ -178,7 +178,6 @@ static struct usb_device_id id_table [] 
>  
>  	{ USB_DEVICE(0x1199, 0x0112), .driver_info = DEVICE_1_PORT }, /* Sierra Wireless AirCard 580 */
>  	{ USB_DEVICE(0x0F3D, 0x0112), .driver_info = DEVICE_1_PORT }, /* Airprime/Sierra PC 5220 */
> -	{ USB_DEVICE(0x05C6, 0x6613), .driver_info = DEVICE_1_PORT }, /* Onda H600/ZTE MF330 */
>  
>  	{ USB_DEVICE(0x1199, 0x0FFF), .driver_info = DEVICE_INSTALLER},
>  	{ }
> --- linux-2.6.25-rc1/drivers/usb/serial/option.c.orig	2008-02-11 11:42:10.000000000 -0800
> +++ linux-2.6.25-rc1/drivers/usb/serial/option.c	2008-02-11 11:42:18.000000000 -0800
> @@ -121,6 +121,8 @@ static int  option_send_setup(struct usb
>  #define BANDRICH_PRODUCT_C100_1			0x1002
>  #define BANDRICH_PRODUCT_C100_2			0x1003
>  
> +#define QUALCOMM_VENDOR_ID			0x05C6
> +
>  static struct usb_device_id option_ids[] = {
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_COLT) },
>  	{ USB_DEVICE(OPTION_VENDOR_ID, OPTION_PRODUCT_RICOLA) },
> @@ -186,6 +188,7 @@ static struct usb_device_id option_ids[]
>  	{ USB_DEVICE(ANYDATA_VENDOR_ID, ANYDATA_PRODUCT_ADU_500A) },
>  	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_1) },
>  	{ USB_DEVICE(BANDRICH_VENDOR_ID, BANDRICH_PRODUCT_C100_2) },
> +	{ USB_DEVICE(QUALCOMM_VENDOR_ID, 0x6613)}, /* Onda H600/ZTE MF330 */
>  	{ } /* Terminating entry */
>  };
>  MODULE_DEVICE_TABLE(usb, option_ids);

Because I, for one, don't have a clue why you did this?
