Return-Path: <linux-kernel-owner+w=401wt.eu-S1759932AbZBYErT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932AbZBYErT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 23:47:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756221AbZBYErA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 23:47:00 -0500
Received: from g1t0029.austin.hp.com ([15.216.28.36]:21213 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZBYErA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 23:47:00 -0500
Date: Tue, 24 Feb 2009 20:49:03 -0800 (PST)
From: Justin Chen <jchen@hpdst41.cup.hp.com>
Message-Id: <200902250449.UAA12761@hpdst41.cup.hp.com>
To: linux-arch@vger.kernel.org
Subject: [PATCH 05/15] bitops: Change the bitmap index from int to unsigned long [cris]
Cc: bjorn.helgaas@hp.com, jesper.nilsson@axis.com, justin.chen@hp.com,
       linux-kernel@vger.kernel.org, starvik@axis.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the index to unsigned long in all bitops for [cris]

Signed-off-by: Justin Chen <justin.chen@hp.com>
Reviewed-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---
 arch/cris/include/asm/bitops.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)
diff -Nru a/arch/cris/include/asm/bitops.h b/arch/cris/include/asm/bitops.h
--- a/arch/cris/include/asm/bitops.h	2009-02-13 15:31:30.000000000 -0800
+++ b/arch/cris/include/asm/bitops.h	2009-02-15 18:19:39.771556647 -0800
@@ -70,7 +70,8 @@
  * It also implies a memory barrier.
  */
 
-static inline int test_and_set_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_set_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned int mask, retval;
 	unsigned long flags;
@@ -100,7 +101,8 @@
  * It also implies a memory barrier.
  */
 
-static inline int test_and_clear_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_clear_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned int mask, retval;
 	unsigned long flags;
@@ -124,7 +126,8 @@
  * It also implies a memory barrier.
  */
 
-static inline int test_and_change_bit(int nr, volatile unsigned long *addr)
+static inline int
+test_and_change_bit(unsigned long nr, volatile unsigned long *addr)
 {
 	unsigned int mask, retval;
 	unsigned long flags;
