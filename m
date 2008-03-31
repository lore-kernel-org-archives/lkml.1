Return-Path: <linux-kernel-owner+w=401wt.eu-S1758544AbYCaJLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544AbYCaJLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 05:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756259AbYCaJIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 05:08:22 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:54086 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756187AbYCaJIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 05:08:20 -0400
Date: Mon, 31 Mar 2008 12:08:05 +0300
From: Adrian Bunk <bunk@kernel.org>
To: bzolnier@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>
Subject: [2.6.25 patch] ide/legacy/q40ide.c: add MODULE_LICENSE
Message-ID: <20080331090805.GP28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that it can be built modular it needs a MODULE_LICENSE.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
b6aa1f0123d81fbd4224a352161e6838d39b060d diff --git a/drivers/ide/legacy/q40ide.c b/drivers/ide/legacy/q40ide.c
index 1381b91..2da2875 100644
--- a/drivers/ide/legacy/q40ide.c
+++ b/drivers/ide/legacy/q40ide.c
@@ -153,3 +153,5 @@ static int __init q40ide_init(void)
 }
 
 module_init(q40ide_init);
+
+MODULE_LICENSE("GPL");

