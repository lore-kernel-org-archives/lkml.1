Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbYB0UL3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbYB0UL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 15:11:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbYB0ULV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 15:11:21 -0500
Received: from xenotime.net ([66.160.160.81]:60062 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757102AbYB0ULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 15:11:21 -0500
Date: Wed, 27 Feb 2008 12:11:16 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: kernel@wantstofly.org, nico@cam.org, rmk@arm.linux.org.uk
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] arm: eliminate MODULE_PARM() usage
Message-Id: <20080227121116.bd9ee5aa.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Convert debug-only (and removed) MODULE_PARM() to module_param().
Compiles cleanly (with DEBUG=1).

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/arm/mach-pxa/cpu-pxa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- next-20080227.orig/arch/arm/mach-pxa/cpu-pxa.c
+++ next-20080227/arch/arm/mach-pxa/cpu-pxa.c
@@ -43,7 +43,7 @@
 
 #ifdef DEBUG
 static unsigned int freq_debug;
-MODULE_PARM(freq_debug, "i");
+module_param(freq_debug, uint, 0);
 MODULE_PARM_DESC(freq_debug, "Set the debug messages to on=1/off=0");
 #else
 #define freq_debug  0
