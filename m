Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbYCGFBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbYCGFBF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 00:01:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755441AbYCGFAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 00:00:47 -0500
Received: from mx2.suse.de ([195.135.220.15]:57668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981AbYCGFAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 00:00:46 -0500
From: NeilBrown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Fri, 7 Mar 2008 16:00:40 +1100
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 000 of 2] md: To more bugfixes for 2.6.25
Message-ID: <20080307155754.25976.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two more little bug fixes for md in 2.6.25.

One fixes a formatting error in /proc/mdstat.  Technically this is a
user-interface change for an interface that has been around since
2.6.15.  However the only program known to parse this file trips over
the error.  So I think it is safe to fix it.

The second fixes a small bug in a recent patch.

 [PATCH 001 of 2] md: Fix formatting error in /proc/mdstat.
 [PATCH 002 of 2] md: Reduce CPU wastage on idle md array with a write-intent bitmap. fix
