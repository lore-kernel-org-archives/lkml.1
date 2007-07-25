Return-Path: <linux-kernel-owner+w=401wt.eu-S1758924AbXGYU1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924AbXGYU1k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 16:27:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXGYU1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 16:27:33 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:48674 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753253AbXGYU1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 16:27:32 -0400
Message-id: <2202318244913131003@wsc.cz>
Subject: [PATCH 1/1] Char: cyclades, select FW_LOADER
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <toralf.foerster@gmx.de>
Date: Wed, 25 Jul 2007 22:27:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, select FW_LOADER

Fix link errors below by selecting FW_LOADER
  LD      .tmp_vmlinux1
drivers/built-in.o: In function `cyz_load_fw':
drivers/char/cyclades.c:4908: undefined reference to `request_firmware'
drivers/char/cyclades.c:4979: undefined reference to `release_firmware'

Cc: <toralf.foerster@gmx.de>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 199ef96ce81ae8dab526b4a954489e11255ae741
tree b1e8229dcd309f13b5416928fc77f962b5e88c95
parent fdf11b85b74221d25a3abf38a9ebf947959d0fe1
author Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 22:22:52 +0200
committer Jiri Slaby <jirislaby@gmail.com> Wed, 25 Jul 2007 22:22:52 +0200

 drivers/char/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 2a9bcd1..90015de 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -130,6 +130,7 @@ config ROCKETPORT
 config CYCLADES
 	tristate "Cyclades async mux support"
 	depends on SERIAL_NONSTANDARD && (PCI || ISA)
+	select FW_LOADER
 	---help---
 	  This driver supports Cyclades Z and Y multiserial boards.
 	  You would need something like this to connect more than two modems to
