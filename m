Return-Path: <linux-kernel-owner+w=401wt.eu-S1759234AbXIMJwO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759234AbXIMJwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2007 05:52:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750768AbXIMJv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Sep 2007 05:51:58 -0400
Received: from cantor.suse.de ([195.135.220.2]:50224 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713AbXIMJv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2007 05:51:58 -0400
Date: Thu, 13 Sep 2007 02:53:13 -0700
From: Greg KH <gregkh@suse.de>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH]PCI:disable resource decode in PCI BAR detection
Message-ID: <20070913095313.GA745@suse.de>
References: <1189664467.17835.1.camel@sli10-conroe.sh.intel.com> <20070913073140.GA17367@parisc-linux.org> <1189668286.18361.3.camel@sli10-conroe.sh.intel.com> <20070913075536.GB17367@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070913075536.GB17367@parisc-linux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2007 at 01:55:36AM -0600, Matthew Wilcox wrote:
> On Thu, Sep 13, 2007 at 03:24:46PM +0800, Shaohua Li wrote:
> > On Thu, 2007-09-13 at 01:31 -0600, Matthew Wilcox wrote:
> > > You missed the part where we have to avoid doing this for host bridges ...
> > > 
> > > http://marc.info/?l=linux-kernel&m=118809338631160&w=2
> > > 
> > > (I believe it's now queued in Greg's tree, and possibly Andrew's tree
> > > too)
> > Hmm, I don't know there is already a fix for this, so waste a whole
> > morning :(. yes, your patch looks better.
> 
> Yes, this bug is causing a lot of people to waste time.  I fielded an
> internal request for this patch this afternoon.  I appreciate we're
> post-rc6 at this point, but it does rather suck to be releasing a kernel
> which freezes on boot on this class of machines.

But it's not like the kernel every worked on this class of machines,
right?  This is not something that was a regression from what I can see.

> Unfortunately if this patch does cause any machine to break, these will
> be machines that worked fine up until this point, so that would be a
> regression, which is worse.  Life sucks.

If, after a while, you think the change should go into the -stable tree,
I have no objection.

thanks,

greg k-h
