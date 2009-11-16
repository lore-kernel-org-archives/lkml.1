Return-Path: <linux-kernel-owner+w=401wt.eu-S1752003AbZKPFw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbZKPFw4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 00:52:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751451AbZKPFwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 00:52:55 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:45322 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbZKPFwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 00:52:55 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH] Kbuild: clean up marker
Date: Mon, 16 Nov 2009 13:49:54 +0800
Message-Id: <1258350595-19285-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4B00E8B8.00A8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop Module.markers from cleaning list.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index 8278361..1c8c3e1 100644
--- a/Makefile
+++ b/Makefile
@@ -1198,7 +1198,7 @@ MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-		  Module.symvers Module.markers tags TAGS cscope*
+		  Module.symvers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
@@ -1217,7 +1217,7 @@ clean: archclean $(clean-dirs)
 		\( -name '*.[oas]' -o -name '*.ko' -o -name '.*.cmd' \
 		-o -name '.*.d' -o -name '.*.tmp' -o -name '*.mod.c' \
 		-o -name '*.symtypes' -o -name 'modules.order' \
-		-o -name 'Module.markers' -o -name '.tmp_*.o.*' \
+		-o -name '.tmp_*.o.*' \
 		-o -name '*.gcno' \) -type f -print | xargs rm -f
 
 # mrproper - Delete all generated files, including .config
@@ -1415,7 +1415,6 @@ $(clean-dirs):
 
 clean:	rm-dirs := $(MODVERDIR)
 clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
-                   $(KBUILD_EXTMOD)/Module.markers \
                    $(KBUILD_EXTMOD)/modules.order
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
-- 
1.5.6

