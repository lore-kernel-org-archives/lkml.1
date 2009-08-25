Return-Path: <linux-kernel-owner+w=401wt.eu-S1754496AbZHYLZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbZHYLZk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 07:25:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZHYLZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 07:25:39 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:38195 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887AbZHYLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 07:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wMPcVGYcpIJy9JcWg5UV73J8WWl1NKyEipvkixqet2BWLk+oilQ2ZdApB/0WuWtIzx
         BkYDxVWmzMoiKR9iuPTr/dvaY2qdKGfgRmF8ayo5qhwttsvLRn4+x6X8F7BC8deV+n4n
         i0yvgmylV6CihUs6Uf6azHfMIHFD8XFCSzXN0=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] samsung-laptop: should include delay.h
Date: Tue, 25 Aug 2009 13:55:00 +0400
Message-Id: <1251194100-15472-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix this build error:
drivers/platform/x86/samsung-laptop.c:141: error: implicit declaration of function 'msleep'

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/platform/x86/samsung-laptop.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
index c6f9a86..19e0ef2 100644
--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -17,6 +17,7 @@
 #include <linux/fb.h>
 #include <linux/dmi.h>
 #include <linux/platform_device.h>
+#include <linux/delay.h>
 
 /*
  * This driver is needed because a number of Samsung laptops do not hook
-- 
1.6.4

