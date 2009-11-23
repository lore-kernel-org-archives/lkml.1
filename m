Return-Path: <linux-kernel-owner+w=401wt.eu-S1755617AbZKWPkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755617AbZKWPkk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbZKWPkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:40:39 -0500
Received: from smtp.nokia.com ([192.100.122.233]:23544 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbZKWPkj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:40:39 -0500
From: Roger Quadros <roger.quadros@nokia.com>
To: dtor@insightbb.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Input: force feedback - fix function name in comment
Date: Mon, 23 Nov 2009 21:10:27 +0530
Message-Id: <1258990827-3957-1-git-send-email-roger.quadros@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 23 Nov 2009 15:40:34.0169 (UTC) FILETIME=[4BB48E90:01CA6C53]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function name is input_ff_destroy() and not input_ff_free()

Signed-off-by: Roger Quadros <roger.quadros@nokia.com>
---
 drivers/input/ff-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/ff-core.c b/drivers/input/ff-core.c
index 72c63e5..3d7816c 100644
--- a/drivers/input/ff-core.c
+++ b/drivers/input/ff-core.c
@@ -353,7 +353,7 @@ int input_ff_create(struct input_dev *dev, int max_effects)
 EXPORT_SYMBOL_GPL(input_ff_create);
 
 /**
- * input_ff_free() - frees force feedback portion of input device
+ * input_ff_destroy() - frees force feedback portion of input device
  * @dev: input device supporting force feedback
  *
  * This function is only needed in error path as input core will
-- 
1.6.3.3

