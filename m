Return-Path: <linux-kernel-owner+w=401wt.eu-S1758524AbYFVWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758524AbYFVWI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756085AbYFVWIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 18:08:04 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:60314 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516AbYFVWH7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 18:07:59 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/5] kbuild: include/asm may be a file - fix mrproper for this
Date: Mon, 23 Jun 2008 00:08:41 +0200
Message-Id: <1214172524-9043-2-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.4.1.143.ge7e51
In-Reply-To: <20080622220508.GA8957@uranus.ravnborg.org>
References: <20080622220508.GA8957@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I upcoming patch include/asm is a directory when we do
a "make O=..." build, so teach mrproper to handle this

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 4ea5189..ef30745 100644
--- a/Makefile
+++ b/Makefile
@@ -1120,8 +1120,8 @@ CLEAN_FILES +=	vmlinux System.map \
                 .tmp_kallsyms* .tmp_version .tmp_vmlinux* .tmp_System.map
 
 # Directories & files removed with 'make mrproper'
-MRPROPER_DIRS  += include/config include2 usr/include
-MRPROPER_FILES += .config .config.old include/asm .version .old_version \
+MRPROPER_DIRS  += include/config include2 usr/include include/asm
+MRPROPER_FILES += .config .config.old .version .old_version             \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-- 
1.5.4.1.143.ge7e51

