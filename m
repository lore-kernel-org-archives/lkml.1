Return-Path: <linux-kernel-owner+w=401wt.eu-S1763262AbXGFKVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763262AbXGFKVM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 06:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758861AbXGFKU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 06:20:59 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:57622 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753993AbXGFKU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 06:20:58 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 06:18:42 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] NLS:  Remove obsolete Makefile entries.
Message-ID: <Pine.LNX.4.64.0707060617070.11581@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since the corresponding source files no longer exist, remove the
irrelevant Makefile entries for them.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/fs/nls/Makefile b/fs/nls/Makefile
index a7ade13..f499dd7 100644
--- a/fs/nls/Makefile
+++ b/fs/nls/Makefile
@@ -36,11 +36,9 @@ obj-$(CONFIG_NLS_ISO8859_6)	+= nls_iso8859-6.o
 obj-$(CONFIG_NLS_ISO8859_7)	+= nls_iso8859-7.o
 obj-$(CONFIG_NLS_ISO8859_8)	+= nls_cp1255.o
 obj-$(CONFIG_NLS_ISO8859_9)	+= nls_iso8859-9.o
-obj-$(CONFIG_NLS_ISO8859_10)	+= nls_iso8859-10.o
 obj-$(CONFIG_NLS_ISO8859_13)	+= nls_iso8859-13.o
 obj-$(CONFIG_NLS_ISO8859_14)	+= nls_iso8859-14.o
 obj-$(CONFIG_NLS_ISO8859_15)	+= nls_iso8859-15.o
 obj-$(CONFIG_NLS_KOI8_R)	+= nls_koi8-r.o
 obj-$(CONFIG_NLS_KOI8_U)	+= nls_koi8-u.o nls_koi8-ru.o
-obj-$(CONFIG_NLS_ABC)		+= nls_abc.o
 obj-$(CONFIG_NLS_UTF8)		+= nls_utf8.o
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
