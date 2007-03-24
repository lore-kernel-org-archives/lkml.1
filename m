Return-Path: <linux-kernel-owner+w=401wt.eu-S1751786AbXCXAeE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbXCXAeE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 20:34:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXCXAeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 20:34:04 -0400
Received: from ns.suse.de ([195.135.220.2]:36374 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbXCXAeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 20:34:03 -0400
Date: Fri, 23 Mar 2007 17:30:30 -0700
From: Greg KH <gregkh@suse.de>
To: "Williams, Mitch A" <mitch.a.williams@intel.com>
Cc: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
Message-ID: <20070324003030.GA18615@suse.de>
References: <20070323222207.GB22500@suse.de> <08FE5CC30C9A3F41BF819A502CF7BF6EF55DD2@fmsmsx411.amr.corp.intel.com> <20070324002802.GA18061@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324002802.GA18061@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 05:28:02PM -0700, Greg KH wrote:
> On Fri, Mar 23, 2007 at 05:24:23PM -0700, Williams, Mitch A wrote:
> > Greg KH wrote:
> > >Well, I'm sure you can agree that it is _very_ late in the 2.6.21
> > >release cycle to expect to get this in for that kernel.  How about
> > >waiting for 2.6.22 and if it's a big deal, getting it into the
> > >2.6.21-stable tree if needed.
> > >
> > >So far I have not seen any bug reports that this patch would fix, have
> > >you?
> > 
> > Well, I've seen several bug reports on this issue -- but they're all
> > internal to Intel.
> > 
> > However, we do have here a real bug, which shows up on real hardware,
> > which will be released soon.  Obviously, I can't discuss release
> > schedules, but "soon" is a good word to use.  You might find out more if
> > you read The Register (wink, wink).
> 
> Ok, but again, as this is something that no one outside of a company can
> see, it doesn't really make sense to rush it into the kernel.
> 
> > Given the time frame for release of 2.6.21, I'd be fine with skipping
> > 2.6.20.x, and putting this in 2.6.21.  But we really don't want to wait
> > for 2.6.22.
> 
> I think it needs to wait, especially given that there is no public
> hardware yet.
> 
> I'll add this to my queue.

No, nevermind, I'll wait till it hits linux-pci and gets review from the
people there, as there are a _ton_ of other pending MSI patches that you
will need to be aware of, as they might conflict with this patch.
Please see the linux-pci archives for details of them.

thanks,

greg k-h
