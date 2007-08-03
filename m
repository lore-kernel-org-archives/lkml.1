Return-Path: <linux-kernel-owner+w=401wt.eu-S1763598AbXHCPDh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763598AbXHCPDh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:03:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763299AbXHCPD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:03:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45047 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1763257AbXHCPDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:03:24 -0400
Date: Fri, 3 Aug 2007 11:03:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Engraf <david.engraf@netcom.eu>
cc: Greg KH <gregkh@suse.de>, <linux-pci@atrey.karlin.mff.cuni.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB BIOS early handoff only when the
 we the driver is configured
In-Reply-To: <46B2D0C6.5010409@netcom.eu>
Message-ID: <Pine.LNX.4.44L0.0708031101530.2597-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, David Engraf wrote:

> So we have hardware which has problems when we are not doing the
> handoff, and hardware which has
> problems when we are  doing the handoff...

What hardware has problems when we do the handoff?  Your system and 
mine experience a delay, but it doesn't break anything.

> What is the best way to solve the problem? Maybe a kernel parameter, a
> config flag or an automatic
> hardware dependent check of the system?
> In fact it is hard to find a solution which works for both as long as
> the hardware has this bugs.

If we really need it, I say we should use a Kconfig flag.

Alan Stern

