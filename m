Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbZLCPQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbZLCPQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 10:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228AbZLCPQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 10:16:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41167 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756083AbZLCPQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 10:16:52 -0500
Date: Thu, 3 Dec 2009 10:16:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Justin P. Mattock" <justinmattock@gmail.com>,
       Robert Hancock <hancockrwd@gmail.com>,
       Linux-usb <linux-usb@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: root hub lost power or was reset
In-Reply-To: <200912030933.47769.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912031014190.4795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Dec 2009, Oliver Neukum wrote:

> Am Donnerstag, 3. Dezember 2009 01:58:46 schrieb Justin P. Mattock:
> > >> Now looking at dmesg I see:
> > >>
> > >> [ 413.551845] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
> > >> -> IRQ 23
> > >> [ 413.551855] uhci_hcd 0000:00:1d.0: setting latency timer to 64
> > >> [ 413.551887] usb usb2: root hub lost power or was reset
> > >
> > > Is that unexpected? It seems reasonable to me..
> > 
> > honestly I can't remember seeing this or not.
> > if this is normal then I'll leave it as is.
> 
> This happens if your system cuts power to USB during S2.

It also happens if the system retains power but resets the controller
while resuming (as indicated by the log message: "lost power or was
reset".)  Again, it's a BIOS thing.

And it seems to be very widespread.  I haven't seen more than a handful 
of systems which _don't_ cut power or reset their UHCI controllers 
during S3 sleep.

Alan Stern

