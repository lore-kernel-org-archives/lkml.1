Return-Path: <linux-kernel-owner+w=401wt.eu-S935348AbYBUWfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbYBUWfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 17:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbYBUWfA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 17:35:00 -0500
Received: from cantor.suse.de ([195.135.220.2]:34967 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765887AbYBUWe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 17:34:59 -0500
Date: Thu, 21 Feb 2008 14:33:26 -0800
From: Greg KH <gregkh@suse.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>, greg@kroah.com,
       linux-kernel@vger.kernel.org, linux-pm@lists.osdl.org
Subject: Re: [linux-pm] patch power_state-remove-it-from-usb.patch added to
	gregkh-2.6 tree
Message-ID: <20080221223326.GA2480@suse.de>
References: <1203630196303@kroah.org> <Pine.LNX.4.44L0.0802211717230.4990-100000@iolanthe.rowland.org> <20080221222202.GB25977@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221222202.GB25977@elf.ucw.cz>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2008 at 11:22:02PM +0100, Pavel Machek wrote:
> On Thu 2008-02-21 17:18:32, Alan Stern wrote:
> > On Thu, 21 Feb 2008 gregkh@suse.de wrote:
> > 
> > > This is a note to let you know that I've just added the patch titled
> > > 
> > >      Subject: power_state: remove it from usb
> > > 
> > > to my gregkh-2.6 tree.  Its filename is
> > > 
> > >      power_state-remove-it-from-usb.patch
> > > 
> > > This tree can be found at 
> > >     http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
> > > 
> > > 
> > > From pavel@ucw.cz  Thu Feb 21 13:36:03 2008
> > > From: Pavel Machek <pavel@ucw.cz>
> > > Date: Thu, 21 Feb 2008 14:01:45 +0100
> > > Subject: power_state: remove it from usb
> > > To: kernel list <linux-kernel@vger.kernel.org>, Linux-pm mailing list <linux-pm@lists.osdl.org>, Greg KH <greg@kroah.com>, stern@rowland.harvard.edu, linux-usb@vger.kernel.org
> > > Message-ID: <20080221130145.GA3789@elf.ucw.cz>
> > > Content-Disposition: inline
> > > 
> > > 
> > > 
> > > power_state is scheduled for removal, and it is used only write-only
> > > by USB. Remove it.
> > 
> > Greg, this patch is incomplete.  Some of the settings that Pavel 
> > removed are used by the host controller drivers.  Please revert this; 
> > I'll send a more complete patch later.
> 
> Alan is right, I was blind... and my config was not affected...
> ...
> host/sl811-hcd.c:	if (dev->dev.power.power_state.event == PM_EVENT_SUSPEND
> misc/usbtest.c:	if (intf->dev.power.power_state.event != PM_EVENT_ON) {
> ...

Will do, thanks for letting me know.

greg k-h
