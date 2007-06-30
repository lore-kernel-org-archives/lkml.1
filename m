Return-Path: <linux-kernel-owner+w=401wt.eu-S1758826AbXF3Qc4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826AbXF3Qc4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 12:32:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbXF3Qcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 12:32:47 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:41238 "EHLO
	ipn26-148.piekary.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756162AbXF3Qcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 12:32:46 -0400
Date: Sat, 30 Jun 2007 18:32:44 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [PATCH v2 2/5] uvesafb: add connector entries
Message-ID: <20070630163244.GC3838@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add connector idx and val constants for v86d and uvesafb.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
 include/linux/connector.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/connector.h b/include/linux/connector.h
index 10eb56b..14cecaf 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -36,9 +36,10 @@
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

