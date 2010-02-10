Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481Ab0BJAiQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 19:38:16 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:33312 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0BJAiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 19:38:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=hH5AYv+CT4CEZ/bCLZ9cl65qsKwhlYETQCHTlf+og2r4gaAy4TwBDUqCulhGvqCGVa
         DTGl45BiTGt6PW10Su1CTMu/27BtbUBPVNiQYv89u5CLWahXBHyo9NjLgz3PvvPjOLbC
         Z5aJWbrRd0iuK83kE4Xk3oufT1RWfbIRsh17g=
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: linux-crypto@vger.kernel.org
Cc: Richard Hartmann <richih.mailinglist@gmail.com>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] SCRIPTS: Fix whitespace in get_maintainer output
Date: Wed, 10 Feb 2010 01:37:01 +0100
Message-Id: <1265762223-21006-1-git-send-email-richih.mailinglist@gmail.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Richard Hartmann <richih.mailinglist@gmail.com>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index 2f3230d..430928e 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -278,7 +278,7 @@ foreach my $file (@ARGV) {
 	}
 	close(PATCH);
 	if ($file_cnt == @files) {
-	    warn "$P: file '${file}' doesn't appear to be a patch.  "
+	    warn "$P: file '${file}' doesn't appear to be a patch. "
 		. "Add -f to options?\n";
 	}
 	@files = sort_and_uniq(@files);
-- 
1.6.6.1

