Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbYGNWY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbYGNWY2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 18:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755460AbYGNWYR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 18:24:17 -0400
Received: from nat13.teradata.com ([153.65.16.13]:12814 "EHLO
	rpc7149.teradata.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755325AbYGNWYQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 18:24:16 -0400
X-Greylist: delayed 595 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 18:24:15 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [patch] include/linux/jiffies.h: correcting small comment typo
Date: Mon, 14 Jul 2008 18:14:18 -0400
Message-ID: <C903E2B04DDD1E4C9811DA2FE78FE52D03D8B019@susday7659.TD.teradata.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] include/linux/jiffies.h: correcting small comment typo
Thread-Index: Acjl/vVqzW6RNlSkRO2m+spc0KCA5g==
From: "Landis, Mark" <Mark.Landis@Teradata.com>
To: <linux-kernel@vger.kernel.org>
X-imss-version: 2.051
X-imss-result: Passed
X-imss-scanInfo: M:P L:E SM:0
X-imss-tmaseResult: TT:0 TS:0.0000 TC:00 TRN:0 TV:5.5.1026(16032.002)
X-imss-scores: Clean:99.90000 C:2 M:3 S:5 R:5
X-imss-settings: Baseline:1 C:1 M:1 S:1 R:1 (0.0000 0.0000)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixing a very small typo in comments.

Signed-off-by: Mark Landis <mark.landis@teradata.com>
---
 include/linux/jiffies.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index abb6ac6..69d0f51 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -42,7 +42,7 @@
 /* LATCH is used in the interval timer and ftape setup. */
 #define LATCH  ((CLOCK_TICK_RATE + HZ/2) / HZ) /* For divider */

-/* Suppose we want to devide two numbers NOM and DEN: NOM/DEN, then we
can
+/* Suppose we want to divide two numbers NOM and DEN: NOM/DEN, then we
can
  * improve accuracy by shifting LSH bits, hence calculating:
  *     (NOM << LSH) / DEN
  * This however means trouble for large NOM, because (NOM << LSH) may
no
--
1.5.6.2
