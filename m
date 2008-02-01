Return-Path: <linux-kernel-owner+w=401wt.eu-S1755857AbYBAPWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755857AbYBAPWV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 10:22:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbYBAPWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 10:22:06 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:40282 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754023AbYBAPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 10:22:04 -0500
Date: Fri, 1 Feb 2008 10:22:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: linux-kernel@vger.kernel.org, <linux-pm@lists.linux-foundation.org>,
       <Harvey.Harrison@gmail.com>
Subject: Re: Removing dev.power.power_state (WAS: Feature Removals for 2.6.25)
In-Reply-To: <200801312128.10700.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0802011019370.3839-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jan 2008, David Brownell wrote:

> Quoth Harvey Harrison:
> 
> > Ping?
> > What:	dev->power.power_state
> > When:	July 2007
> > Why:	Broken design for runtime control over driver power states, confusing
> > 	driver-internal runtime power management with:  mechanisms to support
> > 	system-wide sleep state transitions; event codes that distinguish
> > 	different phases of swsusp "sleep" transitions; and userspace policy
> > 	inputs.  This framework was never widely used, and most attempts to
> > 	use it were broken.  Drivers should instead be exposing domain-specific
> > 	interfaces either to kernel or to userspace.
> > Who:	Pavel Machek <pavel@suse.cz>
> 
> A lot of the infrastructure using that has already been deleted, and
> there are some incremental improvements pending for 2.6.25:

> But there are still quite a few users left, and a new one was (sigh)
> recently added.

>  - drivers/usb/... has various users, HCDs look easy enough to fix but
>    the other bits will take more thought

>  - drivers/scsi/mesh.c

> I'll probably send in a few more patches for easy stuff in areas
> that I touch semi-frequently, but other folk should fix ATA, IDE,
> SCSI, SERIO, and so forth.  It'd be good if Alan would help fix
> the USB stuff too.  I'm not sure what Pavel's doing there...

I can look at the USB and SCSI stuff.  It shouldn't be all that bad.  
The userspace interface has been gone for quite some time now, and most 
of the remaining uses of that field are write-only.

Alan Stern

