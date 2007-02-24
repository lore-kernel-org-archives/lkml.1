Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbXBXMWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbXBXMWi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750977AbXBXMWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:22:38 -0500
Received: from ftp.linux-mips.org ([194.74.144.162]:41942 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbXBXMWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:22:38 -0500
Date: Sat, 24 Feb 2007 12:22:11 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] <linux/sysdev.h> needs to include <linux/module.h>
Message-ID: <20070224122211.GA17040@linux-mips.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

sysdev.h uses THIS_MODULE so should include <linux/module.h>.

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

diff --git a/include/linux/sysdev.h b/include/linux/sysdev.h
index 389ccf8..e699ab2 100644
--- a/include/linux/sysdev.h
+++ b/include/linux/sysdev.h
@@ -22,6 +22,7 @@
 #define _SYSDEV_H_
 
 #include <linux/kobject.h>
+#include <linux/module.h>
 #include <linux/pm.h>
 
 
