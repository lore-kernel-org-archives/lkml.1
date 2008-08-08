Return-Path: <linux-kernel-owner+w=401wt.eu-S1757738AbYHHVxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738AbYHHVxV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 17:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbYHHVxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 17:53:07 -0400
Received: from netrider.rowland.org ([192.131.102.5]:3225 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751874AbYHHVxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 17:53:05 -0400
Date: Fri, 8 Aug 2008 17:53:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jeff Garzik <jeff@garzik.org>
cc: linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.27-rc] USB storage:  hangs and massive dmesg spews
In-Reply-To: <489CBC49.6050602@garzik.org>
Message-ID: <Pine.LNX.4.44L0.0808081752270.24293-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Aug 2008, Jeff Garzik wrote:

> Running kernel 2.6.27-rc1-00156-g94ad374 on x86-64, I
> 
> 1) plugged in a USB device
> 
> > Aug  8 15:32:03 core kernel: usb 1-8: new high speed USB device using ehci_hcd a
> > nd address 4
> > Aug  8 15:32:04 core kernel: usb 1-8: configuration #1 chosen from 1 choice
> > Aug  8 15:32:04 core kernel: usb 1-8: New USB device found, idVendor=041e, idPro
> > duct=4155
> > Aug  8 15:32:04 core kernel: usb 1-8: New USB device strings: Mfr=1, Product=2, 
> > SerialNumber=3
> > Aug  8 15:32:04 core kernel: usb 1-8: Product: ZEN Stone Plus
> > Aug  8 15:32:04 core kernel: usb 1-8: Manufacturer: CREATIVE
> > Aug  8 15:32:04 core kernel: usb 1-8: SerialNumber: F03A09331004CD04
> > Aug  8 15:32:04 core kernel: Initializing USB Mass Storage driver...
> [...]
> > scsi 10:0:0:0: Direct-Access     CREATIVE ZEN Stone Plus   1031 PQ: 0 ANSI: 4
> > sd 10:0:0:0: [sdc] 963968 2048-byte hardware sectors (1974 MB)
> > sd 10:0:0:0: [sdc] Write Protect is off
> > sd 10:0:0:0: [sdc] Mode Sense: 38 00 00 00
> > sd 10:0:0:0: [sdc] Assuming drive cache: write through
> 
> 
> 2) I executed: sudo dd if=/dev/sdc of=foo.img bs=32k
> 
> 
> 3) judging from ls(1), the entire storage device's contents was 
> successfully dumped to my hard drive.  HOWEVER, dd(1) sat in disk wait, 
> failing to end execution once the end of the USB storage device was reached.
> 
> 
> 4) a huge amount of dmesg spew followed.  at the time of this writing, 
> the following spew has been passed to dmesg over TWO HUNDRED times:
> 
> > Aug  8 15:41:01 core kernel: INFO: task usb-storage:21894 blocked for more than 
> > 120 seconds.

This has been fixed in 2.6.27-rc2.

Alan Stern

