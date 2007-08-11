Return-Path: <linux-kernel-owner+w=401wt.eu-S1761408AbXHKOkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761408AbXHKOkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 10:40:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbXHKOki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 10:40:38 -0400
Received: from ipn26-148.piekary.net ([83.238.26.148]:52093 "EHLO spock.one.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755813AbXHKOkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 10:40:37 -0400
Date: Sat, 11 Aug 2007 16:40:13 +0200
From: Michal Januszewski <spock@gentoo.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] uvesafb: fix a typo in a warning
Message-ID: <20070811144013.GD13632@spock.one.pl>
Reply-To: spock@gentoo.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Replace "vesafb" with "uvesafb" in a kernel warning message.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
---
diff --git a/drivers/video/uvesafb.c b/drivers/video/uvesafb.c
--- a/drivers/video/uvesafb.c
+++ b/drivers/video/uvesafb.c
@@ -408,7 +412,7 @@ static void uvesafb_vbe_state_restore(struct uvesafb_par *par, u8 *state_buf)
 
 	err = uvesafb_exec(task);
 	if (err || (task->t.regs.eax & 0xffff) != 0x004f)
-		printk(KERN_WARNING "vesafb: VBE state restore call "
+		printk(KERN_WARNING "uvesafb: VBE state restore call "
 				"failed (eax=0x%x, err=%d)\n",
 				task->t.regs.eax, err);
 

