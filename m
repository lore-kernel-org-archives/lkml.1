Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0CLIaL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 03:30:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:39682 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab0CLIaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 03:30:08 -0500
From: Arun Bhanu <arun@bhanu.net>
To: linux-kernel@vger.kernel.org, microblaze-uclinux@itee.uq.edu.au
Cc: Michal Simek <monstr@monstr.eu>, Arun Bhanu <arun@bhanu.net>
Subject: [PATCH] microblaze: Add a missing single quote to make 'make help' happy
Date: Fri, 12 Mar 2010 16:31:40 +0800
Message-Id: <1268382700-18218-1-git-send-email-arun@bhanu.net>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'make ARCH=microblaze help' fails with the following error due to a
missing single quote.

/bin/sh: -c: line 0: unexpected EOF while looking for matching `''
/bin/sh: -c: line 1: syntax error: unexpected end of file
make: *** [help] Error 2

Signed-off-by: Arun Bhanu <arun@bhanu.net>
---
 arch/microblaze/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/microblaze/Makefile b/arch/microblaze/Makefile
index d2d6cfc..f49d8e6 100644
--- a/arch/microblaze/Makefile
+++ b/arch/microblaze/Makefile
@@ -83,7 +83,7 @@ define archhelp
   echo '* linux.bin    - Create raw binary'
   echo '  linux.bin.gz - Create compressed raw binary'
   echo '  simpleImage.<dt> - ELF image with $(arch)/boot/dts/<dt>.dts linked in'
-  echo '                   - stripped elf with fdt blob
+  echo '                   - stripped elf with fdt blob'
   echo '  simpleImage.<dt>.unstrip - full ELF image with fdt blob'
   echo '  *_defconfig      - Select default config from arch/microblaze/configs'
   echo ''
-- 
1.6.2.5

