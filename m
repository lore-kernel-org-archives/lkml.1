Return-Path: <linux-kernel-owner+w=401wt.eu-S1763681AbXGPPDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763681AbXGPPDw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 11:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756039AbXGPPDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 11:03:44 -0400
Received: from sicnat2.emn.fr ([193.54.76.193]:46005 "EHLO ron.emn.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754331AbXGPPDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 11:03:44 -0400
From: Yoann Padioleau <padator@wanadoo.fr>
To: linux-janitors@vger.kernel.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH] potential parse error, drivers/serial/dz.h
Date: Mon, 16 Jul 2007 17:02:13 +0200
Message-ID: <87k5t05r4a.fsf@wanadoo.fr>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


potential parse error in declaration under a #ifdef.

Signed-off-by: Yoann Padioleau <padator@wanadoo.fr> 


diff --git a/drivers/serial/dz.h b/drivers/serial/dz.h
index 9674d4e..9141c37 100644
--- a/drivers/serial/dz.h
+++ b/drivers/serial/dz.h
@@ -125,8 +125,8 @@ #define DZ_XMIT_SIZE   4096             
 #define DZ_WAKEUP_CHARS   DZ_XMIT_SIZE/4
 
 #ifdef MODULE
-int init_module (void)
-void cleanup_module (void)
+int init_module (void);
+void cleanup_module (void);
 #endif
 
 #endif /* DZ_SERIAL_H */

