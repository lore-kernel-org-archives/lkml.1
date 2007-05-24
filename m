Return-Path: <linux-kernel-owner+w=401wt.eu-S1751551AbXEXRh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbXEXRh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbXEXRhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:37:17 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1755 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbXEXRhP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:37:15 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: spyro@f2s.com
Subject: [PATCH] arm26: remove broken and unused macro
Date: Thu, 24 May 2007 19:37:12 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705241937.12535.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Remove broken and unused macro.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/arm26/mm/init.c |    3 ---
 1 file changed, 3 deletions(-)

diff -upr linux-2.6.22-rc2-mm1-a/arch/arm26/mm/init.c linux-2.6.22-rc2-mm1-b/arch/arm26/mm/init.c
--- linux-2.6.22-rc2-mm1-a/arch/arm26/mm/init.c 2007-05-19 06:06:17.000000000 +0200
+++ linux-2.6.22-rc2-mm1-b/arch/arm26/mm/init.c 2007-05-24 18:30:46.000000000 +0200
@@ -33,9 +33,6 @@
 
 #include <asm/map.h>
 
-
-#define TABLE_SIZE PTRS_PER_PTE * sizeof(pte_t))
-
 struct mmu_gather mmu_gathers[NR_CPUS];
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
