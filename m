Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbXLFQOC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbXLFQOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 11:14:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752387AbXLFQNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 11:13:54 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:16805 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbXLFQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 11:13:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=buVEkqAlYZsH0pLFYyc1KRh66+dzBvImenHvR9mLt5HE+kVoSjx2+d5reOK5uzupXLz3Lm6nDASq503m3uI+3f4Fvq0jx8GfShgDdMvIljL3BgbzlWSSo70a4HB58lZerglok6nRqLrztvT/8mnKApHpf8mM6L31mVheOFBqjk8=
From: Denis Cheng <crquan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 18/20] drivers/char/ipmi/ipmi_msghandler.c: use LIST_HEAD instead of LIST_HEAD_INIT
Date: Fri,  7 Dec 2007 00:13:23 +0800
Message-Id: <1196957605-5797-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

these three list_head are all local variables, but can also use LIST_HEAD.

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 drivers/char/ipmi/ipmi_msghandler.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index d01c4ff..32b2b22 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -441,7 +441,7 @@ struct watcher_entry {
 int ipmi_smi_watcher_register(struct ipmi_smi_watcher *watcher)
 {
 	ipmi_smi_t intf;
-	struct list_head to_deliver = LIST_HEAD_INIT(to_deliver);
+	LIST_HEAD(to_deliver);
 	struct watcher_entry *e, *e2;
 
 	mutex_lock(&smi_watchers_mutex);
-- 
1.5.3.4

