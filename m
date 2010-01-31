Return-Path: <linux-kernel-owner+w=401wt.eu-S1754218Ab0AaUDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab0AaUDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:03:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754092Ab0AaUCW
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:22 -0500
Received: from mail.perches.com ([173.55.12.10]:1643 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab0AaUCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:20 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 02/10] arch/blackfin: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:04 -0800
Message-Id: <518828987c6692c676b93c2fdb0059efa6c86b23.1264967498.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/blackfin/mach-common/smp.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 369e687..c7bcbe5 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -161,8 +161,8 @@ static irqreturn_t ipi_handler(int irq, void *dev_instance)
 			kfree(msg);
 			break;
 		default:
-			printk(KERN_CRIT "CPU%u: Unknown IPI message \
-			0x%lx\n", cpu, msg->type);
+			printk(KERN_CRIT "CPU%u: Unknown IPI message 0x%lx\n",
+			       cpu, msg->type);
 			kfree(msg);
 			break;
 		}
-- 
1.6.6.rc0.57.gad7a

