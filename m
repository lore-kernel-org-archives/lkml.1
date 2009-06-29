Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZF2ETy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZF2ETy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 00:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752309AbZF2ETj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 00:19:39 -0400
Received: from hera.kernel.org ([140.211.167.34]:48412 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754229AbZF2ETh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 00:19:37 -0400
Date: Mon, 29 Jun 2009 04:19:11 GMT
From: "tip-bot for Figo.zhang" <figo1802@gmail.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       figo1802@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       figo1802@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1246183659.2530.4.camel@myhost>
References: <1246183659.2530.4.camel@myhost>
Subject: [tip:x86/mm] x86, pgtable.h: Clean up types
Message-ID: <tip-ce0c0f9eec2f377055e8b23c6fa192202381e022@git.kernel.org>
Git-Commit-ID: ce0c0f9eec2f377055e8b23c6fa192202381e022
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 29 Jun 2009 04:19:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ce0c0f9eec2f377055e8b23c6fa192202381e022
Gitweb:     http://git.kernel.org/tip/ce0c0f9eec2f377055e8b23c6fa192202381e022
Author:     Figo.zhang <figo1802@gmail.com>
AuthorDate: Sun, 28 Jun 2009 18:07:39 +0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 29 Jun 2009 06:14:42 +0200

x86, pgtable.h: Clean up types

Use "unsigned long" consistently, not "unsigned".

Signed-off-by: Figo.zhang <figo1802@gmail.com>
LKML-Reference: <1246183659.2530.4.camel@myhost>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/include/asm/pgtable.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index af5481e..9de8729 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -356,7 +356,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  * this macro returns the index of the entry in the pmd page which would
  * control the given virtual address
  */
-static inline unsigned pmd_index(unsigned long address)
+static inline unsigned long pmd_index(unsigned long address)
 {
 	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
 }
@@ -376,7 +376,7 @@ static inline unsigned pmd_index(unsigned long address)
  * this function returns the index of the entry in the pte page which would
  * control the given virtual address
  */
-static inline unsigned pte_index(unsigned long address)
+static inline unsigned long pte_index(unsigned long address)
 {
 	return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
 }
@@ -462,7 +462,7 @@ static inline unsigned long pgd_page_vaddr(pgd_t pgd)
 #define pgd_page(pgd)		pfn_to_page(pgd_val(pgd) >> PAGE_SHIFT)
 
 /* to find an entry in a page-table-directory. */
-static inline unsigned pud_index(unsigned long address)
+static inline unsigned long pud_index(unsigned long address)
 {
 	return (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
 }
