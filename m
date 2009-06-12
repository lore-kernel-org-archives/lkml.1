Return-Path: <linux-kernel-owner+w=401wt.eu-S1760816AbZFLOp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760816AbZFLOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757318AbZFLOpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:45:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:48741 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756598AbZFLOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:45:17 -0400
Date: Fri, 12 Jun 2009 10:45:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?B?T3phbiDDh2HEn2xheWFu?= <ozan@pardus.org.tr>
cc: linux-kernel <linux-kernel@vger.kernel.org>, <arjan@linux.intel.com>
Subject: Re: [BUG] usb-storage hangs while waiting for device to settle
In-Reply-To: <4A324B9E.6070701@pardus.org.tr>
Message-ID: <Pine.LNX.4.44L0.0906121044260.2915-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, [UTF-8] Ozan Çağlayan wrote:

> Hi,
> 
> One of our users reported that he had some issues with its Sony Walkman
> after switching from 2.6.30_rc7(-git2) to 2.6.30_rc8(-git6).

> 2.6.30_rc8
> -----------
> 
> kernel: [210.259083] usb 2-6: new high speed USB device using ehci_hcd and
> address 5
> kernel: [210.374010] usb 2-6: New USB device found, idVendor=054c,
> idProduct=036e
> kernel: [210.374019] usb 2-6: New USB device strings: Mfr=1, Product=2,
> SerialNumber=5
> kernel: [210.374028] usb 2-6: Product: WALKMAN
> kernel: [210.374033] usb 2-6: Manufacturer: SONY
> kernel: [210.374038] usb 2-6: SerialNumber: 390100011A5487120002D8F517EBC712
> kernel: [210.374216] usb 2-6: configuration #1 chosen from 1 choice
> kernel: [210.381558] scsi7 : SCSI emulation for USB Mass Storage devices
> kernel: [210.381893] usb-storage: device found at 5
> kernel: [210.381899] usb-storage: waiting for device to settle before scanning
> 
> 
> I looked a little bit the differences between rc7 and rc8 and the only commit that could be related to that problem seems to be:
> 
> d5a877e8dd409d8c702986d06485c374b705d340 async: make sure independent async domains can't accidentally entangle
> 
> I'm also attaching the kernel configuration. I'll make him to try
> again with the stable 2.6.30.

If this persists in 2.6.30, report it on the linux-scsi mailing list.

Alan Stern

