Return-Path: <linux-kernel-owner+w=401wt.eu-S1754131AbXJVHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131AbXJVHP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 03:15:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJVHPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 03:15:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43211 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbXJVHPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 03:15:44 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Mon, 22 Oct 2007 17:15:27 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Stable <stable@kernel.org>, M@suse.de
Subject: [PATCH 000 of 2] md: Fixes for md in 2.6.23
Message-ID: <20071022171426.31103.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


It appears that a couple of bugs slipped in to md for 2.6.23.
These two patches fix them and are appropriate for 2.6.23.y as well
as 2.6.24-rcX

Thanks,
NeilBrown

 [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
 [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
