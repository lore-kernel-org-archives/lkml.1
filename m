Return-Path: <linux-kernel-owner+w=401wt.eu-S1761134AbYGOOUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761134AbYGOOUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 10:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760677AbYGOOUO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 10:20:14 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34692 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759948AbYGOOUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 10:20:13 -0400
Date: Tue, 15 Jul 2008 10:20:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Berg <johannes@sipsolutions.net>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
In-Reply-To: <1216110638.3535.0.camel@johannes.berg>
Message-ID: <Pine.LNX.4.44L0.0807151019420.2517-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jul 2008, Johannes Berg wrote:

> > Add
> > 
> > 	printk(KERN_ALERT "Unplug now!\n");
> > 	ssleep(10);
> > 
> > to the start of slave_configure() in drivers/usb/storage/scsiglue.c.  
> > Then it should be very easy to trigger the failure.  :-)
> 
> Indeed.
> 
> > Assuming the failure does occur without the patch, see if it still 
> > occurs once the patch is in place.
> 
> Yes, it occurs without the patch and not with the patch, thanks!

Okay, thanks for testing.  I will submit the patch for 2.6.26.1.

Alan Stern

