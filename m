Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZHPP5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZHPP5y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 11:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZHPP5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 11:57:53 -0400
Received: from netrider.rowland.org ([192.131.102.5]:45641 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754594AbZHPP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 11:57:52 -0400
Date: Sun, 16 Aug 2009 11:57:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Matthew Garrett <mjg59@srcf.ucam.org>, <linux-usb@vger.kernel.org>,
       <linux-pci@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
In-Reply-To: <200908152321.53283.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908161151020.6522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Aug 2009, Rafael J. Wysocki wrote:

> > Why would you ever want runtime_wakeup to be false unless 
> > runtime_forbidden is true? Surely the point of runtime power management 
> > is to be transparent to the user, in which case remote wakeup is 
> > required?

Matthew, what makes you think remote wakeup is required?  Lots of
power-manageable devices don't support it at all (consider disk drives
or display screens).

> Well, this was exactly my point previously. :-)
> 
> Still, although for the majority of devices 'runtime_wakeup' disabled would
> mean no runtime PM at all IMO, there may be devices that actually work without
> remote wakeup, although they support it in general.

That last part is quite true.  For example, we might suspend the device
whenever no process has opened the device file.  It would be a degraded 
form of power management, but better than nothing.

> I can even imagine a scenario where this setting might be useful, like when
> we don't want a network adapter to be woken up from the outside.

Or if the device's support for remote wakeup is broken.

Alan Stern

