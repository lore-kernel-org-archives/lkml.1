Return-Path: <linux-kernel-owner+w=401wt.eu-S934761AbXLPQ7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934761AbXLPQ7l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 11:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765954AbXLPQ7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 11:59:31 -0500
Received: from styx.suse.cz ([82.119.242.94]:56853 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754860AbXLPQ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 11:59:30 -0500
Date: Sun, 16 Dec 2007 17:59:28 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nicolas Mailhot <nicolas.mailhot@laposte.net>
cc: argyllcms@freelists.org, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       Frederic Crozat <fcrozat@mandriva.com>, Greg KH <greg@kroah.com>
Subject: Re: [argyllcms] Re: [PATCH] usb/hid: Blacklist the Gretag-Macbeth
 Huey display	colorimeter
In-Reply-To: <1197634579.2766.8.camel@rousalka.dyndns.org>
Message-ID: <Pine.LNX.4.64.0712161756480.12449@jikos.suse.cz>
References: <1197585460.28927.2.camel@rousalka.dyndns.org> 
 <20071214053853.GD7765@kroah.com>  <1197626696.5281.5.camel@rousalka.dyndns.org>
  <47626D00.202@argyllcms.com> <1197634579.2766.8.camel@rousalka.dyndns.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Dec 2007, Nicolas Mailhot wrote:

> > Actually (to put it frankly), I'm amazed that this exceptions list is 
> > compiled into the driver. I would have thought that such a list should 
> > at least be in a configuration file that an installed application can 
> > add or delete, if not something more sophisticated.
> Something more sophisticated will happen someday, this is what we have
> now.

There is also possibility (for quite a few releases already) to change the 
quirk list in runtime. See the 'quirk' parameter to the usbhid module.

> > What will happen if the HID driver is fixed to allow arbitrary 
> > messages, and I want to switch back to using it rather than libusb ?

What exactly is the problem here? I didn't seem to catch the beginning of 
the thread (or it happened off the list I am subscribed to).

I will apply the patch to my tree, thanks.

-- 
Jiri Kosina
SUSE Labs
