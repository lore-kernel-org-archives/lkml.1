Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757912Ab0AOSEs (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:04:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901Ab0AOSEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:04:47 -0500
Received: from kroah.org ([198.145.64.141]:36442 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756510Ab0AOSEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:04:47 -0500
Date: Fri, 15 Jan 2010 09:33:11 -0800
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another dt3155 driver for drivers/staging
Message-ID: <20100115173311.GA10695@kroah.com>
References: <201001122242.22774.mitov@issp.bas.bg>
 <20100114031345.GA22542@aao.gov.au>
 <20100114034055.GA27311@kroah.com>
 <201001142139.26837.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001142139.26837.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 09:39:26PM +0200, Marin Mitov wrote:
> Hi Greg,
> > > 
> > > No. They are both standalone drivers. If we want V4L2 compatibility
> > > we would have to modify (either) driver significantly.
> 
> Both are character drivers. My one uses open, read, mmap, ioctl, close.
> Mainly tested on read. mmap works, but not yet extensively tested.
> ioctl is used to start/stop acquisition, get info about buffer length,
> and some error statistics collected during acquisitions.
> 
> see:
> 
> http://lfb.issp.bas.bg/~mitov/linux/dt3155pci/00README
> 
> for more detailed description.

Thanks, but the code needs to use the v4l interface, as it is a video
device.

> > Well, that will be the requirement to get it merged into the main
> > portion of the kernel tree.  No special interfaces are allowed, sorry.
> 
> I do not quite understand V4L2 lib in particular how can I get a
> contiguous buffer in physical memory which do not cross 4MB
> boundary (hardware requirement).

Try asking on the linux-media mailing list, I don't think this is a big
deal, as you have already done it in the driver, so that would not have
to be reworked.

thanks,

greg k-h
