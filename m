Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYIKFiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYIKFiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 01:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751560AbYIKFhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 01:37:51 -0400
Received: from smtp1.dnsmadeeasy.com ([205.234.170.134]:49366 "EHLO
	smtp1.dnsmadeeasy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483AbYIKFhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 01:37:50 -0400
X-Authenticated-Name: js.dnsmadeeasy
X-Transit-System: In case of SPAM please contact abuse@dnsmadeeasy.com
Message-ID: <48C8AEA6.6060901@avtrex.com>
Date: Wed, 10 Sep 2008 22:37:42 -0700
From: David Daney <ddaney@avtrex.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 1/6] MIPS: Add HARDWARE_WATCHPOINTS configure option.
References: <48C8ADEF.9020305@avtrex.com>
In-Reply-To: <48C8ADEF.9020305@avtrex.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Sep 2008 05:37:43.0711 (UTC) FILETIME=[83802AF0:01C913D0]
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
index 49896a2..7c724ea 100644
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

