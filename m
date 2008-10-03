Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbYJCPvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbYJCPvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 11:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbYJCPuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 11:50:44 -0400
Received: from tallyho.bytemark.co.uk ([80.68.81.166]:58074 "EHLO
	tallyho.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659AbYJCPum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 11:50:42 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 12/13] checkpatch: allow for comments either side of a brace on case
Date: Fri,  3 Oct 2008 16:25:53 +0100
Message-Id: <1223047554-31111-13-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.1.451.gc8d31
In-Reply-To: <1223047554-31111-1-git-send-email-apw@shadowen.org>
References: <1223047554-31111-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When specifying case we may have comments and/or braces at the end without
actually having a 'statement'.  Allow for these to occur in any order.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 862e8e0..ada27c4 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2043,7 +2043,7 @@ sub process {
 # case and default should not have general statements after them
 		if ($line =~ /^.\s*(?:case\s*.*|default\s*):/g &&
 		    $line !~ /\G(?:
-			(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
+			(?:\s*$;*)(?:\s*{)?(?:\s*$;*)(?:\s*\\)?\s*$|
 			\s*return\s+
 		    )/xg)
 		{
-- 
1.6.0.1.451.gc8d31

