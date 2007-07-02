Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbXGBBqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbXGBBqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 21:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbXGBBqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 21:46:15 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:52893 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbXGBBqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 21:46:15 -0400
Date: Sun, 1 Jul 2007 21:42:49 -0400
From: Josef Sipek <jsipek@fsl.cs.sunysb.edu>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, ezk@cs.sunysb.edu,
       jsipek@cs.sunysb.edu, linux-kernel@vger.kernel.org,
       unionfs@filesystems.org
Subject: Re: [-mm patch] unionfs: make functions static
Message-ID: <20070702014249.GA14417@filer.fsl.cs.sunysb.edu>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org> <20070701202330.GU10869@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070701202330.GU10869@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 01, 2007 at 10:23:30PM +0200, Adrian Bunk wrote:
> This patch makes some needlessly global functions static.
> 
...
> --- linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c.old	2007-07-01 00:05:02.000000000 +0200
> +++ linux-2.6.22-rc6-mm1/fs/unionfs/lookup.c	2007-07-01 00:06:05.000000000 +0200
> @@ -18,6 +18,8 @@
>  
>  #include "union.h"
>  
> +static int realloc_dentry_private_data(struct dentry *dentry);
> +
>  /* is the filename valid == !(whiteout for a file or opaque dir marker) */

I forget who said it, but someone wasn't very happy with prototypes like
that in .c files. What's the prefered way - are they ok for static symbols?

Josef "Jeff" Sipek.

-- 
We have joy, we have fun, we have Linux on a Sun...
