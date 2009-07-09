Return-Path: <linux-kernel-owner+w=401wt.eu-S1759703AbZGIFrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759703AbZGIFrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 01:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757373AbZGIFqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 01:46:42 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4617 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833AbZGIFqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 01:46:40 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/2] MAINTAINERS: Remove directory trailing slash pattern requirement
Date: Wed,  8 Jul 2009 22:46:38 -0700
Message-Id: <3aae479eda8169221f73ccb502ae9f2ebe4e1f4b.1247117932.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1247117932.git.joe@perches.com>
References: <cover.1247117932.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index e4b1a3d..e4a4de9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -91,17 +91,16 @@ S: Status, one of the following:
 			should be using that.
 
 F: Files and directories with wildcard patterns.
-   A trailing slash includes all files and subdirectory files.
-	F:	drivers/net/	all files in and below drivers/net
+	F:	drivers/net	all files in and below drivers/net
 	F:	drivers/net/*	all files in drivers/net, but not below
 	F:	*/net/*		all files in "any top level directory"/net
    One pattern per line.  Multiple F: lines acceptable.
 X: Files and directories that are NOT maintained, same rules as F:
    Files exclusions are tested before file matches.
    Can be useful for excluding a specific subdirectory, for instance:
-	F:	net/
-	X:	net/ipv6/
-   matches all files in and below net excluding net/ipv6/
+	F:	net
+	X:	net/ipv6
+   matches all files in and below net excluding net/ipv6
 
 3C505 NETWORK DRIVER
 P:	Philip Blundell
-- 
1.6.3.1.10.g659a0.dirty

