Return-Path: <linux-kernel-owner+w=401wt.eu-S2992701AbXDDG2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992701AbXDDG2R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 02:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992709AbXDDG2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 02:28:16 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:2886 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992701AbXDDG2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 02:28:13 -0400
X-IronPort-AV: i="4.14,367,1170651600"; 
   d="scan'208"; a="26306157:sNHT25991049"
Subject: [PATCH] Blackfin arch: add asm-blackfin socket header files
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 04 Apr 2007 14:28:08 +0800
Message-Id: <1175668088.10608.37.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 include/asm-blackfin/socket.h  |   55 ++++++++++++++++++++++++++++++++++++++++
 include/asm-blackfin/sockios.h |   13 +++++++++
 2 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 include/asm-blackfin/socket.h
 create mode 100644 include/asm-blackfin/sockios.h

diff --git a/include/asm-blackfin/socket.h b/include/asm-blackfin/socket.h
new file mode 100644
index 0000000..77a45d9
--- /dev/null
+++ b/include/asm-blackfin/socket.h
@@ -0,0 +1,55 @@
+#ifndef _ASM_BLACKFIN_SOCKET_H
+#define _ASM_BLACKFIN_SOCKET_H
+
+#include <asm/sockios.h>
+
+/* For setsockopt(2) */
+#define SOL_SOCKET	1
+
+#define SO_DEBUG	1
+#define SO_REUSEADDR	2
+#define SO_TYPE		3
+#define SO_ERROR	4
+#define SO_DONTROUTE	5
+#define SO_BROADCAST	6
+#define SO_SNDBUF	7
+#define SO_RCVBUF	8
+#define SO_SNDBUFFORCE	32
+#define SO_RCVBUFFORCE	33
+#define SO_KEEPALIVE	9
+#define SO_OOBINLINE	10
+#define SO_NO_CHECK	11
+#define SO_PRIORITY	12
+#define SO_LINGER	13
+#define SO_BSDCOMPAT	14
+/* To add :#define SO_REUSEPORT 15 */
+#define SO_PASSCRED	16
+#define SO_PEERCRED	17
+#define SO_RCVLOWAT	18
+#define SO_SNDLOWAT	19
+#define SO_RCVTIMEO	20
+#define SO_SNDTIMEO	21
+
+/* Security levels - as per NRL IPv6 - don't actually do anything */
+#define SO_SECURITY_AUTHENTICATION		22
+#define SO_SECURITY_ENCRYPTION_TRANSPORT	23
+#define SO_SECURITY_ENCRYPTION_NETWORK		24
+
+#define SO_BINDTODEVICE	25
+
+/* Socket filtering */
+#define SO_ATTACH_FILTER        26
+#define SO_DETACH_FILTER        27
+
+#define SO_PEERNAME             28
+#define SO_TIMESTAMP		29
+#define SCM_TIMESTAMP		SO_TIMESTAMP
+
+#define SO_ACCEPTCONN		30
+
+#define SO_PEERSEC             31
+#define SO_PASSSEC		34
+#define SO_TIMESTAMPNS		35
+#define SCM_TIMESTAMPNS		SO_TIMESTAMPNS
+
+#endif /* _ASM_BLACKFIN_SOCKET_H */
diff --git a/include/asm-blackfin/sockios.h b/include/asm-blackfin/sockios.h
new file mode 100644
index 0000000..7874234
--- /dev/null
+++ b/include/asm-blackfin/sockios.h
@@ -0,0 +1,13 @@
+#ifndef _ASM_BLACKFIN_SOCKIOS_H_
+#define _ASM_BLACKFIN_SOCKIOS_H_
+
+/* Socket-level I/O control calls. */
+#define FIOSETOWN	0x8901
+#define SIOCSPGRP	0x8902
+#define FIOGETOWN	0x8903
+#define SIOCGPGRP	0x8904
+#define SIOCATMARK	0x8905
+#define SIOCGSTAMP	0x8906		/* Get stamp (timeval) */
+#define SIOCGSTAMPNS	0x8907		/* Get stamp (timespec) */
+
+#endif /* _ASM_BLACKFIN_SOCKIOS_H_ */
-- 
1.5.0.5

