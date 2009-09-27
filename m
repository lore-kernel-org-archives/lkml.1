Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZI0Ct4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZI0Ct4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 22:49:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZI0Ct4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 22:49:56 -0400
Received: from mail-yx0-f199.google.com ([209.85.210.199]:36055 "EHLO
	mail-yx0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbZI0Ctz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 22:49:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=rGDyMcaC8XOhsnC9sWxV6rr8ml4twJzMgHHoB9/0X1phmJ3Ams1yv+NnpUwrX0xeAE
         zb4knd8F+9bV9WxeMaTUxdqn5SFl8xF0Tnj5Dd3kMQyOCTtYD6QFZt8iQzSC5LxPW7CJ
         l3hm7bVOqzdaEZHTQNNWfyRuRnigysk3zsDdg=
From: Huang Shijie <shijie8@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Huang Shijie <shijie8@gmail.com>
Subject: [PATCH] add comment for "make help"
Date: Sun, 27 Sep 2009 10:49:52 +0800
Message-Id: <1254019792-14890-1-git-send-email-shijie8@gmail.com>
X-Mailer: git-send-email 1.6.0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "make cscope(tags)" only generate the tag database for the current
architecture.

So add this comment to remind the people.

Signed-off-by: Huang Shijie <shijie8@gmail.com>
---
 Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/Makefile b/Makefile
index f908acc..ad2c20d 100644
--- a/Makefile
+++ b/Makefile
@@ -1331,6 +1331,7 @@ help:
 	@echo  '  modules_prepare - Set up for building external modules'
 	@echo  '  tags/TAGS	  - Generate tags file for editors'
 	@echo  '  cscope	  - Generate cscope index'
+	@echo  '                    (default: $(SRCARCH), see scripts/tags.sh for more architectures)';
 	@echo  '  kernelrelease	  - Output the release version string'
 	@echo  '  kernelversion	  - Output the version stored in Makefile'
 	@echo  '  headers_install - Install sanitised kernel headers to INSTALL_HDR_PATH'; \
-- 
1.6.0.6

