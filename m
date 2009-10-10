Return-Path: <linux-kernel-owner+w=401wt.eu-S1754538AbZJJGGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538AbZJJGGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 02:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZJJGFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 02:05:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2051 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbZJJGFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 02:05:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Grant Likely <grant.likely@secretlab.ca>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 2/3] MAINTAINERS: Document new "K:" entry type
Date: Fri,  9 Oct 2009 23:05:03 -0700
Message-Id: <6773e26fed99c1e686bf6efa3dd59eba525c7633.1255153863.git.joe@perches.com>
X-Mailer: git-send-email 1.6.5.rc3.dirty
In-Reply-To: <cover.1255153863.git.joe@perches.com>
References: <cover.1255153863.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

K: is for keyword.  Syntax is perl extended regex.

Reorganized header documentation and indent the section
entry descriptions so that the first K: would not be
considered a regex to match by get_maintainer.pl

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   70 ++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 39 insertions(+), 31 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e1da925..4407de2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -65,43 +65,51 @@ trivial patch so apply some common sense.
 
 8.	Happy hacking.
 
-		-----------------------------------
-
-Maintainers List (try to look for most precise areas first)
+Descriptions of section entries:
+
+	P: Person (obsolete)
+	M: Mail patches to: FullName <address@domain>
+	L: Mailing list that is relevant to this area
+	W: Web-page with status/info
+	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
+	S: Status, one of the following:
+	   Supported:	Someone is actually paid to look after this.
+	   Maintained:	Someone actually looks after it.
+	   Odd Fixes:	It has a maintainer but they don't have time to do
+			much other than throw the odd patch in. See below..
+	   Orphan:	No current maintainer [but maybe you could take the
+			role as you write your new code].
+	   Obsolete:	Old code. Something tagged obsolete generally means
+			it has been replaced by a better system and you
+			should be using that.
+	F: Files and directories with wildcard patterns.
+	   A trailing slash includes all files and subdirectory files.
+	   F:	drivers/net/	all files in and below drivers/net
+	   F:	drivers/net/*	all files in drivers/net, but not below
+	   F:	*/net/*		all files in "any top level directory"/net
+	   One pattern per line.  Multiple F: lines acceptable.
+	X: Files and directories that are NOT maintained, same rules as F:
+	   Files exclusions are tested before file matches.
+	   Can be useful for excluding a specific subdirectory, for instance:
+	   F:	net/
+	   X:	net/ipv6/
+	   matches all files in and below net excluding net/ipv6/
+	K: Keyword perl extended regex pattern to match content in a
+	   patch or file.  For instance:
+	   K: of_get_profile
+	      matches patches or files that contain "of_get_profile"
+	   K: \b(printk|pr_(info|err))\b
+	      matches patches or files that contain one or more of the words
+	      printk, pr_info or pr_err
+	   One regex pattern per line.  Multiple K: lines acceptable.
 
 Note: For the hard of thinking, this list is meant to remain in alphabetical
 order. If you could add yourselves to it in alphabetical order that would be
 so much easier [Ed]
 
-P: Person (obsolete)
-M: Mail patches to: FullName <address@domain>
-L: Mailing list that is relevant to this area
-W: Web-page with status/info
-T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
-S: Status, one of the following:
-
-	Supported:	Someone is actually paid to look after this.
-	Maintained:	Someone actually looks after it.
-	Odd Fixes:	It has a maintainer but they don't have time to do
-			much other than throw the odd patch in. See below..
-	Orphan:		No current maintainer [but maybe you could take the
-			role as you write your new code].
-	Obsolete:	Old code. Something tagged obsolete generally means
-			it has been replaced by a better system and you
-			should be using that.
+Maintainers List (try to look for most precise areas first)
 
-F: Files and directories with wildcard patterns.
-   A trailing slash includes all files and subdirectory files.
-	F:	drivers/net/	all files in and below drivers/net
-	F:	drivers/net/*	all files in drivers/net, but not below
-	F:	*/net/*		all files in "any top level directory"/net
-   One pattern per line.  Multiple F: lines acceptable.
-X: Files and directories that are NOT maintained, same rules as F:
-   Files exclusions are tested before file matches.
-   Can be useful for excluding a specific subdirectory, for instance:
-	F:	net/
-	X:	net/ipv6/
-   matches all files in and below net excluding net/ipv6/
+		-----------------------------------
 
 3C505 NETWORK DRIVER
 M:	Philip Blundell <philb@gnu.org>
-- 
1.6.5.rc3.dirty

