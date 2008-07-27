Return-Path: <linux-kernel-owner+w=401wt.eu-S1758275AbYG0BKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbYG0BKe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbYG0BK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:10:26 -0400
Received: from mx2.suse.de ([195.135.220.15]:53903 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbYG0BK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:10:26 -0400
Date: Sun, 27 Jul 2008 03:10:22 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/7] Define AF_ISDN and PF_ISDN
Message-ID: <20080727011022.GB3415@pingi.kke.suse.de>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the address and protocol family value for mISDN.

Signed-off-by: Karsten Keil <kkeil@suse.de>
---
 include/linux/socket.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/linux/socket.h b/include/linux/socket.h
index 950af63..dc5086f 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -189,7 +189,8 @@ struct ucred {
 #define AF_BLUETOOTH	31	/* Bluetooth sockets 		*/
 #define AF_IUCV		32	/* IUCV sockets			*/
 #define AF_RXRPC	33	/* RxRPC sockets 		*/
-#define AF_MAX		34	/* For now.. */
+#define AF_ISDN		34	/* mISDN sockets 		*/
+#define AF_MAX		35	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -225,6 +226,7 @@ struct ucred {
 #define PF_BLUETOOTH	AF_BLUETOOTH
 #define PF_IUCV		AF_IUCV
 #define PF_RXRPC	AF_RXRPC
+#define PF_ISDN		AF_ISDN
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
-- 
1.5.6.4


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
