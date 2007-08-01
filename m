Return-Path: <linux-kernel-owner+w=401wt.eu-S1764768AbXHAOlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764768AbXHAOlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXHAOk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:40:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45836 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752456AbXHAOk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:40:56 -0400
Date: Wed, 1 Aug 2007 10:40:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: linux-kernel@vger.kernel.org, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <gregkh@suse.de>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
In-Reply-To: <46B03078.5040305@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0708011038130.3764-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2007, David Engraf wrote:

> At the moment I have a Jetway/VIA Mainboard which seems to have a problem
> with the handoff. Even
> when I wait about 20 seconds the EHCI_USBLEGSUP_BIOS flag is not cleared.
> I think this is a BIOS
> bug and I will have to talk to Jetway/VIA.

I have the same problem on my Intel motherboard.  Which is surprising, 
considering that Intel invented the BIOS-handoff technique.

> On the other hand, I don't need the EHCI controller in my kernel, so I
> think the kernel shouldn't take the
> handover for the EHCI controller like other OS which do not have an usb
> driver and so don't know that
> there is a EHCI_USBLEGSUP_BIOS flag which should be cleared.

There ought to be a solution to satisfy everybody.  For instance, you 
could add a Kconfig flag for enabling USB handoff, and make it be 
selected automatically if any of the PCI USB drivers are configured.

Alan Stern

