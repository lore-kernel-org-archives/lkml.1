Return-Path: <linux-kernel-owner+w=401wt.eu-S1762590AbXGQHwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762590AbXGQHwY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 03:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760668AbXGQHtm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 03:49:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50991 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743AbXGQHth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 03:49:37 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH] sparc32 has working dma-mapping only with CONFIG_PCI
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       davem@davemloft.net
Message-Id: <E1IAhoN-0001iq-Rf@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 17 Jul 2007 08:49:35 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/sparc/Kconfig |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 8567cc9..73df711 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -217,6 +217,9 @@ source "drivers/pci/Kconfig"
 
 endif
 
+config NO_DMA
+	def_bool !PCI
+
 config SUN_OPENPROMFS
 	tristate "Openprom tree appears in /proc/openprom"
 	help
-- 
1.5.3.GIT


