Return-Path: <linux-kernel-owner+w=401wt.eu-S1754465AbZKPVbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754465AbZKPVbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 16:31:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZKPVbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 16:31:17 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:48996 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752294AbZKPVbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 16:31:16 -0500
Date: Mon, 16 Nov 2009 16:31:20 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: [RFC][PATCH 1/10] PM: Add flag for devices capable of generating
 run-time wake-up events
In-Reply-To: <20091116210545.GA29696@srcf.ucam.org>
Message-ID: <Pine.LNX.4.44L0.0911161629310.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Nov 2009, Matthew Garrett wrote:

> On Mon, Nov 16, 2009 at 04:00:49PM -0500, Alan Stern wrote:
> > On Mon, 16 Nov 2009, Rafael J. Wysocki wrote:
> > > Yes, in general.  The platform.
> > 
> > And for non-platform devices (hot-pluggable, for example)?  Presumably 
> > you would want the driver that detects and registers the device to set 
> > this flag.
> 
> Are there any cases where the bus code won't know this?

None that I'm aware of.  I merely wanted to clarify where the flag was 
supposed to get set.

> > > > What if the kernel can't tell whether or not the device can generate 
> > > > runtime wake-up events?
> > > 
> > > Do you have any specific examples in mind?
> > 
> > What about Matthew's example of an ACPI GPE which might or might not 
> > cause a runtime wake-up event, depending on the AML code in the BIOS?
> 
> The platform knows whether or not that's the case.

Okay, then it isn't a problem.  Except perhaps in the case of buggy 
devices which _should_ generate these events but don't.

Alan Stern

