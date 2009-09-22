Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbZIVF3v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbZIVF3v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 01:29:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbZIVF3u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 01:29:50 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:49174 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754543AbZIVF3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 01:29:50 -0400
From: Darren Hart <dvhltc@us.ibm.com>
Subject: [PATCH 0/5] Futex cleanups and race fix
To: linux-kernel@vger.kernel.org
Date: Mon, 21 Sep 2009 22:29:52 -0700
Message-ID: <20090922052452.8717.39673.stgit@Aeon>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series corrects several innacurate comments in the futex code as
well as reformat some of the existing comments to be mostly consistent
throughout futex.c. The final patch fixes a nasty little race in the requeue pi
code resulting in missed wakeups and hung userspace application threads.

Signed-off-by: Darren Hart <dvhltc@us.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
CC: Eric Dumazet <eric.dumazet@gmail.com>
CC: Dinakar Guniguntala <dino@in.ibm.com>
CC: John Stultz <johnstul@us.ibm.com>

---

Darren Hart (5):
      futex: fix wakeup race by setting TASK_INTERRUPTIBLE before queue_me
      futex: correct futex_q woken state commentary
      futex: make function kernel-doc commentary consistent
      futex: correct queue_me and unqueue_me commentary
      futex: correct futex_wait_requeue_pi() commentary


 kernel/futex.c |  135 ++++++++++++++++++++++++++++++--------------------------
 1 files changed, 72 insertions(+), 63 deletions(-)

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
