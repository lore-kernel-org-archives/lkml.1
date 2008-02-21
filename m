Return-Path: <linux-kernel-owner+w=401wt.eu-S935046AbYBUWV4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935046AbYBUWV4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:21:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761564AbYBUWVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:21:47 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:40868 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755292AbYBUWVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:21:46 -0500
Date: Thu, 21 Feb 2008 23:22:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@suse.de, greg@kroah.com, linux-kernel@vger.kernel.org,
       linux-pm@lists.osdl.org
Subject: Re: [linux-pm] patch power_state-remove-it-from-usb.patch added to
	gregkh-2.6 tree
Message-ID: <20080221222202.GB25977@elf.ucw.cz>
References: <1203630196303@kroah.org> <Pine.LNX.4.44L0.0802211717230.4990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0802211717230.4990-100000@iolanthe.rowland.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-02-21 17:18:32, Alan Stern wrote:
> On Thu, 21 Feb 2008 gregkh@suse.de wrote:
> 
> > This is a note to let you know that I've just added the patch titled
> > 
> >      Subject: power_state: remove it from usb
> > 
> > to my gregkh-2.6 tree.  Its filename is
> > 
> >      power_state-remove-it-from-usb.patch
> > 
> > This tree can be found at 
> >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> > 
> > 
> > From pavel@ucw.cz  Thu Feb 21 13:36:03 2008
> > From: Pavel Machek <pavel@ucw.cz>
> > Date: Thu, 21 Feb 2008 14:01:45 +0100
> > Subject: power_state: remove it from usb
> > To: kernel list <linux-kernel@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.osdl.org>, Greg KH <greg@kroah.com>, stern@rowland.harvard.edu, linux-usb@vger.kernel.org
> > Message-ID: <20080221130145.GA3789@elf.ucw.cz>
> > Content-Disposition: inline
> > 
> > 
> > 
> > power_state is scheduled for removal, and it is used only write-only
> > by USB. Remove it.
> 
> Greg, this patch is incomplete.  Some of the settings that Pavel 
> removed are used by the host controller drivers.  Please revert this; 
> I'll send a more complete patch later.

Alan is right, I was blind... and my config was not affected...
...
host/sl811-hcd.c:	if (dev->dev.power.power_state.event == PM_EVENT_SUSPEND
misc/usbtest.c:	if (intf->dev.power.power_state.event != PM_EVENT_ON) {
...

									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
