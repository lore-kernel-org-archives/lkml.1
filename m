Return-Path: <linux-kernel-owner+w=401wt.eu-S1758318AbZEXCjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbZEXCjv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625AbZEXCiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1435 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757AbZEXCiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:04 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 10/18] scripts/get_maintainer.pl - change "die" to "warn" when command line file is not a patch
Date: Sat, 23 May 2009 19:37:41 -0700
Message-Id: <705427561bf7720968de6809a71d11c0f389d716.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixes git send-email with a cover letter

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 951cb95..9c21826 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -165,7 +165,7 @@ foreach my $file (@ARGV) {
 	}
 	close(PATCH);
 	if ($file_cnt == @files) {
-	    die "$P: file '${file}' doesn't appear to be a patch.  "
+	    warn "$P: file '${file}' doesn't appear to be a patch.  "
 		. "Add -f to options?\n";
 	}
 	@files = sort_and_uniq(@files);
-- 
1.6.3.1.10.g659a0.dirty

