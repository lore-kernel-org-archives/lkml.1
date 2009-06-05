Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZFEIQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZFEIQm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755511AbZFEIGc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:32 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37531 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755516AbZFEIFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:47 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org, Graf Yang <graf.yang@analog.com>
Subject: [PATCH 31/62] Blackfin: annotate anomaly 05000120
Date: Fri,  5 Jun 2009 04:04:40 -0400
Message-Id: <1244189111-19639-32-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graf Yang <graf.yang@analog.com>

Add some notes for anomaly 05000120 to make sure we work around it.

Signed-off-by: Graf Yang <graf.yang@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/mach-common/smp.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index 93eab61..187c79e 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -45,6 +45,10 @@
 #include <asm/cpu.h>
 #include <linux/err.h>
 
+/*
+ * Anomaly notes:
+ * 05000120 - we always define corelock as 32-bit integer in L2
+ */
 struct corelock_slot corelock __attribute__ ((__section__(".l2.bss")));
 
 void __cpuinitdata *init_retx_coreb, *init_saved_retx_coreb,
-- 
1.6.3.1

