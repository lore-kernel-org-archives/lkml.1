Return-Path: <linux-kernel-owner+w=401wt.eu-S1757899AbZAHJbN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757899AbZAHJbN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 04:31:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753577AbZAHJaz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 04:30:55 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:60826 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZAHJay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 04:30:54 -0500
Date: Thu, 8 Jan 2009 11:30:52 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] w35und: Move ETH_LENGTH_OF_ADDRESS to wbhal_s.h
Message-ID: <Pine.LNX.4.64.0901081130160.15334@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

The common.h header file is a dumping ground for miscellaneous crap. In order
to get rid of it, move the ETH_LENGHT_OF_ADDRESS macro to wbhal_s.h where it's
actually being used.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/common.h  |    1 -
 drivers/staging/winbond/wbhal_s.h |    1 +
 2 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/winbond/common.h b/drivers/staging/winbond/common.h
index c4d9604..61ccc86 100644
--- a/drivers/staging/winbond/common.h
+++ b/drivers/staging/winbond/common.h
@@ -16,7 +16,6 @@
 // Common function definition
 //==================================================================================================
 #define DEBUG_ENABLED
-#define ETH_LENGTH_OF_ADDRESS	6
 #ifdef DEBUG_ENABLED
 #define WBDEBUG( _M )	printk _M
 #else
diff --git a/drivers/staging/winbond/wbhal_s.h b/drivers/staging/winbond/wbhal_s.h
index 276d2b1..513babb 100644
--- a/drivers/staging/winbond/wbhal_s.h
+++ b/drivers/staging/winbond/wbhal_s.h
@@ -427,6 +427,7 @@ typedef struct _TXVGA_FOR_50 {
 #include "wb35tx_s.h"
 #include "wb35rx_s.h"
 
+#define ETH_LENGTH_OF_ADDRESS 6
 
 // For Hal using ==================================================================
 typedef struct _HW_DATA_T
-- 
1.5.4.3

