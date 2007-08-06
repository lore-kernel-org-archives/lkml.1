Return-Path: <linux-kernel-owner+w=401wt.eu-S933522AbXHFOJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933522AbXHFOJX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 10:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757851AbXHFOJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 10:09:04 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53383 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754701AbXHFOJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 10:09:03 -0400
Date: Mon, 6 Aug 2007 10:09:00 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Miles Lane <miles.lane@gmail.com>
cc: Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.23-rc1-mm2 + cpufreq patch + hot-fixes --
 [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
In-Reply-To: <a44ae5cd0708040518vfcf671p7ef1c6d89e330d89@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0708061007350.3265-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Aug 2007, Miles Lane wrote:

> Initializing USB Mass Storage driver...
> usb-storage 4-3:1.0: usb_probe_interface
> usb-storage 4-3:1.0: usb_probe_interface - got id
> scsi2 : SCSI emulation for USB Mass Storage devices
> usbcore: registered new interface driver usb-storage
> usb-storage: device found at 2
> usb-storage: waiting for device to settle before scanning
> schedule_timeout: wrong timeout value f8ea51d2
>  [<c01080ab>] show_trace_log_lvl+0x12/0x25
>  [<c0108a9e>] show_trace+0xd/0x10
>  [<c0108bac>] dump_stack+0x16/0x18
>  [<c031e31e>] schedule_timeout+0x2c/0x8b
>  [<f8ea528f>] usb_stor_scan_thread+0xbd/0x15a [usb_storage]
>  [<c0139d64>] kthread+0x3b/0x63
>  [<c0107c63>] kernel_thread_helper+0x7/0x10
>  =======================

Does this happen repeatably?

Did you set usb-storage's delay_use parameter to something peculiar?

Alan Stern

