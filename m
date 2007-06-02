Return-Path: <linux-kernel-owner+w=401wt.eu-S1763705AbXFBTJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763705AbXFBTJd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 15:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763426AbXFBTJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 15:09:10 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:51897 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1763399AbXFBTJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 15:09:08 -0400
Date: Sat, 2 Jun 2007 21:09:11 +0200
From: Adrian Bunk <bunk@stusta.de>
To: paulus@samba.org
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] make drivers/char/hvc_console.c:khvcd() static
Message-ID: <20070602190911.GL5500@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlesly global khvcd() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc3-mm1/drivers/char/hvc_console.c.old	2007-06-02 19:58:07.000000000 +0200
+++ linux-2.6.22-rc3-mm1/drivers/char/hvc_console.c	2007-06-02 19:58:28.000000000 +0200
@@ -674,7 +674,7 @@
  * calling hvc_poll() who determines whether a console adapter support
  * interrupts.
  */
-int khvcd(void *unused)
+static int khvcd(void *unused)
 {
 	int poll_mask;
 	struct hvc_struct *hp;

