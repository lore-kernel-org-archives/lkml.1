Return-Path: <linux-kernel-owner+w=401wt.eu-S1756203AbYCRBKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756203AbYCRBKl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:10:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYCRBJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:09:46 -0400
Received: from smtp-out03.alice-dsl.net ([88.44.63.5]:38123 "EHLO
	smtp-out03.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYCRBJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:09:37 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20080318209.039112899@firstfloor.org>
In-Reply-To: <20080318209.039112899@firstfloor.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH prototype] [1/8] Give ELF shdr types a name
Message-Id: <20080318010935.4467B1B41E1@basil.firstfloor.org>
Date: Tue, 18 Mar 2008 02:09:35 +0100 (CET)
X-OriginalArrivalTime: 18 Mar 2008 01:03:00.0596 (UTC) FILETIME=[CFAEAB40:01C88893]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The pbitmap code is the first code in Linux to know
about ELF shdrs. They were already in the include files, but
not given a suitable type name. Fix that.

Signed-off-by: Andi Kleen <andi@firstfloor.org>

---
 include/linux/elf.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/include/linux/elf.h
===================================================================
--- linux.orig/include/linux/elf.h
+++ linux/include/linux/elf.h
@@ -286,7 +286,7 @@ typedef struct elf64_phdr {
 #define SHN_COMMON	0xfff2
 #define SHN_HIRESERVE	0xffff
  
-typedef struct {
+typedef struct elf32_shdr {
   Elf32_Word	sh_name;
   Elf32_Word	sh_type;
   Elf32_Word	sh_flags;
@@ -382,6 +382,7 @@ extern Elf32_Dyn _DYNAMIC [];
 #define elf_phdr	elf32_phdr
 #define elf_note	elf32_note
 #define elf_addr_t	Elf32_Off
+#define elf_shdr	elf32_shdr
 
 #else
 
@@ -390,6 +391,7 @@ extern Elf64_Dyn _DYNAMIC [];
 #define elf_phdr	elf64_phdr
 #define elf_note	elf64_note
 #define elf_addr_t	Elf64_Off
+#define elf_shdr	elf64_shdr
 
 #endif
 
