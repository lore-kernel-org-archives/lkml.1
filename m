Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbYHLKZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbYHLKZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 06:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYHLKZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 06:25:19 -0400
Received: from mga10.intel.com ([192.55.52.92]:41667 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751667AbYHLKZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 06:25:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,195,1217833200"; 
   d="scan'208";a="369969792"
Subject: [PATCH]Clean-up for crypto Intel CRC32 code.
From: Austin Zhang <austin_zhang@linux.intel.com>
To: herbert@gondor.apana.org.au, drepper@gmail.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Date: Tue, 12 Aug 2008 06:23:13 -0400
Message-Id: <1218536593.16293.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

﻿Herbert and ﻿Ulrich, sorry for late reply.
see below.
This patch was created against cryptodev-2.6


Clean-up by new MACRO;

Signed-off-by: Austin Zhang <austin.zhang@intel.com>
---
 crc32c-intel.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -Naurp cryptodev-2.6/arch/x86/crypto/crc32c-intel.c cryptodev-2.6-patch/arch/x86/crypto/crc32c-intel.c
--- cryptodev-2.6/arch/x86/crypto/crc32c-intel.c	2008-08-12 04:44:00.000000000 -0400
+++ cryptodev-2.6-patch/arch/x86/crypto/crc32c-intel.c	2008-08-12 05:58:56.000000000 -0400
@@ -26,12 +26,12 @@
 #define CHKSUM_BLOCK_SIZE	1
 #define CHKSUM_DIGEST_SIZE	4
 
+#define SCALE_F	sizeof(unsigned long)
+
 #ifdef CONFIG_X86_64
 #define REX_PRE "0x48, "
-#define SCALE_F 8
 #else
 #define REX_PRE
-#define SCALE_F 4
 #endif
 
 static u32 crc32c_intel_le_hw_byte(u32 crc, unsigned char const *data, size_t length)


