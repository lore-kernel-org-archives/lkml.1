Return-Path: <linux-kernel-owner+w=401wt.eu-S1754299AbZEFUYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299AbZEFUYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZEFUYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:24:15 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35050 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756177AbZEFUYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:24:14 -0400
Date: Wed, 6 May 2009 16:24:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jason Wessel <jason.wessel@windriver.com>, <greg@kroah.com>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/5] usb_debug: EXPERIMENTAL - poll hcd device to force
 writes
In-Reply-To: <200905062201.42965.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0905061614320.4430-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009, Oliver Neukum wrote:

> Am Mittwoch, 6. Mai 2009 21:24:56 schrieb Alan Stern:
> > On Wed, 6 May 2009, Oliver Neukum wrote:
> 
> > A little thought yielded the following algorithm.  It assumes there is
> > a fixed set of URBs allocated, unlike what you have done.  Does it make
> 
> No, it does not ;-) Your approach is more general than you think.
> The only important constraint is that the number of URBs in flight
> be limited. It doesn't matter when they are allocated.

You're optimistically assuming that URB allocations will succeed.  I 
guess that's okay -- dropping characters when there's insufficient 
memory seems like a good thing to do.

What's the point of that "reserve_buffer" thing?  Why not just use the 
next URB's transfer buffer?

Alan Stern

