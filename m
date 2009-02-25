Return-Path: <linux-kernel-owner+w=401wt.eu-S1762617AbZBYPSo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762617AbZBYPSo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 10:18:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759826AbZBYPJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 10:09:30 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:56735 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbZBYPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 10:08:45 -0500
Message-Id: <20090225150836.612725313@de.ibm.com>
References: <20090225150622.529143164@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Feb 2009 16:06:56 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch/s390 34/46] topology: define SD_MC_INIT to fix performance regression
Content-Disposition: inline; filename=133-sd-mc-init.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

The default values for SD_MC_INIT cause an additional cpu usage of up
to 40% on some network benchmarks compared to the plain SD_CPU_INIT
values. So just define SD_MC_INIT to SD_CPU_INIT.
More tuning needs to be done.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 arch/s390/include/asm/topology.h |    2 ++
 1 file changed, 2 insertions(+)

Index: quilt-2.6/arch/s390/include/asm/topology.h
===================================================================
--- quilt-2.6.orig/arch/s390/include/asm/topology.h
+++ quilt-2.6/arch/s390/include/asm/topology.h
@@ -30,6 +30,8 @@ static inline void s390_init_cpu_topolog
 };
 #endif
 
+#define SD_MC_INIT SD_CPU_INIT
+
 #include <asm-generic/topology.h>
 
 #endif /* _ASM_S390_TOPOLOGY_H */

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

