Return-Path: <linux-kernel-owner+w=401wt.eu-S1761823AbXGaXZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761823AbXGaXZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 19:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbXGaXZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 19:25:16 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:53898 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754105AbXGaXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 19:25:13 -0400
From: Christoph Lameter <clameter@sgi.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 4/7] Simple Performance Counters: IA64 support
Date: Tue, 31 Jul 2007 16:25:09 -0700
Message-Id: <11859243122176-git-send-email-clameter@sgi.com>
X-Mailer: git-send-email 1.5.2.4
In-Reply-To: simple-perf-counters
References: simple-perf-counters
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Provide a cycles_to_ns function

Signed-off-by: Christoph Lameter <clameter@sgi.com>
---
 include/asm-ia64/timex.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/include/asm-ia64/timex.h b/include/asm-ia64/timex.h
index 05a6baf..60a1eeb 100644
--- a/include/asm-ia64/timex.h
+++ b/include/asm-ia64/timex.h
@@ -39,4 +39,7 @@ get_cycles (void)
 	return ret;
 }
 
+#define cycles_to_ns(x) (((x) * local_cpu_data->nsec_per_cyc) \
+					>> IA64_NSEC_PER_CYC_SHIFT)
+
 #endif /* _ASM_IA64_TIMEX_H */
-- 
1.5.2.4

