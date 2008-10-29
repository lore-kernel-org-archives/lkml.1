Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbYJ2SMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbYJ2SMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754227AbYJ2SMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:12:40 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189AbYJ2SMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:12:40 -0400
Date: Wed, 29 Oct 2008 20:11:49 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] w35und: remove unused macros from common.h
Message-ID: <Pine.LNX.4.64.0810292011140.16596@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The macros are not used anywhere so remove them from driver code.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/common.h |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index f171b88..8290779 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -33,21 +33,6 @@
 
 //#define DEBUG_ENABLED  1
 
-
-
-//===============================================================
-// Common type definition
-//===============================================================
-
-//===========================================
-#define IGNORE      2
-#define	SUCCESS     1
-#define	FAILURE     0
-
-
-#define STATUS_MEDIA_CONNECT 1
-#define STATUS_MEDIA_DISCONNECT 0
-
 //==================================================================================================
 // Common function definition
 //==================================================================================================
-- 
1.5.3.7

