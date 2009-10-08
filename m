Return-Path: <linux-kernel-owner+w=401wt.eu-S1754367AbZJHGFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367AbZJHGFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbZJHGFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:05:30 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34546 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbZJHGFP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:15 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 06/13] Blackfin: fix missed cache config renames
Date: Thu,  8 Oct 2009 02:04:22 -0400
Message-Id: <1254981869-21586-7-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Looks like the big Kconfig cache split/rename missed one spot in the SMP
cache lock headers.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/cache.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/include/asm/cache.h b/arch/blackfin/include/asm/cache.h
index 7d829ea..8542bc3 100644
--- a/arch/blackfin/include/asm/cache.h
+++ b/arch/blackfin/include/asm/cache.h
@@ -38,10 +38,10 @@
 
 #if defined(CONFIG_SMP) && \
     !defined(CONFIG_BFIN_CACHE_COHERENT)
-# if defined(CONFIG_BFIN_ICACHEABLE) || defined(CONFIG_BFIN_L2_ICACHEABLE)
+# if defined(CONFIG_BFIN_EXTMEM_ICACHEABLE) || defined(CONFIG_BFIN_L2_ICACHEABLE)
 # define __ARCH_SYNC_CORE_ICACHE
 # endif
-# if defined(CONFIG_BFIN_DCACHEABLE) || defined(CONFIG_BFIN_L2_DCACHEABLE)
+# if defined(CONFIG_BFIN_EXTMEM_DCACHEABLE) || defined(CONFIG_BFIN_L2_DCACHEABLE)
 # define __ARCH_SYNC_CORE_DCACHE
 # endif
 #ifndef __ASSEMBLY__
-- 
1.6.5.rc2

