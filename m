Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbZEXCi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbZEXCi5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 22:38:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZEXCiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 22:38:05 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1427 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZEXCiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 22:38:01 -0400
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 06/18] scripts/get_maintainer.pl - Better email name quoting
Date: Sat, 23 May 2009 19:37:37 -0700
Message-Id: <335bd45f814fc3b8167c6158c3a6f973539090a1.1243131992.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1243131992.git.joe@perches.com>
References: <cover.1243131992.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/get_maintainer.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index e62e72f..9ea2db0 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -356,6 +356,7 @@ sub format_email {
     my ($name, $email) = @_;
 
     $name =~ s/^\s+|\s+$//g;
+    $name =~ s/^\"|\"$//g;
     $email =~ s/^\s+|\s+$//g;
 
     my $formatted_email = "";
-- 
1.6.3.1.10.g659a0.dirty

