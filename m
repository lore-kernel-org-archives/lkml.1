Return-Path: <linux-kernel-owner+w=401wt.eu-S1757313AbYH1VpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313AbYH1VpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 17:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754390AbYH1VpI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 17:45:08 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:48835 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYH1VpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 17:45:07 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 17:45:07 EDT
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48B71C61.3020004@avtrex.com>
Date: Thu, 28 Aug 2008 14:45:05 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: Patch [1/6] MIPS: Add HARDWARE_WATCHPOINTS configure option.
References: <48B71ADD.601@avtrex.com>
In-Reply-To: <48B71ADD.601@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Aug 2008 21:45:05.0707 (UTC) FILETIME=[557167B0:01C90957]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is automatically set for all MIPS32 and MIPS64 processors.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 4da736e..f5b3fca 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1272,6 +1272,13 @@ config CPU_SUPPORTS_32BIT_KERNEL
 config CPU_SUPPORTS_64BIT_KERNEL
 	bool
 
+#
+# Set to y for ptrace access to watch registers.
+#
+config HARDWARE_WATCHPOINTS
+       bool
+       default y if CPU_MIPS32 || CPU_MIPS64
+
 menu "Kernel type"
 
 choice
-- 
1.5.5.1


