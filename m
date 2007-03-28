Return-Path: <linux-kernel-owner+w=401wt.eu-S1753924AbXC1EUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924AbXC1EUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 00:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXC1EUU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 00:20:20 -0400
Received: from canuck.infradead.org ([209.217.80.40]:57352 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbXC1EUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 00:20:19 -0400
Date: Tue, 27 Mar 2007 21:10:05 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: new sysfs layout and ethernet device names
Message-ID: <20070328041005.GA7550@kroah.com>
References: <20070320170102.GA16341@nostromo.devel.redhat.com> <3ae72650703220147j42db8f79s734d4755c2fa43fd@mail.gmail.com> <20070328031743.GA11819@nostromo.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070328031743.GA11819@nostromo.devel.redhat.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2007 at 11:17:43PM -0400, Bill Nottingham wrote:
> Kay Sievers (kay.sievers@vrfy.org) said: 
> > >If you *do* try to use one of these names, the rename will succeed...
> > >partway. The link in /sys/class/net is renamed, the directory is
> > >not (as it obviously can't rename on top of whatever is already there.)
> > >Various networking tools then break in assorted ways due to the
> > >naming disconnect.
> > >
> > >Going back to the deprecated layout makes these names available again -
> > >it's possible (although not necessarily likely) that the new layout
> > >will break someone's device configuration if they upgrade kernels,
> > >even if the rest of their tools are updated for the new layout.
> > 
> > There will be a directory at the bus-device with the name of the
> > class, that glues together the bus-devices and the class-devices in
> > the unified tree:
> >  http://git.kernel.org/?p=linux/kernel/git/gregkh/patches.git;a=blob;f=driver/driver-core-fix-namespace-issue-with-devices-assigned-to-classes.patch;hb=HEAD
> > 
> > So the network-interface(s) will be in their own directory "net",
> > below the bus-device, and don't conflict with the existing attributes.
> 
> So, the layout will change again?

If you follow the rules in Documentation/ABI/testing/sysfs-class your
program will not have any problems.

And yes, it will change by adding another subdirectory in the device
tree, but just follow the link from the /sys/class/ directorys and you
will be fine.

thanks,

greg k-h
