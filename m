Return-Path: <linux-kernel-owner+w=401wt.eu-S936893AbXHPAix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936893AbXHPAix (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2007 20:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbXHPAil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Aug 2007 20:38:41 -0400
Received: from ns.suse.de ([195.135.220.2]:58468 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbXHPAik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2007 20:38:40 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 16 Aug 2007 10:38:32 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 2] md: bug fixes for 2.6.23-rc
Message-ID: <20070816103626.32539.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following 2 patches contain bugfixes for md.  Both apply to earlier
kernels, but probably aren't significant enough for -stable (no oops,
no data corruption, no security hole).
They should go in 2.6.23 though.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Make sure a re-add after a restart honours bitmap when resyncing.
 [PATCH 002 of 2] md: Correctly update sysfs when a raid1 is reshaped.
