Return-Path: <linux-kernel-owner+w=401wt.eu-S1761483AbXJXQbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483AbXJXQbT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759055AbXJXQX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:23:27 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33360 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759002AbXJXQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:23:26 -0400
Date: Wed, 24 Oct 2007 18:23:55 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Ryan Reading <ryanr23@gmail.com>, Samuel Ortiz <samuel@sortiz.org>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [2.6 patch] make ircomm_tty static
Message-ID: <20071024162355.GZ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ircomm_tty can now become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 include/net/irda/ircomm_tty.h |    1 -
 net/irda/ircomm/ircomm_tty.c  |    2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

487bdc857155e7346cbb80b07d2ec3df150fc9d2 
diff --git a/include/net/irda/ircomm_tty.h b/include/net/irda/ircomm_tty.h
index 8dabdd6..eea2e61 100644
--- a/include/net/irda/ircomm_tty.h
+++ b/include/net/irda/ircomm_tty.h
@@ -127,7 +127,6 @@ extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file,
 			    unsigned int cmd, unsigned long arg);
 extern void ircomm_tty_set_termios(struct tty_struct *tty, 
 				   struct ktermios *old_termios);
-extern hashbin_t *ircomm_tty;
 
 #endif
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 3d241e4..1120b15 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -77,7 +77,7 @@ static int ircomm_tty_read_proc(char *buf, char **start, off_t offset, int len,
 #endif /* CONFIG_PROC_FS */
 static struct tty_driver *driver;
 
-hashbin_t *ircomm_tty = NULL;
+static hashbin_t *ircomm_tty = NULL;
 
 static const struct tty_operations ops = {
 	.open            = ircomm_tty_open,

