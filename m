Return-Path: <linux-kernel-owner+w=401wt.eu-S1758468AbXFQXnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468AbXFQXnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 19:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761802AbXFQXmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 19:42:46 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37895 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761968AbXFQXmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 19:42:45 -0400
Date: Mon, 18 Jun 2007 01:43:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/sys_ni.c should #include <linux/syscalls.h>
Message-ID: <20070617234301.GF3588@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
it's global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc4-mm2/kernel/sys_ni.c.old	2007-06-17 16:03:11.000000000 +0200
+++ linux-2.6.22-rc4-mm2/kernel/sys_ni.c	2007-06-17 16:03:30.000000000 +0200
@@ -1,6 +1,7 @@
 
 #include <linux/linkage.h>
 #include <linux/errno.h>
+#include <linux/syscalls.h>
 
 #include <asm/unistd.h>
 

