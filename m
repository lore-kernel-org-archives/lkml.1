Return-Path: <linux-kernel-owner+w=401wt.eu-S1759035AbYA3KPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035AbYA3KPh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 05:15:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbYA3KP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 05:15:29 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:65153 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703AbYA3KP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 05:15:28 -0500
X-IronPort-AV: E=Sophos;i="4.25,276,1199682000"; 
   d="scan'208";a="47625971"
From: Bryan Wu <bryan.wu@analog.com>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, Bryan Wu <bryan.wu@analog.com>
Subject: [PATCH 1/1] [Scripts] add svn revision information to setlocalversion
Date: Wed, 30 Jan 2008 18:15:25 +0800
Message-Id: <1201688125-1387-1-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 scripts/setlocalversion |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 52f032e..2d6645c 100644
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -25,6 +25,10 @@ if head=`git rev-parse --verify HEAD 2>/dev/null`; then
 	# All done with git
 	exit
 fi
+# Check for svn and a svn repo.
+if rev=`svn info 2>/dev/null | grep '^Revision' | awk '{print $NF}'` ; then
+        printf -- '-svn%s' $rev
+fi
 
 # Check for mercurial and a mercurial repo.
 if hgid=`hg id 2>/dev/null`; then
-- 
1.5.3.4
