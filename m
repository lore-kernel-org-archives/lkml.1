Return-Path: <linux-kernel-owner+w=401wt.eu-S1754814AbYL0UXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbYL0UXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Dec 2008 15:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754058AbYL0UXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Dec 2008 15:23:37 -0500
Received: from mail.parknet.ad.jp ([210.171.162.6]:59110 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbYL0UXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Dec 2008 15:23:36 -0500
X-Greylist: delayed 363 seconds by postgrey-1.27 at vger.kernel.org; Sat, 27 Dec 2008 15:23:36 EST
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hirofumi@mail.parknet.co.jp
Subject: [PATCH] fat: fix duplicate addition of ->llseek handler
Date: Sun, 28 Dec 2008 05:17:24 +0900
Message-Id: <985eafcc5480b0d98419b96869f2560abb2764c7.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Mailer: git-send-email 1.6.0.5.dirty
In-Reply-To: <ebeb0406f153db51ab2d4771faf2342bd6ca14dd.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
 <ebeb0406f153db51ab2d4771faf2342bd6ca14dd.1230408710.git.hirofumi@mail.parknet.co.jp>
In-Reply-To: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
References: <cover.1230408710.git.hirofumi@mail.parknet.co.jp>
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---
 fs/fat/dir.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 67e0583..3a7f603 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -841,7 +841,6 @@ const struct file_operations fat_dir_operations = {
 	.compat_ioctl	= fat_compat_dir_ioctl,
 #endif
 	.fsync		= file_fsync,
-	.llseek		= generic_file_llseek,
 };
 
 static int fat_get_short_entry(struct inode *dir, loff_t *pos,
-- 
1.6.0.5.dirty

