Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYBKJuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYBKJuc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 04:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbYBKJuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 04:50:20 -0500
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:30309 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278AbYBKJuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 04:50:18 -0500
From: Andi Kleen <ak@suse.de>
Message-Id: <200802111050.372086035@suse.de>
To: tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: [PATCH] [0/8] Misc CPA patchkit
Date: Mon, 11 Feb 2008 10:50:15 +0100 (CET)
X-OriginalArrivalTime: 11 Feb 2008 09:43:54.0235 (UTC) FILETIME=[9D6E84B0:01C86C92]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


(relative to git-x86#mm 05afd57b4438d4650d93e6f54f465b0cdd2d9ea8) 

They should be all safe/useful enough to be considered .25 candidates.

Some minor features for pageattr.c:
- Use less memory in the !DEBUG_PAGEALLOC case
(second patch for that is just a optional cleanup)
- Support CPU self snoop (resubmit of earlier patch)
- Add some statistic counters about the direct mapping to /proc/meminfo
- Shrink code size by doing less inlining
- Remove obsolete BUG()s

The patches are all fairly independent (except the two debug-pagealloc patches) 
so it's possible to cherry-pick.

-Andi
