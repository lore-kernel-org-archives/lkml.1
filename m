Return-Path: <linux-kernel-owner+w=401wt.eu-S1753545AbZHKMM1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545AbZHKMM1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 08:12:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbZHKMM0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 08:12:26 -0400
Received: from server1.wserver.cz ([82.113.45.157]:35056 "EHLO
	server1.wserver.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbZHKMM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 08:12:26 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
       Renzo Davoli <renzo@cs.unibo.it>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/1] fs-char_devc-remove-useless-loop fix
Date: Tue, 11 Aug 2009 11:08:09 +0200
Message-Id: <1249981689-10482-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compilation warning:
fs/char_dev.c: In function `register_chrdev':
fs/char_dev.c:267: warning: unused variable `s'

Cc: Renzo Davoli <renzo@cs.unibo.it>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 fs/char_dev.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/char_dev.c b/fs/char_dev.c
index e29f4be..33327d6 100644
--- a/fs/char_dev.c
+++ b/fs/char_dev.c
@@ -264,7 +264,6 @@ int register_chrdev(unsigned int major, const char *name,
 {
 	struct char_device_struct *cd;
 	struct cdev *cdev;
-	char *s;
 	int err = -ENOMEM;
 
 	cd = __register_chrdev_region(major, 0, 256, name);
-- 
1.6.3.3

