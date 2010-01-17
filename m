Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917Ab0AQVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0AQVZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871Ab0AQVZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:25:01 -0500
Received: from liberdade.minaslivre.org ([72.232.254.139]:39729 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640Ab0AQVZB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:25:01 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-pm@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] trivial: fix typo s/leve/level/ in pm-runtime doc
Date: Sun, 17 Jan 2010 19:22:28 -0200
Message-Id: <1263763348-9531-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 Documentation/power/runtime_pm.txt |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
index 356fd86..8602e15 100644
--- a/Documentation/power/runtime_pm.txt
+++ b/Documentation/power/runtime_pm.txt
@@ -250,7 +250,7 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
       to suspend the device again in future
 
   int pm_runtime_resume(struct device *dev);
-    - execute the subsystem-leve resume callback for the device; returns 0 on
+    - execute the subsystem-level resume callback for the device; returns 0 on
       success, 1 if the device's run-time PM status was already 'active' or
       error code on failure, where -EAGAIN means it may be safe to attempt to
       resume the device again in future, but 'power.runtime_error' should be
-- 
1.6.6

