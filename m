Return-Path: <linux-kernel-owner+w=401wt.eu-S1760942AbYFBNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760942AbYFBNDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760201AbYFBNDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 09:03:16 -0400
Received: from gw.goop.org ([64.81.55.164]:51877 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760045AbYFBNDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 09:03:15 -0400
Message-ID: <4843EF6A.20305@goop.org>
Date: Mon, 02 Jun 2008 14:02:34 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       xen-devel <xen-devel@lists.xensource.com>,
       Thomas Gleixner <tglx@linutronix.de>, Hugh Dickins <hugh@veritas.com>,
       Zachary Amsden <zach@vmware.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH] mm: fix comment formatting in asm-generic/pgtable.h:__ptep_modify_prot_
References: <patchbomb.1212192268@localhost> <4deead25e96efc8ca783.1212192269@localhost> <20080602111339.GB18586@elte.hu>
In-Reply-To: <20080602111339.GB18586@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 include/asm-generic/pgtable.h |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

===================================================================
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -201,9 +201,11 @@
 					     unsigned long addr,
 					     pte_t *ptep)
 {
-	/* Get the current pte state, but zero it out to make it
-	   non-present, preventing the hardware from asynchronously
-	   updating it. */
+	/*
+	 * Get the current pte state, but zero it out to make it
+	 * non-present, preventing the hardware from asynchronously
+	 * updating it.
+	 */
 	return ptep_get_and_clear(mm, addr, ptep);
 }
 
@@ -211,8 +213,10 @@
 					     unsigned long addr,
 					     pte_t *ptep, pte_t pte)
 {
-	/* The pte is non-present, so there's no hardware state to
-	   preserve. */
+	/*
+	 * The pte is non-present, so there's no hardware state to
+	 * preserve.
+	 */
 	set_pte_at(mm, addr, ptep, pte);
 }
 


