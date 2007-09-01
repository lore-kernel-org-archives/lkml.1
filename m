Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbXIAFzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbXIAFzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 01:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751106AbXIAFzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 01:55:46 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1808 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750937AbXIAFzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 01:55:45 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -mm] add-a-rounddown_pow_of_two-routine-to-log2h.patch fix
Date: Sat, 1 Sep 2007 07:55:36 +0200
User-Agent: KMail/1.9.7
Cc: Robert Day <rpjday@mindspring.com>, lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709010755.37838.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	This patch fixes the unbalanced parenthesis inroduced by
add-a-rounddown_pow_of_two-routine-to-log2h.patch.

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/linux/log2.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc4-mm1-a/include/linux/log2.h	2007-09-01 07:23:28.000000000 +0200
+++ linux-2.6.23-rc4-mm1-b/include/linux/log2.h	2007-09-01 07:29:27.000000000 +0200
@@ -186,7 +186,7 @@ unsigned long __rounddown_pow_of_two(uns
 (						\
 	__builtin_constant_p(n) ? (		\
 		(n == 1) ? 0 :			\
-		(1UL << ilog2(n)) :		\
+		(1UL << ilog2(n))) :		\
 	__rounddown_pow_of_two(n)		\
  )

