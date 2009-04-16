Return-Path: <linux-kernel-owner+w=401wt.eu-S1756193AbZDPKBu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756193AbZDPKBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 06:01:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753776AbZDPKA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 06:00:59 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:54380 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753160AbZDPKA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 06:00:57 -0400
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>
Subject: [PATCH 03/11] microblaze: Remove uncache shadow condition
Date: Thu, 16 Apr 2009 11:56:30 +0200
Message-Id: <f62690af2276b3fb111af2adae91e65ba1587c11.1239874968.git.monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
References: <1239875798-10523-1-git-send-email-monstr@monstr.eu>
 <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
 <11ed83a6ecbedc74fc543dad9cb81157ce5771ee.1239874968.git.monstr@monstr.eu>
In-Reply-To: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
References: <764365e7af2e476e43cd674738e51f13b306979b.1239874968.git.monstr@monstr.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Uncached shadow feature is not supported in current
kernel code that's why I removed it.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/cache.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/microblaze/include/asm/cache.h b/arch/microblaze/include/asm/cache.h
index c4c64b4..c209c47 100644
--- a/arch/microblaze/include/asm/cache.h
+++ b/arch/microblaze/include/asm/cache.h
@@ -37,9 +37,4 @@ void _invalidate_dcache(unsigned int addr);
 #define __disable_dcache()		_disable_dcache()
 #define __invalidate_dcache(addr)	_invalidate_dcache(addr)
 
-/* FIXME - I don't think this is right */
-#ifdef CONFIG_XILINX_UNCACHED_SHADOW
-#define UNCACHED_SHADOW_MASK (CONFIG_XILINX_ERAM_SIZE)
-#endif
-
 #endif /* _ASM_MICROBLAZE_CACHE_H */
-- 
1.5.5.1

