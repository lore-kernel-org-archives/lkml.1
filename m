Return-Path: <linux-kernel-owner+w=401wt.eu-S1763975AbXFGPiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763975AbXFGPiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 11:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756155AbXFGPhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 11:37:53 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59851 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516AbXFGPhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 11:37:52 -0400
Subject: Re: 2.6.22-rc4-mm2 - usb-storage
From: Peter Zijlstra <peterz@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, mdharm-usb@one-eyed-alien.net
Cc: linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
In-Reply-To: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
References: <20070606220313.8f7c1fab.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 07 Jun 2007 17:37:08 +0200
Message-Id: <1181230628.7348.266.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

My kernel went chatty when I tried to access my usb-stick; which it
didn't seem to find.


Initializing USB Mass Storage driver...
scsi6 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
scsi7 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 5
usb-storage: waiting for device to settle before scanning
usbcore: registered new interface driver usb-storage
USB Mass Storage support registered.
usb-storage: device scan complete
WARNING: at /usr/src/linux-2.6/drivers/usb/core/urb.c:293
usb_submit_urb()

Call Trace:
 [<ffffffff8020d4c7>] show_trace+0x34/0x4f
 [<ffffffff8020d4f4>] dump_stack+0x12/0x17
 [<ffffffff803cac6a>] usb_submit_urb+0x9f/0x226
 [<ffffffff803cc4c7>] usb_sg_wait+0x56/0x132
 [<ffffffff8820519d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
 [<ffffffff88205313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
 [<ffffffff8820577f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
 [<ffffffff882066c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
 [<ffffffff8024a7df>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12

usb-storage: device scan complete
WARNING: at /usr/src/linux-2.6/drivers/usb/core/urb.c:293
usb_submit_urb()

Call Trace:
 [<ffffffff8020d4c7>] show_trace+0x34/0x4f
 [<ffffffff8020d4f4>] dump_stack+0x12/0x17
 [<ffffffff803cac6a>] usb_submit_urb+0x9f/0x226
 [<ffffffff803cc4c7>] usb_sg_wait+0x56/0x132
 [<ffffffff8820519d>] :usb_storage:usb_stor_bulk_transfer_sg+0x9d/0xf3
 [<ffffffff88205313>] :usb_storage:usb_stor_Bulk_transport+0x120/0x244
 [<ffffffff8820577f>] :usb_storage:usb_stor_invoke_transport+0x25/0x2d2
 [<ffffffff882066c0>] :usb_storage:usb_stor_control_thread+0x14b/0x1e7
 [<ffffffff8024a7df>] kthread+0x47/0x74
 [<ffffffff8020cc28>] child_rip+0xa/0x12



