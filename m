Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXLNQuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXLNQuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 11:50:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753134AbXLNQtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 11:49:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:28939 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752015AbXLNQtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 11:49:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,168,1196668800"; 
   d="scan'208";a="238633145"
Date: Fri, 14 Dec 2007 17:48:58 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 1/5] x86, ptrace: remove bad comment
Message-ID: <20071214174858.A20475@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove no longer correct comment.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2007-12-14 15:31:37.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2007-12-14 15:31:42.%N +0100
@@ -597,10 +597,6 @@
 		memset(tss->io_bitmap, 0xff, prev->io_bitmap_max);
 	}
 
-	/*
-	 * Last branch recording recofiguration of trace hardware and
-	 * disentangling of trace data per task.
-	 */
 	if (test_tsk_thread_flag(prev_p, TIF_BTS_TRACE_TS))
 		ptrace_bts_take_timestamp(prev_p, BTS_TASK_DEPARTS);
 
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

