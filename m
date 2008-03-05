Return-Path: <linux-kernel-owner+w=401wt.eu-S934830AbYCEBST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934830AbYCEBST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 20:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761131AbYCEBR1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 20:17:27 -0500
Received: from gv-out-0910.google.com ([216.239.58.188]:28071 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634AbYCEBRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 20:17:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=t072OQjAjauiPeRqXWyZF9uGnaYcQ85diOk2bhHseIPi2D0F5G6tMnxnwO+kjiaug8E05II5YNAKwr13UxfG1zh8OobZHIqyVOiVf1K4T3WItpUhINDV8H8zcDl9uT0xF2m1lFhoKKrtszQdkN7A1Kgd39VdYo1poXv5lTPL7SU=
Subject: [PATCH 2/9] mips: replace __inline with inline
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 17:17:16 -0800
Message-Id: <1204679837.5698.68.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 arch/mips/math-emu/ieee754dp.h |    2 +-
 arch/mips/math-emu/ieee754sp.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/math-emu/ieee754dp.h b/arch/mips/math-emu/ieee754dp.h
index 8977eb5..7627865 100644
--- a/arch/mips/math-emu/ieee754dp.h
+++ b/arch/mips/math-emu/ieee754dp.h
@@ -46,7 +46,7 @@
 #define DPDNORMX	DPDNORMx(xm, xe)
 #define DPDNORMY	DPDNORMx(ym, ye)
 
-static __inline ieee754dp builddp(int s, int bx, u64 m)
+static inline ieee754dp builddp(int s, int bx, u64 m)
 {
 	ieee754dp r;
 
diff --git a/arch/mips/math-emu/ieee754sp.h b/arch/mips/math-emu/ieee754sp.h
index 9917c1e..d9e3586 100644
--- a/arch/mips/math-emu/ieee754sp.h
+++ b/arch/mips/math-emu/ieee754sp.h
@@ -51,7 +51,7 @@
 #define SPDNORMX	SPDNORMx(xm, xe)
 #define SPDNORMY	SPDNORMx(ym, ye)
 
-static __inline ieee754sp buildsp(int s, int bx, unsigned m)
+static inline ieee754sp buildsp(int s, int bx, unsigned m)
 {
 	ieee754sp r;
 
-- 
1.5.4.3.500.g83a2c


