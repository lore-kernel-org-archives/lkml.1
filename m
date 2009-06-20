Return-Path: <linux-kernel-owner+w=401wt.eu-S1760099AbZFTSvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099AbZFTSvf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 14:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758413AbZFTSro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 14:47:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48223 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758566AbZFTSrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 14:47:43 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Yi Li <yi.li@analog.com>
Subject: [PATCH 25/25] Blackfin: drop BF535-specific text for exception 0x2A (unaligned instruction)
Date: Sat, 20 Jun 2009 14:44:48 -0400
Message-Id: <1245523488-26536-26-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
References: <1245523488-26536-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yi Li <yi.li@analog.com>

We don't support the BF535 at all, and the exception 0x2A text specific to
it is pretty verbose and confusing (since the behavior is simply odd), so
punt it to keep the noise down.

Signed-off-by: Yi Li <yi.li@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/traps.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/arch/blackfin/include/asm/traps.h b/arch/blackfin/include/asm/traps.h
index 34f7295..3cdc454 100644
--- a/arch/blackfin/include/asm/traps.h
+++ b/arch/blackfin/include/asm/traps.h
@@ -111,9 +111,7 @@
 	level "   bits in the Watchpoint Instruction Address Control register (WPIACTL) is set.\n"
 #define EXC_0x2A(level) \
 	"Instruction fetch misaligned address violation\n" \
-	level " - Attempted misaligned instruction cache fetch. On a misaligned instruction fetch\n" \
-	level "   exception, the return address provided in RETX is the destination address which is\n" \
-	level "   misaligned, rather than the address of the offending instruction.\n"
+	level " - Attempted misaligned instruction cache fetch.\n"
 #define EXC_0x2B(level) \
 	"CPLB protection violation\n" \
 	level " - Illegal instruction fetch access (memory protection violation).\n"
-- 
1.6.3.1

