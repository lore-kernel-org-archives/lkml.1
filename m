Return-Path: <linux-kernel-owner+w=401wt.eu-S1754988AbZJVL6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754988AbZJVL6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 07:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754800AbZJVL6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 07:58:34 -0400
Received: from [195.39.106.218] ([195.39.106.218]:57385 "EHLO
	trurl.localdomain" rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754530AbZJVL6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 07:58:34 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-sh@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
       Lubomir Rintel <lkundrak@v3.sk>
Subject: [PATCH] sh: Build fix: define more __movmem* symbols
Date: Thu, 22 Oct 2009 13:58:37 +0200
Message-Id: <1256212717-14858-1-git-send-email-lkundrak@v3.sk>
X-Mailer: git-send-email 1.6.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ERROR: "__movmemSI12" [net/unix/unix.ko] undefined!
ERROR: "__movmemSI52" [net/ipv6/sit.ko] undefined!
ERROR: "__movmemSI24" [net/ipv6/ipv6.ko] undefined!
ERROR: "__movmemSI60" [net/ipv6/ipv6.ko] undefined!
ERROR: "__movmemSI16" [net/ipv6/ipv6.ko] undefined!
ERROR: "__movmemSI20" [net/ipv6/ipv6.ko] undefined!
ERROR: "__movmemSI32" [net/ipv6/ipv6.ko] undefined!
---
 arch/sh/kernel/sh_ksyms_32.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/sh/kernel/sh_ksyms_32.c b/arch/sh/kernel/sh_ksyms_32.c
index 86c2704..444cce3 100644
--- a/arch/sh/kernel/sh_ksyms_32.c
+++ b/arch/sh/kernel/sh_ksyms_32.c
@@ -85,6 +85,20 @@ DECLARE_EXPORT(__movstr_i4_even);
 DECLARE_EXPORT(__movstr_i4_odd);
 DECLARE_EXPORT(__movstrSI12_i4);
 DECLARE_EXPORT(__movmem);
+DECLARE_EXPORT(__movmemSI8);
+DECLARE_EXPORT(__movmemSI12);
+DECLARE_EXPORT(__movmemSI16);
+DECLARE_EXPORT(__movmemSI20);
+DECLARE_EXPORT(__movmemSI24);
+DECLARE_EXPORT(__movmemSI28);
+DECLARE_EXPORT(__movmemSI32);
+DECLARE_EXPORT(__movmemSI36);
+DECLARE_EXPORT(__movmemSI40);
+DECLARE_EXPORT(__movmemSI44);
+DECLARE_EXPORT(__movmemSI48);
+DECLARE_EXPORT(__movmemSI52);
+DECLARE_EXPORT(__movmemSI56);
+DECLARE_EXPORT(__movmemSI60);
 DECLARE_EXPORT(__movmem_i4_even);
 DECLARE_EXPORT(__movmem_i4_odd);
 DECLARE_EXPORT(__movmemSI12_i4);
-- 
1.6.2.5

