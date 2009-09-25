Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZIYEyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZIYEyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 00:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZIYEyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 00:54:23 -0400
Received: from mail.impulse.net.au ([210.9.195.23]:51814 "HELO
	mail.impulse.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751407AbZIYEyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 00:54:22 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 25 Sep 2009 00:54:21 EDT
From: "Ben Ryan" <ben@impulse.net.au>
To: <linux-kernel@vger.kernel.org>
Subject: USB HDD boot panic (2.6.31)
Date: Fri, 25 Sep 2009 14:47:45 +1000
Message-ID: <002701ca3d9b$53250240$f96f06c0$@net.au>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Aco9m1LWIPrtEiXlR0WdgQNIlquzgg==
Content-Language: en-au
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've a question regarding boot from USB-attached IDE HDD under 2.6.31
(slackware/lilo).
Searches haven't shed much light on status or resolutions.
Booting from this device throws:


VFS: Cannot open root device "sda1" or unknown-block(0,0)
Please append a correct "root=" boot option; here are the available
partitions:
.
Kernel panic - not syncing: VFS: Unable to mount root fs on unknown
block(0,)


I notice that there's no /dev/sd(x) devices listed as possible roots in the
error.
I've tried a kernel build with all relevant drivers inbuilt (not modules).
Tested on multiple machines with same result.
This issue seems to have some history, earlier kernels had patches written
for genhd.c (but I lack the skills to port them forward).
Discussion here:
http://lkml.indiana.edu/hypermail/linux/kernel/0405.0/0224.html

>From what I can gather the USB drivers aren't finished initialising before
the disks are enumerated and mapped to /dev.

Is this a known, current issue?
Does anyone have a patch that can help? If so, why isn't it mainlined?
(Please CC responses!)

Thanks
Ben

