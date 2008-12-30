Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbYL3MZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbYL3MZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 07:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbYL3MZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 07:25:10 -0500
Received: from lucidpixels.com ([75.144.35.66]:48023 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbYL3MZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:25:08 -0500
Date: Tue, 30 Dec 2008 07:25:08 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: 2.6.28: md0: unknown partition table
Message-ID: <alpine.DEB.1.10.0812300610190.11356@p34.internal.lan>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had a question about the new option in 2.6.28:

[    7.655297] usb 6-2: configuration #1 chosen from 1 choice
[    7.663280] hub 6-2:1.0: USB hub found
[    7.666533] hub 6-2:1.0: 3 ports detected
[    7.698008] udev: renamed network interface eth0_rename to eth1
[    7.824538]  md1:<6> md0: unknown partition table
[    7.835978] 
[    7.950237] usb 6-2.1: new full speed USB device using uhci_hcd and address 3
[    8.081335] usb 6-2.1: configuration #1 chosen from 1 choice

See line:
[    7.824538]  md1:<6> md0: unknown partition table

This is swap, I do not recall seeing this error in kernels < 2.6.28, should
the kernel not scan for partitions on a swap-based parititon? [1]

[2] partitions for mdadm/raid are usually md0_p1 md1_p2 why would it scan for
partitions on /dev/md0, /dev/md1, /dev/md2 as they are 'block devices' e.g.,
similar to /dev/sda, /dev/sdb, /dev/sdc

I do have the option checked off:
[*]     Autodetect RAID arrays during kernel boot

As I compile everything in statically, no modules are used.

If I disable that option, would my system still boot/that would get rid of 
the error/so it does not try to scan for partitions on swap?

Justin.

