Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYJHDYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYJHDYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 23:24:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754230AbYJHDYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 23:24:10 -0400
Received: from kroah.org ([198.145.64.141]:52592 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754009AbYJHDYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 23:24:09 -0400
Date: Tue, 7 Oct 2008 20:21:39 -0700
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       zhangqianchun@huawei.com
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card product
	IDs, fix kernel 2.6.27-rc7
Message-ID: <20081008032139.GA14931@kroah.com>
References: <faf7b1bd45d66.45d66faf7b1bd@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf7b1bd45d66.45d66faf7b1bd@huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 09:31:35AM +0800, fangxiaozhi 00110321 wrote:
>   From: fangxiaozhi <huananhu@huawei.com>
>  
>  1. This patch is based on the kernel of 2.6.27-rc7 
>  2. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. So to declare the unusual device for new Huawei data card devices 
>  in unusual_devs.h and to declare more new product IDs in option.c.
>  3. To modify the data value and length in the function of 
>  usb_stor_huawei_e220_init in initializers.c
>    That's because based on the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
>    In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
>     But in this new solution, it can be compatible with all of our data card devices.
> 
>  Signed-off-by: fangxiaozhi <huananhu@huawei.com>
>  -------------------------------------------------------------------
> 
> diff -uprN -X linux-2.6.27-rc7-orig/Documentation/dontdiff linux-2.6.27-rc7-orig/drivers/usb/serial/option.c linux-2.6.27-rc7/drivers/usb/serial/option.c
> --- linux-2.6.27-rc7-orig/drivers/usb/serial/option.c 2008-09-22 06:29:55.000000000 +0800
> +++ linux-2.6.27-rc7/drivers/usb/serial/option.c 2008-09-24 12:00:14.000000000 +0800
> @@ -106,11 +106,20 @@ static int  option_send_setup(struct tty
>  #define HUAWEI_PRODUCT_E220                 0x1003
>  #define HUAWEI_PRODUCT_E220BIS                 0x1004
>  #define HUAWEI_PRODUCT_E1401                 0x1401
> +#define HUAWEI_PRODUCT_E1402                 0x1402

Hm, all of the tabs seem to have been converted to spaces in this patch,
and it does not apply at all.

Care to fix your email client settings and try again?

thanks,

greg k-h
