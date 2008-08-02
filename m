Return-Path: <linux-kernel-owner+w=401wt.eu-S1757801AbYHBQy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801AbYHBQy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:54:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755738AbYHBQyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:54:52 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:49610 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755662AbYHBQyw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:54:52 -0400
Date: Sat, 2 Aug 2008 19:53:44 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] sh/boards/Makefile typo fix
Message-ID: <20080802165344.GP19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following build error was caused by an obvious typo:

<--  snip  -->

...
  LD      arch/sh/mm/built-in.o
make[2]: *** No rule to make target `arch/sh/boards/board-shmin..o', needed by `arch/sh/boards/built-in.o'.  Stop.

<--  snip  -->

Reported-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
399bc393a7499892af33d7a4621516c5f5c359d8 
diff --git a/arch/sh/boards/Makefile b/arch/sh/boards/Makefile
index ff9b93c..463022c 100644
--- a/arch/sh/boards/Makefile
+++ b/arch/sh/boards/Makefile
@@ -5,4 +5,4 @@ obj-$(CONFIG_SH_AP325RXA)	+= board-ap325rxa.o
 obj-$(CONFIG_SH_MAGIC_PANEL_R2)	+= board-magicpanelr2.o
 obj-$(CONFIG_SH_RSK7203)	+= board-rsk7203.o
 obj-$(CONFIG_SH_SH7785LCR)	+= board-sh7785lcr.o
-obj-$(CONFIG_SH_SHMIN)		+= board-shmin..o
+obj-$(CONFIG_SH_SHMIN)		+= board-shmin.o

