Return-Path: <linux-kernel-owner+w=401wt.eu-S1760277AbXGJDgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760277AbXGJDgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 23:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754409AbXGJDfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 23:35:54 -0400
Received: from terminus.zytor.com ([192.83.249.54]:39388 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591AbXGJDfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 23:35:53 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
To: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       andi@firstfloor.org, akpm@linux-foundation.org
Cc: "H. Peter Anvin" <hpa@zytor.com>
Subject: [x86 setup 21/33] Version string for the new x86 setup code
Date: Mon,  9 Jul 2007 19:52:00 -0700
Message-Id: <11840381413065-git-send-email-hpa@zytor.com>
X-Mailer: git-send-email 1.5.2.2
In-Reply-To: <11840380363720-git-send-email-hpa@zytor.com>
References: <11840359321823-git-send-email-hpa@zytor.com>
 <11840360383913-git-send-email-hpa@zytor.com>
 <11840361432207-git-send-email-hpa@zytor.com>
 <11840362483663-git-send-email-hpa@zytor.com>
 <11840363531039-git-send-email-hpa@zytor.com>
 <11840364593068-git-send-email-hpa@zytor.com>
 <1184036564610-git-send-email-hpa@zytor.com>
 <11840366692770-git-send-email-hpa@zytor.com>
 <11840367741994-git-send-email-hpa@zytor.com>
 <11840368791603-git-send-email-hpa@zytor.com>
 <11840369841576-git-send-email-hpa@zytor.com>
 <11840370903975-git-send-email-hpa@zytor.com>
 <11840371953778-git-send-email-hpa@zytor.com>
 <11840373002601-git-send-email-hpa@zytor.com>
 <11840374052662-git-send-email-hpa@zytor.com>
 <1184037510289-git-send-email-hpa@zytor.com>
 <11840376162370-git-send-email-hpa@zytor.com>
 <11840377211519-git-send-email-hpa@zytor.com>
 <11840378261081-git-send-email-hpa@zytor.com>
 <11840379311574-git-send-email-hpa@zytor.com>
 <11840380363720-git-send-email-hpa@zytor.com>
Message-Id: <b4eed00df1889f94e8799ca6c0ce081bc5140688.1184032749.git.hpa@zytor.com>
In-Reply-To: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
References: <2034f71d414def30de582fb59573295cadbdabb4.1184032748.git.hpa@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Module which only includes the kernel version string.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/i386/boot/version.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)
 create mode 100644 arch/i386/boot/version.c

diff --git a/arch/i386/boot/version.c b/arch/i386/boot/version.c
new file mode 100644
index 0000000..c61462f
--- /dev/null
+++ b/arch/i386/boot/version.c
@@ -0,0 +1,23 @@
+/* -*- linux-c -*- ------------------------------------------------------- *
+ *
+ *   Copyright (C) 1991, 1992 Linus Torvalds
+ *   Copyright 2007 rPath, Inc. - All Rights Reserved
+ *
+ *   This file is part of the Linux kernel, and is made available under
+ *   the terms of the GNU General Public License version 2.
+ *
+ * ----------------------------------------------------------------------- */
+
+/*
+ * arch/i386/boot/version.c
+ *
+ * Kernel version string
+ */
+
+#include "boot.h"
+#include <linux/utsrelease.h>
+#include <linux/compile.h>
+
+const char kernel_version[] =
+	UTS_RELEASE " (" LINUX_COMPILE_BY "@" LINUX_COMPILE_HOST ") "
+	UTS_VERSION;
-- 
1.5.2.2

