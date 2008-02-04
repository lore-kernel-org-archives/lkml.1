Return-Path: <linux-kernel-owner+w=401wt.eu-S1757322AbYBDNpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322AbYBDNpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 08:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756110AbYBDNmn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 08:42:43 -0500
Received: from py-out-1112.google.com ([64.233.166.177]:19271 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbYBDNmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 08:42:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=iYqq+h82mkNMZjyOcwFDDIAro/aFyOhtxvE4aIIgdOeikzgsAjFX1Tde55e1rfzwghBg8RmwiDN6j7J8DrQjroMwTxAkIdsSpIX83HnbFQEqsQY3AJ1K6e7lZ1yk6xJy7R3nf7h5xoTo5T6GHKviGdZNCZivEiX2nwOKFrvqF9Q=
To: <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 17/22] ide-tape: collect module-related macro calls at the end
Date: Mon,  4 Feb 2008 14:40:35 +0100
Message-Id: <1202132440-26648-18-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email debian.1.5.3.7.1-dirty
In-Reply-To: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 24f048f..cfcf5b0 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -3681,9 +3681,6 @@ failed:
 	return -ENODEV;
 }
 
-MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
-MODULE_LICENSE("GPL");
-
 static void __exit idetape_exit (void)
 {
 	driver_unregister(&idetape_driver.gen_driver);
@@ -3726,3 +3723,5 @@ MODULE_ALIAS("ide:*m-tape*");
 module_init(idetape_init);
 module_exit(idetape_exit);
 MODULE_ALIAS_CHARDEV_MAJOR(IDETAPE_MAJOR);
+MODULE_DESCRIPTION("ATAPI Streaming TAPE Driver");
+MODULE_LICENSE("GPL");
-- 
1.5.3.7

