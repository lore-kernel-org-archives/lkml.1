Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYESBKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYESBKZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 21:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751417AbYESBKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 21:10:13 -0400
Received: from mail.suse.de ([195.135.220.2]:35861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbYESBKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 21:10:12 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 19 May 2008 11:10:00 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Bernd Schubert <bernd-schubert@gmx.de>
Cc: Bernd Schubert <bs@q-leap.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Eivind Sarto" <ivan@kasenna.com>
Cc: "Fairbanks, David" <David.Fairbanks@stratus.com>
Cc: "Mike Snitzer" <snitzer@gmail.com>
Subject: [PATCH 000 of 10] md: Various bug fixes and small improvements for md in 2.6.26-rc
Message-ID: <20080519110910.7473.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following are a collection of 10 patches for md/raid that are suitable
for 2.6.26-rc.  They are ordered roughly from simple to more complex with 
serious bugfixes possibly getting elevated in the sort order.

Thanks,
NeilBrown

 [PATCH 000 of 10] md: Introduction EXPLAIN PATCH SET HERE
 [PATCH 001 of 10] md: Fix possible oops when removing a bitmap from an active array
 [PATCH 002 of 10] md: proper extern for mdp_major
 [PATCH 003 of 10] md: kill file_path wrapper
 [PATCH 004 of 10] md: md: raid5 rate limit error printk
 [PATCH 005 of 10] md: raid1: Fix restoration of bio between failed read and write.
 [PATCH 006 of 10] md: Notify userspace on 'write-pending' changes to array_state
 [PATCH 007 of 10] md: notify userspace on 'stop' events
 [PATCH 008 of 10] md: Improve setting of "events_cleared" for write-intent bitmaps.
 [PATCH 009 of 10] md: Allow parallel resync of md-devices.
 [PATCH 010 of 10] md: Restart recovery cleanly after device failure.
