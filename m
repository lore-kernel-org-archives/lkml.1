Return-Path: <linux-kernel-owner+w=401wt.eu-S932791AbZLKWcX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932791AbZLKWcX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:32:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762753AbZLKWZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:25:13 -0500
Received: from kroah.org ([198.145.64.141]:32777 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762709AbZLKWY6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:24:58 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay.sievers@vrfy.org>, Mark Rosenstand <rosenstand@gmail.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 08/27] Driver-Core: devtmpfs - set root directory mode to 0755
Date: Fri, 11 Dec 2009 14:24:30 -0800
Message-Id: <1260570289-6997-8-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211212642.GA6624@kroah.com>
References: <20091211212642.GA6624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kay Sievers <kay.sievers@vrfy.org>

Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
Cc: Mark Rosenstand <rosenstand@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/devtmpfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index c7f5c08..50375bb 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -361,7 +361,7 @@ int __init devtmpfs_init(void)
 		return err;
 	}
 
-	mnt = kern_mount(&dev_fs_type);
+	mnt = kern_mount_data(&dev_fs_type, "mode=0755");
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
 		printk(KERN_ERR "devtmpfs: unable to create devtmpfs %i\n", err);
-- 
1.6.5.5

