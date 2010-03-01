Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751352Ab0CAPOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 10:14:21 -0500
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:60578 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751527Ab0CAPOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 10:14:14 -0500
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 18/26] w35und: Remove unused struct _RXDATA
Date: Mon,  1 Mar 2010 17:04:20 +0200
Message-Id: <1267455868-4533-18-git-send-email-penberg@cs.helsinki.fi>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
References: <1267455868-4533-1-git-send-email-penberg@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/mlme_s.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/mlme_s.h b/drivers/staging/winbond/mlme_s.h
index 88f9666..f637539 100644
--- a/drivers/staging/winbond/mlme_s.h
+++ b/drivers/staging/winbond/mlme_s.h
@@ -157,11 +157,4 @@ struct wb35_mlme_frame {
                     	            //  excluding the discarded
 };
 
-typedef struct _RXDATA
-{
-	s32		FrameLength;
-	u8	__attribute__ ((packed)) *pbFramePtr;
-
-}__attribute__ ((packed)) RXDATA, *psRXDATA;
-
 #endif
-- 
1.6.3.3

