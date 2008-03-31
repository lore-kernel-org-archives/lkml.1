Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbYCaWIE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbYCaWIE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:08:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbYCaWHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:07:53 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:55717 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751755AbYCaWHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:07:53 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] [MIPS] make standard_io_resources[] static
Date: Tue,  1 Apr 2008 02:03:24 +0400
Message-Id: <1207001005-2633-6-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
References: <1207001005-2633-1-git-send-email-dmitri.vorobiev@gmail.com>
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10001; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The array standard_io_resources[] needs not to be exposed in the kernel
global namespace. This patch makes it static.

Successfully build-tested using default configs for Malta, Atlas
and SEAD boards.

Runtime test successfully performed by booting the Malta 4Kc board
up to the shell prompt.

Signed-off-by: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
---
 arch/mips/mips-boards/malta/malta_setup.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/mips-boards/malta/malta_setup.c b/arch/mips/mips-boards/malta/malta_setup.c
index 2cd8f57..a06e4b5 100644
--- a/arch/mips/mips-boards/malta/malta_setup.c
+++ b/arch/mips/mips-boards/malta/malta_setup.c
@@ -1,7 +1,7 @@
 /*
  * Carsten Langgaard, carstenl@mips.com
  * Copyright (C) 2000 MIPS Technologies, Inc.  All rights reserved.
- * Copyright (C) Dmitri Vorobiev
+ * Copyright (C) 2008 Dmitri Vorobiev
  *
  *  This program is free software; you can distribute it and/or modify it
  *  under the terms of the GNU General Public License (Version 2) as
@@ -36,7 +36,7 @@
 #include <linux/console.h>
 #endif
 
-struct resource standard_io_resources[] = {
+static struct resource standard_io_resources[] = {
 	{
 		.name = "dma1",
 		.start = 0x00,
-- 
1.5.3

