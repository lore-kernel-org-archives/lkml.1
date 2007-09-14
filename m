Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbXINJ7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbXINJ7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 05:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750843AbXINJ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 05:59:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750898AbXINJ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 05:59:07 -0400
Date: Fri, 14 Sep 2007 02:59:00 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Kosina <jikos@jikos.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Oliver Neukum <oneukum@suse.de>,
       Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Subject: Re: [GIT PATCH] USB autosuspend fixes for 2.6.23-rc6
Message-ID: <20070914095900.GA19032@suse.de>
References: <Pine.LNX.4.44L0.0709131421130.7406-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0709141047580.24429@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709141047580.24429@twin.jikos.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2007 at 10:55:46AM +0200, Jiri Kosina wrote:
> For the rest of the HID quirks -- most of them are also workarounds for 
> broken classess of devices. Usually, they claim to be HID-compliant device 
> in their file descriptor, but they do not follow the spec (they send 
> inverted axes values, send usage codes that violate the specification, 
> etc), but we can easily work around these bugs by a few lines of code and 
> let the devices to be handled by usbhid flawlessly. I guess this is worth 
> it.

The reason for this is that the only way to write a userspace "driver"
for USB devices on Windows versions prior to Vista was to be a HID
device.  Your userspace program could then easily grab the device and
control it.

This could be fixed in Linux by providing a way to have driver
"heirachy" for USB whereby a vendor/product id providing driver would
take a higher priority than a class driver.

But we've been talking about that for over 7 years now :)

thanks,

greg k-h
