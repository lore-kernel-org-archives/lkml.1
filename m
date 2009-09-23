Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZIWAkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZIWAkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZIWAkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:40:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbZIWAkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:40:31 -0400
Date: Tue, 22 Sep 2009 17:40:20 -0700
From: Greg KH <greg@kroah.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Marcin Slusarz <marcin.slusarz@gmail.com>, Ed Tomlinson <edt@aei.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, linux-mm-cc <linux-mm-cc@laptop.org>
Subject: Re: [PATCH 0/3] compcache: in-memory compressed swapping v4
Message-ID: <20090923004020.GA2237@kroah.com>
References: <1253595414-2855-1-git-send-email-ngupta@vflare.org> <1253600030.30406.2.camel@penberg-laptop> <20090922153752.GA24256@kroah.com> <4AB8F2BE.8060007@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AB8F2BE.8060007@vflare.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 09:22:30PM +0530, Nitin Gupta wrote:
> On 09/22/2009 09:07 PM, Greg KH wrote:
> > On Tue, Sep 22, 2009 at 09:13:50AM +0300, Pekka Enberg wrote:
> >> On Tue, 2009-09-22 at 10:26 +0530, Nitin Gupta wrote:
> >>>  drivers/staging/Kconfig                   |    2 +
> >>>  drivers/staging/Makefile                  |    1 +
> >>>  drivers/staging/ramzswap/Kconfig          |   21 +
> >>>  drivers/staging/ramzswap/Makefile         |    3 +
> >>>  drivers/staging/ramzswap/ramzswap.txt     |   51 +
> >>>  drivers/staging/ramzswap/ramzswap_drv.c   | 1462 +++++++++++++++++++++++++++++
> >>>  drivers/staging/ramzswap/ramzswap_drv.h   |  173 ++++
> >>>  drivers/staging/ramzswap/ramzswap_ioctl.h |   50 +
> >>>  drivers/staging/ramzswap/xvmalloc.c       |  533 +++++++++++
> >>>  drivers/staging/ramzswap/xvmalloc.h       |   30 +
> >>>  drivers/staging/ramzswap/xvmalloc_int.h   |   86 ++
> >>>  include/linux/swap.h                      |    5 +
> >>>  mm/swapfile.c                             |   34 +
> >>>  13 files changed, 2451 insertions(+), 0 deletions(-)
> >>
> >> This diffstat is not up to date, I think.
> >>
> >> Greg, would you mind taking this driver into staging? There are some
> >> issues that need to be ironed out for it to be merged to kernel proper
> >> but I think it would benefit from being exposed to mainline.
> > 
> > That would be fine, will there be a new set of patches for me to apply,
> > or is this the correct series?
> > 
> 
> This is the correct series.

Ok, thanks, I'll queue it up when I get back from the Plumbers
conference.

greg k-h
