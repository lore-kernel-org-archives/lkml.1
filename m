Return-Path: <linux-kernel-owner+w=401wt.eu-S965857AbXBTBBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965857AbXBTBBH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965858AbXBTBBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:01:06 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:45402 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965857AbXBTBBE (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:01:04 -0500
X-Greylist: delayed 1152 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Feb 2007 20:01:04 EST
Date: Tue, 20 Feb 2007 11:41:38 +1100
From: David Chinner <dgc@sgi.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: xfs-masters@oss.sgi.com, linux-kernel@vger.kernel.org, tes@sgi.com
Subject: Re: [2.6 patch] make xfs_buftarg_list static again
Message-ID: <20070220004138.GW5724@melbourne.sgi.com>
References: <20070220000747.GC13958@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070220000747.GC13958@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 20, 2007 at 01:07:47AM +0100, Adrian Bunk wrote:
> xfs_buftarg_list became global for no good reason.

Fallout from a much larger patch. Looks like there were a couple
of STATIC -> static conversions stuffed up. Thanks for catching
this, Adrian.

Tim - another one for you ;)

> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 
> ---
> --- linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c.old	2007-02-18 22:55:40.000000000 +0100
> +++ linux-2.6.20-mm2/fs/xfs/linux-2.6/xfs_buf.c	2007-02-18 22:56:08.000000000 +0100
> @@ -1424,7 +1424,7 @@
>  /*
>   *	buftarg list for delwrite queue processing
>   */
> -LIST_HEAD(xfs_buftarg_list);
> +static LIST_HEAD(xfs_buftarg_list);
>  static DEFINE_SPINLOCK(xfs_buftarg_lock);
>  
>  STATIC void

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
