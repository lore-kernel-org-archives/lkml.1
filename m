Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbXKERQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbXKERQV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 12:16:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757221AbXKERIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 12:08:14 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:59529 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757243AbXKERIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 12:08:04 -0500
Date: Mon, 5 Nov 2007 18:07:40 +0100
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] proper prototype for vty_init()
Message-ID: <20071105170740.GS12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a proper prototype for vty_init() in 
include/linux/vt_kern.h

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/tty_io.c   |    4 ----
 include/linux/vt_kern.h |    1 +
 2 files changed, 1 insertion(+), 4 deletions(-)

e2bf6097115923c07a04b4791f8abecf3b14c709 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f36fecd..c927f42 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -4048,10 +4048,6 @@ void __init console_init(void)
 	}
 }
 
-#ifdef CONFIG_VT
-extern int vty_init(void);
-#endif
-
 static int __init tty_class_init(void)
 {
 	tty_class = class_create(THIS_MODULE, "tty");
diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index feb5e99..9448ffb 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -77,6 +77,7 @@ void change_console(struct vc_data *new_vc);
 void reset_vc(struct vc_data *vc);
 extern int unbind_con_driver(const struct consw *csw, int first, int last,
 			     int deflt);
+int vty_init(void);
 
 /*
  * vc_screen.c shares this temporary buffer with the console write code so that

