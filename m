Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYJPWae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYJPWae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 18:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756964AbYJPWaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 18:30:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756415AbYJPWaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 18:30:13 -0400
Date: Thu, 16 Oct 2008 15:29:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH vfs-2.6 6/6] vfs: add LOOKUP_RENAME_TARGET intent
Message-Id: <20081016152933.ec52ceba.akpm@linux-foundation.org>
In-Reply-To: <11d623e93e848f673b5620397.ps@mail.parknet.co.jp>
References: <e86c95d83e848f673b3120397.ps@mail.parknet.co.jp>
	<ef1e4d933e848f673b4220397.ps@mail.parknet.co.jp>
	<4e71a4b03e848f673b4320397.ps@mail.parknet.co.jp>
	<f5d2a7043e848f673b5420397.ps@mail.parknet.co.jp>
	<e8c7efff3e848f673b5520397.ps@mail.parknet.co.jp>
	<11d623e93e848f673b5620397.ps@mail.parknet.co.jp>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I put these six patches into my tree for sending to Al when he
resurfaces.

We're near the end of the merge window and a lot of trees (including
git-vfs) have a lot of outstanding material:

-rw-r----- 1 akpm src  2168830 Oct 15 14:24 patches/git-firmware.patch
-rw-r----- 1 akpm src  1999274 Oct 15 14:24 patches/git-bdev.patch
-rw-r----- 1 akpm src  1643851 Oct 15 14:24 patches/git-tip.patch
-rw-r----- 1 akpm src  1137163 Oct 15 14:24 patches/git-uwb.patch
-rw-r----- 1 akpm src  1003617 Oct 15 14:24 patches/git-kvm.patch
-rw-r----- 1 akpm src   992495 Oct 15 14:24 patches/git-v4l-dvb.patch
-rw-r----- 1 akpm src   849673 Oct 15 14:24 patches/git-parisc.patch
-rw-r----- 1 akpm src   661519 Oct 15 14:24 patches/git-scsi-post-merge.patch
-rw-r----- 1 akpm src   652920 Oct 15 14:23 patches/git-arm.patch
-rw-r----- 1 akpm src   589596 Oct 15 14:24 patches/git-creds.patch
-rw-r----- 1 akpm src   568498 Oct 15 14:24 patches/git-scsi.patch
-rw-r----- 1 akpm src   410896 Oct 15 14:24 patches/git-drm.patch
-rw-r----- 1 akpm src   404578 Oct 15 14:24 patches/git-ftrace.patch
-rw-r----- 1 akpm src   352603 Oct 15 14:23 patches/git-acpi.patch
-rw-r----- 1 akpm src   314552 Oct 15 14:24 patches/git-sh.patch
-rw-r----- 1 akpm src   254238 Oct 15 14:24 patches/git-mtd.patch
-rw-r----- 1 akpm src   203336 Oct 15 14:24 patches/git-tests.patch
-rw-r----- 1 akpm src   199476 Oct 15 14:24 patches/git-timers.patch
-rw-r----- 1 akpm src   192928 Oct 15 14:24 patches/git-v9fs.patch
-rw-r----- 1 akpm src   158605 Oct 15 14:23 patches/git-avr32.patch
-rw-r----- 1 akpm src   152326 Oct 15 14:24 patches/git-input.patch
-rw-r----- 1 akpm src   138826 Oct 15 14:24 patches/git-pci.patch
-rw-r----- 1 akpm src   135356 Oct 15 14:24 patches/git-slab.patch
-rw-r----- 1 akpm src   125258 Oct 15 14:24 patches/git-vfs.patch
-rw-r----- 1 akpm src   122588 Oct 15 14:24 patches/git-nfs.patch
-rw-r----- 1 akpm src   120826 Oct 15 14:24 patches/git-sparseirq.patch
-rw-r----- 1 akpm src   120746 Oct 15 14:24 patches/git-cris.patch
-rw-r----- 1 akpm src   105868 Oct 15 14:24 patches/git-kmemcheck.patch
-rw-r----- 1 akpm src   101011 Oct 15 14:24 patches/git-mfd.patch
-rw-r----- 1 akpm src    93335 Oct 15 14:24 patches/git-tip-core.patch
-rw-r----- 1 akpm src    84488 Oct 15 14:24 patches/git-ubifs.patch
-rw-r----- 1 akpm src    46595 Oct 15 14:24 patches/git-net-current.patch
-rw-r----- 1 akpm src    30945 Oct 15 14:24 patches/git-stackprotector.patch
-rw-r----- 1 akpm src    30415 Oct 15 14:24 patches/git-crypto.patch
-rw-r----- 1 akpm src    30354 Oct 15 14:24 patches/git-x86.patch
-rw-r----- 1 akpm src    29001 Oct 15 14:24 patches/git-fastboot.patch
-rw-r----- 1 akpm src    28915 Oct 15 14:24 patches/git-hid.patch
-rw-r----- 1 akpm src    26872 Oct 15 14:24 patches/git-wireless-current.patch
-rw-r----- 1 akpm src    25944 Oct 15 14:23 patches/git-backlight.patch
-rw-r----- 1 akpm src    23001 Oct 15 14:24 patches/git-block.patch
-rw-r----- 1 akpm src    20753 Oct 15 14:24 patches/git-sound-current.patch
-rw-r----- 1 akpm src    20752 Oct 15 14:24 patches/git-sound.patch
-rw-r----- 1 akpm src    20616 Oct 15 14:24 patches/git-semaphore-removal.patch
-rw-r----- 1 akpm src    19849 Oct 15 14:24 patches/git-trivial.patch
-rw-r----- 1 akpm src    17854 Oct 15 14:24 patches/git-genirq.patch
-rw-r----- 1 akpm src    17689 Oct 15 14:24 patches/git-gfs2.patch
-rw-r----- 1 akpm src    17135 Oct 15 14:23 patches/git-battery.patch
-rw-r----- 1 akpm src    13923 Oct 15 14:24 patches/git-s390.patch
-rw-r----- 1 akpm src    12604 Oct 15 14:24 patches/git-nfsd.patch
-rw-r----- 1 akpm src    12151 Oct 15 14:24 patches/git-leds.patch
-rw-r----- 1 akpm src     8330 Oct 15 14:24 patches/git-cpus4096.patch
-rw-r----- 1 akpm src     6612 Oct 15 14:24 patches/git-infiniband.patch
-rw-r----- 1 akpm src     4421 Oct 15 14:16 patches/git-tests-git-rejects.patch
-rw-r----- 1 akpm src     4270 Oct 15 14:24 patches/git-kgdb.patch
-rw-r----- 1 akpm src     3898 Oct 15 14:24 patches/git-ubi.patch
-rw-r----- 1 akpm src     3855 Oct 15 14:24 patches/git-safe-poison-pointers.patch
-rw-r----- 1 akpm src     3402 Oct 15 14:24 patches/git-xtensa.patch
-rw-r----- 1 akpm src     3326 Oct 15 14:24 patches/git-oprofile.patch

