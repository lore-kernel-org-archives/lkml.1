Return-Path: <linux-kernel-owner+w=401wt.eu-S1757655AbXFLBKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757655AbXFLBKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 21:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbXFLBJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 21:09:37 -0400
Received: from mx2.suse.de ([195.135.220.15]:53473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbXFLBJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 21:09:36 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 12 Jun 2007 11:09:23 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Accetta <maccetta@laurelnetworks.com>
Cc: Neil Brown <neilb@suse.de>
Cc: stable@kernel.org
Subject: [PATCH 000 of 2] md: Introduction - bugfixes for md/raid{1,10}
Message-ID: <20070612110634.25171.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Following are a couple of bugfixes for raid10 and raid1.  They only
affect fairly uncommon configurations (more than 2 mirrors) and can
cause data corruption.  Thay are suitable for 2.6.22 and 21-stable.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Fix two raid10 bugs.
 [PATCH 002 of 2] md: Fix bug in error handling during raid1 repair.
