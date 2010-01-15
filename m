Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab0AOSFB (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 13:05:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757936Ab0AOSE5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 13:04:57 -0500
Received: from kroah.org ([198.145.64.141]:36451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757922Ab0AOSE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 13:04:56 -0500
Date: Fri, 15 Jan 2010 10:02:33 -0800
From: Greg KH <greg@kroah.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Driver-Core: devtmpfs - remove EXPERIMENTAL and enable it by
 default
Message-ID: <20100115180233.GB10981@kroah.com>
References: <1263505677.2074.2.camel@yio.site>
 <4B5076E2.2090203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B5076E2.2090203@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 15, 2010 at 03:08:34PM +0100, Stefan Richter wrote:
> Kay Sievers wrote:
> >  config DEVTMPFS_MOUNT
> > -	bool "Automount devtmpfs at /dev"
> > +	bool "Automount devtmpfs at /dev, after the kernel mouted the rootfs"
> 
> mouted -> mounted
> 
> >  	depends on DEVTMPFS
> > +	default y
> >  	help
> > -	  This will mount devtmpfs at /dev if the kernel mounts the root
> > -	  filesystem. It will not affect initramfs based mounting.
> > -	  If unsure, say N here.
> > +	  This will instruct the kernel to automatically mount the
> > +	  devtmpfs filesystem at /dev, directly after the kernel has
> > +	  mounted the root filesystem. The behavior can be overridden
> > +	  with the commandline parameter: devtmpfs.mount=0|1.
> > +	  This option does not affect initramfs based booting, here
> > +	  the devtmpfs filesystem always needs to be mouted manually
> 
> Here too.

Thanks for the review, I've edited the patch to include these spelling
changes.

greg k-h
