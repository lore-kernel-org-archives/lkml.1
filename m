Return-Path: <linux-kernel-owner+w=401wt.eu-S1756543AbZIVPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543AbZIVPjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZIVPjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:39:51 -0400
Received: from kroah.org ([198.145.64.141]:45970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084AbZIVPju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:39:50 -0400
Date: Tue, 22 Sep 2009 08:37:52 -0700
From: Greg KH <greg@kroah.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Nitin Gupta <ngupta@vflare.org>, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 0/3] compcache: in-memory compressed swapping v4
Message-ID: <20090922153752.GA24256@kroah.com>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org>
 <1253600030.30406.2.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253600030.30406.2.camel@penberg-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 09:13:50AM +0300, Pekka Enberg wrote:
> On Tue, 2009-09-22 at 10:26 +0530, Nitin Gupta wrote:
> >  drivers/staging/Kconfig                   |    2 +
> >  drivers/staging/Makefile                  |    1 +
> >  drivers/staging/ramzswap/Kconfig          |   21 +
> >  drivers/staging/ramzswap/Makefile         |    3 +
> >  drivers/staging/ramzswap/ramzswap.txt     |   51 +
> >  drivers/staging/ramzswap/ramzswap_drv.c   | 1462 +++++++++++++++++++++++++++++
> >  drivers/staging/ramzswap/ramzswap_drv.h   |  173 ++++
> >  drivers/staging/ramzswap/ramzswap_ioctl.h |   50 +
> >  drivers/staging/ramzswap/xvmalloc.c       |  533 +++++++++++
> >  drivers/staging/ramzswap/xvmalloc.h       |   30 +
> >  drivers/staging/ramzswap/xvmalloc_int.h   |   86 ++
> >  include/linux/swap.h                      |    5 +
> >  mm/swapfile.c                             |   34 +
> >  13 files changed, 2451 insertions(+), 0 deletions(-)
> 
> This diffstat is not up to date, I think.
> 
> Greg, would you mind taking this driver into staging? There are some
> issues that need to be ironed out for it to be merged to kernel proper
> but I think it would benefit from being exposed to mainline.

That would be fine, will there be a new set of patches for me to apply,
or is this the correct series?

thanks,

greg k-h
