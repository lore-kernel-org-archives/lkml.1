Return-Path: <linux-kernel-owner+w=401wt.eu-S1755141AbYLJPjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbYLJPjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYLJPjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:39:35 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:45684 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753510AbYLJPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:39:35 -0500
Date: Wed, 10 Dec 2008 10:39:33 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Laurent Pinchart <laurent.pinchart@skynet.be>,
       Wu Fengguang <fengguang.wu@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: make printk messges more searchable
In-Reply-To: <200812101056.15457.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0812101035450.2175-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008, Oliver Neukum wrote:

> Am Mittwoch, 10. Dezember 2008 10:42:17 schrieb Laurent Pinchart:
> > Hi Wu,
> > 
> > On Wednesday 10 December 2008, Wu Fengguang wrote:
> > > Make USB printk messages long and straightforward.  One of these
> > > decorated USB error messages cost me some smart efforts to locate.
> > 
> > That would make the code break the 80 columns limit.
> > 
> > From "Documentation/CodingStyle":
> > 
> > "The limit on the length of lines is 80 columns and this is a strongly
> > preferred limit."
> 
> Too rigid an application is bad. The kernel must be greppable.

The kernel is greppable in either case.  It's foolish to rigidly insist 
that long strings must not be broken.  And don't forget that some 
strings are created dynamically (with %s specifiers, for instance).  
How are you going to grep for them?

It's also worth pointing out that much of the source code in usbcore 
tends to indent continuation lines by two extra tab stops.  This isn't 
done all the time, admittedly.  But deliberately changing the code so 
that continuations use only one tab stop feels like a bad idea -- one 
extra tab stop looks too much like a nested statement.

Alan Stern

