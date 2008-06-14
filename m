Return-Path: <linux-kernel-owner+w=401wt.eu-S1760088AbYFNCSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088AbYFNCSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 22:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbYFNCSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 22:18:12 -0400
Received: from jenny.ondioline.org ([66.220.1.122]:45048 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbYFNCSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 22:18:10 -0400
From: Paul Collins <paul@burly.ondioline.org>
To: jack@suse.cz
Cc: manciuleas@yahoo.com, linux-kernel@vger.kernel.org
Subject: [PATCH] udf: restore UDFFS_DEBUG to being undefined by default
Date: Sat, 14 Jun 2008 14:14:59 +1200
Message-ID: <87d4mkiwyk.fsf@burly.wgtn.ondioline.org>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 706047a79725b585cf272fdefc234b31b6545c72, "udf: Fix compilation
warnings when UDF debug is on" inadvertently (I assume) enabled
debugging messages by default for UDF.  This patch disables them again.

Signed-off-by: Paul Collins <paul@ondioline.org>

diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 8fa9c2d..8ec865d 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -16,7 +16,7 @@
 #define UDF_PREALLOCATE
 #define UDF_DEFAULT_PREALLOC_BLOCKS	8
 
-#define UDFFS_DEBUG
+#undef UDFFS_DEBUG
 
 #ifdef UDFFS_DEBUG
 #define udf_debug(f, a...) \


-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
