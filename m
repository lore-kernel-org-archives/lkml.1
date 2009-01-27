Return-Path: <linux-kernel-owner+w=401wt.eu-S1756535AbZA0U3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535AbZA0U3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 15:29:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbZA0U3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 15:29:16 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51783 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbZA0U3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 15:29:15 -0500
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: [PATCH] struct linux_binprm: drop unused fields
Date: Tue, 27 Jan 2009 22:32:40 +0200
Message-Id: <1233088360-20929-1-git-send-email-kirill@shutemov.name>
X-Mailer: git-send-email 1.6.0.2.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
---
 include/linux/binfmts.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 77b4a9e..6638b81 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -35,8 +35,7 @@ struct linux_binprm{
 #endif
 	struct mm_struct *mm;
 	unsigned long p; /* current top of mem */
-	unsigned int sh_bang:1,
-		misc_bang:1,
+	unsigned int
 		cred_prepared:1,/* true if creds already prepared (multiple
 				 * preps happen for interpreters) */
 		cap_effective:1;/* true if has elevated effective capabilities,
-- 
1.6.0.2.GIT

