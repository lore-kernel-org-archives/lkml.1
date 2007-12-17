Return-Path: <linux-kernel-owner+w=401wt.eu-S932100AbXLQPmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932100AbXLQPmW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 10:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756030AbXLQPmN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 10:42:13 -0500
Received: from mtagate8.de.ibm.com ([195.212.29.157]:28692 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103AbXLQPmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 10:42:12 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Mon, 17 Dec 2007 16:42:09 +0100
Message-Id: <1197906130.7955.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 include/asm-s390/pgtable.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

Martin Schwidefsky (1):
      [S390] pud_present/pmd_present bug.

diff --git a/include/asm-s390/pgtable.h b/include/asm-s390/pgtable.h
index f2cc25b..1f530f8 100644
--- a/include/asm-s390/pgtable.h
+++ b/include/asm-s390/pgtable.h
@@ -453,12 +453,12 @@ static inline int pgd_bad(pgd_t pgd)	 { return 0; }
 
 static inline int pud_present(pud_t pud)
 {
-	return pud_val(pud) & _REGION_ENTRY_ORIGIN;
+	return (pud_val(pud) & _REGION_ENTRY_ORIGIN) != 0UL;
 }
 
 static inline int pud_none(pud_t pud)
 {
-	return pud_val(pud) & _REGION_ENTRY_INV;
+	return (pud_val(pud) & _REGION_ENTRY_INV) != 0UL;
 }
 
 static inline int pud_bad(pud_t pud)
@@ -471,12 +471,12 @@ static inline int pud_bad(pud_t pud)
 
 static inline int pmd_present(pmd_t pmd)
 {
-	return pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN;
+	return (pmd_val(pmd) & _SEGMENT_ENTRY_ORIGIN) != 0UL;
 }
 
 static inline int pmd_none(pmd_t pmd)
 {
-	return pmd_val(pmd) & _SEGMENT_ENTRY_INV;
+	return (pmd_val(pmd) & _SEGMENT_ENTRY_INV) != 0UL;
 }
 
 static inline int pmd_bad(pmd_t pmd)


