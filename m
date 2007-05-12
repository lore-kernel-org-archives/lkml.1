Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbXELVlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbXELVlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 17:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754252AbXELVlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 17:41:09 -0400
Received: from twin.jikos.cz ([213.151.79.26]:56727 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754183AbXELVlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 17:41:08 -0400
Date: Sat, 12 May 2007 23:40:42 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Oliver Neukum <oneukum@suse.de>
cc: Soeren Sonnenburg <kernel@nn7.de>, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-usb-devel] converting appletouch to usb autosuspend...
In-Reply-To: <Pine.LNX.4.44L0.0705121552230.22494-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.64.0705122337470.16923@twin.jikos.cz>
References: <Pine.LNX.4.44L0.0705121552230.22494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 May 2007, Alan Stern wrote:

> > While we are at it usb related powerhogs on this macbook pro are 
> > uhci_hcd (usb keyboard) and usb_hcd_poll_rh_status (rh_timer_func) 
> > too...
> They would use less power if the UHCI host controller were suspended.  
> But obviously it cannot be suspended while devices attached to it (such 
> as the USB keyboard and the appletouch device) remain active.

A sidenote for completness, when this has been mentioned: Oliver has been 
working on autosuspend support for HID devices, he sent me some (yet 
incomplete) patches some time ago. So autosuspending of USB 
keyboards/mice/etc. is being worked on.

Oliver, do you have any update please?

Thanks,

-- 
Jiri Kosina
