Return-Path: <linux-kernel-owner+w=401wt.eu-S969726AbXFHW2y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969726AbXFHW2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 18:28:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970836AbXFHW2P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 18:28:15 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:41954
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S970756AbXFHW2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 18:28:14 -0400
Message-ID: <4669D619.6000801@hawkeye.stone.uk.eu.org>
Date: Fri, 08 Jun 2007 23:20:09 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, raven@themaw.net
Subject: [PATCH 1/7] Add a new debug function to kernel.h
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
In-Reply-To: <4669D5B7.7050005@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jack Stone <jack@hawkeye.stone.uk.eu.org>
---

Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -228,11 +228,18 @@ extern void print_hex_dump(const char *l
 /* If you are writing a driver, please use dev_dbg instead */
 #define pr_debug(fmt,arg...) \
 	printk(KERN_DEBUG fmt,##arg)
+#define pr_err(fmt,arg...) \
+	printk(KERN_ERR fmt,##arg)
 #else
 static inline int __attribute__ ((format (printf, 1, 2)))
pr_debug(const char * fmt, ...)
 {
 	return 0;
 }
+
+static inline int __attribute__ ((format (printf, 1, 2))) pr_err(const
char * fmt, ...)
+{
+	return 0;
+}
 #endif

 #define pr_info(fmt,arg...) \

--

