Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXKBPne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXKBPne (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755897AbXKBPnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:43:22 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:49688 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755561AbXKBPnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:43:21 -0400
Date: Fri, 2 Nov 2007 16:42:58 +0100
From: Adrian Bunk <bunk@kernel.org>
To: lenb@kernel.org
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] linux/init.h: simplify __mem{init,exit}* dependencies
Message-ID: <20071102154258.GH30287@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch simplifies the dependencies on __mem{init,exit}*
(ACPI_HOTPLUG_MEMORY requires MEMORY_HOTPLUG).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
7f058c09288450736c541f6a5d043abd86d0c3bb 
diff --git a/include/linux/init.h b/include/linux/init.h
index 5141381..7dc5085 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -278,8 +278,7 @@ void __init parse_early_param(void);
 #define __cpuexitdata	__exitdata
 #endif
 
-#if defined(CONFIG_MEMORY_HOTPLUG) || defined(CONFIG_ACPI_HOTPLUG_MEMORY) \
-	|| defined(CONFIG_ACPI_HOTPLUG_MEMORY_MODULE)
+#if defined(CONFIG_MEMORY_HOTPLUG)
 #define __meminit
 #define __meminitdata
 #define __memexit

