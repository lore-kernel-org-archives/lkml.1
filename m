Return-Path: <linux-kernel-owner+w=401wt.eu-S1757988AbXJ3JcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988AbXJ3JcS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 05:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbXJ3JcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 05:32:00 -0400
Received: from nic2.axis.se ([193.13.178.10]:39902 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbXJ3Jb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 05:31:59 -0400
Date: Tue, 30 Oct 2007 10:31:49 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 8/16] CRIS architecture: Correct compile errors
Message-ID: <20071030093148.GK11960@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing defines for (unsupported) baud rates.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 termbits.h |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- clean_linux-2.6.23/include/asm-cris/termbits.h	2007-10-09 22:31:38.000000000 +0200
+++ linux-2.6.23/include/asm-cris/termbits.h	2007-10-26 13:08:09.000000000 +0200
@@ -171,6 +171,19 @@
 #define  B115200 0010002
 #define  B230400 0010003
 #define  B460800 0010004
+
+/* Unsupported rates, but needed to avoid compile error. */
+#define   B500000 0010005
+#define   B576000 0010006
+#define  B1000000 0010010
+#define  B1152000 0010011
+#define  B1500000 0010012
+#define  B2000000 0010013
+#define  B2500000 0010014
+#define  B3000000 0010015
+#define  B3500000 0010016
+#define  B4000000 0010017
+
 /* etrax supports these additional three baud rates */
 #define  B921600   0010005
 #define  B1843200  0010006

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
