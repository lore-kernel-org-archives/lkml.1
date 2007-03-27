Return-Path: <linux-kernel-owner+w=401wt.eu-S932943AbXC0QWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbXC0QWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933010AbXC0QWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:22:48 -0400
Received: from mail.gatrixx.com ([217.111.11.44]:55138 "EHLO mail.gatrixx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943AbXC0QWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:22:47 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Mar 2007 12:22:47 EDT
Message-ID: <46094344.4090007@j-o-a.de>
Date: Tue, 27 Mar 2007 18:16:04 +0200
From: Oliver Joa <oliver@j-o-a.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Corrupt XFS -Filesystems on new Hardware and Kernel
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since some weeks i try to get my new hardware running:

Intel(R) Core(TM)2 CPU          6300  @ 1.86GHz
Intel DP965LT Mainboard
Seagate SATA-Harddisk in AHCI-Mode

After some hours of running or after some heavy file-i/o
(find / | cpio -padm /test) I always get a corrupted
XFS-filesystem.

I used already the following Kernels:
2.6.19.2
2.6.19.7
2.6.20.2
2.6.20.4

After xfs_repair I get damaged files in lost+found.

I read in newsgroups that the write-cache of the harddisk
should be turned of, but the messages are all very old.

Is it still true, that it should be switched of? At startup
I get the following line:

[    6.820776] SCSI device sda: write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA

So I wonder if it should be on or off.

I also often get a sata-bus-reset with the kernels 2.6.19.2
and 2.6.20.2.

What can I do to find the problem? I think about to change
from xfs to ext2 but the filesystemcheck every 30 mounts lasts
a long time.

Do you have any Idea?

Which kernel is at the moment a so called stable? Stable enough
for my hardware?

Thanks a lot

Oliver Joa

