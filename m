Return-Path: <linux-kernel-owner+w=401wt.eu-S1757357AbYLVVyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbYLVVyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 16:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbYLVVtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 16:49:14 -0500
Received: from mail.suse.de ([195.135.220.2]:41601 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755922AbYLVVtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 16:49:13 -0500
From: Mark Fasheh <mfasheh@suse.com>
To: linux-kernel@vger.kernel.org
Cc: ocfs2-devel@oss.oracle.com, Joel Becker <joel.becker@oracle.com>,
       Jan Kara <jack@suse.cz>, Mark Fasheh <mfasheh@suse.com>
Subject: [PATCH 16/56] quota: Update version number
Date: Mon, 22 Dec 2008 13:47:57 -0800
Message-Id: <1229982517-3455-17-git-send-email-mfasheh@suse.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
References: <1229982517-3455-1-git-send-email-mfasheh@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kara <jack@suse.cz>

Increase reported version number of quota support since quota core has changed
significantly. Also remove __DQUOT_NUM_VERSION__ since nobody uses it.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
---
 include/linux/quota.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/quota.h b/include/linux/quota.h
index 6d98885..ec82beb 100644
--- a/include/linux/quota.h
+++ b/include/linux/quota.h
@@ -36,8 +36,7 @@
 #include <linux/errno.h>
 #include <linux/types.h>
 
-#define __DQUOT_VERSION__	"dquot_6.5.1"
-#define __DQUOT_NUM_VERSION__	6*10000+5*100+1
+#define __DQUOT_VERSION__	"dquot_6.5.2"
 
 #define MAXQUOTAS 2
 #define USRQUOTA  0		/* element used for user quotas */
-- 
1.5.6

