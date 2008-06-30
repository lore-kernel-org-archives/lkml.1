Return-Path: <linux-kernel-owner+w=401wt.eu-S933605AbYF3Vmp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbYF3Vmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 17:42:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932948AbYF3Ve7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 17:34:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:48250 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763179AbYF3Ved (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 17:34:33 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: kbuild <linux-kbuild@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 18/24] kbuild: remove Module.markers during mrproper
Date: Mon, 30 Jun 2008 23:35:12 +0200
Message-Id: <1214861718-32626-18-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.5.6.1.93.gef98
In-Reply-To: <20080630213155.GA32479@uranus.ravnborg.org>
References: <20080630213155.GA32479@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index 4a1ed80..f2c181a 100644
--- a/Makefile
+++ b/Makefile
@@ -1140,7 +1140,7 @@ MRPROPER_FILES += .config .config.old include/asm .version .old_version \
                   include/linux/autoconf.h include/linux/version.h      \
                   include/linux/utsrelease.h                            \
                   include/linux/bounds.h include/asm*/asm-offsets.h     \
-		  Module.symvers tags TAGS cscope*
+		  Module.symvers Module.markers tags TAGS cscope*
 
 # clean - Delete most, but leave enough to build external modules
 #
-- 
1.5.6.1.93.gef98

