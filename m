Return-Path: <linux-kernel-owner+w=401wt.eu-S1760539AbXGUD6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760539AbXGUD6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 23:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbXGUD6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 23:58:25 -0400
Received: from [212.12.190.69] ([212.12.190.69]:33252 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750878AbXGUD6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 23:58:25 -0400
From: Al Boldi <a1426z@gawab.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Kconfig:  Remove top level menu "Code maturity level options"
Date: Sat, 21 Jul 2007 06:58:28 +0300
User-Agent: KMail/1.5
Cc: Andrew Morton <akpm@osdl.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707210658.28241.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes the top level menu "Code maturity level options", and 
moves its options into menu "General setup".

This makes Kconfig less cluttered and easier to setup.


Cc: Andrew Morton <akpm@osdl.org>
Signed-off-by: Al Boldi <a1426z@gawab.com>

---
--- a/init/Kconfig	2007-07-09 06:38:47.000000000 +0300
+++ b/init/Kconfig	2007-07-21 06:42:06.000000000 +0300
@@ -7,7 +7,7 @@ config DEFCONFIG_LIST
 	default "/boot/config-$UNAME_RELEASE"
 	default "arch/$ARCH/defconfig"
 
-menu "Code maturity level options"
+menu "General setup"
 
 config EXPERIMENTAL
 	bool "Prompt for development and/or incomplete code/drivers"
@@ -61,9 +61,6 @@ config INIT_ENV_ARG_LIMIT
 	  Maximum of each of the number of arguments and environment
 	  variables passed to init from the kernel command line.
 
-endmenu
-
-menu "General setup"
 
 config LOCALVERSION
 	string "Local version - append to kernel release"

