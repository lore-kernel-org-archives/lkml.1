Return-Path: <linux-kernel-owner+w=401wt.eu-S935873AbXGUAtx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935873AbXGUAtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 20:49:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXGUAtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 20:49:45 -0400
Received: from canuck.infradead.org ([209.217.80.40]:33062 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbXGUAtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 20:49:45 -0400
Date: Fri, 20 Jul 2007 17:49:06 -0700
From: Greg KH <greg@kroah.com>
To: Rob Landley <rob@landley.net>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, linux-kernel@vger.kernel.org,
       Michael-Luke Jones <mlj28@cam.ac.uk>, Krzysztof Halasa <khc@pm.waw.pl>,
       Rod Whitby <rod@whitby.id.au>, Russell King <rmk@arm.linux.org.uk>,
       david@lang.hm
Subject: Re: Documentation for sysfs, hotplug, and firmware loading.
Message-ID: <20070721004906.GB14362@kroah.com>
References: <200707171703.31340.rob@landley.net> <200707181339.54192.rob@landley.net> <20070719101617.08c867a7@gondolin.boeblingen.de.ibm.com> <200707202021.40009.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707202021.40009.rob@landley.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2007 at 08:21:39PM -0400, Rob Landley wrote:
> I'm not trying to document /sys/devices.  I'm trying to document hotplug, 
> populating /dev, and things like firmware loading that fall out of that.  
> This requires use of sysfs, and I'm only trying to document as much of sysfs 
> as you need to do that.

Like I stated before, you do not need to even have sysfs mounted to have
a dynamic /dev.

And why do you need to document populating /dev dynamically?  udev
already solves this problem for you, it's not like people are going off
and reinventing udev for their own enjoyment would not at least look at
how it solves this problem first.

To do otherwise would be foolish :)

Firmware loading is fine to document if you wish to do so.  But again,
why?  We already have multiple userspace programs that provide this
feature for them.  Perhaps you want to document how to add firmware to a
system in order for these different programs to pick them up?

Or perhaps you want to document how to add this kind of functionality to
your kernel driver so that it can handle firmware loading by using the
firmware interface that the kernel provides?

If you just want to document the hotplug/uevent api, then do just that.
However I think you are overreaching with your scope here and getting
mighty confused in the process.

thanks,

greg k-h
