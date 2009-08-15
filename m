Return-Path: <linux-kernel-owner+w=401wt.eu-S1752400AbZHOVoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752400AbZHOVoO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 17:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbZHOVoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 17:44:13 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43386 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbZHOVoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 17:44:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [RFC] PCI: Runtime power management
Date: Sat, 15 Aug 2009 23:44:46 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc5-rjw; KDE/4.3.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       linux-pci@vger.kernel.org, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0908151143560.18415-100000@netrider.rowland.org> <200908152321.53283.rjw@sisk.pl> <20090815212756.GA31784@srcf.ucam.org>
In-Reply-To: <20090815212756.GA31784@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908152344.46898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 August 2009, Matthew Garrett wrote:
> On Sat, Aug 15, 2009 at 11:21:53PM +0200, Rafael J. Wysocki wrote:
> 
> > I can even imagine a scenario where this setting might be useful, like when
> > we don't want a network adapter to be woken up from the outside.
> 
> I think in that case we'd probably just want the interface to be downed? 
> Some of this is going to require device-specific policy, I think - for 
> the network case we probably want something in between IF_RUNNING and 
> IF_DOWN (IF_CARRIER, perhaps) that indicates that we want the PHY to be 
> powered. Pushing this out to sysfs would mean we'd have a consistent 
> interface but varying semantics, and I'm not convinced that's an 
> especially helpful interface.

I'm not disagreeing with that.

At this point I'd like to know the Alan's opinion.  I would gladly use the
'runtime_forbidden' flag only, but if we overlook something now, it's going
to be difficult to fix later.

Thanks,
Rafael
