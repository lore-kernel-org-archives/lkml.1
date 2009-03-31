Return-Path: <linux-kernel-owner+w=401wt.eu-S1758834AbZCaNae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758834AbZCaNae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 09:30:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757678AbZCaNaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 09:30:21 -0400
Received: from mga14.intel.com ([143.182.124.37]:61978 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757639AbZCaNaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 09:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,453,1233561600"; 
   d="scan'208";a="126098810"
Date: Tue, 31 Mar 2009 15:30:05 +0200
From: Markus Metzger <markus.t.metzger@intel.com>
To: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com
Cc: markus.t.metzger@intel.com, markus.t.metzger@gmail.com, roland@redhat.com,
       eranian@googlemail.com, oleg@redhat.com, juan.villacis@intel.com,
       ak@linux.jf.intel.com
Subject: [patch 13/21] x86, ds: fix compiler warning
Message-ID: <20090331153005.A13222@sedona.ch.intel.com>
Mime-Version: 1.0
Content-Disposition: inline
User-Agent: Mutt/1.2.5i
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Size_t is defined differently on i386 and x86_64.
Change type to avoid compiler warning.


Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>
---

Index: git-tip/arch/x86/kernel/ds_selftest.c
===================================================================
--- git-tip.orig/arch/x86/kernel/ds_selftest.c	2009-03-30 19:09:44.000000000 +0200
+++ git-tip/arch/x86/kernel/ds_selftest.c	2009-03-30 19:12:32.000000000 +0200
@@ -95,7 +95,7 @@ static int ds_selftest_bts_read(struct b
 	/* Now to the test itself. */
 	for (at = from; (void *)at < to; at += trace->ds.size) {
 		struct bts_struct bts;
-		size_t index;
+		unsigned long index;
 		int error;
 
 		if (((void *)at - trace->ds.begin) % trace->ds.size) {
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

