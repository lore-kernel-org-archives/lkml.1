Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbYDHOzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbYDHOzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756070AbYDHOzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:55:32 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54396 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756071AbYDHOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:55:31 -0400
From: Jan Engelhardt <jengelh@computergmbh.de>
To: apw@shadowen.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] checkpatch: nested structs
Date: Tue,  8 Apr 2008 16:55:30 +0200
Message-Id: <282cb105d4016d63a4c24442e244d157ef3aebe8.1207666528.git.jengelh@computergmbh.de>
X-Mailer: git-send-email 1.5.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required for nested struct/union compounds.
---
 scripts/checkpatch.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 58a9494..cf78e86 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1582,7 +1582,7 @@ sub process {
 
 # closing brace should have a space following it when it has anything
 # on the line
-		if ($line =~ /}(?!(?:,|;|\)))\S/) {
+		if ($line =~ /}+(?!(?:,|;|\)))\S/) {
 			ERROR("space required after that close brace '}'\n" . $herecurr);
 		}
 
-- 
1.5.5.rc3

