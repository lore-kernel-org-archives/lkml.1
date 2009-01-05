Return-Path: <linux-kernel-owner+w=401wt.eu-S1752632AbZAERTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbZAERTc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 12:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbZAERTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 12:19:06 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:36609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbZAERTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 12:19:04 -0500
To: torvalds@linux-foundation.org
Subject: X86_DEBUGCTLMSR won't work on uml
Cc: jdike@addtoit.com, linux-kernel@vger.kernel.org
Message-Id: <E1LJt6U-0003Tg-TZ@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Mon, 05 Jan 2009 17:19:02 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index 85a7857..8078955 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -408,7 +408,7 @@ config X86_MINIMUM_CPU_FAMILY
 
 config X86_DEBUGCTLMSR
 	def_bool y
-	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386)
+	depends on !(MK6 || MWINCHIPC6 || MWINCHIP3D || MCYRIXIII || M586MMX || M586TSC || M586 || M486 || M386) && !UML
 
 menuconfig PROCESSOR_SELECT
 	bool "Supported processor vendors" if EMBEDDED
-- 
1.5.6.5

