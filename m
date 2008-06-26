Return-Path: <linux-kernel-owner+w=401wt.eu-S1762596AbYFZNJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762596AbYFZNJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761850AbYFZMwf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:52:35 -0400
Received: from ns2.suse.de ([195.135.220.15]:39913 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759967AbYFZMwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:52:33 -0400
From: Bernhard Walle <bwalle@suse.de>
To: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, vgoyal@redhat.com, kexec@lists.infradead.org,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Remove experimental status of kdump on IA64
Date: Thu, 26 Jun 2008 14:53:11 +0200
Message-Id: <1214484791-25439-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the experimental status of kdump on IA64. kdump is on IA64
now since more than one year and it has proven to be stable.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/ia64/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 16be414..f548e43 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -539,8 +539,8 @@ config KEXEC
 	  strongly in flux, so no good recommendation can be made.
 
 config CRASH_DUMP
-	  bool "kernel crash dumps (EXPERIMENTAL)"
-	  depends on EXPERIMENTAL && IA64_MCA_RECOVERY && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
+	  bool "kernel crash dumps"
+	  depends on IA64_MCA_RECOVERY && !IA64_HP_SIM && (!SMP || HOTPLUG_CPU)
 	  help
 	    Generate crash dump after being started by kexec.
 
-- 
1.5.6

