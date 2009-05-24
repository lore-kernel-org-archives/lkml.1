Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbZEXCic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbZEXCic (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754695AbZEXCiD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:03 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1423 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/18] scripts/get_maintainer.pl - Better fix for subscriber-only mailing lists
Date: Sat, 23 May 2009 19:37:33 -0700
Message-Id: <09e99bb8191ff3fc31aa06021beba832d8d509dc.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index c4b25a7..f302ad3 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -380,7 +380,7 @@ sub add_categories {
 		    $list_address = $1;
 		    $list_additional = $2;
 		}
-		if ($list_additional =~ m/\(subscribers-only\)/) {
+		if ($list_additional =~ m/subscribers-only/) {
 		    if ($email_subscriber_list) {
 			push(@list_to, $list_address);
 		    }
-- 
1.6.3.1.10.g659a0.dirty

