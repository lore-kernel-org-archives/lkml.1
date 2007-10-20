Return-Path: <linux-kernel-owner+w=401wt.eu-S965818AbXJTBXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965818AbXJTBXW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 21:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbXJTBXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 21:23:07 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:35535 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281AbXJTBXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 21:23:06 -0400
Message-ID: <47195876.7080208@ct.jp.nec.com>
Date: Fri, 19 Oct 2007 18:23:02 -0700
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: vgoyal@in.ibm.com, hbabu@us.ibm.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: [PATCH 2/3] x86: add safe_smp_processor_id for x86_64
References: <47195763.1090803@ct.jp.nec.com>
In-Reply-To: <47195763.1090803@ct.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>

Signed-off-by: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
---
 include/asm-x86/smp_64.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/smp_64.h b/include/asm-x86/smp_64.h
index 6f0e027..ab612b0 100644
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -76,6 +76,8 @@ extern unsigned __cpuinitdata disabled_cpus;
 
 #endif /* CONFIG_SMP */
 
+#define safe_smp_processor_id()		smp_processor_id()
+
 static inline int hard_smp_processor_id(void)
 {
 	/* we don't want to mark this access volatile - bad code generation */
-- 
1.5.2.3
