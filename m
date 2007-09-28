Return-Path: <linux-kernel-owner+w=401wt.eu-S1753939AbXI1Qpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbXI1Qpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 12:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752285AbXI1Qpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 12:45:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58519 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752219AbXI1Qpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 12:45:43 -0400
Date: Fri, 28 Sep 2007 12:45:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Jonathan Corbet <corbet@lwn.net>, Chakri n <chakriin5@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, <nfs@lists.sourceforge.net>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] Re: A unresponsive file system can hang all I/O in
 the system on linux-2.6.23-rc6 (dirty_thresh problem?)
In-Reply-To: <1190986542.13204.10.camel@twins>
Message-ID: <Pine.LNX.4.44L0.0709281244250.4336-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007, Peter Zijlstra wrote:

> On Fri, 2007-09-28 at 07:28 -0600, Jonathan Corbet wrote:

> > Is it really NFS-related?  I was trying to back up my 2.6.23-rc8 system
> > to an external USB drive the other day when something flaked and the
> > drive fell off the bus.  That, too, was sufficient to wedge the entire
> > system, even though the only thing which needed the dead drive was one
> > rsync process.  It's kind of a bummer to have to hit the reset button
> > after the failure of (what should be) a non-critical piece of hardware.
> > 
> > Not that I have a fix to propose...:)
> 
> the per bdi work in -mm should make the system not drop dead.
> 
> Still, would a remove,re-insert of the usb media end up with the same
> bdi? That is, would it recognise as the same and resume the transfer.

Removal and replacement of the media might work.  I have never tried 
it.

But Jon described removal of the device, not the media.  Replacing the 
device definitely will not work.

Alan Stern

