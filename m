Return-Path: <linux-kernel-owner+w=401wt.eu-S932142AbZKSArF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142AbZKSArF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 19:47:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbZKSArE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 19:47:04 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:53321 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbZKSArE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 19:47:04 -0500
From: Wenji Huang <wenji.huang@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, akpm@linux-foundation.org,
       Wenji Huang <wenji.huang@oracle.com>
Subject: [PATCH v2] Kbuild: clean up marker
Date: Thu, 19 Nov 2009 08:44:32 +0800
Message-Id: <1258591472-13240-1-git-send-email-wenji.huang@oracle.com>
X-Mailer: git-send-email 1.5.6
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B049564.0109:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop Module.markers from cleaning list since marker 
is removed.

Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
---
 Makefile |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index aa3e13a..a2343b1 100644
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

