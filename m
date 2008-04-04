Return-Path: <linux-kernel-owner+w=401wt.eu-S1753182AbYDDVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbYDDVX3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 17:23:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751472AbYDDVXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 17:23:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42563 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751466AbYDDVXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 17:23:18 -0400
Date: Fri, 4 Apr 2008 17:23:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb unbind/bind => WARNING at fs/sysfs/dir.c [Was: 2.6.25-rc8-mm1]
In-Reply-To: <20080404205154.GB14315@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0804041721080.2175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Apr 2008, Greg KH wrote:

> On Fri, Apr 04, 2008 at 10:16:32PM +0200, Jiri Slaby wrote:
> > On 04/02/2008 06:32 AM, Andrew Morton wrote:
> >> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc8/2.6.25-rc8-mm1/
> >
> > After
> > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/unbind
> > $ echo -n 4-1.2 >/sys/bus/usb/drivers/usb/bind
> >
> > I have this in logs:
> >
> > sysfs: duplicate filename 'usbdev4.12_ep81' can not be created
> 
> Does this also show up in 2.6.25-rc8 without -mm?
> 
> I thought I fixed this already, I don't see what slipped into -mm that
> would have caused it to come back.  Time to run some more tests...
> 
> Oh, also note that binding and unbinding the main "usb" driver is not
> encouraged, or even supported.  I'm amazed it works, as this is not
> something that any "real" user would do as it makes no sense at all
> because we have no "alternative" drivers yet for the main USB device.

It's a real bug.  I don't have time to track it down now.  Next week...

Alan Stern

