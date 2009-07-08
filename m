Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbZGHT5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbZGHT5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 15:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZGHT52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 15:57:28 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53395 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754539AbZGHT52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 15:57:28 -0400
Date: Wed, 8 Jul 2009 15:57:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Michael S. Zick" <lkml@morethan.org>
cc: Oliver Neukum <oliver@neukum.org>, Jiri Kosina <jkosina@suse.cz>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Null Pointer BUG in uhci_hcd
In-Reply-To: <200907081130.07370.lkml@morethan.org>
Message-ID: <Pine.LNX.4.44L0.0907081555310.22105-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jul 2009, Michael S. Zick wrote:

> But, then again, we might just get lucky:
> ehci_hcd 0000:00:10.4: Unlink after no-IRQ?  Controller is probably using the wrong IRQ.
> usb 1-5: khubd timed out on ep0in len=18/64

Like I've been telling you all along, the hardware isn't working.  I 
suspect it's worse than a simple interrupt-routing mistake.

> > > For more information enable CONFIG_USB_DEBUG and CONFIG_DEBUG_FS, then 
> > > see what's sitting in the usb/uhci/* files in debugfs.
> > > 
> 
> Anything in particular to look for/at?

Just post the contents of those files.

Alan Stern

