Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbXFWK7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbXFWK7g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 06:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753866AbXFWK7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 06:59:25 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:59930 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849AbXFWK7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 06:59:25 -0400
Date: Sat, 23 Jun 2007 12:51:46 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] fbdev: add connector entries for uvesafb
Message-ID: <20070623105146.GC12623@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add connector's idx and val constants for v86d and uvesafb.

Also change the maximum message size to 4k to allow transfers of VBE
data blocks from userspace.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
include/linux/connector.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/connector.h b/include/linux/connector.h
index 10eb56b..46b2aba 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -36,14 +36,15 @@
 #define CN_VAL_CIFS                     0x1
 #define CN_W1_IDX			0x3	/* w1 communication */
 #define CN_W1_VAL			0x1
+#define CN_IDX_V86D			0x4
+#define CN_VAL_V86D_UVESAFB		0x1
 
-
-#define CN_NETLINK_USERS		4
+#define CN_NETLINK_USERS		5
 
 /*
  * Maximum connector's message size.
  */
-#define CONNECTOR_MAX_MSG_SIZE 	1024
+#define CONNECTOR_MAX_MSG_SIZE 	4096
 
 /*
  * idx and val are unique identifiers which 


