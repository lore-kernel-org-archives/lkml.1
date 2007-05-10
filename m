Return-Path: <linux-kernel-owner+w=401wt.eu-S1757681AbXEJGXD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757681AbXEJGXD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 02:23:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755600AbXEJGWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 02:22:51 -0400
Received: from mx2.suse.de ([195.135.220.15]:55671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbXEJGWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 02:22:50 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 10 May 2007 16:22:19 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 000 of 2] md: Two more bugfixes.
Message-ID: <20070510161940.20204.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following are two bugfixes for md in current kernels.
The first is suitable for -stable is it can allow drive errors
through to the filesystem wrongly.
Both are suitable for 2.6.22.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Avoid a possibility that a read error can wrongly propagate through md/raid1 to a filesystem.
 [PATCH 002 of 2] md: Improve the is_mddev_idle test
