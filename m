Return-Path: <linux-kernel-owner+w=401wt.eu-S932580AbZKYVjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580AbZKYVjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 16:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759377AbZKYVjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 16:39:09 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58042 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759378AbZKYVjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 16:39:06 -0500
From: Mike Frysinger <vapier@gentoo.org>
To: uclinux-dist-devel@blackfin.uclinux.org
Cc: linux-kernel@vger.kernel.org,
       =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Subject: [PATCH 2/8] Blackfin: fix cache Kconfig typo
Date: Wed, 25 Nov 2009 16:39:01 -0500
Message-Id: <1259185147-31999-3-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
References: <1259185147-31999-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Goddard Rosa <andre.goddard@gmail.com>

The Kconfig option is "BFIN_EXTMEM_WRITETHROUGH", not "..._WRITETROUGH".

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/cplb-mpu/cplbinit.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/blackfin/kernel/cplb-mpu/cplbinit.c b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
index f7b9cdc..b52c1f8 100644
--- a/arch/blackfin/kernel/cplb-mpu/cplbinit.c
+++ b/arch/blackfin/kernel/cplb-mpu/cplbinit.c
@@ -38,7 +38,7 @@ void __init generate_cplb_tables_cpu(unsigned int cpu)
 
 #ifdef CONFIG_BFIN_EXTMEM_DCACHEABLE
 	d_cache = CPLB_L1_CHBL;
-#ifdef CONFIG_BFIN_EXTMEM_WRITETROUGH
+#ifdef CONFIG_BFIN_EXTMEM_WRITETHROUGH
 	d_cache |= CPLB_L1_AOW | CPLB_WT;
 #endif
 #endif
-- 
1.6.5.3

