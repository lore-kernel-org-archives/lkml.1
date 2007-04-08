Return-Path: <linux-kernel-owner+w=401wt.eu-S1751325AbXDHPMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751325AbXDHPMy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 11:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbXDHPMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 11:12:54 -0400
Received: from verein.lst.de ([213.95.11.210]:42500 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbXDHPMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 11:12:53 -0400
Date: Sun, 8 Apr 2007 17:12:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] merge compat_ioctl.h into compat_ioctl.c
Message-ID: <20070408151257.GA31164@lst.de>
References: <20070408140433.GA28023@lst.de> <200704081651.21148.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704081651.21148.arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 04:51:20PM +0200, Arnd Bergmann wrote:
> On Sunday 08 April 2007, Christoph Hellwig wrote:
> > 
> > Now that there is no arch-specific compat ioctl handling left there
> > is not point in having a separate copat_ioctl.h, so merge it into
> > compat_ioctl.c
> 
> Yes, definitely a good idea.
> 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
>  
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> On a similar subject, how about merging include/linux/ioctl32.h and the ioctl
> bits of fs/compat.c into fs/compat_ioctl.c as well to make it completely
> self-contained?

I have a patch for that pending.

