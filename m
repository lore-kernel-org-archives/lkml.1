Return-Path: <linux-kernel-owner+w=401wt.eu-S1754790AbYLIS7Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbYLIS7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:59:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754016AbYLIS7Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:59:16 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:20855 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731AbYLIS7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:59:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=i9aZf53I0juc9F51tdMgWfTs7DAOKdljMMaMqQsb7pQsvDl7Wwux7zyCf8XFjo3ZVi
         72Bc6Y4n/UJdtqRlAgWffwtYcZ3kDSUVbMo06JZ9Bu+5YWfvY4bAjFpZPNO90GchPn6X
         Cu2q/+ebDuAPSIjIXoSXyyn5OpkAh4X7TmgI0=
Message-ID: <493EC000.5040800@gmail.com>
Date: Tue, 09 Dec 2008 19:59:12 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 17/33] drivers/misc: Make static
References: <493EA286.7080500@gmail.com>
In-Reply-To: <493EA286.7080500@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sparse asked whether these could be static.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/misc/lkdtm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 1bfe5d1..9019a1d 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -183,7 +183,7 @@ static int jp_scsi_dispatch_cmd(struct scsi_cmnd *cmd)
 }
 
 #ifdef CONFIG_IDE
-int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
+static int jp_generic_ide_ioctl(ide_drive_t *drive, struct file *file,
 			struct block_device *bdev, unsigned int cmd,
 			unsigned long arg)
 {
@@ -235,7 +235,7 @@ static int recursive_loop(int a)
         	return recursive_loop(a);
 }
 
-void lkdtm_handler(void)
+static void lkdtm_handler(void)
 {
 	printk(KERN_INFO "lkdtm : Crash point %s of type %s hit\n",
 					 cpoint_name, cpoint_type);

