Return-Path: <linux-kernel-owner+w=401wt.eu-S1752430AbZGXD1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430AbZGXD1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 23:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752140AbZGXD1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 23:27:19 -0400
Received: from sh.osrg.net ([192.16.179.4]:45083 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812AbZGXD1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 23:27:17 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linuxppc-dev@lists.ozlabs.org
Cc: beckyb@kernel.crashing.org, galak@kernel.crashing.org,
       benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/5] add set_dma_mask hook to struct dma_map_ops
Date: Fri, 24 Jul 2009 12:24:13 +0900
Message-Id: <1248405855-15546-4-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 24 Jul 2009 12:27:11 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POWERPC needs this hook. SPARC could use it too.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 include/linux/dma-mapping.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index c0f6c3c..91b7618 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -58,6 +58,7 @@ struct dma_map_ops {
 				   enum dma_data_direction dir);
 	int (*mapping_error)(struct device *dev, dma_addr_t dma_addr);
 	int (*dma_supported)(struct device *dev, u64 mask);
+	int (*set_dma_mask)(struct device *dev, u64 mask);
 	int is_phys;
 };
 
-- 
1.6.0.6

