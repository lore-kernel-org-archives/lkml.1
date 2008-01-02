Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbYABUXk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbYABUXk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:23:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752822AbYABUXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:23:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:59466 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752666AbYABUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:23:31 -0500
Date: Wed, 2 Jan 2008 15:23:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@ucw.cz>, Raymano Garibaldi <raymano@faunos.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [FEATURE REQUEST] Transparent hot plugging of
 root file system on portable storage devices.
In-Reply-To: <200801021119.22104.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0801021521291.2990-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jan 2008, Oliver Neukum wrote:

> Am Dienstag 01 Januar 2008 schrieb Pavel Machek:
> > Hi1
> > 
> > > I would like to request a feature in the Linux kernel that would allow
> > > a user to unplug a live read-only root file system which exists on a
> > > detachable storage device such as a USB key drive. The desired
> > > behavior is that once the same device is reattached to the computer
> > > the user can continue work transparently without having to reboot.
> > > 
> > > Having such a feature is becoming more important with advances in
> > > detachable solid state drive technology.
> > 
> > Yep, that would be nice.... In fact, patch would be very welcome :-).
> 
> Use the USB persist feature and hibernate. It should work. If you modify
> the fs in any way, you'll crash and burn. Unmounting / is harder which you
> need if you want to do this safely.

What about people who prefer (for reasons of restart latency or
non-availability of swap space) to suspend rather than hibernate?

Alan Stern

