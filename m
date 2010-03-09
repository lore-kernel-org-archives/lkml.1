Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab0CISrc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 13:47:32 -0500
Received: from kroah.org ([198.145.64.141]:52709 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab0CISra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 13:47:30 -0500
Date: Tue, 9 Mar 2010 10:47:23 -0800
From: Greg KH <greg@kroah.com>
To: Alex Chiang <achiang@hp.com>
Cc: sarah.a.sharp@linux.intel.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] small xhci cleanups
Message-ID: <20100309184723.GA31374@kroah.com>
References: <20100309174815.29339.96173.stgit@bob.kio>
 <20100309181413.GB31027@kroah.com>
 <20100309183227.GD15974@grease.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100309183227.GD15974@grease.lan>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 09, 2010 at 11:32:27AM -0700, Alex Chiang wrote:
> * Greg KH <greg@kroah.com>:
> > On Tue, Mar 09, 2010 at 10:52:43AM -0700, Alex Chiang wrote:
> > 
> > >       USB: xhci: move all debug code under CONFIG_XHCI_HCD_DEBUGGING
> > 
> > Does this conflict with Sarah's other debugging patch she just sent out?
> 
> I'm assuming you're talking about this patch:
> 
> 	http://thread.gmane.org/gmane.linux.usb.general/28681

Yes.

> Yes, we'll definitely have conflicts. If you agree that we should
> move the debug code under the Kconfig option, then the best
> course of action would be for Sarah to rebase her work on top of
> my patches (since they're intrusive).

As Sarah is the maintainer of the file, I'll leave that decision up to
her :)

And keeping a config option for debugging isn't a good idea.  The rest
of the kernel has switched to using dynamic debugging, so that distros
and others can easily get information without requiring a kernel rebuild
(which we can't expect users to always be able to do.)  So I would not
recommend this change.

thanks,

greg k-h
