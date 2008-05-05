Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbYEESWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbYEESWw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751223AbYEESWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:22:42 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54675 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYEESWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:22:41 -0400
Date: Mon, 5 May 2008 21:21:34 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Miloslav Trmac <mitr@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] remove is_tty()
Message-ID: <20080505182134.GC17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the no longer used is_tty().

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 drivers/char/tty_io.c |   13 -------------
 1 file changed, 13 deletions(-)

235f289c0d590299142947baddd41153bd312f6d diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 2fa6856..b1f6d33 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1576,19 +1576,6 @@ int tty_hung_up_p(struct file *filp)
 
 EXPORT_SYMBOL(tty_hung_up_p);
 
-/**
- *	is_tty	-	checker whether file is a TTY
- *	@filp:		file handle that may be a tty
- *
- *	Check if the file handle is a tty handle.
- */
-
-int is_tty(struct file *filp)
-{
-	return filp->f_op->read == tty_read
-		|| filp->f_op->read == hung_up_tty_read;
-}
-
 static void session_clear_tty(struct pid *session)
 {
 	struct task_struct *p;

