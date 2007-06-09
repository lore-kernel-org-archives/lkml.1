Return-Path: <linux-kernel-owner+w=401wt.eu-S1762258AbXFIINk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762258AbXFIINk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 04:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756237AbXFIIN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 04:13:27 -0400
Received: from host86-137-96-215.range86-137.btcentralplus.com ([86.137.96.215]:39736
	"EHLO hawkeye.stone.uk.eu.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755538AbXFIIN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 04:13:26 -0400
Message-ID: <466A610B.3030903@hawkeye.stone.uk.eu.org>
Date: Sat, 09 Jun 2007 09:12:59 +0100
From: Jack Stone <jack@hawkeye.stone.uk.eu.org>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: hpa@zytor.com, Ian Kent <raven@themaw.net>
Subject: [PATCH 4/7] Update DPRINTK macro to use pr_debug
References: <4669D5B7.7050005@hawkeye.stone.uk.eu.org> <466A5E28.2000707@hawkeye.stone.uk.eu.org>
In-Reply-To: <466A5E28.2000707@hawkeye.stone.uk.eu.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the DPRINTK macro in autofs4 to use pr_debug as the
macro uses a special print format.

Signed-off-by Jack Stone <jack@hawkeye.stone.uk.eu.org>
---
Index: linux/fs/autofs4/autofs_i.h
===================================================================
--- linux.orig/fs/autofs4/autofs_i.h
+++ linux/fs/autofs4/autofs_i.h
@@ -35,7 +35,7 @@
 /* #define DEBUG */

 #ifdef DEBUG
-#define DPRINTK(fmt,args...) do { printk(KERN_DEBUG "pid %d: %s: " fmt
"\n" , current->pid , __FUNCTION__ , ##args); } while(0)
+#define DPRINTK(fmt,args...) do { pr_debug("pid %d: %s: " fmt "\n" ,
current->pid , __FUNCTION__ , ##args); } while(0)
 #else
 #define DPRINTK(fmt,args...) do {} while(0)
 #endif


