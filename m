Return-Path: <linux-kernel-owner+w=401wt.eu-S1422883AbXBANxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422883AbXBANxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 08:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422886AbXBANxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 08:53:08 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:40152 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422880AbXBANwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 08:52:54 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] efi_set_rtc_mmss() is not __init
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HCcMw-0007S6-03@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Thu, 01 Feb 2007 13:52:54 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


fix the extern in efi.h

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 include/linux/efi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index df1c918..f8ebd7c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -301,7 +301,7 @@ extern int __init efi_uart_console_only (void);
 extern void efi_initialize_iomem_resources(struct resource *code_resource,
 					struct resource *data_resource);
 extern unsigned long efi_get_time(void);
-extern int __init efi_set_rtc_mmss(unsigned long nowtime);
+extern int efi_set_rtc_mmss(unsigned long nowtime);
 extern int is_available_memory(efi_memory_desc_t * md);
 extern struct efi_memory_map memmap;
 
-- 
1.5.0-rc2.GIT


