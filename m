Return-Path: <linux-kernel-owner+w=401wt.eu-S1765372AbXGZPfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765372AbXGZPfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 11:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759211AbXGZPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 11:35:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33067 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754290AbXGZPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 11:35:22 -0400
Date: Thu, 26 Jul 2007 11:35:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [GIT PATCH] more USB patches for 2.6.22
In-Reply-To: <alpine.LFD.0.999.0707251628200.3607@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0707261132130.2554-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007, Linus Torvalds wrote:

> I have a flaky(?) USB multi-card reader, and I just got an oops with it on 
> x86-64. It was preceded by some of the IO errors:
> 
> 	end_request: I/O error, dev sdc, sector 0
> 	sd 11:0:0:1: [sdc] Result: hostbyte=0x07 driverbyte=0x00
> 	end_request: I/O error, dev sdc, sector 0
> 	Buffer I/O error on device sdc, logical block 0
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: reset high speed USB device using ehci_hcd and address 10
> 	usb 2-5: device descriptor read/all, error 0

Error 0?  That sounds bogus.  Perhaps this patch will take care of 
everything:

http://marc.info/?l=linux-usb-devel&m=118531582013355&w=2

It has already been submitted to Greg KH, but if it takes care of your 
problem you might want to merge it immediately.  It fixes an obvious 
bug that was recently introduced.

Alan Stern

