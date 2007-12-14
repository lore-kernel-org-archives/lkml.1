Return-Path: <linux-kernel-owner+w=401wt.eu-S1758342AbXLNG01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758342AbXLNG01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:26:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752293AbXLNG0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:26:07 -0500
Received: from mail.suse.de ([195.135.220.2]:34021 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658AbXLNG0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:26:06 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 14 Dec 2007 17:26:02 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 000 of 7] md: Introduction EXPLAIN PATCH SET HERE
Message-ID: <20071214171950.1308.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 7 md related patches are suitable for the next -mm
and maybe for 2.6.25.

They move towards giving user-space programs more fine control of an
array so that we can add support for more complex metadata formats
(e.g. DDF) without bothering the kernel with such things.

The last patch isn't strictly md related.  It adds an ioctl which
allows mapping from an open file descriptor on a block device to
a name in /sys.  This makes finding name of things in /sys more practical.
As I put this in block-layer code, I have Cc:ed Jens Axboe.

 [PATCH 001 of 7] md: Support 'external' metadata for md arrays.
 [PATCH 002 of 7] md: Give userspace control over removing failed devices when external metdata in use
 [PATCH 003 of 7] md: Allow a maximum extent to be set for resyncing.
 [PATCH 004 of 7] md: Allow devices to be shared between md arrays.
 [PATCH 005 of 7] md: Lock address when changing attributes of component devices.
 [PATCH 006 of 7] md: Allow an md array to appear with 0 drives if it has external metadata.
 [PATCH 007 of 7] md: Get name for block device in sysfs
