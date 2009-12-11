Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbZLKXmF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbZLKXmF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:42:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933806AbZLKXlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:41:55 -0500
Received: from kroah.org ([198.145.64.141]:50433 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762811AbZLKX2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:28:53 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/58] tty: const: constify remaining tty_operations
Date: Fri, 11 Dec 2009 15:27:53 -0800
Message-Id: <1260574122-10676-9-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/xtensa/platforms/iss/console.c  |    2 +-
 drivers/char/bfin_jtag_comm.c        |    2 +-
 drivers/char/epca.c                  |    2 +-
 drivers/char/pcmcia/ipwireless/tty.c |    2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/xtensa/platforms/iss/console.c b/arch/xtensa/platforms/iss/console.c
index 4c559cf..e60a1f5 100644
--- a/arch/xtensa/platforms/iss/console.c
+++ b/arch/xtensa/platforms/iss/console.c
@@ -196,7 +196,7 @@ static const struct file_operations rs_proc_fops = {
 	.release	= single_release,
 };
 
-static struct tty_operations serial_ops = {
+static const struct tty_operations serial_ops = {
 	.open = rs_open,
 	.close = rs_close,
 	.write = rs_write,
diff --git a/drivers/char/bfin_jtag_comm.c b/drivers/char/bfin_jtag_comm.c
index 1d7c34c..2628c74 100644
--- a/drivers/char/bfin_jtag_comm.c
+++ b/drivers/char/bfin_jtag_comm.c
@@ -226,7 +226,7 @@ bfin_jc_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 }
 
-static struct tty_operations bfin_jc_ops = {
+static const struct tty_operations bfin_jc_ops = {
 	.open            = bfin_jc_open,
 	.close           = bfin_jc_close,
 	.write           = bfin_jc_write,
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index dde5134..17b044a 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -935,7 +935,7 @@ static int info_open(struct tty_struct *tty, struct file *filp)
 	return 0;
 }
 
-static struct tty_operations info_ops = {
+static const struct tty_operations info_ops = {
 	.open = info_open,
 	.ioctl = info_ioctl,
 };
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index 674b3ab..2bb7874 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -603,7 +603,7 @@ void ipwireless_tty_free(struct ipw_tty *tty)
 	}
 }
 
-static struct tty_operations tty_ops = {
+static const struct tty_operations tty_ops = {
 	.open = ipw_open,
 	.close = ipw_close,
 	.hangup = ipw_hangup,
-- 
1.6.5.5

