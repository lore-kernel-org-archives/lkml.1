Return-Path: <linux-kernel-owner+w=401wt.eu-S1757701AbZFEXss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757701AbZFEXss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756207AbZFEXl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:41:58 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:36414 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755465AbZFEXlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:41:11 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Amerigo Wang <amwang@redhat.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 19/39] kbuild: clean up scripts/headers.sh
Date: Sat,  6 Jun 2009 01:42:37 +0200
Message-Id: <1244245377-17441-19-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.3.rc3.40.g75b44
In-Reply-To: <20090605233720.GA13588@uranus.ravnborg.org>
References: <20090605233720.GA13588@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Amerigo Wang <amwang@redhat.com>

'drop' variable is unused.

'ppc' and 'sparc64' directories don't exist in arch/,
and I think their headers can be well exported now, so
just remove them.

Signed-off-by: WANG Cong <amwang@redhat.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/headers.sh |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/scripts/headers.sh b/scripts/headers.sh
index d33426f..0308ecc 100755
--- a/scripts/headers.sh
+++ b/scripts/headers.sh
@@ -15,19 +15,12 @@ do_command()
 	fi
 }
 
-# Do not try this architecture
-drop="generic um ppc sparc64 cris"
-
 archs=$(ls ${srctree}/arch)
 
 for arch in ${archs}; do
 	case ${arch} in
 	um)        # no userspace export
 		;;
-	ppc)       # headers exported by powerpc
-		;;
-	sparc64)   # headers exported by sparc
-		;;
 	cris)      # headers export are known broken
 		;;
 	*)
-- 
1.6.3.rc3.40.g75b44

