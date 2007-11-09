Return-Path: <linux-kernel-owner+w=401wt.eu-S1762627AbXKIGEe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627AbXKIGEe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 01:04:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbXKIGDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 01:03:41 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52864 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751744AbXKIGDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 01:03:39 -0500
Date: Fri, 9 Nov 2007 07:03:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86 mce_64.c: make struct mcelog static
Message-ID: <20071109060316.GT26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global struct mcelog static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
d4c45993fc617ff0f56e3280fcccb7159b31e9e8 
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index b9f802e..986bf15 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -63,7 +63,7 @@ static DECLARE_WAIT_QUEUE_HEAD(mce_wait);
  * separate MCEs from kernel messages to avoid bogus bug reports.
  */
 
-struct mce_log mcelog = {
+static struct mce_log mcelog = {
 	MCE_LOG_SIGNATURE,
 	MCE_LOG_LEN,
 };

