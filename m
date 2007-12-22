Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbXLVHCh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbXLVHCh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 02:02:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751870AbXLVHCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 02:02:18 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3064 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751420AbXLVHCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:02:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <trivial@kernel.org>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Richard Henderson <rth@twiddle.net>
Subject: [PATCH 1/3] Remove unused dependency
Date: Fri, 21 Dec 2007 23:02:09 -0800
Message-Id: <1198306931-5258-2-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
In-Reply-To: <1198306931-5258-1-git-send-email-joe@perches.com>
References: <1198306931-5258-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/alpha/boot/Makefile |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/alpha/boot/Makefile b/arch/alpha/boot/Makefile
index cd14388..c53169c 100644
--- a/arch/alpha/boot/Makefile
+++ b/arch/alpha/boot/Makefile
@@ -112,5 +112,3 @@ $(obj)/bootpheader: $(obj)/bootloader.lds $(OBJ_bootph) $(LIBS_Y) FORCE
 
 $(obj)/bootpzheader: $(obj)/bootloader.lds $(OBJ_bootpzh) $(LIBS_Y) FORCE
 	$(call if_changed,ld)
-
-$(obj)/misc.o: lib/inflate.c
-- 
1.5.3.7.949.g2221a6

