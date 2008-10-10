Return-Path: <linux-kernel-owner+w=401wt.eu-S1763692AbYJJVX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763692AbYJJVX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 17:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761420AbYJJVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 17:23:39 -0400
Received: from kroah.org ([198.145.64.141]:36251 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761327AbYJJVXh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 17:23:37 -0400
Date: Fri, 10 Oct 2008 14:15:59 -0700
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       zhangqianchun@huawei.com
Subject: Re: PATCH 10/8]linux-usb: To support more Huawei data card product
	IDs, fix kernel 2.6.27-rc7
Message-ID: <20081010211559.GC17701@kroah.com>
References: <f9029a2044fb8.44fb8f9029a20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9029a2044fb8.44fb8f9029a20@huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 12:02:46PM +0800, fangxiaozhi 00110321 wrote:
> From: fangxiaozhi <huananhu@huawei.com>
>  
> 1. This patch is based on the kernel of 2.6.27-rc7 
> 2. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. So to declare the unusual device for new Huawei data card devices 
> in unusual_devs.h and to declare more new product IDs in option.c.
> 3. To modify the data value and length in the function of 
> usb_stor_huawei_e220_init in initializers.c
> That's because based on the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
> In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
> But in this new solution, it can be compatible with all of our data card devices.

Can you make the changes Alan suggested?

I'll hold off for a new version after you have integrated that change.

thanks,

greg k-h
