Return-Path: <linux-kernel-owner+w=401wt.eu-S1761667AbZCZU6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761667AbZCZU6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 16:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756432AbZCZU6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 16:58:12 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:32994 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZCZU6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 16:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ugP2Z1L5/lx7uPPH00oSSnwci+JUQIuRUSIUwx0DQhWRGt1nzz0Ud/jTSUzu5AiBr/
         tBG+TXMMWICXUs7MOvcIKwEZ9z8VigJf5IiHAIb7jKQAsPqgSlqwpqowBZoL2D8XkmaK
         FIb2kWdowVR2LoQRaEgDoM0M0yh6qNcD4Bad8=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: sam@ravnborg.org, linux-kernel@vger.kernel.org
Cc: Peter Korsgaard <jacmet@sunsite.dk>
Subject: [PATCH] setlocalversion: use git svn instead of git-svn
Date: Thu, 26 Mar 2009 21:58:04 +0100
Message-Id: <1238101084-7213-1-git-send-email-jacmet@sunsite.dk>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the correct git <subcmd> syntax instead of the deprecated git-<subcmd>.

Signed-off-by: Peter Korsgaard <jacmet@sunsite.dk>
---
 scripts/setlocalversion |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/setlocalversion b/scripts/setlocalversion
index f1c4b35..47e75b6 100755
--- a/scripts/setlocalversion
+++ b/scripts/setlocalversion
@@ -21,7 +21,7 @@ if head=`git rev-parse --verify --short HEAD 2>/dev/null`; then
 
 	# Is this git on svn?
 	if git config --get svn-remote.svn.url >/dev/null; then
-	        printf -- '-svn%s' "`git-svn find-rev $head`"
+	        printf -- '-svn%s' "`git svn find-rev $head`"
 	fi
 
 	# Are there uncommitted changes?
-- 
1.6.2

