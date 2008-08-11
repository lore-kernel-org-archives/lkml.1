Return-Path: <linux-kernel-owner+w=401wt.eu-S1757841AbYHKUNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841AbYHKUNp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbYHKUNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:20 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41159 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753263AbYHKUNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:18 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 06/17] checkpatch: ____cacheline_aligned et al are modifiers
Date: Mon, 11 Aug 2008 21:13:01 +0100
Message-Id: <1218485592-6679-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the cacheline alignment modifiers to the attribute lists.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 1c032b1..303c363 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -113,7 +113,10 @@ our $Attribute	= qr{
 			const|
 			__read_mostly|
 			__kprobes|
-			__(?:mem|cpu|dev|)(?:initdata|init)
+			__(?:mem|cpu|dev|)(?:initdata|init)|
+			____cacheline_aligned|
+			____cacheline_aligned_in_smp|
+			____cacheline_internodealigned_in_smp
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline};
-- 
1.6.0.rc1.258.g80295

