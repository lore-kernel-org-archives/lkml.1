Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0BYQom (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:44:42 -0500
Received: from kroah.org ([198.145.64.141]:34532 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932906Ab0BYQok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:44:40 -0500
Date: Thu, 25 Feb 2010 08:44:36 -0800
From: Greg KH <greg@kroah.com>
To: Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Problem with auto-detecting a HV environment from within Linux
Message-ID: <20100225164436.GA3310@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

In looking at the HV code, there doesn't seem to be a way to
automatically detect if we are running in a HV environment in order to
know to load the drivers in the first place.

Normally, we trigger off of things like PCI ids, or some other
externally visible id to know if we can properly load the drivers.

This also is a problem for distros, as they need to know to include the
drivers or not, through their device update processes (i.e. rpm and
install tools can detect pci dependancies of a machine to know to set
things properly.)

So, is there a way to "know" ahead of time if we are in a HV guest
environment?  I was told that there is a Microsoft VGA adapter that is
exposed to the guest, could we trigger off of this device?  Or is there
some other unique PCI id that we could use?

thanks,

greg k-h
