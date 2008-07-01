Return-Path: <linux-kernel-owner+w=401wt.eu-S1756231AbYGASlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbYGASlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 14:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYGASlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 14:41:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:50978 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbYGASlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 14:41:09 -0400
Date: Tue, 1 Jul 2008 11:37:33 -0700
From: Greg KH <greg@kroah.com>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/4] debugfs: Implement debugfs_remove_recursive()
Message-ID: <20080701183733.GB4879@kroah.com>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com> <1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2008 at 03:14:51PM +0200, Haavard Skinnemoen wrote:
> debugfs_remove_recursive() will remove a dentry and all its children.
> Drivers can use this to zap their whole debugfs tree so that they don't
> need to keep track of every single debugfs dentry they created.
> 
> It may fail to remove the whole tree in certain cases:
> 
> sh-3.2# rmmod atmel-mci < /sys/kernel/debug/mmc0/ios/clock
> mmc0: card b368 removed
> atmel_mci atmel_mci.0: Lost dma0chan1, falling back to PIO
> sh-3.2# ls /sys/kernel/debug/mmc0/
> ios
> 
> But I'm not sure if that case can be handled in any sane manner.
> 
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> Cc: Greg KH <greg@kroah.com>

If this is tied to some other series that needs to go through some other
maintainer, feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
to the patch and let someone else take it.

Otherwise, if you need me to take it, I will be glad to do so, just let
me know what is easiest for you.

thanks,

greg k-h
