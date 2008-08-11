Return-Path: <linux-kernel-owner+w=401wt.eu-S1758373AbYHKUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758373AbYHKUPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 16:15:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757390AbYHKUNY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 16:13:24 -0400
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:41180 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891AbYHKUNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 16:13:19 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 09/17] checkpatch: include/asm checks should be anchored
Date: Mon, 11 Aug 2008 21:13:04 +0100
Message-Id: <1218485592-6679-10-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.rc1.258.g80295
In-Reply-To: <1218485592-6679-1-git-send-email-apw@shadowen.org>
References: <1218485592-6679-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to have other include/asm paths within the tree which
are not subject to the do not edit checks.  Ignore those.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 482768c..0e5af8e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1134,7 +1134,7 @@ sub process {
 			$realfile = $1;
 			$realfile =~ s@^[^/]*/@@;
 
-			if ($realfile =~ m@include/asm/@) {
+			if ($realfile =~ m@^include/asm/@) {
 				ERROR("do not modify files in include/asm, change architecture specific files in include/asm-<architecture>\n" . "$here$rawline\n");
 			}
 			next;
-- 
1.6.0.rc1.258.g80295

