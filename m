Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927AbYKGUY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927AbYKGUY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 15:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbYKGUYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 15:24:51 -0500
Received: from mail.cyberdogtech.com ([64.22.125.39]:40364 "EHLO
	mail.cyberdogtech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYKGUYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 15:24:51 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Nov 2008 15:24:51 EST
From: Matt LaPlante <kernel1@cyberdogtech.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Matt LaPlante <kernel1@cyberdogtech.com>
Subject: [PATCH] Change default for STRICT_DEVMEM
Date: Fri,  7 Nov 2008 14:18:36 -0600
Message-Id: <1226089116-7700-1-git-send-email-kernel1@cyberdogtech.com>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recommendation for STRICT_DEVMEM is to select Y,
however the option currently defaults to N.  Have the option
default to Y since it is recommended.

---
 arch/x86/Kconfig.debug |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 2a3dfbd..a03597c 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -7,6 +7,7 @@ source "lib/Kconfig.debug"
 
 config STRICT_DEVMEM
 	bool "Filter access to /dev/mem"
+	default y
 	help
 	  If this option is disabled, you allow userspace (root) access to all
 	  of memory, including kernel and userspace memory. Accidental
-- 
1.5.6.3

