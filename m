Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751922Ab0CAX0G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 18:26:06 -0500
Received: from [206.15.93.42] ([206.15.93.42]:5162 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751337Ab0CAX0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 18:26:05 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging/dt3155: remove TRUE / FALSE defines
Date: Mon, 1 Mar 2010 16:26:01 -0700
Cc: greg@kroah.com, ss@aao.gov.au
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003011626.01894.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The TRUE / FALSE defines are only used in the dt3155.h header to
establish the bit setting needed to set 50/60Hz operation.

Remove the defines and just use 1 / 0 as appropriate.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155.h b/drivers/staging/dt3155/dt3155.h
index 1bf7863..33329a5 100644
--- a/drivers/staging/dt3155/dt3155.h
+++ b/drivers/staging/dt3155/dt3155.h
@@ -45,9 +45,6 @@ MA 02111-1307 USA
 #endif
 
 
-#define TRUE  1
-#define FALSE 0
-
 /* Uncomment this for 50Hz CCIR */
 #define CCIR 1
 
@@ -62,11 +59,11 @@ MA 02111-1307 USA
 #ifdef CCIR
 #define DT3155_MAX_ROWS	576
 #define DT3155_MAX_COLS	768
-#define FORMAT50HZ	TRUE
+#define FORMAT50HZ	1
 #else
 #define DT3155_MAX_ROWS	480
 #define DT3155_MAX_COLS	640
-#define FORMAT50HZ	FALSE
+#define FORMAT50HZ	0
 #endif
 
 /* Configuration structure */
