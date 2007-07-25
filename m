Return-Path: <linux-kernel-owner+w=401wt.eu-S1764829AbXGYOVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764829AbXGYOVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 10:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbXGYOVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 10:21:33 -0400
Received: from mta-m2.tc.umn.edu ([134.84.119.106]:58705 "EHLO
	mta-m2.tc.umn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099AbXGYOVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 10:21:32 -0400
X-Greylist: delayed 911 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jul 2007 10:21:32 EDT
X-Umn-Remote-Mta: [N] wm1.tc.umn.edu [134.84.119.117] #+LO+NM+TR
From: beck0778@umn.edu
To: linux-kernel@vger.kernel.org
Subject: Linux 2.6 removable media block device driver question
Date: 25 Jul 2007 09:06:15 -0500
X-Mailer: Prayer v1.0.16
X-Originating-IP: [160.94.17.169]
Message-ID: <Prayer.1.0.16.0707250906150.27917@wm1.tc.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm trying to write a block driver for accessing an SD card through a 
memory-mapped SPI module implemented in a Xilinx FPGA. I'm working with 
MontaVista's PPC 2.6.10 kernel. I have finished the lower-level card access 
routines, and can successfully read and write blocks, and even fdisk and 
mount the card. Through a hardware register, I can tell if a card is 
inserted, so that is not the problem.

Currently, things only work if I have the sd card inserted when I load the 
driver module. My next step is to figure out how to handle card insertion 
and removal after the driver has been loaded, and how to notify the kernel 
that there is now a disk present.

If there is not a card present at module init, how much can you tell the 
kernel about your device? Should I allocate a gendisk if I don't know the 
capacity? Should I set up a timer to periodically check for the presence of 
a card, and if so, how do I notify the kernel that a new disk has been 
discovered.

I have a copy of Corbet, Rubini, and Kroah-Hartman's book 'Linux Device 
Drivers', which has been a big help. Their sample block driver, 
unfortunately, does not appear to show how to handle a disk that may change 
during execution, and may not even be present some times.

Is there a guide to the proper way to handle a changing block device?

Thanks in advance for any help,
Matthew
