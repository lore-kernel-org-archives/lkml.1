Return-Path: <linux-kernel-owner+w=401wt.eu-S1760339AbYDWKBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760339AbYDWKBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 06:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbYDWJxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 05:53:21 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:36992 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755303AbYDWJxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 05:53:20 -0400
Date: Wed, 23 Apr 2008 12:52:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: make struct nommu_dma_ops static
Message-ID: <20080423095240.GM28933@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct nommu_dma_ops static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d9446cb290ebca8105db4ec4fad27177a48898a5 diff --git a/arch/x86/kernel/pci-nommu.c b/arch/x86/kernel/pci-nommu.c
index aec43d5..7699d8d 100644
--- a/arch/x86/kernel/pci-nommu.c
+++ b/arch/x86/kernel/pci-nommu.c
@@ -83,7 +83,7 @@ static int nommu_mapping_error(dma_addr_t dma_addr)
 }
 
 
-const struct dma_mapping_ops nommu_dma_ops = {
+static const struct dma_mapping_ops nommu_dma_ops = {
 	.map_single = nommu_map_single,
 	.map_sg = nommu_map_sg,
 	.mapping_error = nommu_mapping_error,

