Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbYHSJVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbYHSJVn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 05:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752995AbYHSJVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 05:21:32 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:44343
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751125AbYHSJVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 05:21:31 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH RT 0/2] Misc fixes for 2.6.26-rt1
To: mingo@elte.hu, rostedt@goodmis.org, tglx@linutronix.de
Cc: ghaskins@novell.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Date: Tue, 19 Aug 2008 05:19:13 -0400
Message-ID: <20080819091817.21725.81831.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Thomas, Steven,
  Please consider the following patches for 2.6.26-rt2

---

Gregory Haskins (2):
      ftrace: fix elevated preempt_count in wakeup-tracer
      seqlock: make sure that raw_seqlock_t retries readers while writes are pending


 include/linux/seqlock.h           |   12 ++++++++++--
 kernel/trace/trace_sched_wakeup.c |    2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)


