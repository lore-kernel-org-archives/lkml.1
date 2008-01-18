Return-Path: <linux-kernel-owner+w=401wt.eu-S1758940AbYARDop@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940AbYARDop (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 22:44:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752088AbYARDoi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 22:44:38 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:49695 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbYARDoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 22:44:37 -0500
Date: Thu, 17 Jan 2008 19:50:32 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] X86: fix typo PAT to X86_PAT
To: Ingo Molnar <mingo@elte.hu>
Cc: venkatesh.pallipadi@intel.com, LKML <linux-kernel@vger.kernel.org>
Message-id: <200801171950.32458.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] X86: fix typo PAT to X86_PAT

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1b38c21..980f054 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -953,7 +953,7 @@ config MATH_EMULATION
 
 config MTRR
 	bool "MTRR (Memory Type Range Register) support"
-	depends on !PAT
+	depends on !X86_PAT
 	---help---
 	  On Intel P6 family processors (Pentium Pro, Pentium II and later)
 	  the Memory Type Range Registers (MTRRs) may be used to control
