Return-Path: <linux-kernel-owner+w=401wt.eu-S1754342AbYJ2SMB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342AbYJ2SMB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 14:12:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbYJ2SLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 14:11:45 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:44704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbYJ2SLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 14:11:44 -0400
Date: Wed, 29 Oct 2008 20:11:13 +0200 (EET)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: Greg Kroah-Hartman <greg@kroah.com>
cc: Pavel Machek <pavel@suse.cz>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] w35und: remove abs() and BIT() macros
Message-ID: <Pine.LNX.4.64.0810292010570.16596@melkki.cs.Helsinki.FI>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

We can use the kernel built-in abs() and BIT() macros the just fine.

Cc: Pavel Machek <pavel@suse.cz>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 drivers/staging/winbond/linux/common.h |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/winbond/linux/common.h b/drivers/staging/winbond/linux/common.h
index 046dab6..f171b88 100644
--- a/drivers/staging/winbond/linux/common.h
+++ b/drivers/staging/winbond/linux/common.h
@@ -48,16 +48,9 @@
 #define STATUS_MEDIA_CONNECT 1
 #define STATUS_MEDIA_DISCONNECT 0
 
-#ifndef BIT
-#define BIT(x)                  (1 << (x))
-#endif
-
 //==================================================================================================
 // Common function definition
 //==================================================================================================
-#ifndef abs
-#define abs(_T)							((_T) < 0 ? -_T : _T)
-#endif
 #define DEBUG_ENABLED
 #define ETH_LENGTH_OF_ADDRESS	6
 #ifdef DEBUG_ENABLED
-- 
1.5.3.7

