Return-Path: <linux-kernel-owner+w=401wt.eu-S1756487AbZJSOtP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487AbZJSOtP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 10:49:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZJSOtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 10:49:15 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:36908 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754636AbZJSOtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 10:49:14 -0400
Subject: [PATCH 0/4] Kmemleak patches for 2.6.33
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 19 Oct 2009 15:49:17 +0100
Message-ID: <20091019144602.14221.27128.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-rc4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Oct 2009 14:49:18.0211 (UTC) FILETIME=[55D55D30:01CA50CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of kmemleak patches for the upcoming merging window.
The final patch in the series changes the leak reporting logic a bit to
reduce the transient false positives.

If there are no objections, I'll push them to the -next tree. Thanks.


Catalin Marinas (4):
      kmemleak: Simplify the kmemleak_scan_area() function prototype
      kmemleak: Scan the _ftrace_events section in modules
      kmemleak: Store object reverse references for debugging purposes
      kmemleak: Allow two scanning passes before reported an object as leak


 include/linux/kmemleak.h |    8 +--
 kernel/module.c          |   13 +++-
 mm/kmemleak.c            |  141 ++++++++++++++++++----------------------------
 mm/slab.c                |    4 +
 4 files changed, 68 insertions(+), 98 deletions(-)

-- 
Catalin
