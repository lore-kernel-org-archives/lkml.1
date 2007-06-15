Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbXFOBgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbXFOBgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 21:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752041AbXFOBgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 21:36:32 -0400
Received: from ns2.suse.de ([195.135.220.15]:48230 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610AbXFOBgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 21:36:32 -0400
Date: Fri, 15 Jun 2007 03:36:30 +0200
From: Nick Piggin <npiggin@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] make fs/buffer.c:cont_expand_zero() static
Message-ID: <20070615013630.GB29085@wotan.suse.de>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org> <20070614221545.GX3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070614221545.GX3588@stusta.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Adrian,

Thanks for doing these, but can we hold them off for now?

Thanks,
Nick


On Fri, Jun 15, 2007 at 12:15:45AM +0200, Adrian Bunk wrote:
> cont_expand_zero() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.22-rc4-mm2/fs/buffer.c.old	2007-06-14 01:51:08.000000000 +0200
> +++ linux-2.6.22-rc4-mm2/fs/buffer.c	2007-06-14 01:51:42.000000000 +0200
> @@ -2181,8 +2181,8 @@
>  	return err;
>  }
>  
> -int cont_expand_zero(struct file *file, struct address_space *mapping,
> -			loff_t pos, loff_t *bytes)
> +static int cont_expand_zero(struct file *file, struct address_space *mapping,
> +			    loff_t pos, loff_t *bytes)
>  {
>  	struct inode *inode = mapping->host;
>  	unsigned blocksize = 1 << inode->i_blkbits;
