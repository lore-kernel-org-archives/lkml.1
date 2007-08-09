Return-Path: <linux-kernel-owner+w=401wt.eu-S965856AbXHIOoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965856AbXHIOoR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 10:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765477AbXHIOoB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 10:44:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40333 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1765067AbXHIOn7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 10:43:59 -0400
Date: Thu, 9 Aug 2007 10:43:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Andrew Morton <akpm@linux-foundation.org>, <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [usb-storage] schedule_timeout: wrong timeout
 value c1a95554
In-Reply-To: <200708091210.21383.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.44L0.0708091042520.3559-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2007, Mariusz Kozlowski wrote:

> Hello,
> 
> 	Happens every time I reattach usb pen drive.
> 
> usb 1-2: new high speed USB device using ehci_hcd and address 10
> usb 1-2: configuration #1 chosen from 1 choice
> scsi6 : SCSI emulation for USB Mass Storage devices
> usb 1-2: new device found, idVendor=13fe, idProduct=1a00
> usb 1-2: new device strings: Mfr=1, Product=2, SerialNumber=0
> usb 1-2: Product: GEIL USB DISK   
> usb 1-2: Manufacturer:         
> usb-storage: device found at 10
> usb-storage: waiting for device to settle before scanning
> schedule_timeout: wrong timeout value c1a95554
>  [<c010456a>] show_trace_log_lvl+0x1a/0x30
>  [<c010508d>] show_trace+0x12/0x14
>  [<c01051e0>] dump_stack+0x15/0x17
>  [<c04174d1>] schedule_timeout+0x8c/0xa2
>  [<c032aeec>] usb_stor_scan_thread+0x100/0x160
>  [<c0127f2e>] kthread+0x36/0x58
>  [<c0104233>] kernel_thread_helper+0x7/0x14
>  =======================
> scsi 6:0:0:0: Direct-Access              GEIL USB DISK    >2.0 PQ: 0 ANSI: 0 CCS
> sd 6:0:0:0: [sda] 1007616 512-byte hardware sectors (516 MB)
> sd 6:0:0:0: [sda] Write Protect is off
> sd 6:0:0:0: [sda] Mode Sense: 23 00 00 00
> sd 6:0:0:0: [sda] Assuming drive cache: write through
> sd 6:0:0:0: [sda] 1007616 512-byte hardware sectors (516 MB)
> sd 6:0:0:0: [sda] Write Protect is off
> sd 6:0:0:0: [sda] Mode Sense: 23 00 00 00
> sd 6:0:0:0: [sda] Assuming drive cache: write through
>  sda: sda1
> sd 6:0:0:0: [sda] Attached SCSI removable disk
> sd 6:0:0:0: Attached scsi generic sg0 type 0
> usb-storage: device scan complete

This is a known problem.  See

	http://marc.info/?l=linux-kernel&m=118641424414399&w=2

Rafael, has this been fixed yet?

Alan Stern

