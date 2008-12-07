Return-Path: <linux-kernel-owner+w=401wt.eu-S1755655AbYLGSdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655AbYLGSdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 13:33:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbYLGSbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 13:31:06 -0500
Received: from bigben2.bytemark.co.uk ([80.68.81.132]:55710 "EHLO
	bigben2.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbYLGSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 13:31:04 -0500
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andy Whitcroft <apw@shadowen.org>
Subject: [PATCH 06/13] checkpatch: loosen spacing on typedef function checks
Date: Sun,  7 Dec 2008 18:30:43 +0000
Message-Id: <1228674650-24392-7-git-send-email-apw@shadowen.org>
X-Mailer: git-send-email 1.6.0.4.911.gc990
In-Reply-To: <1228674650-24392-1-git-send-email-apw@shadowen.org>
References: <1228674650-24392-1-git-send-email-apw@shadowen.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Loosen spacing checks to correctly detect this valid use of a typedef:

	typedef struct rcu_data *(*get_data_func)(int);

Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 705a043..d80b55a 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1618,7 +1618,7 @@ sub process {
 # check for new typedefs, only function parameters and sparse annotations
 # make sense.
 		if ($line =~ /\btypedef\s/ &&
-		    $line !~ /\btypedef\s+$Type\s+\(\s*\*?$Ident\s*\)\s*\(/ &&
+		    $line !~ /\btypedef\s+$Type\s*\(\s*\*?$Ident\s*\)\s*\(/ &&
 		    $line !~ /\btypedef\s+$Type\s+$Ident\s*\(/ &&
 		    $line !~ /\b$typeTypedefs\b/ &&
 		    $line !~ /\b__bitwise(?:__|)\b/) {
-- 
1.6.0.4.911.gc990

