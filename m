Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbZAHREe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbZAHREe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751930AbZAHREZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:04:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:52429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751072AbZAHREY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:04:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [Regression] USB wakeup problem on Toshiba Portege R500
Date: Thu, 8 Jan 2009 18:03:48 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@suse.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>
References: <200901080835.39639.rjw@sisk.pl> <200901081736.12926.rjw@sisk.pl> <200901081748.58962.oliver@neukum.org>
In-Reply-To: <200901081748.58962.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901081803.49632.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 January 2009, Oliver Neukum wrote:
> Am Thursday 08 January 2009 17:36:12 schrieb Rafael J. Wysocki:
> > > We do support remote wakeup from PS2 keyboards. So you might argue we
> > > should do the same for USB HID devices.
> > 
> > Well, _I_ can live with a few 'echo disabled > /sys/devices/.../power/wakeup'
> > lines in my init scripts, but I'm afraid we're going to get many problem
> > reports related to this.  This means people will likely lose time on trying to
> > debug this problem and someone will have to handle the reports.  Are you
> > volunteering to do that?
> 
> You are making a very persuasive argument for reverting it.
> But what about laptops that only have a USB keyboard?

Well, up to and including 2.6.28 they needed to echo 'enable' to the USB
controllers' /sys/devices/.../power/wakeup files, so if the patch is reverted,
they won't be worse off than they were day before yestarday. :-)

Perhaps we can choose the default depending on whether or not any HID devices
are attached to given controller?

Thanks,
Rafael
