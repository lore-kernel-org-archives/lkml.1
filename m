Return-Path: <linux-kernel-owner+w=401wt.eu-S1752990AbZI3G2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbZI3G2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 02:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbZI3G2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 02:28:33 -0400
Received: from r11na27.net.upc.cz ([94.113.108.27]:54118 "EHLO
	bimbo.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752905AbZI3G2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 02:28:32 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Sep 2009 02:28:32 EDT
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-sh@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] sh: Build fix: define __movmem
Date: Wed, 30 Sep 2009 08:17:34 +0200
Message-Id: <1254291454-7436-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__movmem" [net/irda/irda.ko] undefined!
ERROR: "__movmem" [fs/nfsd/nfsd.ko] undefined!
ERROR: "__movmem" [fs/lockd/lockd.ko] undefined!
ERROR: "__movmem" [crypto/sha1_generic.ko] undefined!
---
 arch/sh/kernel/sh_ksyms_32.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/sh_ksyms_32.c b/arch/sh/kernel/sh_ksyms_32.c
index fcc5de3..98b63de 100644
--- a/arch/sh/kernel/sh_ksyms_32.c
+++ b/arch/sh/kernel/sh_ksyms_32.c
@@ -84,6 +84,7 @@ DECLARE_EXPORT(__movstrSI60);
 DECLARE_EXPORT(__movstr_i4_even);
 DECLARE_EXPORT(__movstr_i4_odd);
 DECLARE_EXPORT(__movstrSI12_i4);
+DECLARE_EXPORT(__movmem);
 DECLARE_EXPORT(__movmem_i4_even);
 DECLARE_EXPORT(__movmem_i4_odd);
 DECLARE_EXPORT(__movmemSI12_i4);
-- 
1.6.4.4

