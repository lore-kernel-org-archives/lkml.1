Return-Path: <linux-kernel-owner+w=401wt.eu-S1754166AbYHUBZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbYHUBZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 21:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751937AbYHUBZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 21:25:12 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:60561 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbYHUBZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 21:25:11 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] setlocalversion: dont include svn change count
Date: Wed, 20 Aug 2008 21:25:08 -0400
Message-Id: <1219281908-18829-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The number of pending changes is pretty useless, so encoding it into the
version is just annoying by the constant shuffle in corresponding modules.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 83b7512..397a04a 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -55,7 +55,7 @@ if rev=`svn info 2>/dev/null | grep '^Revision'`; then
 
 	# Are there uncommitted changes?
 	if [ $changes != 0 ]; then
-		printf -- '-svn%s%s%s' "$rev" -dirty "$changes"
+		printf -- '-svn%s%s%s' "$rev" -dirty
 	else
 		printf -- '-svn%s' "$rev"
 	fi
-- 
1.5.6.5

