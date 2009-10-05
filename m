Return-Path: <linux-kernel-owner+w=401wt.eu-S932246AbZJEA4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932246AbZJEA4F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 20:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758340AbZJEA4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 20:56:04 -0400
Received: from mail.perches.com ([173.55.12.10]:1747 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758343AbZJEAz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 20:55:59 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Samuel Chessman <chessman@tux.org>, netdev@vger.kernel.org
Subject: [PATCH 21/21] drivers/net/tlan.h: Convert printk(KERN_DEBUG to pr_dbg(
Date: Sun,  4 Oct 2009 17:53:48 -0700
Message-Id: <29c66ee0bae26a0c352b4605e3f1fcbe0612f3a5.1254701151.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
In-Reply-To: <cover.1254701151.git.joe@perches.com>
References: <cover.1254701151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed "TLAN: " prefix from debug printks, it's added by pr_fmt

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/tlan.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tlan.h b/drivers/net/tlan.h
index 4b82f28..c5a4ad5 100644
--- a/drivers/net/tlan.h
+++ b/drivers/net/tlan.h
@@ -44,7 +44,7 @@
 #define TLAN_RECORD		1
 
 #define TLAN_DBG(lvl, format, args...)	\
-	do { if (debug&lvl) printk(KERN_DEBUG "TLAN: " format, ##args ); } while(0)
+	do { if (debug & lvl) pr_dbg(format, ##args); } while (0)
 
 #define TLAN_DEBUG_GNRL		0x0001
 #define TLAN_DEBUG_TX		0x0002
-- 
1.6.3.1.10.g659a0.dirty

