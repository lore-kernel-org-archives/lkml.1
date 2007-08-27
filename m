Return-Path: <linux-kernel-owner+w=401wt.eu-S1763553AbXH0Vee@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763553AbXH0Vee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 17:34:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765318AbXH0V2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 17:28:22 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:58827 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764375AbXH0V2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 17:28:19 -0400
Date: Mon, 27 Aug 2007 23:28:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: pazke@donpac.ru, linux-visws-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: [2.6 patch] i386 visws: "extern inline" -> "static inline"
Message-ID: <20070827212819.GW4121@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"extern inline" will have different semantics with gcc 4.3.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 14 Aug 2007

 include/asm-i386/mach-visws/cobalt.h  |    8 ++++----
 include/asm-i386/mach-visws/lithium.h |    8 ++++----
 2 files changed, 8 insertions(+), 8 deletions(-)

e12d2e797af72524f53a0ef3a7dd3cf91f58c542 
diff --git a/include/asm-i386/mach-visws/cobalt.h b/include/asm-i386/mach-visws/cobalt.h
index 33c3622..9952588 100644
--- a/include/asm-i386/mach-visws/cobalt.h
+++ b/include/asm-i386/mach-visws/cobalt.h
@@ -94,22 +94,22 @@
 #define	CO_IRQ_8259	CO_IRQ(CO_APIC_8259)
 
 #ifdef CONFIG_X86_VISWS_APIC
-extern __inline void co_cpu_write(unsigned long reg, unsigned long v)
+static inline void co_cpu_write(unsigned long reg, unsigned long v)
 {
 	*((volatile unsigned long *)(CO_CPU_VADDR+reg))=v;
 }
 
-extern __inline unsigned long co_cpu_read(unsigned long reg)
+static inline unsigned long co_cpu_read(unsigned long reg)
 {
 	return *((volatile unsigned long *)(CO_CPU_VADDR+reg));
 }            
              
-extern __inline void co_apic_write(unsigned long reg, unsigned long v)
+static inline void co_apic_write(unsigned long reg, unsigned long v)
 {
 	*((volatile unsigned long *)(CO_APIC_VADDR+reg))=v;
 }            
              
-extern __inline unsigned long co_apic_read(unsigned long reg)
+static inline unsigned long co_apic_read(unsigned long reg)
 {
 	return *((volatile unsigned long *)(CO_APIC_VADDR+reg));
 }
diff --git a/include/asm-i386/mach-visws/lithium.h b/include/asm-i386/mach-visws/lithium.h
index d443e68..dfcd4f0 100644
--- a/include/asm-i386/mach-visws/lithium.h
+++ b/include/asm-i386/mach-visws/lithium.h
@@ -29,22 +29,22 @@
 #define	LI_INTD		0x0080
 
 /* More special purpose macros... */
-extern __inline void li_pcia_write16(unsigned long reg, unsigned short v)
+static inline void li_pcia_write16(unsigned long reg, unsigned short v)
 {
 	*((volatile unsigned short *)(LI_PCIA_VADDR+reg))=v;
 }
 
-extern __inline unsigned short li_pcia_read16(unsigned long reg)
+static inline unsigned short li_pcia_read16(unsigned long reg)
 {
 	 return *((volatile unsigned short *)(LI_PCIA_VADDR+reg));
 }
 
-extern __inline void li_pcib_write16(unsigned long reg, unsigned short v)
+static inline void li_pcib_write16(unsigned long reg, unsigned short v)
 {
 	*((volatile unsigned short *)(LI_PCIB_VADDR+reg))=v;
 }
 
-extern __inline unsigned short li_pcib_read16(unsigned long reg)
+static inline unsigned short li_pcib_read16(unsigned long reg)
 {
 	return *((volatile unsigned short *)(LI_PCIB_VADDR+reg));
 }

