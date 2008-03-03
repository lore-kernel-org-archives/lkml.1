Return-Path: <linux-kernel-owner+w=401wt.eu-S1756003AbYCCSWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003AbYCCSWy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 13:22:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752218AbYCCSWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 13:22:45 -0500
Received: from el-out-1112.google.com ([209.85.162.183]:41004 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682AbYCCSWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 13:22:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tfir5uf86hodnr2ymFYNrciJpx6ybU0x263Tvegaq811l97hR3LtcOLRdipCujubqNigrBpkJiPrHuam7r1mW+Wk+DfMxVaA/IIwHQXvH0Vf09QFEG/54cd+443n/zMBY7EtcsXGTYATLOTgp1SVjFcJIu4RxjSBmoEcmLwicbw=
Subject: [PATCH] m32r: replace remaining __FUNCTION__ occurances
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 03 Mar 2008 10:22:37 -0800
Message-Id: <1204568557.3266.25.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/m32r/kernel/process.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/m32r/kernel/process.c b/arch/m32r/kernel/process.c
index a689e29..5973df8 100644
--- a/arch/m32r/kernel/process.c
+++ b/arch/m32r/kernel/process.c
@@ -11,7 +11,7 @@
 #undef DEBUG_PROCESS
 #ifdef DEBUG_PROCESS
 #define DPRINTK(fmt, args...)  printk("%s:%d:%s: " fmt, __FILE__, __LINE__, \
-  __FUNCTION__, ##args)
+  __func__, ##args)
 #else
 #define DPRINTK(fmt, args...)
 #endif
-- 
1.5.4.3.500.g83a2c



