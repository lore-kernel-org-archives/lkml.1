Return-Path: <linux-kernel-owner+w=401wt.eu-S1752289AbXLVHCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbXLVHCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 02:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbXLVHCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 02:02:18 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3065 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbXLVHCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:02:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, <trivial@kernel.org>
Subject: [PATCH 2/3] Remove unused dependency
Date: Fri, 21 Dec 2007 23:02:10 -0800
Message-Id: <1198306931-5258-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
In-Reply-To: <1198306931-5258-2-git-send-email-joe@perches.com>
References: <1198306931-5258-1-git-send-email-joe@perches.com>
 <1198306931-5258-2-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/boot/compressed/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/boot/compressed/Makefile b/arch/arm/boot/compressed/Makefile
index 5fde99f..563cfc2 100644
--- a/arch/arm/boot/compressed/Makefile
+++ b/arch/arm/boot/compressed/Makefile
@@ -111,5 +111,5 @@ $(obj)/font.c: $(FONTC)
 $(obj)/vmlinux.lds: $(obj)/vmlinux.lds.in arch/arm/boot/Makefile .config
 	@sed "$(SEDFLAGS)" < $< > $@
 
-$(obj)/misc.o: $(obj)/misc.c include/asm/arch/uncompress.h lib/inflate.c
+$(obj)/misc.o: $(obj)/misc.c include/asm/arch/uncompress.h
 
-- 
1.5.3.7.949.g2221a6

