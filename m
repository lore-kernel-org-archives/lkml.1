Return-Path: <linux-kernel-owner+w=401wt.eu-S1030581AbXDLR0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030581AbXDLR0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030583AbXDLR0Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:26:24 -0400
Received: from canuck.infradead.org ([209.217.80.40]:44218 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030581AbXDLR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:26:23 -0400
Date: Thu, 12 Apr 2007 10:25:36 -0700
From: Greg KH <greg@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Kosina <jikos@jikos.cz>, Helge Hafting <helgehaf@aitel.hist.no>,
       linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       Corey Minyard <minyard@acm.org>, Mike Galbraith <efault@gmx.de>,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc6-mm1 USB related boot hang
Message-ID: <20070412172536.GB3431@kroah.com>
References: <20070408143559.f5014629.akpm@linux-foundation.org> <20070411194227.GA31286@aitel.hist.no> <20070411134346.d10765da.akpm@linux-foundation.org> <20070411230700.GA4023@aitel.hist.no> <Pine.LNX.4.64.0704120947230.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121001400.12991@twin.jikos.cz> <Pine.LNX.4.64.0704121642110.12991@twin.jikos.cz> <20070412095531.d792f671.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412095531.d792f671.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 09:55:31AM -0700, Andrew Morton wrote:
> On Thu, 12 Apr 2007 17:31:52 +0200 (CEST) Jiri Kosina <jikos@jikos.cz> wrote:
> 
> > On Thu, 12 Apr 2007, Jiri Kosina wrote:
> > 
> > > > - try booting without any HID devices plugged in (i.e. usb mice, usb 
> > > >   keyboards) if the problem persists?
> > > > - recompile 2.6.21-rc6-mm1 with git-hid.patch reverted to see if it helps?
> > > Do you compile with CONFIG_HIDRAW?
> > 
> > Helge,
> > 
> > with your .config, my machine hangs upon IPMI initialization, the last 
> > thing I see before total freeze is 
> > 
> > ipmi_si: Trying PCI-specified kcs state machine at mem address 0xd0121000, slave address 0x0, irq 5
> > 
> > (this was run on 32bit machine)
> 
> Was that with ipmi linked into vmlinux?  (Please send the output of grep
> IPMI .config)
> 
> I thought we fixed that.

I thought we fixed that too :(

Can you run with the "print out what init function is running" option
and see if it really is the ipmi driver that is dying or not?

thanks,

greg k-h
