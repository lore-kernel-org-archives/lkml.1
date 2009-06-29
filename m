Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZF2CXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZF2CXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 22:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751699AbZF2CW4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 22:22:56 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:31628 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZF2CWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 22:22:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=l+PYUuXJEf71GEjcOxQl6WBmBmx0n/krzmXmd7LSXKdE47NgA64PVC9wpge2hCLHtW
         p0kwsykjcDS1Wv3g/lMUm/qxkPXG4ptFLIEID1MOLuJWDK9L3Bc0FdhkPEtaghgDNkMP
         tN1zOT1f9a+pOA+TA4AhI8sgktvERYMbkcTak=
Subject: [PATCH]highmem_32.c : clean up comment
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@osdl.org>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 29 Jun 2009 10:22:53 +0800
Message-Id: <1246242173.2561.8.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up comment.

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/mm/highmem_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
index 58f621e..d20af06 100644
--- a/arch/x86/mm/highmem_32.c
+++ b/arch/x86/mm/highmem_32.c
@@ -24,7 +24,7 @@ void kunmap(struct page *page)
  * no global lock is needed and because the kmap code must perform a global TLB
  * invalidation when the kmap pool wraps.
  *
- * However when holding an atomic kmap is is not legal to sleep, so atomic
+ * However when holding an atomic kmap is not legal to sleep, so atomic
  * kmaps are appropriate for short, tight code paths only.
  */
 void *kmap_atomic_prot(struct page *page, enum km_type type, pgprot_t prot)


