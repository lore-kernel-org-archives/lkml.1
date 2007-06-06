Return-Path: <linux-kernel-owner+w=401wt.eu-S936189AbXFFVBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936189AbXFFVBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 17:01:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935809AbXFFVAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 17:00:48 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:37256 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935289AbXFFVAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 17:00:47 -0400
From: Grant Wilson <gww@swandive.no-ip.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm1
Date: Wed, 6 Jun 2007 21:58:38 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <20070606020737.4663d686.akpm@linux-foundation.org>
In-Reply-To: <20070606020737.4663d686.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706062158.39057.gww@swandive.no-ip.com>
X-Originating-Pythagoras-IP: [82.71.45.175]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 June 2007 10:07:37 Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc4/2.6.22-rc4-mm1/

Patch 'usb-try-to-debug-bug-8561' triggers when I plug in a usb flash drive:

[10998.881000] usb 1-10: new high speed USB device using ehci_hcd and address 3
[10999.001000] usb 1-10: new device found, idVendor=13fe, idProduct=1a00
[10999.002000] usb 1-10: new device strings: Mfr=1, Product=2, SerialNumber=3
[10999.016000] usb 1-10: Product: USB DISK 2.0
[10999.025000] usb 1-10: Manufacturer:
[10999.033000] usb 1-10: SerialNumber: 07720947018D
[10999.034000] usb 1-10: configuration #1 chosen from 1 choice
[10999.047000] scsi8 : SCSI emulation for USB Mass Storage devices
[11004.055000] WARNING: at drivers/usb/core/urb.c:293 usb_submit_urb()
[11004.055000]
[11004.055000] Call Trace:
[11004.055000]  [<ffffffff8020d30f>] dump_trace+0x43f/0x480
[11004.055000]  [<ffffffff8020d393>] show_trace+0x43/0x70
[11004.055000]  [<ffffffff8020d3d5>] dump_stack+0x15/0x20
[11004.055000]  [<ffffffff804b4314>] usb_submit_urb+0x224/0x240
[11004.055000]  [<ffffffff804b5ff5>] usb_sg_wait+0xd5/0x180
[11004.055000]  [<ffffffff804cf464>] usb_stor_bulk_transfer_sg+0xc4/0x120
[11004.055000]  [<ffffffff804cf611>] usb_stor_Bulk_transport+0x151/0x2e0
[11004.055000]  [<ffffffff804cfb57>] usb_stor_invoke_transport+0x37/0x380
[11004.055000]  [<ffffffff804ce9f9>] usb_stor_transparent_scsi_command+0x9/0x10
[11004.055000]  [<ffffffff804d0aea>] usb_stor_control_thread+0x18a/0x230
[11004.055000]  [<ffffffff8024927d>] kthread+0x4d/0x80
[11004.055000]  [<ffffffff8020c868>] child_rip+0xa/0x12

Cheers,
Grant
