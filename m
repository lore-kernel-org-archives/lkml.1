Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXFOS6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXFOS6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754005AbXFOS6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:58:17 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:51012 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbXFOS6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:58:16 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 15 Jun 2007 14:56:22 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove final two references to "__obsolete_setup" macro.
Message-ID: <Pine.LNX.4.64.0706151454460.14715@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  given that there aren't any other references to this macro anywhere
in the tree, i'm just *guessing* it may not have any further value.

diff --git a/include/linux/init.h b/include/linux/init.h
index 56ec4c6..5b52853 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -171,9 +171,6 @@ struct obs_kernel_param {
 #define __setup(str, fn)					\
 	__setup_param(str, fn, fn, 0)

-#define __obsolete_setup(str)					\
-	__setup_null_param(str, __LINE__)
-
 /* NOTE: fn is as per module_param, not __setup!  Emits warning if fn
  * returns non-zero. */
 #define early_param(str, fn)					\
@@ -239,7 +236,6 @@ void __init parse_early_param(void);
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup_null_param(str, unique_id) 	/* nothing */
 #define __setup(str, func) 			/* nothing */
-#define __obsolete_setup(str) 			/* nothing */
 #endif

 /* Data marked not to be saved by software suspend */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
