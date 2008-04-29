Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbYD2B31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbYD2B31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 21:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751617AbYD2B3S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 21:29:18 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.144]:44072 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbYD2B3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 21:29:18 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <481679E9.8030205@avtrex.com>
Date: Mon, 28 Apr 2008 18:29:13 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/6] Add HARDWARE_WATCHPOINTS configure option.
References: <48167832.3090103@avtrex.com>
In-Reply-To: <48167832.3090103@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2008 01:29:14.0372 (UTC) FILETIME=[6F135440:01C8A998]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add HARDWARE_WATCHPOINTS configure option.

This is automatically set for all MIPS32 and MIPS64 processors.

Signed-off-by: David Daney <ddaney@avtrex.com>
---
 arch/mips/Kconfig |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 8724ed3..a52d3a8 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -1344,6 +1344,13 @@ config CPU_SUPPORTS_32BIT_KERNEL
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
1.5.5

