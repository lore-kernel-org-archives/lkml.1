Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbXKGQpZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbXKGQpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 11:45:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754694AbXKGQpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 11:45:16 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37163 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754682AbXKGQpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 11:45:14 -0500
Date: Wed, 7 Nov 2007 11:45:14 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Drake <dsd@gentoo.org>
cc: rjw@sisk.pl, <linux-pm@lists.linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <kay.sievers@vrfy.org>,
       <linux-hotplug-devel@lists.sourceforge.net>, <greg@kroah.com>,
       <oneukum@suse.de>
Subject: Re: [PATCH] create /sys/.../power when CONFIG_PM is set
In-Reply-To: <20071107101043.2E64C9D4ECC@zog.reactivated.net>
Message-ID: <Pine.LNX.4.44L0.0711071143200.4444-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2007, Daniel Drake wrote:

> The CONFIG_SUSPEND changes in 2.6.23 caused a regression under certain
> configuration conditions (SUSPEND=n, USB_AUTOSUSPEND=y) where all USB device
> attributes in sysfs (idVendor, idProduct, ...) silently disappeared, causing
> udev breakage and more.
> 
> The cause of this is that the /sys/.../power subdirectory is now only created
> when CONFIG_PM_SLEEP is set, however, it should be created whenever CONFIG_PM
> is set to handle the above situation. The following patch fixes the
> regression.
> 
> Signed-off-by: Daniel Drake <dsd@gentoo.org>

I haven't tried applying this, but it looks okay to me.  There may be 
some conflict with other changes already merged in the PM core.

Alan Stern

