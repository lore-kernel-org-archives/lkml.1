Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbXKHAcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbXKHAcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 19:32:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbXKHAcG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 19:32:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56225 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbXKHAcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 19:32:02 -0500
Date: Wed, 7 Nov 2007 16:27:35 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Daniel Drake <dsd@gentoo.org>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, stern@rowland.harvard.edu,
       kay.sievers@vrfy.org, linux-hotplug-devel@lists.sourceforge.net,
       oneukum@suse.de, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] create /sys/.../power when CONFIG_PM is set
Message-ID: <20071108002735.GA22848@kroah.com>
References: <20071107101043.2E64C9D4ECC@zog.reactivated.net> <200711072324.56125.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200711072324.56125.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 07, 2007 at 11:24:55PM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 7 of November 2007, Daniel Drake wrote:
> > The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
> > configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB device
> > attributes in sysfs (idVendor, idProduct, ...) silently disappeared, causing
> > udev breakage and more.
> > 
> > The cause of this is that the /sys/.../power subdirectory is now only created
> > when CONFIG_PM_SLEEP is set, however, it should be created whenever CONFIG_PM
> > is set to handle the above situation. The following patch fixes the
> > regression.
> > 
> > Signed-off-by: Daniel Drake <dsd@gentoo.org>
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Greg, I think this patch should go through your tree?

Yes, I'll take it.  I'm at a conference until Friday, but will take it
then and then get it to Linus before 2.6.24 is out.

thanks,

greg k-h
