Return-Path: <linux-kernel-owner+w=401wt.eu-S1757063AbZIROFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063AbZIROFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 10:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756669AbZIROFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 10:05:03 -0400
Received: from THUNK.ORG ([69.25.196.29]:37601 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630AbZIROFB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 10:05:01 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] EDAC, AMD: Fix build error by including <linux/smp.h>
Date: Fri, 18 Sep 2009 10:04:59 -0400
Message-Id: <1253282699-14611-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.2.1.gb9f7d.dirty
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing the per-cpu variable cpu_llc_id now requires that
<linux/smp.h> header file be included.

Cc: Borislav Petkov <borislav.petkov@amd.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---

This fixes a compile error found in 2.6.31-git6

 drivers/edac/edac_mce_amd.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/edac/edac_mce_amd.c b/drivers/edac/edac_mce_amd.c
index c8ca713..6ae3b66 100644
--- a/drivers/edac/edac_mce_amd.c
+++ b/drivers/edac/edac_mce_amd.c
@@ -1,4 +1,5 @@
 #include <linux/module.h>
+#include <linux/smp.h>
 #include "edac_mce_amd.h"
 
 static bool report_gart_errors;
-- 
1.6.3.2.1.gb9f7d.dirty

