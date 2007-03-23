Return-Path: <linux-kernel-owner+w=401wt.eu-S934262AbXCWBKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262AbXCWBKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 21:10:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934267AbXCWBKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 21:10:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40994 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934262AbXCWBKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 21:10:12 -0400
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 23 Mar 2007 12:10:06 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 3] md: bug fixes for md for 2.6.21
Message-ID: <20070323120828.5793.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A minor new feature and 2 bug fixes for md suitable for 2.6.21

The minor feature is to make reshape (adding a drive to an array and
restriping it) work for raid4.  The code is all ready, it just wasn't
used.

Thanks,
NeilBrown


 [PATCH 001 of 3] md: Allow raid4 arrays to be reshaped.
 [PATCH 002 of 3] md: Clear the congested_fn when stopping a raid5
 [PATCH 003 of 3] md: Convert compile time warnings into runtime warnings.
