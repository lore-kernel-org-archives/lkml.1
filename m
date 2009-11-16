Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZKPUve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZKPUve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 15:51:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZKPUvd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 15:51:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:59532 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968AbZKPUvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 15:51:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/10] PM: Add flag for devices capable of generating run-time wake-up events
Date: Mon, 16 Nov 2009 21:52:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.32-rc7-rjw; KDE/4.3.3; x86_64; ; )
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>, Shaohua Li <shaohua.li@intel.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>
References: <Pine.LNX.4.44L0.0911161436560.2971-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911161436560.2971-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911162152.38333.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 November 2009, Alan Stern wrote:
> On Mon, 16 Nov 2009, Rafael J. Wysocki wrote:
> 
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Apparently, there are devices that can wake up the system from sleep
> > states and yet are incapable of generating wake-up events at run
> > time.  Thus, introduce a flag indicating if given device is capable
> > of generating run-time wake-up events.
> 
> This raises the question: Who is responsible for setting the new 
> flag?  The code that registers the device?

Yes, in general.  The platform.

Actually, I needed it for PCI, but I thought it would be better to put it at
the core level.

> What if the kernel can't tell whether or not the device can generate 
> runtime wake-up events?

Do you have any specific examples in mind?

> What if the user wants to override the kernel's setting?  Should there 
> be a sysfs attribute controlling the flag?

I have no plans for adding anything like that.

Rafael
