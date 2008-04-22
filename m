Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYDVABl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYDVABl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 20:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773AbYDVABK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 20:01:10 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:47049 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756909AbYDVABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 20:01:09 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <480D2ABF.5000005@avtrex.com>
Date: Mon, 21 Apr 2008 17:01:03 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/6] Add HARDWARE_WATCHPOINTS configure option.
References: <480D2151.2020701@avtrex.com>
In-Reply-To: <480D2151.2020701@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2008 00:01:04.0870 (UTC) FILETIME=[F5652060:01C8A40B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This first patch just adds the HARDWARE_WATCHPOINTS option to the
'Kernel type' menu.  If N, the watch register support is disabled.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8724ed3..98f46f6 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1622,6 +1622,13 @@ config CPU_HAS_SMARTMIPS
 	  you don't know you probably don't have SmartMIPS and should say N
 	  here.
 
+config HARDWARE_WATCHPOINTS
+	bool "Debugger support for hardware watchpoints"
+	depends on (CPU_MIPS32 || CPU_MIPS64)
+	help
+	  Saying yes here allows you to utilize the hardware watchpoint
+	  registers.  Most people should say Y here.
+
 config CPU_HAS_WB
 	bool
 
-- 
1.5.5

