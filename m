Return-Path: <linux-kernel-owner+w=401wt.eu-S1751806AbXDKJhp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806AbXDKJhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751795AbXDKJhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:37:45 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:36422 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789AbXDKJhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:37:40 -0400
X-IronPort-AV: i="4.14,393,1170651600"; 
   d="scan'208"; a="34580491:sNHT21571347"
Subject: [PATCH 3/5] blackfin arch: source kernel preemption option
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Wed, 11 Apr 2007 17:40:06 +0800
Message-Id: <1176284407.29581.28.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Aubrey Li <aubrey.li@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 arch/blackfin/Kconfig              |    1 +
 arch/blackfin/kernel/vmlinux.lds.S |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 91e6804..1a49305 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -70,6 +70,7 @@ config IRQCHIP_DEMUX_GPIO
 	default y
 
 source "init/Kconfig"
+source "kernel/Kconfig.preempt"
 
 menu "Blackfin Processor Options"
 
diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
index 53c6a23..6ae9ebb 100644
--- a/arch/blackfin/kernel/vmlinux.lds.S
+++ b/arch/blackfin/kernel/vmlinux.lds.S
@@ -68,6 +68,7 @@ SECTIONS
 		*(__vermagic)		/* Kernel version magic */
 		*(.rodata1)
 		*(.fixup)
+		*(.spinlock.text)
 
 		/* Kernel symbol table: Normal symbols */
 		. = ALIGN(4);
-- 
1.5.0.5

