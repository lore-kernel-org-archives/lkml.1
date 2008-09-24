Return-Path: <linux-kernel-owner+w=401wt.eu-S1753864AbYIXPGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753864AbYIXPGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 11:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYIXPGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 11:06:10 -0400
Received: from [198.145.64.141] ([198.145.64.141]:36377 "EHLO coco.kroah.org"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752117AbYIXPGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 11:06:09 -0400
Date: Wed, 24 Sep 2008 08:03:04 -0700
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card product
	IDs, fix kernel 2.6.27-rc7
Message-ID: <20080924150304.GC26466@kroah.com>
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com> <f9fd97f63cf97.3cf97f9fd97f6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f9fd97f63cf97.3cf97f9fd97f6@huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 02:08:12PM +0800, fangxiaozhi 00110321 wrote:
> 
>  From: fangxiaozhi <huananhu@huawei.com>
>  
>  1. This patch is based on the kernel of 2.6.27-rc7 2. To declare the unusual device for new Huawei data card devices 
>  in unusual_devs.h
>  3. To modify the data value and length in the function of 
>  usb_stor_huawei_e220_init in initializers.c
>  4. To declare more new product IDs in option.c.

I thought I asked you to split this up into 4 different patches?  Hm,
maybe three should be all that is needed, I thought your original one
did 4 different things.

And isn't your modification of the usb_stor_huawei_e220_init function
going to break the devices that it currently works for?  Or has it
always been wrong?

thanks,

greg k-h
