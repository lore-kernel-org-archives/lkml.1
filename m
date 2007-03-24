Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXCXXo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXCXXo1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 19:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933140AbXCXXo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 19:44:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:44600 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933104AbXCXXo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 19:44:26 -0400
Date: Sat, 24 Mar 2007 16:41:54 -0700
From: Greg KH <gregkh@suse.de>
To: "Kok, Auke" <auke-jan.h.kok@intel.com>
Cc: "Williams, Mitch A" <mitch.a.williams@intel.com>,
       linux-kernel@vger.kernel.org, mingo@redhat.com,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 2.6.20.3] Flush writes to MSI-X table
Message-ID: <20070324234154.GA10057@suse.de>
References: <20070323222207.GB22500@suse.de> <08FE5CC30C9A3F41BF819A502CF7BF6EF55DD2@fmsmsx411.amr.corp.intel.com> <20070324002802.GA18061@suse.de> <20070324003030.GA18615@suse.de> <4605B555.3020107@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4605B555.3020107@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 04:33:41PM -0700, Kok, Auke wrote:
> Greg KH wrote:
> >On Fri, Mar 23, 2007 at 05:28:02PM -0700, Greg KH wrote:
> >>On Fri, Mar 23, 2007 at 05:24:23PM -0700, Williams, Mitch A wrote:
> >>>Greg KH wrote:
> >>>>Well, I'm sure you can agree that it is _very_ late in the 2.6.21
> >>>>release cycle to expect to get this in for that kernel.  How about
> >>>>waiting for 2.6.22 and if it's a big deal, getting it into the
> >>>>2.6.21-stable tree if needed.
> >>>>
> >>>>So far I have not seen any bug reports that this patch would fix, have
> >>>>you?
> >>>Well, I've seen several bug reports on this issue -- but they're all
> >>>internal to Intel.
> >>>
> >>>However, we do have here a real bug, which shows up on real hardware,
> >>>which will be released soon.  Obviously, I can't discuss release
> >>>schedules, but "soon" is a good word to use.  You might find out more if
> >>>you read The Register (wink, wink).
> >>Ok, but again, as this is something that no one outside of a company can
> >>see, it doesn't really make sense to rush it into the kernel.
> >>
> >>>Given the time frame for release of 2.6.21, I'd be fine with skipping
> >>>2.6.20.x, and putting this in 2.6.21.  But we really don't want to wait
> >>>for 2.6.22.
> >>I think it needs to wait, especially given that there is no public
> >>hardware yet.
> >>
> >>I'll add this to my queue.
> >
> >No, nevermind, I'll wait till it hits linux-pci and gets review from the
> >people there, as there are a _ton_ of other pending MSI patches that you
> >will need to be aware of, as they might conflict with this patch.
> >Please see the linux-pci archives for details of them.
> 
> Actually Mitch and me have been monitoring those and applying them as they 
> came in for the last two months as some of those partially impacted 
> (improved) the issue. The read flush to update the msi-x tables is the only 
> thing missing right now.

Are you including the 21 set MSI patch that want to linux-pci two days
ago?

I don't understand your need to try to rush an api change like this in
so quickly in an area that has a lot of churn and disagreement lately.
_Especially_ so late in the release cycle, and with no hardware publicly
availble.  What is the pressing need here?

thanks,

greg k-h
