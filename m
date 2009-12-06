Return-Path: <linux-kernel-owner+w=401wt.eu-S933740AbZLFONJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933740AbZLFONJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 09:13:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933673AbZLFONI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 09:13:08 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59042 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932535AbZLFONG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 09:13:06 -0500
From: Andi Kleen <andi@firstfloor.org>
Message-Id: <20091206313.812075626@firstfloor.org>
To: ying.huang@intel.com, x86@kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [1/3] x86: Improve CONFIG_KEXEC_JUMP description
Date: Sun,  6 Dec 2009 15:13:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been puzzling what CONFIG_KEXEC_JUMP was good for.

The Kconfig help was not very helpful in explaining why one
want to set this option. This patch improves 
it a bit, based on the original commit log. It's still
not fully clear, but then I couldn't find a concrete application
anywhere.

Cc: ying.huang@intel.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

Index: linux-2.6.32-ak/arch/x86/Kconfig
===================================================================
--- linux-2.6.32-ak.orig/arch/x86/Kconfig
+++ linux-2.6.32-ak/arch/x86/Kconfig
@@ -1496,8 +1496,10 @@ config KEXEC_JUMP
 	depends on EXPERIMENTAL
 	depends on KEXEC && HIBERNATION
 	---help---
-	  Jump between original kernel and kexeced kernel and invoke
-	  code in physical address mode via KEXEC
+	  Allow to call code through kexec with paging turned off and then
+	  return to the normal kernel. This can be used to call BIOS
+	  code for example, and to implement kexec based hibernation.
+	  Requires uptodate kexec tools.
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
