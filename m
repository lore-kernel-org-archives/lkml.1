Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0CJFgY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 00:36:24 -0500
Received: from netl01.es2u.com ([202.71.108.95]:43706 "EHLO netl01.es2u.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab0CJFgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 00:36:23 -0500
X-Greylist: delayed 13071 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Mar 2010 00:36:22 EST
Message-ID: <4B96FD64.9070305@ngiap.com>
Date: Wed, 10 Mar 2010 10:01:08 +0800
From: steven yong <stevenyong@ngiap.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Thunderbird/3.0.1
MIME-Version: 1.0
To: gregkh@suse.de, peterhuewe@gmx.de, sudhakar.raj@ti.com, mmarek@suse.cz,
       abogani@texware.it
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: panel: correct the include path of uaccess.h in
 panel.c
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - netl01.es2u.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ngiap.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the panel.c file that fixes up a #include warning
found by the checkpatch.pl tool
---
Signed-off-by: Steven Yong <stevenyong@ngiap.com>

 drivers/staging/panel/panel.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
index 377884f..f9fcb2f 100644
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -57,7 +57,7 @@
 #include <generated/utsrelease.h>
 
 #include <linux/io.h>
-#include <asm/uaccess.h>
+#include <linux/uaccess.h>
 #include <asm/system.h>
 
 #define LCD_MINOR        156
-- 
1.6.5.1

