Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbZFEIOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbZFEIOA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 04:14:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZFEIGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 04:06:18 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37486 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755252AbZFEIFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 04:05:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org,
       Robin Getz <robin.getz@analog.com>
Subject: [PATCH 23/62] Blackfin: annotate anomaly 05000119 in core DMA code
Date: Fri,  5 Jun 2009 04:04:32 -0400
Message-Id: <1244189111-19639-24-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
References: <1244189111-19639-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Robin Getz <robin.getz@analog.com>

Add a reminder note to avoid the DMA_DONE bit in our DMA core code.

Signed-off-by: Robin Getz <robin.getz@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/kernel/bfin_dma_5xx.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/kernel/bfin_dma_5xx.c b/arch/blackfin/kernel/bfin_dma_5xx.c
index 704419e..763ed84 100644
--- a/arch/blackfin/kernel/bfin_dma_5xx.c
+++ b/arch/blackfin/kernel/bfin_dma_5xx.c
@@ -20,6 +20,11 @@
 #include <asm/dma.h>
 #include <asm/uaccess.h>
 
+/*
+ * To make sure we work around 05000119 - we always check DMA_DONE bit,
+ * never the DMA_RUN bit
+ */
+
 struct dma_channel dma_ch[MAX_DMA_CHANNELS];
 EXPORT_SYMBOL(dma_ch);
 
-- 
1.6.3.1

