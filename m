Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbXKOWfS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbXKOWfS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 17:35:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933979AbXKOWez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 17:34:55 -0500
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3710 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893AbXKOWey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 17:34:54 -0500
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Andrew Morton <akpm@linux-foundation.org>, grundler@parisc-linux.org,
       kyle@parisc-linux.org
Subject: [PATCH] parisc: balance parenthesis in pte_free_kernel()
Date: Thu, 15 Nov 2007 23:34:27 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, parisc-linux@parisc-linux.org
References: <20071113175906.497a1a6a.akpm@linux-foundation.org>
In-Reply-To: <20071113175906.497a1a6a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711152334.28517.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

	Another parenthesis fix.

Regards,

	Mariusz


Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 include/asm-parisc/pgalloc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc2-mm1-a/include/asm-parisc/pgalloc.h	2007-11-15 11:36:44.000000000 +0100
+++ linux-2.6.24-rc2-mm1-b/include/asm-parisc/pgalloc.h	2007-11-15 11:37:17.000000000 +0100
@@ -141,7 +141,7 @@ static inline void pte_free_kernel(struc
 static inline void pte_free_kernel(struct mm_struct *mm, struct page *pte)
 {
 	pgtable_page_dtor(pte);
-	pte_free_kernel(page_address((pte));
+	pte_free_kernel(page_address(pte));
 }

 #define check_pgt_cache()	do { } while (0)
