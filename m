Return-Path: <linux-kernel-owner+w=401wt.eu-S1760792AbXHTQAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760792AbXHTQAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 12:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbXHTP75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 11:59:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:55891 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759763AbXHTP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 11:59:57 -0400
Date: Mon, 20 Aug 2007 11:59:55 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
cc: linux-kernel@vger.kernel.org, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] why was MODALIAS removed from usb kernel
 events? [u]
In-Reply-To: <200708182132.11336.aj@ciphirelabs.com>
Message-ID: <Pine.LNX.4.44L0.0708201158110.3626-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Andreas Jellinghaus [c] wrote:

> Am Freitag, 17. August 2007 schrieben Sie:
> > On Fri, 17 Aug 2007, Andreas Jellinghaus [c] wrote:
> > > I need some kernel event that has both DEVICE and MODALIAS set.
> > > up to including kernel 2.6.21 this seems to come from
> > > drivers/usb/core/driver.c if I read the code correctly, and then
> > > it was removed.
> > >
> > > udevmonitor --kernel --environment shows one event with both on 2.6.21
> > > plain, but not on 2.6.22 plain.
> >
> > Does this patch improve matters?
> 
> yes, thanks, it does. can you add PRODUCT as well?
> remembered too late that my scripts at least use it too.
> but that one is no big issue, MODALIAS has the same information
> so I could use that information. but other people might use it.

I could, but I don't know whether any of this would be accepted for 
2.6.22.stable.  It might not be too late to get into 2.6.23...

Alan Stern

