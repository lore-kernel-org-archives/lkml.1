Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZF1KHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZF1KHs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 06:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbZF1KHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 06:07:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:30944 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbZF1KHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 06:07:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=rLRRxfhdHbIxbGnxs4xjor0OBLZT0U54q5QJ5OPGka+eQwzxRoaOkHi1AY6MEjp/UL
         4oZ6+XD3/xKhOtiYUVIER2pMWbUNyxC+6mOvCS016OVS0R54RsAX1+OirTWBnYjpeTCl
         o/t2rhGytGfljwMoIBKKjNhWLXZCU/HYmB5C0=
Subject: [PATCH] pgtable.h : clean up
From: "Figo.zhang" <figo1802@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 28 Jun 2009 18:07:39 +0800
Message-Id: <1246183659.2530.4.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

it had better use "unsinged long" than "unsigned"

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---  
arch/x86/include/asm/pgtable.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3cc06e3..f38458b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -351,7 +351,7 @@ static inline unsigned long pmd_page_vaddr(pmd_t pmd)
  * this macro returns the index of the entry in the pmd page which would
  * control the given virtual address
  */
-static inline unsigned pmd_index(unsigned long address)
+static inline unsigned long pmd_index(unsigned long address)
 {
 	return (address >> PMD_SHIFT) & (PTRS_PER_PMD - 1);
 }
@@ -371,7 +371,7 @@ static inline unsigned pmd_index(unsigned long address)
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


