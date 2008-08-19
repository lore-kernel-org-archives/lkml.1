Return-Path: <linux-kernel-owner+w=401wt.eu-S1758279AbYHSULE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279AbYHSULE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 16:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbYHSUKy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 16:10:54 -0400
Received: from gw.goop.org ([64.81.55.164]:60148 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbYHSUKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 16:10:53 -0400
Message-ID: <48AB289F.7090102@goop.org>
Date: Tue, 19 Aug 2008 13:10:07 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: another user of PTE_FLAGS_MASK
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/mm/dump_pagetables.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

===================================================================
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -148,8 +148,8 @@
 	 * we have now. "break" is either changing perms, levels or
 	 * address space marker.
 	 */
-	prot = pgprot_val(new_prot) & ~(PTE_PFN_MASK);
-	cur = pgprot_val(st->current_prot) & ~(PTE_PFN_MASK);
+	prot = pgprot_val(new_prot) & PTE_FLAGS_MASK;
+	cur = pgprot_val(st->current_prot) & PTE_FLAGS_MASK;
 
 	if (!st->level) {
 		/* First entry */


