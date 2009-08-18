Return-Path: <linux-kernel-owner+w=401wt.eu-S1759227AbZHRO7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227AbZHRO7W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 10:59:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbZHRO7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 10:59:22 -0400
Received: from kroah.org ([198.145.64.141]:35888 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759173AbZHRO7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 10:59:21 -0400
Date: Tue, 18 Aug 2009 07:58:00 -0700
From: Greg KH <greg@kroah.com>
To: Eric Miao <eric.y.miao@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, "Aric D. Blumer" <aric@sdgsystems.com>,
       Mike Rapoport <mike@compulab.co.il>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: usb/pxa trees build failure
Message-ID: <20090818145800.GB6074@kroah.com>
References: <20090818135852.0b3b648d.sfr@canb.auug.org.au>
 <20090818114242.GA28534@kroah.com>
 <4A8AB525.7050404@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A8AB525.7050404@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 10:05:25PM +0800, Eric Miao wrote:
> Greg KH wrote:
> > On Tue, Aug 18, 2009 at 01:58:52PM +1000, Stephen Rothwell wrote:
> >> Hi Eric, Greg,
> >>
> >> The next-20090817 (and a few before) build (arm trizeps4_defconfig)
> >> failed like this:
> >>
> >> drivers/usb/host/ohci-pxa27x.c:507: error: 'pdev' undeclared (first use in this function)
> >>
> >> Caused by the interaction of commit
> >> 6458baec17e19d38b9d4eb1f96c213f91609c0e3 ("USB: ohci-pxa27x: Reconfigure
> >> power settings on resume") from the usb tree with commit
> >> b8fb7d4317bcea1b48c9560d23dff81121870ece ("[ARM] pxa: update
> >> ohci-pxa27x.c to use 'struct dev_pm_ops'"). from the pxa tree.
> >>
> >> Greg/Aric, maybe that usb tree patch needs to go through the pxa tree?
> >> (and maybe "USB: ohci-pxa27x: Allow NOCP and OCPM to be cleared" as well?)
> >>
> >> [this also broke the following configs: magician_defconfig,
> >> em_x270_defconfig and cm_x2xx_defconfig.]
> > 
> > Ick, not good.  Aric, should I drop this patch from my tree?
> > 
> 
> I think so, might be better to go through the pxa tree so that I can give
> another review. (the fiber across the pacific seems to be broken again, so
> I have to look into this tomorrow, still fetching -next, sigh).

Ok, let me know if you want me to drop these patches from my tree.

thanks,

greg k-h
