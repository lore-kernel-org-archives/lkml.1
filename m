Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYLTOcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYLTOcR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 09:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYLTOaO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 09:30:14 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:41315 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751920AbYLTOaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 09:30:07 -0500
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Peter Korsgaard <jacmet@sunsite.dk>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 15/26] setlocalversion: print correct subversion revision
Date: Sat, 20 Dec 2008 15:31:26 +0100
Message-Id: <1229783497-19550-15-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20081220142518.GA19390@uranus.ravnborg.org>
References: <20081220142518.GA19390@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Korsgaard <jacmet@sunsite.dk>

Output svn revision of latest change, instead of repo revision as thats
what we're interested in (especially when working on a branch/tag).

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index 72d2335..81d984b 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -51,7 +51,7 @@ if hgid=`hg id 2>/dev/null`; then
 fi
 
 # Check for svn and a svn repo.
-if rev=`svn info 2>/dev/null | grep '^Revision'`; then
+if rev=`svn info 2>/dev/null | grep '^Last Changed Rev'`; then
 	rev=`echo $rev | awk '{print $NF}'`
 	changes=`svn status 2>/dev/null | grep '^[AMD]' | wc -l`
 
-- 
1.6.0.2.GIT

