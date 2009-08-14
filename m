Return-Path: <linux-kernel-owner+w=401wt.eu-S1756946AbZHNTOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946AbZHNTOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 15:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756908AbZHNTOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 15:14:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40585 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756891AbZHNTOc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 15:14:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [RFC] PCI: Runtime power management
Date: Fri, 14 Aug 2009 21:15:25 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Stern <stern@rowland.harvard.edu>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
       linux-pci@vger.kernel.org, linux-usb@vger.kernel.org
References: <200908081625.57333.rjw@sisk.pl> <20090813002925.GA2532@srcf.ucam.org> <20090814103719.79e99d91@jbarnes-g45>
In-Reply-To: <20090814103719.79e99d91@jbarnes-g45>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908142115.25946.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 August 2009, Jesse Barnes wrote:
> On Thu, 13 Aug 2009 01:29:25 +0100
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > I got a fixed BIOS from Dell and have been able to get this working
> > now. It seems entirely happy with USB, but I'd like some sanity
> > checks on whether I'm doing this correctly. There's certainly a
> > couple of quirks related to setting the ACPI GPE type that would need
> > a little bit of work in the ACPI layer, and it breaks ACPI-mediated
> > PCI hotplug though that's easy enough to fix by just calling into the
> > hotplug code from the core notifier.
> > 
> > This patch builds on top of Rafael's work on systemwide runtime power
> > management. It supports suspending and resuming PCI devices at
> > runtime, enabling platform wakeup events that allow the devices to
> > automatically resume when appropriate. It currently requires platform
> > support, but PCIe setups could be supported natively once native PCIe
> > PME code has been added to the kernel.
> 
> PCI bits look pretty good to me, though Rafael should take a look too.

I'm going to do that shortly.

> Card readers and firewire could benefit from similar treatment,

As well us network adapters.

> maybe that would get us to .5W territory on some machines.

Hopefully. :-)

Thanks,
Rafael
