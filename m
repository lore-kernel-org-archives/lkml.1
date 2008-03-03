Return-Path: <linux-kernel-owner+w=401wt.eu-S1758008AbYCCARJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008AbYCCARJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 19:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbYCCAQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 19:16:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:45631 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbYCCAQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 19:16:49 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 3 Mar 2008 11:16:58 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Keld Simonsen <keld@dkuug.dk>
Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Subject: [PATCH 000 of 9] md: Introduction EXPLAIN PATCH SET HERE
Message-ID: <20080303111240.23302.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 9 patches for md in 2.6.25-rc2-mm1.  All are fairly
simply bugfixes and are suitable for 2.6.25 (though I confess I
should have sent some of them eariler :-( ).

They include fixes for three bugs found but the scsi fault injection framework
(thanks!), and small raid10 read optimisation, and various other bits
and pieces.

NeilBrown


 [PATCH 001 of 9] md: Fix deadlock in md/raid1 and md/raid10 when handling a read error.
 [PATCH 002 of 9] md: Reduce CPU wastage on idle md array with a write-intent bitmap.
 [PATCH 003 of 9] md: Guard against possible bad array geometry in v1 metadata.
 [PATCH 004 of 9] md: Clean up irregularity with raid autodetect.
 [PATCH 005 of 9] md: Make sure a reshape is started when device switches to read-write.
 [PATCH 006 of 9] md: Lock access to rdev attributes properly
 [PATCH 007 of 9] md: Don't attempt read-balancing for raid10 'far' layouts.
 [PATCH 008 of 9] md: Fix possible raid1/raid10 deadlock on read error during resync.
 [PATCH 009 of 9] md: The md RAID10 resync thread could cause a md RAID10 array deadlock
