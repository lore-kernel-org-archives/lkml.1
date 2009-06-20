Return-Path: <linux-kernel-owner+w=401wt.eu-S1755544AbZFTUqI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544AbZFTUqI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 16:46:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZFTUp4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 16:45:56 -0400
Received: from hera.kernel.org ([140.211.167.34]:50748 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753360AbZFTUp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 16:45:56 -0400
Subject: [PATCH -tip RESEND] x86: asm/types.h remove irrelevant comment for
 userspace
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <1245347192.2481.15.camel@ht.satnam>
References: <1245314365.31204.7.camel@ht.satnam>
	 <1245346986.2481.10.camel@ht.satnam>  <1245347082.2481.12.camel@ht.satnam>
	 <1245347118.2481.13.camel@ht.satnam>  <1245347157.2481.14.camel@ht.satnam>
	 <1245347192.2481.15.camel@ht.satnam>
Content-Type: text/plain
Date: Sun, 21 Jun 2009 02:16:48 +0530
Message-Id: <1245530808.2459.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


following comment is irrelevant at usr/include/asm/types.h :

"These aren't exported outside the kernel to avoid name space clashes"

Also fixed some spacing issues in usr/include/asm/types.h

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/types.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/types.h b/arch/x86/include/asm/types.h
index 09b9774..bebc9f3 100644
--- a/arch/x86/include/asm/types.h
+++ b/arch/x86/include/asm/types.h
@@ -9,10 +9,10 @@ typedef unsigned short umode_t;
 
 #endif /* __ASSEMBLY__ */
 
+#ifdef __KERNEL__
 /*
  * These aren't exported outside the kernel to avoid name space clashes
  */
-#ifdef __KERNEL__
 
 #ifndef __ASSEMBLY__
 
@@ -26,5 +26,4 @@ typedef u32 dma_addr_t;
 
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
-
 #endif /* _ASM_X86_TYPES_H */
-- 
1.6.0.6



