Return-Path: <linux-kernel-owner+w=401wt.eu-S934088AbXK2WhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934088AbXK2WhU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 17:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbXK2WhD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 17:37:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57229 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759437AbXK2Wg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 17:36:57 -0500
Date: Thu, 29 Nov 2007 14:11:32 -0800
From: Greg KH <gregkh@suse.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Lord <lkml@rtr.ca>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>,
       linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] [PATCH] base/class.c: prevent ooops due to
	insert/remove race (v3)
Message-ID: <20071129221132.GA13651@suse.de>
References: <474F2532.5090708@rtr.ca> <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0711291700260.5666-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 05:07:58PM -0500, Alan Stern wrote:
> On Thu, 29 Nov 2007, Mark Lord wrote:
> 
> > > So again, the problem is in the higher up scsi layer, and that is where
> > > the problem should already be fixed.
> > ..
> > 
> > Ahhh.. so you figure the Oops should also have been fixed
> > as part of the 2.6.24 SCSI fixes ?  That's what I was missing here.
> 
> Yes indeed.  I wish I could point you to the exact patch containing the 
> fix, but the git software seems to have lost track of it (it's combined
> in with a large number of other patches with no obvious way to separate 
> it out).  It's also available in the various mailing list archives, but 
> I don't have a pointer to it and there's no reasonable way to search 
> for it.
> 
> The patch in question was written by Matthew Wilcox; it added code to 
> the SCSI async-scanning routines to utilize the scan_mutex.  IMO it 
> should have been applied to 2.6.23 but it wasn't.

If someone can dig it out, and send it to stable@kernel.org, I'd be
gladd to add it to the older kernel trees...

thanks,

greg k-h
