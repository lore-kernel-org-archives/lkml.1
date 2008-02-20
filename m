Return-Path: <linux-kernel-owner+w=401wt.eu-S934125AbYBTU6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125AbYBTU6o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:58:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765171AbYBTU5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:57:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:25350 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763118AbYBTU5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:57:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:content-type:content-transfer-encoding;
        b=S3dXh5B1lKPpCSQdyuTNVT/1cNmN0ihoLgx4QAOUZwFCbxco7KimPZnAskVV5xnONvxCKNZXdD2il5EW3BWA4THkfdCoNMjma/TU7sWV2eqWX1LWT127dFQ8mtEYijJc/DXKH3oiTdkiLfeMhXma97YWDuIX48TZu5UZQ/ZyQIs=
Message-ID: <47BC9433.8020905@gmail.com>
Date: Wed, 20 Feb 2008 21:57:23 +0100
From: Jiri Olsa <olsajiri@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: gregkh@suse.de
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] fs: removing unused fops from struct char_device_struct
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

seems struct char_device_struct::fops is no longer used, removing it.
I checked with "make allyesconfig" and got proper compile.

Signed-off-by: Jiri Olsa <olsajiri@gmail.com>
---
 fs/char_dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index c3bfa76..e4527fb 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -55,7 +55,6 @@ static struct char_device_struct {
 	unsigned int baseminor;
 	int minorct;
 	char name[64];
-	struct file_operations *fops;
 	struct cdev *cdev;		/* will die */
 } *chrdevs[CHRDEV_MAJOR_HASH_SIZE];
 
