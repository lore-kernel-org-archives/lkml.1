Return-Path: <linux-kernel-owner+w=401wt.eu-S933085AbXAWGgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933085AbXAWGgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 01:36:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933088AbXAWGgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 01:36:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933085AbXAWGgl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 01:36:41 -0500
Date: Mon, 22 Jan 2007 22:35:50 -0800
From: Greg KH <gregkh@suse.de>
To: Don Mullis <dwm@meer.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org,
       rdunlap@xenotime.net
Subject: Re: `make htmldocs` fails
Message-ID: <20070123063550.GB8475@suse.de>
References: <20070111222627.66bb75ab.akpm@osdl.org> <m364aycmbt.fsf@meer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m364aycmbt.fsf@meer.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 22, 2007 at 10:02:30PM -0800, Don Mullis wrote:
> 
> Bisection shows the bad patch to be:
>     gregkh-driver-uio-documentation.patch
> 
> The htmldocs build failure can be eliminated by:
>     quilt remove Documentation/DocBook/kernel-api.tmpl
> 
> The error messages were:
> 
>     .../linux-2.6.19 $ make htmldocs
>       DOCPROC Documentation/DocBook/kernel-api.xml
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'owner'
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:521): No description found for parameter 'info'
>     Warning(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//drivers/uio/uio.c:591): No description found for parameter 'idev'

Thanks, I've fixed these warnings now.

>     Error(/noback/kernel.org/2.6.20-rc_fault-injection/linux-2.6.19//include/linux/uio_driver.h:33): cannot understand prototype: 'struct uio_info '

I think I've fixed this now, the next -mm should contain the update.

thanks for letting me know.

greg k-h
