Return-Path: <linux-kernel-owner+w=401wt.eu-S1751812AbYLXU6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812AbYLXU6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 15:58:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbYLXU6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 15:58:31 -0500
Received: from kroah.org ([198.145.64.141]:53722 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751063AbYLXU6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 15:58:30 -0500
Date: Wed, 24 Dec 2008 12:58:35 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: avorontsov@ru.mvista.com, Alan Stern <stern@rowland.harvard.edu>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Timur Tabi <timur@freescale.com>, Li Yang <leoli@freescale.com>,
       linux-usb@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] USB: FHCI: Driver should be responsible for
	managing endpoint queues
Message-ID: <20081224205835.GA14844@kroah.com>
References: <20081223210322.GA2802@oksana.dev.rtsoft.ru> <20081224191303.GA21815@oksana.dev.rtsoft.ru> <20081224195935.GA11531@kroah.com> <20081224200845.GA1064@oksana.dev.rtsoft.ru> <20081224121853.b46e9174.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081224121853.b46e9174.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 24, 2008 at 12:18:53PM -0800, Andrew Morton wrote:
> On Wed, 24 Dec 2008 23:08:45 +0300 Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > On Wed, Dec 24, 2008 at 11:59:36AM -0800, Greg KH wrote:
> > > On Wed, Dec 24, 2008 at 10:13:03PM +0300, Anton Vorontsov wrote:
> > > > Follow these changes for the FHCI driver:
> > > 
> > > Hm, would it just make more sense to respin the whole driver?  That way
> > > it's never in the tree in a "broken" state?
> > 
> > It's for -mm tree. If I understand -mm workflow correctly, Andrew
> > will merge all the fixes into the final patch before sending it to
> > you in late -rc0 phase, when various -next git trees (on which this
> > driver depend) will be merged into the Linus tree.
> >
> > Andrew, am I correct?
> 
> Yes, that's what I do.
> 
> I prefer to see the incremental patches once a patch has had review or
> testing, so we can see which bits changed.  But if Greg intends to
> merge this driver then he'd probably prefer a fresh new patch,
> particularly as a) version 1 was only sent yesterday and b) he hasn't
> merged version #1.

I do intend to merge it, given that it's in a buildable format :)

So a merged version would be good for me.

thanks,

greg k-h
