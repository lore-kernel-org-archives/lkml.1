Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638Ab0BVSEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 13:04:46 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:44431 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0BVSEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 13:04:45 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging/serial2002: Fix filp_open usage
Date: Tue, 23 Feb 2010 03:04:42 +0900
Message-ID: <87zl31b0zp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.92 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/staging/comedi/drivers/serial2002.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/staging/comedi/drivers/serial2002.c~serial2002-filp_open-fix drivers/staging/comedi/drivers/serial2002.c
--- linux-2.6/drivers/staging/comedi/drivers/serial2002.c~serial2002-filp_open-fix	2010-02-22 23:22:27.000000000 +0900
+++ linux-2.6-hirofumi/drivers/staging/comedi/drivers/serial2002.c	2010-02-22 23:22:27.000000000 +0900
@@ -397,7 +397,7 @@ static void serial_2002_open(struct come
 	char port[20];
 
 	sprintf(port, "/dev/ttyS%d", devpriv->port);
-	devpriv->tty = filp_open(port, 0, O_RDWR);
+	devpriv->tty = filp_open(port, O_RDWR, 0);
 	if (IS_ERR(devpriv->tty)) {
 		printk("serial_2002: file open error = %ld\n",
 		       PTR_ERR(devpriv->tty));
_

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
