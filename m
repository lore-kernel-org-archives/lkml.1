Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbYKTFlk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbYKTFlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 00:41:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbYKTFlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 00:41:24 -0500
Received: from fk-out-0910.google.com ([209.85.128.184]:35530 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031AbYKTFlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 00:41:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=to:cc:subject:date:message-id:x-mailer:in-reply-to:references:from;
        b=vTDL0951jJ60aCJOzdJJpb70HHlxlx7cmhDJxAGd01eY+9Z2kwgV4Q0NIMtyCRuxq3
         spzlWTpqgobFdSr9M+2slBLtN2JIjt3ZitYylyzCT5Ry2r5TdzCC7JrsbGdjONjeMmJN
         Bf1FjTbqdGCro+knKLOuiLK5YLSrKww67ytDw=
To: <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Borislav Petkov <petkovbb@gmail.com>
Subject: [PATCH 1/3] ide-cd: move debug defines into header
Date: Thu, 20 Nov 2008 06:41:21 +0100
Message-Id: <1227159683-2487-2-git-send-email-petkovbb@gmail.com>
X-Mailer: git-send-email 1.6.0.3
In-Reply-To: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
References: <1227159683-2487-1-git-send-email-petkovbb@gmail.com>
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-cd.c |    8 --------
 drivers/ide/ide-cd.h |    8 ++++++++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 5daa4dd..65e5513 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -53,14 +53,6 @@
 
 #include "ide-cd.h"
 
-#define IDECD_DEBUG_LOG		1
-
-#if IDECD_DEBUG_LOG
-#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
-#else
-#define ide_debug_log(lvl, fmt, args...) do {} while (0)
-#endif
-
 static DEFINE_MUTEX(idecd_ref_mutex);
 
 static void ide_cd_release(struct kref *);
diff --git a/drivers/ide/ide-cd.h b/drivers/ide/ide-cd.h
index d5ce336..389faa4 100644
--- a/drivers/ide/ide-cd.h
+++ b/drivers/ide/ide-cd.h
@@ -8,6 +8,14 @@
 #include <linux/cdrom.h>
 #include <asm/byteorder.h>
 
+#define IDECD_DEBUG_LOG		0
+
+#if IDECD_DEBUG_LOG
+#define ide_debug_log(lvl, fmt, args...) __ide_debug_log(lvl, fmt, args)
+#else
+#define ide_debug_log(lvl, fmt, args...) do {} while (0)
+#endif
+
 /*
  * typical timeout for packet command
  */
-- 
1.6.0.4

