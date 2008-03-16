Return-Path: <linux-kernel-owner+w=401wt.eu-S1752600AbYCPJy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752600AbYCPJy0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 05:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbYCPJyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 05:54:17 -0400
Received: from web52002.mail.re2.yahoo.com ([206.190.49.249]:21850 "HELO
	web52002.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751632AbYCPJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 05:54:17 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sun, 16 Mar 2008 05:54:16 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=NY+JxW8eYBQRE3TuPtsemsQ79Tbp0FUCVclgFQgaIGhAIFdjOHIXnj+w+FPwF7iLopWDm5SV0j3VTlYy8TPID4LXWkg0JUdANI4P1jXFBuOfrrm4sT3J/WaC81qlWxBJfYajwnHuupwgS+K5yoopJZEO3y1/VPPGAsr3Hkvlxro=;
X-YMail-OSG: 1OaoqhYVM1lCHXAUvvLDNdyaQv8LSAC8apzHUt9jmYzGyKNPN7281yXtaR11UOwTwz0wjwtTJ9JP.4iTfXDwY5aUMxrSdGPUMT.7UzBA6SwIiA4vYUs-
X-Mailer: YahooMailRC/902.38 YahooMailWebService/0.7.162
Date: Sun, 16 Mar 2008 02:47:35 -0700 (PDT)
From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
Subject: [patch] sync_bitops: fix wrong comments [Bug 10247]
To: linux-kernel@vger.kernel.org
Cc: bugme-daemon@kernel-bugs.osdl.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <681011.80694.qm@web52002.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori mattilinnanvuori@yahoo.com

Fix wrong function name and references to non-x86 architectures.

Signed-off-by: Matti Linnanvuori mattilinnanvuori@yahoo.com

---

--- a/include/asm-x86/sync_bitops.h 2008-03-16 11:34:59.934699500 +0200
+++ b/include/asm-x86/sync_bitops.h 2008-03-16 11:36:35.866059500 +0200
@@ -23,10 +23,6 @@
  * This function is atomic and may not be reordered.  See __set_bit()
  * if you do not require the atomic guarantees.
  *
- * Note: there are no guarantees that this function will not be reordered
- * on non-x86 architectures, so if you are writing portable code,
- * make sure not to rely on its reordering guarantees.
- *
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
@@ -61,8 +57,7 @@ static inline void sync_clear_bit(int nr
  * @nr: Bit to change
  * @addr: Address to start counting from
  *
- * change_bit() is atomic and may not be reordered. It may be
- * reordered on other architectures than x86.
+ * sync_change_bit() is atomic and may not be reordered.
  * Note that @nr may be almost arbitrarily large; this function is not
  * restricted to acting on a single-word quantity.
  */
@@ -80,7 +75,6 @@ static inline void sync_change_bit(int n
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
- * It may be reordered on other architectures than x86.
  * It also implies a memory barrier.
  */
 static inline int sync_test_and_set_bit(int nr, volatile unsigned long * addr)
@@ -99,7 +93,6 @@ static inline int sync_test_and_set_bit(
  * @addr: Address to count from
  *
  * This operation is atomic and cannot be reordered.
- * It can be reorderdered on other architectures other than x86.
  * It also implies a memory barrier.
  */
 static inline int sync_test_and_clear_bit(int nr, volatile unsigned long * addr)


---


      ____________________________________________________________________________________
Looking for last minute shopping deals?  
Find them fast with Yahoo! Search.  http://tools.search.yahoo.com/newsearch/category.php?category=shopping
