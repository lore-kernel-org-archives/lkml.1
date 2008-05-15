Return-Path: <linux-kernel-owner+w=401wt.eu-S1761337AbYEOS4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761337AbYEOS4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 14:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638AbYEOS4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 14:56:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40607 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752481AbYEOS4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 14:56:38 -0400
Date: Thu, 15 May 2008 14:56:38 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <gregkh@suse.de>
cc: "Randy.Dunlap" <rdunlap@xenotime.net>, <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <stable@kernel.org>
Subject: Re: Linux 2.6.25.4
In-Reply-To: <20080515172518.GA23810@suse.de>
Message-ID: <Pine.LNX.4.44L0.0805151454220.2256-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 May 2008, Greg KH wrote:

> On Thu, May 15, 2008 at 09:43:04AM -0700, Randy.Dunlap wrote:
> > On Thu, 15 May 2008, Greg Kroah-Hartman wrote:
> > 
> > > We (the -stable team) are announcing the release of the 2.6.25.4 kernel.
> > > 
> > > It contains a bunch of bug fixes, and one security update, so all users
> > > of the 2.6.25 series are encouraged to upgrade.
> > 
> > Build errors on i386 and x86_64 allyesconfig:
> > 
> > drivers/usb/host/ohci-sm501.c:242: error: 'hcd' undeclared (first use in this function)
> > drivers/usb/host/ohci-sm501.c:242: error: (Each undeclared identifier is reported only once
> > drivers/usb/host/ohci-sm501.c:242: error: for each function it appears in.)
> > make[3]: *** [drivers/usb/host/ohci-hcd.o] Error 1
> 
> Alan, this is due to your OHCI patch :(
> 
> Care to send me a fix for this?

Urk.  When I built the .stable version of that patch, I forgot that the 
original version had this bug.

The fix for the original patch already exists here:

	http://marc.info/?l=linux-usb&m=120818727516898&w=2

I think it will apply to the stable tree with no trouble.  Sorry for 
the inconvenience.

Alan Stern

