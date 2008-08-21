Return-Path: <linux-kernel-owner+w=401wt.eu-S1758338AbYHURh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758338AbYHURh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754135AbYHURhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:37:05 -0400
Received: from ns2.suse.de ([195.135.220.15]:34264 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbYHURhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:37:04 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 04/15] drivers/base/driver.c: remove unused to_dev() macro
Date: Thu, 21 Aug 2008 10:32:52 -0700
Message-Id: <1219339983-9634-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20080821173036.GB7974@suse.de>
References: <20080821173036.GB7974@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/driver.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/base/driver.c b/drivers/base/driver.c
index 2ef5acf..1e2bda7 100644
--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -16,9 +16,6 @@
 #include <linux/string.h>
 #include "base.h"
 
-#define to_dev(node) container_of(node, struct device, driver_list)
-
-
 static struct device *next_device(struct klist_iter *i)
 {
 	struct klist_node *n = klist_next(i);
-- 
1.5.6.5

