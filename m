Return-Path: <linux-kernel-owner+w=401wt.eu-S1758350AbYAJDq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbYAJDq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 22:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbYAJDqT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 22:46:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:49515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756210AbYAJDqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 22:46:18 -0500
Date: Wed, 9 Jan 2008 19:49:52 -0800
From: Greg KH <gregkh@suse.de>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org,
       Zhao Yakui <yakui.zhao@intel.com>, Li Shaohua <shaohua.li@intel.com>,
       Thomas Renninger <trenn@suse.de>, Adam Belay <ambx1@neo.rr.com>,
       Len Brown <lenb@kernel.org>
Subject: Re: Linux 2.6.23.12
Message-ID: <20080110034952.GC20448@suse.de>
References: <20071218224559.GA12696@kroah.com> <20071218224635.GB12696@kroah.com> <200801021342.23763.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801021342.23763.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 01:42:23PM -0700, Bjorn Helgaas wrote:
> The patch below was put in 2.6.23.12 as a fix for
> http://bugzilla.kernel.org/show_bug.cgi?id=9514.  It apparently
> does make 9514 go away, but only by coincidence.  There are a
> couple other ideas about fixing 9514.  My proposed patch is
> attached in the bugzilla.
> 
> The .12 patch reduces the number of resources we reserve from
> 24 to 8 ioport regions and from 12 to 4 mmio regions per PNP device.
> It also removes a warning about regions we ignore.

That patch was merely a revert of a prior patch, it did not "do"
anything new at all :)

> Obviously, we want to reserve ALL the regions for PNP devices,
> and Thomas is working on a patch for that (which I hope will be
> ready for 2.6.25).  But in the meantime, the .12 patch makes it
> more likely that we will have resource conflicts with PNP devices.
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=9630 appears to be
> such a conflict.
> 
> I think the patch below should be removed from the stable series.

What do you mean "removed"?  It was a revert of a prior patch, as this
patch was reported to cause real problems.

Do you want me to add it back, and then add another patch?  If so, can
you please send the requested patches to stable@kernel.org so I can do
it?

thanks,

greg k-h
