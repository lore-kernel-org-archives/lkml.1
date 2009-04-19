Return-Path: <linux-kernel-owner+w=401wt.eu-S1761327AbZDSRKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761327AbZDSRKg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 13:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751359AbZDSRK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 13:10:28 -0400
Received: from fallback-out1.mxes.net ([216.86.168.190]:2021 "EHLO
	fallback-in1.mxes.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751154AbZDSRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 13:10:27 -0400
X-Greylist: delayed 723 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Apr 2009 13:10:27 EDT
From: =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Bri=C3=A8re?= <fbriere@fbriere.net>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] kbuild: clean Module.markers and modules.order for out-of-tree modules
Date: Sun, 19 Apr 2009 12:58:40 -0400
Message-Id: <1240160320-7466-1-git-send-email-fbriere@fbriere.net>
X-Mailer: git-send-email 1.6.2.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Frédéric Brière <fbriere@fbriere.net>
---
 Makefile |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index bfdef56..afbef69 100644
--- a/Makefile
+++ b/Makefile
@@ -1421,7 +1421,9 @@ $(clean-dirs):
 	$(Q)$(MAKE) $(clean)=$(patsubst _clean_%,%,$@)
 
 clean:	rm-dirs := $(MODVERDIR)
-clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers
+clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers \
+                   $(KBUILD_EXTMOD)/Module.markers \
+                   $(KBUILD_EXTMOD)/modules.order
 clean: $(clean-dirs)
 	$(call cmd,rmdirs)
 	$(call cmd,rmfiles)
-- 
1.6.2.1

