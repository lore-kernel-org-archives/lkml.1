Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbYFZNKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbYFZNKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 09:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762695AbYFZM4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:56:38 -0400
Received: from cantor.suse.de ([195.135.220.2]:51621 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758491AbYFZM4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:56:37 -0400
From: Bernhard Walle <bwalle@suse.de>
To: linuxppc-dev@ozlabs.org
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, vgoyal@redhat.com,
       Bernhard Walle <bwalle@suse.de>
Subject: [PATCH] Remove experimental status of kdump on PPC64
Date: Thu, 26 Jun 2008 14:57:15 +0200
Message-Id: <1214485035-26041-1-git-send-email-bwalle@suse.de>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the experimental status of kdump on IA64. kdump is on IA64
now since more than one year and it has proven to be stable.

For i386/x86_64, a similar patch has been accepted by Ingo Molnar and Vivek
Goyal.


Signed-off-by: Bernhard Walle <bwalle@suse.de>
---
 arch/powerpc/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 3934e26..2a116b9 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -308,8 +308,8 @@ config KEXEC
 	  strongly in flux, so no good recommendation can be made.
 
 config CRASH_DUMP
-	bool "Build a kdump crash kernel (EXPERIMENTAL)"
-	depends on PPC_MULTIPLATFORM && PPC64 && EXPERIMENTAL
+	bool "Build a kdump crash kernel"
+	depends on PPC_MULTIPLATFORM && PPC64
 	help
 	  Build a kernel suitable for use as a kdump capture kernel.
 	  The kernel will be linked at a different address than normal, and
-- 
1.5.6

