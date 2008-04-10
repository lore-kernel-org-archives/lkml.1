Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbYDJEl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbYDJEl5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 00:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYDJElr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 00:41:47 -0400
Received: from saeurebad.de ([85.214.36.134]:40770 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYDJElr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 00:41:47 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] avr32: Remove two unused #defines from mm/init.c
CC: Haavard Skinnemoen <hskinnemoen@atmel.com>
Date: Thu, 10 Apr 2008 06:40:54 +0200
Message-ID: <87fxtuqq3t.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Johannes Weiner <hannes@saeurebad.de>

---

diff --git a/arch/avr32/mm/init.c b/arch/avr32/mm/init.c
index 480760b..0e64ddc 100644
--- a/arch/avr32/mm/init.c
+++ b/arch/avr32/mm/init.c
@@ -34,9 +34,6 @@ struct page *empty_zero_page;
  */
 unsigned long mmu_context_cache = NO_CONTEXT;
 
-#define START_PFN	(NODE_DATA(0)->bdata->node_boot_start >> PAGE_SHIFT)
-#define MAX_LOW_PFN	(NODE_DATA(0)->bdata->node_low_pfn)
-
 void show_mem(void)
 {
 	int total = 0, reserved = 0, cached = 0;
