Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbYJJJAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbYJJJAQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 05:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbYJJI75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 04:59:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:49534 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbYJJI74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 04:59:56 -0400
Date: Fri, 10 Oct 2008 17:59:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] memcg: more updates (still under test) v7
Message-Id: <20081010175936.f3b1f4e0.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is just-for-test sets.

ready-to-go set (v7 http://marc.info/?l=linux-mm&m=122353662107309&w=2)
can be applied to the latest mmotm(stamp-2008-10-09-21-35) with small easy
Hunk. (change in mm_types.h show HUNK) So I don't send it again now.

While it seems I have to maintain ready-to-go set by myself until the end of
merge window, I'd like to share patches on my stack and restart Mem+Swap
controller at el.

This set includes following patches

[1/5] ....charge/commit/cancel protcol
[2/5] ....fix for page migration handling (I hope this will be silver bullet.)
[3/5] ....new force_empty() and move_account()
[4/5] ....lazy lru free
[5/5] ....lazy lru add.

I'm still testing this but dump it now before weekend. (works well as far as my
test.) I'll restart Mem+Swap controller from scratch in the next week.

If you want me to do other work rather than Mem+Swap controller, don't hesitate
to request me. I may not notice that any important work should be done before
complicated tasks.
tasks on my queue is..
  - Mem+Swap controller.
  - an interface to shrink memory usage of a group.
  - move account at task move (maybe complicated.)
  - swappiness support (after split-lru setteld.)
  - dirty_ratio (Andrea Righi's work will go.)
  - priority to memory reclaim. (can we ?)
  - hierarchy support. (needs discusstion for trade-off among performance/function.)
  - NUMA statistics (this needs cgroup interface enhancements.)

And maybe we need more performance check.

Bye,
-Kame





