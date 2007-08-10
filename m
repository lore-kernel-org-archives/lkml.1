Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbXHJB5n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbXHJB5n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 21:57:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759555AbXHJB5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 21:57:35 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44586 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757989AbXHJB5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 21:57:34 -0400
Subject: [PATCH] Fix typo in arch/i386/kernel/tsc.c
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, johnstul@us.ibm.com
Content-Type: text/plain
Date: Thu, 09 Aug 2007 18:58:09 -0700
Message-Id: <1186711089.6899.29.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Triplett <josh@kernel.org>
---
 arch/i386/kernel/tsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/i386/kernel/tsc.c b/arch/i386/kernel/tsc.c
index debd7db..8a58d30 100644
--- a/arch/i386/kernel/tsc.c
+++ b/arch/i386/kernel/tsc.c
@@ -80,7 +80,7 @@ EXPORT_SYMBOL_GPL(check_tsc_unstable);
  *	And since SC is a constant power of two, we can convert the div
  *  into a shift.
  *
- *  We can use khz divisor instead of mhz to keep a better percision, since
+ *  We can use khz divisor instead of mhz to keep a better precision, since
  *  cyc2ns_scale is limited to 10^6 * 2^10, which fits in 32 bits.
  *  (mathieu.desnoyers@polymtl.ca)
  *
-- 
1.5.2.1


