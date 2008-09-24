Return-Path: <linux-kernel-owner+w=401wt.eu-S1752919AbYIXCcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbYIXCcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYIXCcX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:32:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:47357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959AbYIXCcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:32:22 -0400
Date: Tue, 23 Sep 2008 19:30:53 -0700
From: Greg KH <greg@kroah.com>
To: fangxiaozhi 00110321 <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Subject: Re: [PATCH 10/4]linux-usb: To support more Huawei data card
	product IDs, fix kernel 2.6.26.5
Message-ID: <20080924023053.GA24846@kroah.com>
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 10:07:31AM +0800, fangxiaozhi 00110321 wrote:
> 
> From: fangxiaozhi <huananhu@huawei.com>
> 
> 1. This patch is based on the kernel of 2.6.26.5

Can you rebase this on 2.6.27-rc7 instead?  Lots of device ids have been
added to this driver since 2.6.26.5

> 2. To declare the unusual device for new Huawei data card devices in unusual_devs.h
> 3. To modify the data value and length in the function of usb_stor_huawei_e220_init in initializers.c
> 4. To declare more new product IDs in option.c.

This should be split up into 4 different patches, as it does 4 different
things.  Care to redo it please?

thanks,

greg k-h
