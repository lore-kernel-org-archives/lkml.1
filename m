Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYACR2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYACR2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbYACR1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:27:04 -0500
Received: from ns.suse.de ([195.135.220.2]:59042 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYACR1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:27:01 -0500
From: Andi Kleen <ak@suse.de>
References: <20080103626.635376000@suse.de>
In-Reply-To: <20080103626.635376000@suse.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] [4/8] GBPAGES: Add pgtable accessor functions for GB pages
Message-Id: <20080103172700.E284514DDD@wotan.suse.de>
Date: Thu,  3 Jan 2008 18:27:00 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andi Kleen <ak@suse.de>

---
 include/asm-x86/pgtable_64.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux/include/asm-x86/pgtable_64.h
===================================================================
--- linux.orig/include/asm-x86/pgtable_64.h
+++ linux/include/asm-x86/pgtable_64.h
@@ -320,6 +320,9 @@ static inline int pmd_large(pmd_t pte) {
 	return (pmd_val(pte) & __LARGE_PTE) == __LARGE_PTE; 
 } 	
 
+static inline int pud_large(pud_t pte) {
+	return (pud_val(pte) & __LARGE_PTE) == __LARGE_PTE;
+}
 
 /*
  * Conversion functions: convert a page and protection to a page entry,
