Return-Path: <linux-kernel-owner+w=401wt.eu-S1763890AbXFATeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763890AbXFATeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 15:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763668AbXFATdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 15:33:51 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46981 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763659AbXFATdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 15:33:50 -0400
Date: Fri, 1 Jun 2007 15:33:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: udev-095 problem with gregkh-all-2.6.22-rc3
In-Reply-To: <1180717440.29941.9.camel@lov.localdomain>
Message-ID: <Pine.LNX.4.44L0.0706011532260.3635-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2007, Kay Sievers wrote:

> > > Care to comment out the block patch in the series file in Greg's tree
> > > and try if it works?
> > 
> > In fact the gregkh-all patch file I used was a few days old (I 
> > downloaded it from a mirror on May 29) and it doesn't include the 
> > block-device patch in the first place.
> 
> Hmm, then I have no idea what patch in Greg's tree could cause this,
> even the block conversion patch is unlikely to cause a failure in the
> block io_context functions.
> 
> > Should I try the current 
> > version?
> 
> Sure, it would be great, if you can sync up to the latest version of
> Greg's patches yes, just to make sure we are not trying to fix something
> that doesn't fail anymore.

Sure enough, the problem is gone now.  Maybe adding the block-device 
patch fixed it.

Consider this a false alarm...

Alan Stern

