Return-Path: <linux-kernel-owner+w=401wt.eu-S1755565AbZFHRWo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755565AbZFHRWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 13:22:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZFHRU2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 13:20:28 -0400
Received: from relay2.sgi.com ([192.48.179.30]:43682 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753956AbZFHRU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 13:20:26 -0400
Message-Id: <20090608172025.493727000@sgi.com>
User-Agent: quilt/0.47-1
Date: Mon, 08 Jun 2009 12:16:59 -0500
From: steiner@sgi.com
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [Patch 11/12] GRU - remove references to the obsolete global status handle
References: <20090608171648.988318000@sgi.com>
Content-Disposition: inline; filename=uv_gru_delete_gsh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Steiner <steiner@sgi.com>

Delete references to the SGI GRU GSH hardware resources.
These GRU resources have been deleted from the hardware.
(These resources have never benn used, anyway).

Signed-off-by: Jack Steiner <steiner@sgi.com>

---
 drivers/misc/sgi-gru/gruhandles.h |    2 --
 1 file changed, 2 deletions(-)

Index: linux/drivers/misc/sgi-gru/gruhandles.h
===================================================================
--- linux.orig/drivers/misc/sgi-gru/gruhandles.h	2009-06-06 17:26:53.000000000 -0500
+++ linux/drivers/misc/sgi-gru/gruhandles.h	2009-06-07 11:32:57.000000000 -0500
@@ -39,7 +39,6 @@
 #define GRU_NUM_CBE		128
 #define GRU_NUM_TFH		128
 #define GRU_NUM_CCH		16
-#define GRU_NUM_GSH		1
 
 /* Maximum resource counts that can be reserved by user programs */
 #define GRU_NUM_USER_CBR	GRU_NUM_CBE
@@ -56,7 +55,6 @@
 #define GRU_CBE_BASE		(GRU_MCS_BASE + 0x10000)
 #define GRU_TFH_BASE		(GRU_MCS_BASE + 0x18000)
 #define GRU_CCH_BASE		(GRU_MCS_BASE + 0x20000)
-#define GRU_GSH_BASE		(GRU_MCS_BASE + 0x30000)
 
 /* User gseg constants */
 #define GRU_GSEG_STRIDE		(4 * 1024 * 1024)

