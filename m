Return-Path: <linux-kernel-owner+w=401wt.eu-S1757872AbXKGT7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757872AbXKGT7k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 14:59:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXKGT7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 14:59:32 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:48305 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081AbXKGT7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 14:59:32 -0500
Date: Wed, 7 Nov 2007 11:53:20 -0800
From: Greg KH <greg@kroah.com>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andrew Morton <akpm@osdl.org>, perfmon@napali.hpl.hp.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix up perfmon to build on -mm
Message-ID: <20071107195320.GA5823@kroah.com>
References: <20071107003454.GA13374@kroah.com> <20071107134255.GE14646@frankl.hpl.hp.com> <20071107174747.GA9918@kroah.com> <20071107175742.GJ14646@frankl.hpl.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071107175742.GJ14646@frankl.hpl.hp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 09:57:42AM -0800, Stephane Eranian wrote:
> Greg,
> 
> On Wed, Nov 07, 2007 at 09:47:47AM -0800, Greg KH wrote:
> > On Wed, Nov 07, 2007 at 05:42:55AM -0800, Stephane Eranian wrote:
> > > Greg,
> > > 
> > > Perfmon sysfs document has been updated following your adivce.
> > > you can check out in my perfmon tree  the following commit:
> > > 
> > > 	e83278f879e52ecee025effe9ad509fd51e4a516
> > 
> > Thanks, that looks a lot better.
> > 
> > Do you want me to send you patches based on this tree to help clean up
> > the sysfs usage now that it's documented?
> > 
> Yes, send me the patches. But from what you were saying earlier it seems
> I would need an extra sysfs patches to make this compile. Is that particular
> patch already in Linus's tree?

No, it's in my tree, and will be in the next -mm.  You will need a few
patches to get this to work, not just a single patch.

> > Also, a lot of your per-cpu sysfs files should probably move to debugfs
> > as they are for debugging only, right?  No need to clutter up sysfs with
> > them when only the very few perfmon developers would be needing access
> > to them.
> > 
> Yes, this is mostly debugging. If debugfs is meant for this, then I'll
> be happy to move this stuff over there. Is there some good example of how
> I could do that based on my current sysfs code?

There is documentation for debugfs in the kernel api document :)

And, there are many in-kernel users of debugfs, a grep for
"debugfs_create_" should show you some examples of how to use this.  If
you have any questions, please let me know.

thanks,

greg k-h
