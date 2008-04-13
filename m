Return-Path: <linux-kernel-owner+w=401wt.eu-S1757269AbYDMWo2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269AbYDMWo2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 18:44:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYDMWno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 18:43:44 -0400
Received: from smtp05.mtu.ru ([62.5.255.52]:57166 "EHLO smtp05.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539AbYDMWnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 18:43:42 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: ericvh@gmail.com, rminnich@sandia.gov, lucho@ionkov.net,
       v9fs-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] 9p: remove redundant variable initialization in net/9p/mod.c
Date: Mon, 14 Apr 2008 02:43:46 +0400
Message-Id: <1208126626-25838-3-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1208126626-25838-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1208126626-25838-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp05.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to explicitly initialize the global variable
p9_debug_level by assigning zero value to it.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 net/9p/mod.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/9p/mod.c b/net/9p/mod.c
index c285aab..d3c5329 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -33,7 +33,7 @@
 #include <linux/list.h>
 
 #ifdef CONFIG_NET_9P_DEBUG
-unsigned int p9_debug_level = 0;	/* feature-rific global debug level  */
+unsigned int p9_debug_level;	/* feature-rific global debug level  */
 EXPORT_SYMBOL(p9_debug_level);
 module_param_named(debug, p9_debug_level, uint, 0);
 MODULE_PARM_DESC(debug, "9P debugging level");
-- 
1.5.3

