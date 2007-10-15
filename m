Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbXJOEej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbXJOEej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 00:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750773AbXJOEe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 00:34:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:33130 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751269AbXJOEe0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 00:34:26 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 15 Oct 2007 14:34:18 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "Dan Williams" <dan.j.williams@intel.com>
Cc: Iustin Pop <iusty@k1024.org>
Subject: [PATCH 000 of 5] md: Five minor md patch, some for 2.6.24.
Message-ID: <20071015143136.5200.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are 5 minor patches for md in current -mm.

The first 4 are suitable to flow into 2.6.24.

The last fixes a small bug in Dan Williams' patches currently in -mm,
which are not scheduled for 2.6.24.

Thanks,
NeilBrown


 [PATCH 001 of 5] md: Fix a bug in some never-used code.
 [PATCH 002 of 5] md: 'sync_action' in sysfs returns wrong value for readonly arrays
 [PATCH 003 of 5] md: Expose the degraded status of an assembled array through sysfs
 [PATCH 004 of 5] md: Make sure read errors are auto-corrected during a 'check' resync in raid1
 [PATCH 005 of 5] md: Fix type that is stopping raid5 grow from working.
