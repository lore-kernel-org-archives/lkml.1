Return-Path: <linux-kernel-owner+w=401wt.eu-S1757396AbXGRIgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbXGRIgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 04:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752104AbXGRIgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 04:36:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41460 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbXGRIgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 04:36:31 -0400
Date: Wed, 18 Jul 2007 01:36:00 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] drivers/base/core: improve device_add() error
	handling, fix bugs
Message-ID: <20070718083600.GA21650@kroah.com>
References: <20070718055348.GA5734@havoc.gtf.org> <20070718101501.6af017bc@gondolin.boeblingen.de.ibm.com> <469DCC4A.9010001@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <469DCC4A.9010001@garzik.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2007 at 04:16:10AM -0400, Jeff Garzik wrote:
>  Cornelia Huck wrote:
> > On Wed, 18 Jul 2007 01:53:48 -0400,
> > Jeff Garzik <jeff@garzik.org> wrote:
> >> The following change was checked into 'warnings' branch of
> >> git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git
> >>
> >> commit 5330916f5a11d8b7def46a6b3e14a831684032f5
> >> Author: Jeff Garzik <jeff@garzik.org>
> >> Date:   Wed Jul 18 01:41:29 2007 -0400
> >>
> >>     drivers/base/core: improve device_add() error handling, fix bugs
> >>         * silence several warnings by handling sysfs_create_link() failure
> >>         * re-order some operations in error handling, to precisely reverse
> >>       the order of operations, i.e. unwind properly.
> >>         Signed-off-by: Jeff Garzik <jeff@garzik.org>
> >>
> >>  drivers/base/core.c |   46 ++++++++++++++++++++++++++++++----------------
> >>  1 file changed, 30 insertions(+), 16 deletions(-)
> > Hm, what about driver-core-check-return-code-of-sysfs_create_link.patch
> > (merged with ...-fix.patch) which has been in -mm for a while?
> 
>  No idea, I didn't check there.   If someone else has a better patch... 
>  great!  Let's merge it :)

It's in my queue.

Or it should be, hm, Cornelia, can you resend it, I seem to have dropped
it :(

thanks,

greg k-h
