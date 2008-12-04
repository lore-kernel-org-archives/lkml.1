Return-Path: <linux-kernel-owner+w=401wt.eu-S1756260AbYLDPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbYLDPkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 10:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbYLDPj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 10:39:59 -0500
Received: from 68-112-229-48.dhcp.oxfr.ma.charter.com ([68.112.229.48]:53191
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756133AbYLDPj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 10:39:58 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v3 0/4] sched: track next-highest priority
To: mingo@elte.hu
Cc: peterz@infradead.org, rostedt@goodmis.org, ghaskins@novell.com,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Date: Thu, 04 Dec 2008 10:43:36 -0500
Message-ID: <20081204154100.21712.88806.stgit@dev.haskins.net>
In-Reply-To: <20081203220628.11729.42174.stgit@dev.haskins.net>
References: <20081203220628.11729.42174.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
  Here is the updated series, per my note about the bug in v2 last night.

Changes since v2

Fix bug in 2/4 related to recomputing .next in dec_rt_task()

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

