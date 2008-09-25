Return-Path: <linux-kernel-owner+w=401wt.eu-S1754483AbYIYCOR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbYIYCOR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 22:14:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbYIYCN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 22:13:57 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40769 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984AbYIYCN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 22:13:57 -0400
Date: Wed, 24 Sep 2008 19:10:01 -0700
From: Greg KH <greg@kroah.com>
To: Franko Fang <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Subject: Re: PATCH 10/4]linux-usb: To support more Huawei data card
	productIDs, fix kernel 2.6.27-rc7
Message-ID: <20080925021001.GA14163@kroah.com>
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com> <f9fd97f63cf97.3cf97f9fd97f6@huawei.com> <20080924150304.GC26466@kroah.com> <025201c91eaf$224001e0$f9100b0a@china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <025201c91eaf$224001e0$f9100b0a@china.huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2008 at 09:36:29AM +0800, Franko Fang wrote:
> 1. In this patch, we want to do one thing: add more Huawei product IDs into the USB driver. Then it can support  more Huawei data card devices. 
>     So I make them in one patch.
> 
> 2. To change usb_stor_huawei_e220_init function as follows, that's because in the USB standard, while sending SET_FETURE_D to the device, it requires the corresponding data to be zero, and its sending length also must be zero.
>     In our old solution, it can be compatible with our WCDMA data card devices, but can not support our CDMA data card devices. 
>     But in this new solution, it can be compatible with all of our data card devices.
> 
>     Hope that my interpreting can satify you.

Ok, that sounds reasonable.  How about resending the patch, and adding
this information to the changelog area so that others also understand
what is going on here.

thanks,

greg k-h
