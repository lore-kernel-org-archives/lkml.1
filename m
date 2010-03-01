Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab0CAPPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:15:00 -0500
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:34578 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab0CAPO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:56 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 20/26] w35und: Convert R01_DESCRIPTOR typedef to struct wb35_R01_descriptor
Date: Mon,  1 Mar 2010 17:04:22 +0200
Message-Id: <1267455868-4533-20-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/wbhal_s.h |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 67cddb5..e772fad 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -168,8 +168,7 @@ typedef struct _T00_DESCRIPTOR
 	};
 } T00_DESCRIPTOR, *PT00_DESCRIPTOR;
 
-typedef struct _R01_DESCRIPTOR
-{
+struct wb35_R01_descriptor {
 	union
 	{
 		u32	value;
@@ -221,7 +220,7 @@ typedef struct _R01_DESCRIPTOR
 		};
 		#endif
 	};
-} R01_DESCRIPTOR, *PR01_DESCRIPTOR;
+};
 
 typedef struct _T01_DESCRIPTOR
 {
@@ -338,7 +337,7 @@ struct wb35_descriptor {		// Skip length = 8 DWORD
 	// For R01 and T01 ----------------------------------------------
 	union
 	{
-		R01_DESCRIPTOR	R01;
+		struct wb35_R01_descriptor	R01;
 		T01_DESCRIPTOR	T01;
 	};
 
-- 
1.6.3.3

