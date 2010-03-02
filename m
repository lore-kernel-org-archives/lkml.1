Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0CBOjT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 09:39:19 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:46743 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab0CBOjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 09:39:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=dsiug6C/ZAs7N4kIO3vtyHxL6R7OB5xE5rk0WSl4xzYhLfFZm0657muy8VTQ3ST5X+
         tbxmZ4R/I2msgz/gjcupXK5xmQwW4wbZnw2UzNtAX5s+MGHGGaLMKrYLInllgdM0Yf6o
         K/8MN/fGHn0ScDiJvz+SSMICNYvqmgG4Je494=
From: John Kacur <jkacur@redhat.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>
Subject: [PATCH] [TRIVIAL] kbuild - tags
Date: Tue,  2 Mar 2010 15:38:10 +0100
Message-Id: <1267540690-15069-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	- Fix spelling error in comment (is->if)

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 scripts/tags.sh |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 1a0c44d..a6a8e71 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -17,7 +17,7 @@ ignore="( -name SCCS -o -name BitKeeper -o -name .svn -o \
           -name .git )                                   \
           -prune -o"
 
-# Do not use full path is we do not use O=.. builds
+# Do not use full path if we do not use O=.. builds
 if [ "${KBUILD_SRC}" = "" ]; then
 	tree=
 else
-- 
1.6.6.1

