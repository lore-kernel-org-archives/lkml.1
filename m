Return-Path: <linux-kernel-owner+w=401wt.eu-S1757339AbXKIWJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757339AbXKIWJG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbXKIWIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:08:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36498 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbXKIWIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:08:55 -0500
Date: Fri, 9 Nov 2007 13:32:23 -0800
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@gentoo.org>, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, kay.sievers@vrfy.org,
       linux-hotplug-devel@lists.sourceforge.net, oneukum@suse.de
Subject: Re: [PATCH] create /sys/.../power when CONFIG_PM is set
Message-ID: <20071109213223.GA28276@kroah.com>
References: <20071107101043.2E64C9D4ECC@zog.reactivated.net> <20071109130555.5304d49a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071109130555.5304d49a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2007 at 01:05:55PM -0800, Andrew Morton wrote:
> On Wed,  7 Nov 2007 10:10:43 +0000 (GMT)
> Daniel Drake <dsd@gentoo.org> wrote:
> 
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
> 
> Your patch is for 2.6.24-rc2 and 2.6.23, afacit.  It needed some work to
> apply on Greg's tree because the new pm_sleep_lock() and pm_sleep_unlock()
> went and copied the same bug as you've fixed here.
> 
> I guess the right thing to do is to apply your patch as-is to 2.6.24-rcX
> and to 2.6.23.x.  I can't really do that because doing so would wreck my
> copy of Greg's tree.
> 
> 
> So I'll run with the below (I think it's right) and will let Greg sort it
> out ;)

Yeah, I'll sort it all out :)

thanks,

greg k-h
