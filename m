Return-Path: <linux-kernel-owner+w=401wt.eu-S1760614AbYFLM2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760614AbYFLM2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 08:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbYFLM2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 08:28:25 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4178 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433AbYFLM2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 08:28:24 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 21/23] checkpatch: handle return types of pointers to functions
Date: Thu, 12 Jun 2008 13:06:00 +0100
Message-Id: <1213272362-19457-22-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.5.6.rc0.140.ga9675
In-Reply-To: <1213272362-19457-1-git-send-email-apw@shadowen.org>
References: <1213272362-19457-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure we correctly mark the return type of the pointer to a function
declaration.

    const void *(*sb_tag)(struct sysfs_tag_info *info);

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 775f2b1..6d07b67 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -715,7 +715,7 @@ sub annotate_values {
 				$av_preprocessor = 0;
 			}
 
-		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\))/) {
+		} elsif ($cur =~ /^($Type)\s*(?:$Ident|,|\)|\()/) {
 			print "DECLARE($1)\n" if ($dbg_values > 1);
 			$type = 'T';
 
-- 
1.5.6.rc0.140.ga9675

