Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbYD3KrD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbYD3KrD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 06:47:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbYD3Kqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 06:46:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33239 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754610AbYD3Kqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 06:46:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1209514311.24729.34.camel@brick>
References: <1209514311.24729.34.camel@brick> <20080429235740.GC15987@cs181133002.pp.htv.fi>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: dhowells@redhat.com, Adrian Bunk <bunk@kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix arch/frv/mm/unaligned.o build error
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Wed, 30 Apr 2008 11:40:01 +0100
Message-ID: <20699.1209552001@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please use this patch instead.  I believe I sent it to you previously.

David
---
[PATCH] FRV: Unbreak misalignment handling changes

From: David Howells <dhowells@redhat.com>

Fix a reference in a arch/frv/mm/Makefile to unaligned.c which has now been
deleted.

Also revert the change to the guard macro name in include/asm-frv/unaligned.h.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mm/Makefile        |    2 +-
 include/asm-frv/unaligned.h |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)


diff --git a/arch/frv/mm/Makefile b/arch/frv/mm/Makefile
index fb8b1d8..1bca5ab 100644
--- a/arch/frv/mm/Makefile
+++ b/arch/frv/mm/Makefile
@@ -6,4 +6,4 @@ obj-y := init.o kmap.o
 
 obj-$(CONFIG_MMU) += \
 	pgalloc.o highmem.o fault.o extable.o cache-page.o tlb-flush.o tlb-miss.o \
-	mmu-context.o dma-alloc.o unaligned.o elf-fdpic.o
+	mmu-context.o dma-alloc.o elf-fdpic.o
diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
index 64ccc73..839a2fb 100644
--- a/include/asm-frv/unaligned.h
+++ b/include/asm-frv/unaligned.h
@@ -9,8 +9,8 @@
  * 2 of the License, or (at your option) any later version.
  */
 
-#ifndef _ASM_FRV_UNALIGNED_H
-#define _ASM_FRV_UNALIGNED_H
+#ifndef _ASM_UNALIGNED_H
+#define _ASM_UNALIGNED_H
 
 #include <linux/unaligned/le_byteshift.h>
 #include <linux/unaligned/be_byteshift.h>
@@ -19,4 +19,4 @@
 #define get_unaligned	__get_unaligned_be
 #define put_unaligned	__put_unaligned_be
 
-#endif /* _ASM_FRV_UNALIGNED_H */
+#endif /* _ASM_UNALIGNED_H */
