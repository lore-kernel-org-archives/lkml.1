Return-Path: <linux-kernel-owner+w=401wt.eu-S1756507AbZHQUnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbZHQUnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 16:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752594AbZHQUnh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 16:43:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37218 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286AbZHQUng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 16:43:36 -0400
Date: Mon, 17 Aug 2009 13:42:09 -0700
From: Greg KH <gregkh@suse.de>
To: Randy Dunlap <rdunlap@xenotime.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] staging/sep: fix build error & warning & kconfig
Message-ID: <20090817204209.GA9274@suse.de>
References: <4A89BF12.6020908@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A89BF12.6020908@xenotime.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 17, 2009 at 01:35:30PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix sep_driver build when CONFIG_PCI=n:
> 
> drivers/staging/sep/sep_driver.c:2548: error: implicit declaration of function 'pci_dev_get'

I just merged a patch to fix this a few minutes ago.

> and printk format warning:
> 
> drivers/staging/sep/sep_driver.c:290:
> warning: format '%d' expects type 'int', but argument 2 has type 'long unsigned
>  int'

I think Alan is taking care of this stuff already.

> Also, the default kconfig value should not be 'y'.
> 
> And something should be done about this warning (but I didn't fix it):
> drivers/staging/sep/sep_driver.c:1780: warning: 'error' may be used uninitialized in this function

Alan has already resolved this one.

thanks,

greg k-h
