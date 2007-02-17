Return-Path: <linux-kernel-owner+w=401wt.eu-S932991AbXBQVgt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932991AbXBQVgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 16:36:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933016AbXBQVgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 16:36:49 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:12514 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S932991AbXBQVgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 16:36:48 -0500
Date: Sat, 17 Feb 2007 16:36:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dan Aloni <da-x@monatomic.org>
cc: Linux Kernel List <linux-kernel@vger.kernel.org>,
       <linux-usb-devel-bounces@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] OOM and USB, latest Linux 2.6
In-Reply-To: <45D7462D.6080700@monatomic.org>
Message-ID: <Pine.LNX.4.44L0.0702171634140.18992-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 17 Feb 2007, Dan Aloni wrote:

> You are right, I looked over this state with kdb, and usb-storage
> waited in usb_stor_bulk_transfer_sg, which does pass GFP_NOIO
> at this scenario.
...

> BTW, soft-rebooting the machine in that state made the USB
> storage device (LEXAR,  JD LIGHTNING II) inaccessible to the
> BIOS. I had to do a complete power cycle in order or the BIOS
> to see it again.

That's the fault of the BIOS and/or the Lexar device.  The BIOS ought to 
do a complete reset of the USB controller and a reset of the device.  If 
the device remains unusable after that, there isn't anything we can do 
about it.

Alan Stern

