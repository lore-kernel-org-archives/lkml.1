Return-Path: <linux-kernel-owner+w=401wt.eu-S932849AbXKPOTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932849AbXKPOTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 09:19:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759586AbXKPOTh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 09:19:37 -0500
Received: from pat.uio.no ([129.240.10.15]:34067 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752820AbXKPOTg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 09:19:36 -0500
Subject: Re: 2.6.24-rc2 XFS nfsd hang
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Chris Wedgwood <cw@f00f.org>
Cc: Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Benny Halevy <bhalevy@panasas.com>, linux-xfs@oss.sgi.com
In-Reply-To: <20071116110315.GA27969@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org>
	 <473AA72C.6020308@panasas.com> <20071114125907.GB4010@fieldses.org>
	 <alpine.DEB.0.99999.0711142317010.12443@sheep.housecafe.de>
	 <alpine.DEB.0.99999.0711150840340.12443@sheep.housecafe.de>
	 <20071116003410.GA16797@puku.stupidest.org>
	 <59468.62.180.231.196.1195204637.squirrel@housecafe.dyndns.org>
	 <20071116110315.GA27969@puku.stupidest.org>
Content-Type: text/plain
Date: Fri, 16 Nov 2007 09:19:32 -0500
Message-Id: <1195222772.7653.16.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-ClamAV-Virus: No
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.087)
X-UiO-Scanned: 2AB1C2656C633C10A506D707CAF5A06631341EC6
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 626 total 5181029 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2007-11-16 at 03:03 -0800, Chris Wedgwood wrote:
> On Fri, Nov 16, 2007 at 10:17:17AM +0100, Christian Kujau wrote:
> 
> > OK, I'll try this. I hope this can be fixed somehow before 2.6.24...
> 
> Well, one simple nasty idea would be something like:
> 
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 429a002..da231fd 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -1604,7 +1604,7 @@ config NFS_FS
>  
>  config NFS_V3
>  	bool "Provide NFSv3 client support"
> -	depends on NFS_FS
> +	depends on NFS_FS && !XFS
>  	help
>  	  Say Y here if you want your NFS client to be able to speak version
>  	  3 of the NFS protocol.
> 
> So people who are likely to be affect just side-step the issue until
> it's resolved.

Very funny, but disabling XFS on the client won't help.

Trond

