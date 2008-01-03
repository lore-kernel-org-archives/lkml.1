Return-Path: <linux-kernel-owner+w=401wt.eu-S1753920AbYACPY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920AbYACPY4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 10:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYACPYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 10:24:20 -0500
Received: from ns2.suse.de ([195.135.220.15]:43011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYACPYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 10:24:19 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103424.989432000@suse.de>
In-Reply-To: <20080103424.989432000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH CPA] [4/28] Add pte_clrhuge on i386
Message-Id: <20080103152418.3B54814E23@wotan.suse.de>
Date: Thu,  3 Jan 2008 16:24:18 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


64bit had it already

Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable_32.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux/include/asm-x86/pgtable_32.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_32.h
+++ linux/include/asm-x86/pgtable_32.h
@@ -234,6 +234,7 @@ static inline pte_t pte_mkdirty(pte_t pt
 static inline pte_t pte_mkyoung(pte_t pte)	{ (pte).pte_low |= _PAGE_ACCESSED; return pte; }
 static inline pte_t pte_mkwrite(pte_t pte)	{ (pte).pte_low |= _PAGE_RW; return pte; }
 static inline pte_t pte_mkhuge(pte_t pte)	{ (pte).pte_low |= _PAGE_PSE; return pte; }
+static inline pte_t pte_clrhuge(pte_t pte)	{ (pte).pte_low &= ~_PAGE_PSE; return pte; }
 static inline pte_t pte_mkglobal(pte_t pte)	{ (pte).pte_low |= _PAGE_GLOBAL; return pte; }
 static inline pte_t pte_clrglobal(pte_t pte)	{ (pte).pte_low &= ~_PAGE_GLOBAL; return pte; }
 
