Return-Path: <linux-kernel-owner+w=401wt.eu-S1754836AbZJHGHF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbZJHGHF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 02:07:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754465AbZJHGHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 02:07:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:34526 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754037AbZJHGFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 02:05:09 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 04/13] Blackfin: asm/irq.h: pull in mach/anomaly.h for anomaly defines
Date: Thu,  8 Oct 2009 02:04:20 -0400
Message-Id: <1254981869-21586-5-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
In-Reply-To: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
References: <1254981869-21586-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The asm/irq.h header uses anomaly defines, but doesn't make sure to
explicitly include the anomaly header for them.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/irq.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/include/asm/irq.h b/arch/blackfin/include/asm/irq.h
index 6ec2a07..e7c0623 100644
--- a/arch/blackfin/include/asm/irq.h
+++ b/arch/blackfin/include/asm/irq.h
@@ -12,6 +12,8 @@
 
 #include <linux/irqflags.h>
 
+#include <mach/anomaly.h>
+
 /* SYS_IRQS and NR_IRQS are defined in <mach-bf5xx/irq.h> */
 #include <mach/irq.h>
 
-- 
1.6.5.rc2

