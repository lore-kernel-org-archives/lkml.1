Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbXDQCBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbXDQCBy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 22:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754272AbXDQCBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 22:01:54 -0400
Received: from ns.suse.de ([195.135.220.2]:56189 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbXDQCBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 22:01:53 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 17 Apr 2007 12:01:35 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: Greg Banks <gnb@melbourne.sgi.com>
Cc: stable@kernel.org
Subject: [PATCH 000 of 2] knfsd: Close oopsable race in nfsd
Message-ID: <20070417115242.28047.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Following two patches fix a bug introduced in 
   7b2b1fee30df7e2165525cd03f7d1d01a3a56794
and hence is in 2.6.19 and later.
The first patch is a minimal fix which is suitable for all kernels 
since 2.6.19-pre1.  The second adds some consequent cleaning up
and is probably best left for 2.6.22-rc (and so it not being cc:ed 
to stable@kernel.org).

Thanks,
NeilBrown


 [PATCH 001 of 2] knfsd: Use a spinlock to protect sk_info_authunix
 [PATCH 002 of 2] knfsd: Rename sk_defer_lock to sk_lock
