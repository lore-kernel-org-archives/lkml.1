Return-Path: <linux-kernel-owner+w=401wt.eu-S1763193AbYASAe7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763193AbYASAe7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 19:34:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757317AbYASAew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 19:34:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34075 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757047AbYASAev (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 19:34:51 -0500
Date: Fri, 18 Jan 2008 16:35:21 -0800
From: Greg KH <gregkh@suse.de>
To: Kevin Lloyd <klloyd@sierrawireless.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] usb-serial: Sierra driver - add devices and update dtr
Message-ID: <20080119003521.GA14512@suse.de>
References: <1199992265.9266.19.camel@linux-z60t> <20080110195403.GA29384@suse.de> <3415E2A2AB26944B9159CDB22001004D022572F5@nestea.sierrawireless.local> <20080111210234.GA3070@suse.de> <3415E2A2AB26944B9159CDB22001004D022577B3@nestea.sierrawireless.local> <20080117180453.GA7780@suse.de> <3415E2A2AB26944B9159CDB22001004D02296DC3@nestea.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3415E2A2AB26944B9159CDB22001004D02296DC3@nestea.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 17, 2008 at 03:15:23PM -0800, Kevin Lloyd wrote:
> > > Correct, the 0x0023 is the only newly added device that requires the
> new
> > > features.
> >
> > Does that mean things will not work for this device if it is added to
> > the device table, without the code updates?
> Adding the device will not break the driver (assuming you remove the
> tag).

Which "tag"?  The device id?

> > And is this device even public yet?
> 
> No, but we are trying to add native support for devices into kernels
> well before they are released in an effort give better native support
> to end-users.

Ok, that's great to do, and is what needs to be done, just can't add new
features during the "bug-fix-only" cycle of development :)

thanks,

greg k-h
