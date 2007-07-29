Return-Path: <linux-kernel-owner+w=401wt.eu-S932988AbXG2PMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988AbXG2PMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764628AbXG2O77
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:59 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47879 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764538AbXG2O76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:58 -0400
Date: Sun, 29 Jul 2007 16:59:35 +0200
From: Adrian Bunk <bunk@stusta.de>
To: pavel@suse.cz, rjw@sisk.pl
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] unexport pm_power_off_prepare
Message-ID: <20070729145935.GJ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the unused EXPORT_SYMBOL(pm_power_off_prepare).

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/kernel/sys.c.old	2007-07-28 07:38:45.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/sys.c	2007-07-28 07:38:59.000000000 +0200
@@ -104,7 +104,6 @@ EXPORT_SYMBOL(cad_pid);
  */
 
 void (*pm_power_off_prepare)(void);
-EXPORT_SYMBOL(pm_power_off_prepare);
 
 static int set_one_prio(struct task_struct *p, int niceval, int error)
 {

