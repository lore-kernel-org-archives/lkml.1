Return-Path: <linux-kernel-owner+w=401wt.eu-S2992739AbXDDIbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992739AbXDDIbR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 04:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992747AbXDDIbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 04:31:17 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:19621 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992739AbXDDIbR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 04:31:17 -0400
X-IronPort-AV: i="4.14,369,1170651600"; 
   d="scan'208"; a="33691114:sNHT27990480"
Subject: [PATCH] blackfin arch: add SCM_TIMESTAMPNS and SIOCGSTAMPNS to
	socket header file with code style cleaning up
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 16:32:47 +0800
Message-Id: <1175675568.10608.52.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/socket.h  |   11 ++++++-----
 include/asm-blackfin/sockios.h |    3 ++-
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/asm-blackfin/socket.h b/include/asm-blackfin/socket.h
index f337bb3..5213c96 100644
--- a/include/asm-blackfin/socket.h
+++ b/include/asm-blackfin/socket.h
@@ -38,15 +38,16 @@
 #define SO_BINDTODEVICE	25
 
 /* Socket filtering */
-#define SO_ATTACH_FILTER        26
-#define SO_DETACH_FILTER        27
+#define SO_ATTACH_FILTER	26
+#define SO_DETACH_FILTER	27
 
-#define SO_PEERNAME             28
+#define SO_PEERNAME		28
 #define SO_TIMESTAMP		29
 #define SCM_TIMESTAMP		SO_TIMESTAMP
 
 #define SO_ACCEPTCONN		30
-#define SO_PEERSEC             31
+#define SO_PEERSEC		31
 #define SO_PASSSEC		34
-
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
 #endif				/* _ASM_SOCKET_H */
diff --git a/include/asm-blackfin/sockios.h b/include/asm-blackfin/sockios.h
index 733f99c..426b89b 100644
--- a/include/asm-blackfin/sockios.h
+++ b/include/asm-blackfin/sockios.h
@@ -7,6 +7,7 @@
 #define FIOGETOWN	0x8903
 #define SIOCGPGRP	0x8904
 #define SIOCATMARK	0x8905
-#define SIOCGSTAMP	0x8906	/* Get stamp */
+#define SIOCGSTAMP	0x8906	/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907	/* Get stamp (timespec) */
 
 #endif				/* __ARCH_BFIN_SOCKIOS__ */
-- 
1.5.0.5

