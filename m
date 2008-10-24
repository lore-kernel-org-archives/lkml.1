Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYJXXKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYJXXKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 19:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbYJXXJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 19:09:58 -0400
Received: from smtp.movial.fi ([62.236.91.34]:45361 "EHLO smtp.movial.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757404AbYJXXJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 19:09:56 -0400
X-Greylist: delayed 1377 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Oct 2008 19:09:56 EDT
From: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [MIPS] sgi_btns: add license specification
Date: Sat, 25 Oct 2008 01:46:57 +0300
Message-Id: <1224888417-26494-2-git-send-email-dmitri.vorobiev@movial.fi>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi>
References: <1224888417-26494-1-git-send-email-dmitri.vorobiev@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SGI Volume Button interface driver uses GPL-only symbols
platform_driver_unregister and platform_driver_register, but
lacks license specification. Thus, when compiled as a module,
this driver cannot be installed. This patch fixes this by
adding the MODULE_LICENSE() specification.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
---
 drivers/input/misc/sgi_btns.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/input/misc/sgi_btns.c b/drivers/input/misc/sgi_btns.c
index ce238f5..be3a15f 100644
--- a/drivers/input/misc/sgi_btns.c
+++ b/drivers/input/misc/sgi_btns.c
@@ -174,5 +174,6 @@ static void __exit sgi_buttons_exit(void)
 	platform_driver_unregister(&sgi_buttons_driver);
 }
 
+MODULE_LICENSE("GPL");
 module_init(sgi_buttons_init);
 module_exit(sgi_buttons_exit);
-- 
1.5.4.3

