Return-Path: <linux-kernel-owner+w=401wt.eu-S1756442AbZJBWle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442AbZJBWle (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 18:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755219AbZJBWld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 18:41:33 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54595 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755025AbZJBWlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 18:41:32 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 67.160.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19dWUYyE5gCBplffnl6S/vY
Subject: [PATCH 4/8] omap: iovmm: Fix incorrect spelling
To: linux-arm-kernel@lists.infradead.org
From: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 02 Oct 2009 15:41:33 -0700
Message-ID: <20091002224133.11962.84509.stgit@localhost>
In-Reply-To: <20091002223510.11962.21751.stgit@localhost>
References: <20091002223510.11962.21751.stgit@localhost>
User-Agent: StGit/0.14.3.347.g594a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

Fix incorrect spelling

Signed-off-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/plat-omap/iovmm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 57f7122..0e5573d 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -47,7 +47,7 @@
  *	'va':	mpu virtual address
  *
  *	'c':	contiguous memory area
- *	'd':	dicontiguous memory area
+ *	'd':	discontiguous memory area
  *	'a':	anonymous memory allocation
  *	'()':	optional feature
  *
@@ -398,7 +398,7 @@ static inline void sgtable_drain_vmalloc(struct sg_table *sgt)
 {
 	/*
 	 * Actually this is not necessary at all, just exists for
-	 * consistency of the code readibility.
+	 * consistency of the code readability.
 	 */
 	BUG_ON(!sgt);
 }
@@ -434,7 +434,7 @@ static inline void sgtable_drain_kmalloc(struct sg_table *sgt)
 {
 	/*
 	 * Actually this is not necessary at all, just exists for
-	 * consistency of the code readibility
+	 * consistency of the code readability
 	 */
 	BUG_ON(!sgt);
 }

