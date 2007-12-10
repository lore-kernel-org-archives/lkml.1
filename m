Return-Path: <linux-kernel-owner+w=401wt.eu-S1756865AbXLJLly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbXLJLly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2007 06:41:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbXLJLk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Dec 2007 06:40:59 -0500
Received: from mga02.intel.com ([134.134.136.20]:58478 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756631AbXLJLk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2007 06:40:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.23,276,1194249600"; 
   d="scan'208";a="292366142"
Date: Mon, 10 Dec 2007 12:38:09 +0100
From: Markus Metzger <markus.t.metzger@intel.com>
To: ak@suse.de, hpa@zytor.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       tglx@linutronix.de
Cc: markut.t.metzger@intel.com, markus.t.metzger@gmail.com,
       suresh.b.siddha@intel.com, roland@redhat.com, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: [patch 1/4] x86: remove bad comment
Message-ID: <20071210123809.A14251@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a comment that is no longer correct. The reconfiguration is done directly in __switch_to_xtra.

Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: linux-2.6-x86/arch/x86/kernel/process_64.c
===================================================================
--- linux-2.6-x86.orig/arch/x86/kernel/process_64.c	2007-12-10 09:35:26.%N +0100
+++ linux-2.6-x86/arch/x86/kernel/process_64.c	2007-12-10 09:36:38.%N +0100
@@ -598,10 +598,6 @@
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
