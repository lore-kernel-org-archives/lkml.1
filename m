Return-Path: <linux-kernel-owner+w=401wt.eu-S1754926AbYLCWGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754926AbYLCWGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 17:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752070AbYLCWFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 17:05:51 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:35940
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751537AbYLCWFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 17:05:51 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 0/4] sched: track next-highest priority
To: mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Wed, 03 Dec 2008 17:09:29 -0500
Message-ID: <20081203220628.11729.42174.stgit@dev.haskins.net>
In-Reply-To: <20081203204025.GA31376@elte.hu>
References: <20081203204025.GA31376@elte.hu>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
  This version of the patches is logically equivelent to v1 with the following
  exceptions.

1) Rebased to tip/master df9fc0207
2) split v1-1/3 into v2-1/4 (cleanup) and v2-2/4 (changes)


I talked to Peter today about reviewing/acking these.  I told him to wait for
v2, so here it is.  Hopefully he will have a chance to look at these soon.


Thanks guys,
-Greg

---

Gregory Haskins (4):
      sched: use highest_prio.next to optimize pull operations
      sched: use highest_prio.curr for pull threshold
      sched: track the next-highest priority on each runqueue
      sched: cleanup inc/dec_rt_tasks


 kernel/sched.c    |    8 ++-
 kernel/sched_rt.c |  156 +++++++++++++++++++++++++++++++----------------------
 2 files changed, 98 insertions(+), 66 deletions(-)

-- 
Signature
