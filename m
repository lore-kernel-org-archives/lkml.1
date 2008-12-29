Return-Path: <linux-kernel-owner+w=401wt.eu-S1752504AbYL2P1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504AbYL2P1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751548AbYL2P1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:27:31 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36181 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751497AbYL2P1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:27:30 -0500
Date: Mon, 29 Dec 2008 10:27:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julia Lawall <julia@diku.dk>
cc: gregkh@suse.de, <dbrownell@users.sourceforge.net>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 10/13] drivers/usb/gadget: use USB API functions rather
 than constants
In-Reply-To: <Pine.LNX.4.64.0812291122180.9555@pc-004.diku.dk>
Message-ID: <Pine.LNX.4.44L0.0812291025220.2250-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Dec 2008, Julia Lawall wrote:

> From: Julia Lawall <julia@diku.dk>
> 
> This set of patches introduces calls to the following set of functions:
> 
> usb_endpoint_dir_in(epd)
> usb_endpoint_dir_out(epd)
> usb_endpoint_is_bulk_in(epd)
> usb_endpoint_is_bulk_out(epd)
> usb_endpoint_is_int_in(epd)
> usb_endpoint_is_int_out(epd)
> usb_endpoint_num(epd)
> usb_endpoint_type(epd)
> usb_endpoint_xfer_bulk(epd)
> usb_endpoint_xfer_control(epd)
> usb_endpoint_xfer_int(epd)
> usb_endpoint_xfer_isoc(epd)

...

> drivers/usb/gadget/file_storage.c   |    1 +

...

> diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
> index 88fedd0..c44092b 100644
> --- a/drivers/usb/gadget/file_storage.c
> +++ b/drivers/usb/gadget/file_storage.c
> @@ -248,6 +248,7 @@
>  #include <linux/freezer.h>
>  #include <linux/utsname.h>
>  
> +#include <linux/usb.h>
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>

While there's nothing wrong with this part of the patch, it hardly 
seems necessary.  Was there any reason for including it?

Alan Stern

