Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbZHNVVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbZHNVVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZHNVVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:21:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42278 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755553AbZHNVVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:21:17 -0400
Date: Fri, 14 Aug 2009 17:21:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908142112.38557.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908141717350.2922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Rafael J. Wysocki wrote:

> On Friday 14 August 2009, Alan Stern wrote:
> > On Thu, 13 Aug 2009, Rafael J. Wysocki wrote:
> > 
> > > > No, I've only tested it with a few selected drivers.  I'm going to try the
> > > > "async everyone" scenario, though.
> > > 
> > > On HP nx6325 booted with init=/bin/bash it doesn't pass the
> > > 'echo devices > /sys/power/pm_test && echo mem > /sys/power/state' test.
> > > 
> > > The suspend part actually seems to work, but the resume part crashes
> > > miserably.
> > 
> > Any details?  Can you tell where it crashes?
> 
> Unfortunately it ends up in a continuous flood of backtraces, so I can't
> say much.

Same sort of thing happened with me, but it appeared to happen during 
suspend.  (I say "appeared" because the system froze for a while at the 
start of the suspend until I hit a key.  This may be related to all the 
recent churn in the TTY layer, combined with the fact that I was using 
a serial console.  It didn't help -- none of the backtraces got sent 
out the serial port.)

> However, if I set async_suspend for all PCI devices, as well as for ACPI battery
> and i8042, everything apparently works, even with real suspend-resume.

I think it would be worthwhile to track down these unknown problems and 
dependencies.  It won't be easy, though...

Alan Stern

