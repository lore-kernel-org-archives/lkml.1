Return-Path: <linux-kernel-owner+w=401wt.eu-S1030376AbXCGWSh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030376AbXCGWSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 17:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992667AbXCGWSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 17:18:36 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47772 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S2992476AbXCGWSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 17:18:33 -0500
Date: Wed, 7 Mar 2007 17:18:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: ebuddington@wesleyan.edu
cc: Oliver Neukum <oneukum@suse.de>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] khubd and ent:sda1 sucking CPU with reiser4
 + USB HD
In-Reply-To: <20070307204722.GA3605@pool-71-123-121-36.spfdma.east.verizon.net>
Message-ID: <Pine.LNX.4.44L0.0703071713220.9831-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2007, Eric Buddington wrote:

> On Wed, Mar 07, 2007 at 03:22:05PM -0500, Alan Stern wrote:
> > On Wed, 7 Mar 2007, Eric Buddington,,, wrote:
> > 
> > > > > So SysRq-t doesn't show anything about khubd, and SysRq-p doesn't give
> > > > > me anything at all. What else can I try?
> > 
> > How about SysRq-r?
> 
> SysRq : Keyboard mode set to XLATE

Whoops, I was thinking of SysRq-p, which you have already tried.

> > These problems start with some USB resets, right?  Did they occur with 
> > earlier kernel versions, or is this new behavior?
> 
> Yes, the problem starts with USB resets (or USB errors that trigger a reset)
> 
> > How often does the problem occur?
> 
> Recently, the USB drive has choked up after several hours of moderate
> use. However, before this instance, it would consistently hang up my
> watchdog process and force a system reboot (no idea why; the watchdog
> process didn't use this drive at all). This may have changed when I
> upgraded from 2.6.20-rc6-mm3 to 2.6.20-mm2, but my sample size is to
> small to be sure.

What about earlier kernels?  Does 2.6.19 work any better?

What about non -mm kernels, like 2.6.21-rc2?

I've never heard of a process failing to show up in a SysRq-t listing.  It 
suggests something is wrong with the process management in the kernel you 
were using.  That leads me to think a non -mm kernel might give more 
informative results.

And as long as you're testing, you might as well also turn on 
CONFIG_USB_DEBUG.

Alan Stern

