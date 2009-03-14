Return-Path: <linux-kernel-owner+w=401wt.eu-S1756636AbZCNPpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636AbZCNPpd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbZCNPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:45:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:37530 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751560AbZCNPpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:45:24 -0400
Subject: [PATCH -tip] x86: trampoline.c cleanup
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 14 Mar 2009 21:14:54 +0530
Message-Id: <1237045494.4546.22.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH] x86: trampoline.c cleanup

Impact: cleanup

 - fix style problems

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/trampoline.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index 808031a..e3b1f2e 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -15,7 +15,7 @@ void __init reserve_trampoline_memory(void)
 	 * trampoline before removing it. (see the GDT stuff)
 	 */
 	reserve_early(PAGE_SIZE, PAGE_SIZE + PAGE_SIZE, "EX TRAMPOLINE");
-#endif
+#endif /* CONFIG_X86_32 */
 	/* Has to be in very low memory so we can execute real-mode AP code. */
 	reserve_early(TRAMPOLINE_BASE, TRAMPOLINE_BASE + TRAMPOLINE_SIZE,
 			"TRAMPOLINE");
@@ -29,5 +29,6 @@ void __init reserve_trampoline_memory(void)
 unsigned long setup_trampoline(void)
 {
 	memcpy(trampoline_base, trampoline_data, TRAMPOLINE_SIZE);
+
 	return virt_to_phys(trampoline_base);
 }
-- 
1.6.0.6



